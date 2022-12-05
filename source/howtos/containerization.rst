How to turn any module into a docker container
==============================================

First of all, the current container base image dependencies:

.. graphviz::

   digraph ros_containers {
      "ros_noetic" [URL="https://github.com/BeagleSystems/ros_base"]
      "nvcr.io/nvidia/l4t-base:r35.1.0"
      "ubuntu:20.04"
      "ros_noetic_mavros" [URL="https://github.com/BeagleSystems/mavros"]
      "ros_noetic_gstreamer" [URL="https://github.com/BeagleSystems/gst-build"]
      "ros_noetic_precland" [URL="https://github.com/BeagleSystems/ros_precland"]
      "nvcr.io/nvidia/l4t-base:r35.1.0" -> "ros_noetic" [ label="if arm64" ]
      "ubuntu:20.04" -> "ros_noetic" [ label="if amd64" ]
      "ros_noetic" -> "ros_noetic_mavros"
      "ros_noetic_mavros" -> "ros_noetic_gstreamer"
      "ros_noetic_gstreamer" -> "ros_noetic_precland"
   }

For MAVSDK applications:

.. graphviz::

   digraph mavsdk_containers {
      "MAVSDK" [URL="https://github.com/BeagleSystems/mavsdk"]
      "grpcio_base" [URL="https://github.com/BeagleSystems/grpc"]
      "mavsdk_python_base" [URL="https://github.com/BeagleSystems/mavsdk_python_base"]
      "mavsdkpy_remote_shutdown" [URL="https://github.com/BeagleSystems/mavsdkpy-remote-shutdown"]
      "mavsdkpy_logfile_download" [URL="https://github.com/BeagleSystems/mavsdkpy-logfile-download"]
      "ubuntu:20.04"
      "ubuntu:22.04"
      "mavsdkcpp_camera_manager" [URL="https://github.com/BeagleSystems/mavsdkcpp-camera-manager"]
      "mavsdkcpp_container_manager" [URL="https://github.com/BeagleSystems/mavsdkcpp-container-manager"]
      "mavsdkcpp_router" [URL="https://github.com/BeagleSystems/mavsdkcpp-router"]
      "ubuntu:20.04" -> "MAVSDK"
      "MAVSDK" -> "mavsdkcpp_camera_manager"
      "MAVSDK" -> "mavsdkcpp_container_manager"
      "MAVSDK" -> "mavsdkcpp_router"
      "ubuntu:22.04" -> "grpcio_base"
      "grpcio_base" -> "mavsdk_python_base"
      "mavsdk_python_base" -> "mavsdkpy_remote_shutdown"
      "mavsdk_python_base" -> "mavsdkpy_logfile_download"
   }

Which basic containers to use?

1. For auto-healing unhealthy containers, we use

.. code-block:: yaml

     autoheal:
       restart: always
       image: willfarrell/autoheal
       environment:
         - AUTOHEAL_CONTAINER_LABEL=all
       volumes:
         - /var/run/docker.sock:/var/run/docker.sock

Install docker-compose:

.. code-block:: sh

   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose

Helpful links:
https://vsupalov.com/cache-docker-build-dependencies-without-volume-mounting/
https://pythonspeed.com/articles/security-updates-in-docker/
https://betterprogramming.pub/cleanup-your-docker-registry-ef0527673e3a

For extracting single files from a docker image:
https://medium.com/@tomwillfixit/extracting-a-single-artifact-from-a-docker-image-without-pulling-3fc038a6e57e

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
