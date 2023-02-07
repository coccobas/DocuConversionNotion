Building CMake v3.17.3 on Jetson NANO
=====================================

SONY SDK required CMake version 3.17.3. 
(Not confirmed to work with anything other than CMake 3.17.3) from SDK readme

The default CMake version is 3.16.3 on Jetson NANO, so we have to upgrade it for SONY SDK.

.. code-block:: sh

    cmake --version
        cmake version 3.16.3
        CMake suite maintained and supported by Kitware (kitware.com/cmake).

    which cmake
        /usr/local/bin/cmake

First make a backup of current cmake and remove the old one

.. code-block:: sh

    sudo cp /usr/local/bin/cmake /usr/local/bin/cmake-v3.16
    sudo rm /usr/local/bin/cmake

Download v3.17.3 source code from Kitware Github repo

.. code-block:: sh

    cd ~/Downloads
    wget https://github.com/Kitware/CMake/archive/refs/tags/v3.17.3.tar.gz
    tar -xzvf v3.17.3.tar.gz

Build cmake from source

.. code-block:: sh

    cd ~/Downloads/CMake-3.17.3/
    ./bootstrap && make
    sudo make install

Check the version again after install

.. code-block:: sh

    cmake --version
        cmake version 3.17.3
        CMake suite maintained and supported by Kitware (kitware.com/cmake).

    which cmake
        /usr/local/bin/cmake
