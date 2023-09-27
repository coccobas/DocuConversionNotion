How to package cmake project into DEB and publish it into reprepro repository
=============================================================================

1. Add cpack parameters to CMakefile.txt in the project (choose the ones needed:

    =========================================   ======================================= =================== ===========
    parameters                                  default values                          comments            required(*)
    =========================================   ======================================= =================== ===========
    CPACK_COMPONENT_DEVELOPMENT_DEPENDS         runtime                                                     
    CPACK_COMPONENT_PROGRAMS_DEPENDS            runtime
    CPACK_DEB_COMPONENT_INSTALL                 OFF
    CPACK_DEBIAN_DEVELOPMENT_PACKAGE_DEPENDS    "${PACKAGE_TARNAME}"
    CPACK_DEBIAN_DEVELOPMENT_PACKAGE_NAME       "${PACKAGE_TARNAME}-dev"
    CPACK_DEBIAN_DEVELOPMENT_PACKAGE_SECTION    "libdevel"
    CPACK_DEBIAN_PACKAGE_HOMEPAGE               ${PACKAGE_URL}
    CPACK_DEBIAN_PACKAGE_NAME                   ${PACKAGE_TARNAME}
    CPACK_DEBIAN_PACKAGE_SECTION                "devel"
    CPACK_DEBIAN_PROGRAMS_PACKAGE_DEPENDS       "${PACKAGE_TARNAME}"
    CPACK_DEBIAN_PROGRAMS_PACKAGE_NAME          "${PACKAGE_TARNAME}-utils"
    CPACK_DEBIAN_PROGRAMS_PACKAGE_SECTION       "utils"
    CPACK_DEBIAN_RUNTIME_PACKAGE_NAME           ${PACKAGE_TARNAME}
    CPACK_DEBIAN_RUNTIME_PACKAGE_RECOMMENDS     "${PACKAGE_TARNAME}-utils"
    CPACK_DEBIAN_RUNTIME_PACKAGE_SECTION        "libs"
    CPACK_NSIS_PACKAGE_NAME                     ${PACKAGE_STRING}
    CPACK_NSIS_URL_INFO_ABOUT                   ${PACKAGE_URL}
    CPACK_PACKAGE_CONTACT                       ${PACKAGE_BUGREPORT}
    CPACK_PACKAGE_DISPLAY_NAME                  ${PACKAGE_STRING}
    CPACK_PACKAGE_INSTALL_DIRECTORY             "${PACKAGE_TARNAME}-${PACKAGE_VERSION}"
    CPACK_PACKAGE_NAME                          ${PACKAGE_TARNAME}                                          *
    CPACK_PACKAGE_VERSION                       ${PACKAGE_VERSION}
    CPACK_PACKAGE_VERSION_MAJOR                 ${LIBXML_MAJOR_VERSION}
    CPACK_PACKAGE_VERSION_MINOR                 ${LIBXML_MINOR_VERSION}
    CPACK_PACKAGE_VERSION_PATCH                 ${LIBXML_MICRO_VERSION}
    CPACK_RESOURCE_FILE_LICENSE                 ${CMAKE_CURRENT_SOURCE_DIR}/Copyright
    CPACK_RPM_COMPONENT_INSTALL                 ON
    CPACK_RPM_development_PACKAGE_NAME          "${PACKAGE_NAME}-devel"
    CPACK_RPM_development_PACKAGE_REQUIRES      "${PACKAGE_NAME}"
    CPACK_RPM_PACKAGE_GROUP                     "Development/Libraries"
    CPACK_RPM_PACKAGE_NAME                      ${PACKAGE_TARNAME}
    CPACK_RPM_PACKAGE_URL                       ${PACKAGE_URL}
    CPACK_RPM_programs_PACKAGE_NAME             "${PACKAGE_NAME}-utils"
    CPACK_RPM_programs_PACKAGE_REQUIRES         "${PACKAGE_NAME}"
    CPACK_RPM_runtime_PACKAGE_NAME              "${PACKAGE_NAME}"
    CPACK_RPM_runtime_PACKAGE_SUGGESTS          "${PACKAGE_NAME}-utils"

    CPACK_DEBIAN_FILE_NAME                      DEB-DEFAULT                                                 *
    CPACK_BINARY_DEB                            ON
    CPACK_DEBIAN_PACKAGE_SHLIBDEPS              ON
    CPACK_DEBIAN_PACKAGE_GENERATE_SHLIBS        ON
    =========================================   ======================================= =================== ===========


set CPACK_DEBIAN_FILE_NAME to DEB-DEFAULT to get default name for deb package like:
<package_name>_<package_version>_<package_arch>.deb

2. run cpack after cmake is done in build folder

.. code-block:: bash

    $ WORKING_DIR=~/projects/myproject/build
    cmake ..
    make -j(nproc)
    cpack -G DEB

3. add the new deb version with description into changelog file


4. generate .changes file with tool (need to find a tool for that or use changetool inside reprepro)

5. add the new deb package with .changes into reprepro repository

.. code-block:: bash

    $ DIR="/your/artifact/folder"
    scp -P $SSH_PORT $DIR/*.deb $DIR/*.changes root@$SSH_HOST:/repo/incoming
    ssh root@$SSH_HOST -p $SSH_PORT "repo-process-incoming $REPO_NAME"

So reprepro need to work with .changes file for each deb package, tried a few but reprepro gave the following error:

.. code-block:: bash

    $ repo-process-incoming BeagleSystems
    [BeagleSystems] Incoming process started at Wed Sep 27 10:43:45 UTC 2023

    long key IDs are discouraged; please use key fingerprints instead
    signfile changes /repo/incoming/tacopie.changes 4248F49047FFF45A
    gpg: starting migration from earlier GnuPG versions
    gpg: porting secret keys from '/root/.gnupg/secring.gpg' to gpg-agent
    gpg: key 4248F49047FFF45A: secret key imported
    gpg: migration succeeded

    Successfully signed changes file
    Not removed as not found: tacopie.changes
    Exporting indices...
    generating main/Contents-i386...
    generating main/Contents-amd64...
    generating main/Contents-arm64...
    Successfully created '/repo/dists/BeagleSystems/Release.gpg.new'
    Successfully created '/repo/dists/BeagleSystems/InRelease.new'
    Unexpected data after ending empty line in 'tacopie.changes'!
    There have been errors!
    Created directory "/tmp/reprepro"
    
Need rollback to step.4 and find the right tool for generate .changes file