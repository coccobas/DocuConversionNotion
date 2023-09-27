Self Host APT repository guide
==============================

This guide will help you to setup your own APT repository for your own packages.

We get used to use debian repository on Ubuntu and according to `DebianRepositorySetup <https://wiki.debian.org/DebianRepository/Setup#Debian_Repository_Generation_Tools>`_, there are a lot of tools can help us.

In general, we need to do the following steps:

- Create share file folder on the server to host all the deb packages
- use ``dpkg-scanpackages`` or other tools from the list to generate the list of packages
- Create a GPG key and secure APT repository with GPG key

1. File Share server
********************

For the share file server, we use `flask-file-server <https://github.com/BeagleSystems/flask-file-server>`_ to host the deb packages.

To make the following steps easier, create the folder and upload all the debs to ``/pool/main/`` folder
all the debs need to have some naming requirements as described in CPack guide.
In short, the deb name should be ``<package_name>_<version>_<arch>.deb``

For example, the folder tree should be like the following:

.. code-block:: bash
   
    ├── dists
    │   └── stable
    │       └── main
    │           ├── binary-amd64
    │           └── binary-arm64
    └── pool
        └── main
            └── cpp_redis_4.3.1_amd64.deb

Currently, we have it deployed on "10.8.1.44:36363/" provided by flask-file-server docker image.

2. Generate the list of packages
********************************

First, we need to generate ``Packages`` and ``Packages.gz`` files

.. code-block:: bash

    cd <share folder>/

    # generate packages file
    dpkg-scanpackages -m --arch amd64 pool/ > ./dists/stable/main/binary-amd64/Packages
    dpkg-scanpackages -m --arch arm64 pool/ > ./dists/stable/main/binary-arm64/Packages

    # generate packages.gz
    cat ./dists/stable/main/binary-amd64/Packages | gzip -9 > ./dists/stable/main/binary-amd64/Packages.gz
    cat ./dists/stable/main/binary-arm64/Packages | gzip -9 > ./dists/stable/main/binary-arm64/Packages.gz


the Packages file and its compressed variant need to be updated every time you upload a new package.
which was not really convenient for usage, so we have to make it automatic scanpackages regularly.

Second, we need to generate ``Release`` file, make a script for this task will be easier.

.. code-block:: sh

    #!/bin/sh

    set -e

    do_hash() {
        HASH_NAME=$1
        HASH_CMD=$2
        echo "${HASH_NAME}:"
        for f in $(find -type f); do
            f=$(echo $f | cut -c3-) # remove ./ prefix
            if [ "$f" = "Release" ]; then
                continue
            fi
            echo " $(${HASH_CMD} ${f}  | cut -d" " -f1) $(wc -c $f)"
        done
    }

    cat << EOF
    Origin: Beagle Systems
    Label: BeagleSystems
    Suite: stable
    Codename: stable
    Version: 1.0
    Architectures: amd64 arm64
    Components: main
    Description: Some software packages used internally by BeagleSystems
    Date: $(date -Ru)
    EOF
    do_hash "MD5Sum" "md5sum"
    do_hash "SHA1" "sha1sum"
    do_hash "SHA256" "sha256sum"

then run the script to generate the Release file

.. code-block:: bash

    $ cd <share folder>/dists/stable/
    $ <path of sh script created>/generate_release.sh > ./dists/stable/Release

like the Packages files, the Release file also needs to be updated on every new uploaded package.


3. Secure APT repository with PGP/GPG keys
******************************************

*On the Server side*, generate a new key once with the template as below in a restricted folder:

.. code-block:: sh

    %echo Generating an PGP key
    Key-Type: RSA
    Key-Length: 4096
    Name-Real: beagle
    Name-Email: mg@beaglesystems.com
    Expire-Date: 0
    %no-ask-passphrase
    %no-protection
    %commit

Save it to pgp-key.batch

.. code-block:: bash

    $ gpg --no-tty --batch --gen-key ./pgp-key.batch

    $ gpg --list-keys

a key-id named with beagle should be listed.
then export the public/private key to a file, KEY-ID will be ``beagle`` as we defined in the batch file.

.. code-block:: bash

    $ gpg --armor --export beagle > beagle.public
    $ gpg --armor --export-secret-keys beagle > beagle.private

Then we can secure Release file with the public key we just generated, and also keep the private key in a safe place.

.. code-block:: bash

    $ cd <share folder>/dists/stable/

    $ export GPG_TTY=$(tty)
    $ cat ./Release | gpg --default-key beagle -abs > ./Release.gpg
    $ cat ./Release | gpg --default-key beagle -abs --clearsign > ./InRelease

The current best practice on Ubuntu 22.04 is to use *gpg* in place of ``apt-key`` and ``add-apt-repository``, 
and in future versions of Ubuntu it will be the only option. ``apt-key`` and ``add-apt-repository`` themselves 
have always acted as wrappers, calling *gpg* in the background. Using *gpg* directly cuts out the intermediary. 
For this reason, the *gpg* method is backwards compatible with older versions of Ubuntu and can be used as 
a drop-in replacement for ``apt-key``.

*On the client sides*, we need to import the public key to the apt keyring.

.. code-block:: bash

    $ gpg --import beagle.public

gpg import does working but apt update still complains about the missing key, looks like apt manager does not like PGP key
so we have to convert it to gpg format and add it to local keyring for apt.

put the public key to share file server as well and download it to client side.

.. code-block:: bash

    $ wget -O - http://10.8.1.44:36363/beagle.public 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/beagle.gpg >/dev/null

then add the following line to ``/etc/apt/sources.list``

.. code-block:: bash

    deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/beagle.gpg] http://10.8.1.44:36363/ stable main

To verify if the client side is ready, run 

.. code-block:: bash

    $ sudo apt update

if apt still complains about missing key like the following:

.. code-block:: bash

    W: GPG error: https://10.8.1.44:36363/ stable InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY KEY-ID
    W: Failed to fetch https://10.8.1.44:36363/dists/stable/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY KEY-ID

then you need to check the gpg key, make sure the keyring is updated and the packages must be signed with the same key.

The following script can help setup the apt repository on the client side.

.. code-block:: bash

    #!/bin/bash
    #
    # Check GPG keys
    # ==============
    #

    if tail /etc/apt/sources.list | grep beagle; then
        echo beagle apt source found
    else
        echo beagle apt source not found
        # Add beagle apt source
        wget -O - http://10.8.1.44:36363/beagle.public 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/beagle.gpg >/dev/null
        echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/beagle.gpg] http://10.8.1.44:36363/ stable main" | sudo tee -a /etc/apt/sources.list
    fi
