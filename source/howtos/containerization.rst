How to turn any module into a docker container
==============================================

Helpful links:
https://vsupalov.com/cache-docker-build-dependencies-without-volume-mounting/
https://pythonspeed.com/articles/security-updates-in-docker/

Size optimization:

Sort installed packages by size and list their reverse dependencies (multiple times) to see what caused their installation:

.. code-block:: sh

   # dpkg-query -Wf '${db:Status-Status} ${Installed-Size}\t${Package}\n' | sed -ne 's/^installed //p'|sort -n
   164581  libvtk7.1p
   # apt-cache --installed rdepends libvtk7-dev
   libvtk7-dev
   Reverse Depends:
     libvtk7-java
     libvtk7-qt-dev
     libpcl-dev
   # apt-cache --installed rdepends libpcl-dev
   libpcl-dev
   Reverse Depends:
     ros-noetic-pcl-ros
     ros-noetic-pcl-ros
     ros-noetic-pcl-conversions

Check why a healthcheck failed:

.. code-block:: sh

   docker inspect --format='{{json .State.Health}}' container_name
