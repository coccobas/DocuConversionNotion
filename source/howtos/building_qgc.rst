Building BeagleGroundControl
============================

.. code-block:: sh

   cd ~/Development/beaglesystems/BeagleGroundControl
   docker build --file ./deploy/docker/Dockerfile-build-linux -t beaglegc-linux-docker .
   mkdir build
   docker run --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build beaglegc-linux-docker


Add an alias for start qgc from the build folder

.. code-block:: sh

   echo "alias qgc='~/Development/qgroundcontrol/build/staging/BeagleGroundControl'" > ~/.bash_aliases
   source .bashrc
   qgc

If xcb is missing when start qgc, need to install the following

.. code-block:: sh

   sudo apt install libxcb-xinerama0 


Or packaging the built folder into appimage for release

.. code-block:: sh

   ./deploy/create_linux_appimage.sh . build/staging

