Building QGroundControl
=======================

.. code-block:: sh

   cd ~/Development/beaglesystems/QGroundControl
   docker build --file ./deploy/docker/Dockerfile-build-linux -t qgc-linux-docker .
   mkdir build
   docker run --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-linux-docker
   ./deploy/create_linux_appimage.sh . build/staging

