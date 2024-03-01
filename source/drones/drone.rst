Drone
=====

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

For MAVSDK C++ applications:

.. graphviz::

   digraph mavsdkcpp_containers {
      "MAVSDK" [URL="https://github.com/BeagleSystems/mavsdk"]
      "ubuntu:18.04"
      "ubuntu:develop"
      "mavsdkcpp_camera_manager" [URL="https://github.com/BeagleSystems/mavsdkcpp-camera-manager"]
      "mavsdkcpp_container_manager" [URL="https://github.com/BeagleSystems/mavsdkcpp-container-manager"]
      "mavsdkcpp_router" [URL="https://github.com/BeagleSystems/mavsdkcpp-router"]
      "ubuntu:18.04" -> "ubuntu:develop" [ label="gcc-9 cmake-3.17" ]
      "ubuntu:develop" -> "MAVSDK"
      "MAVSDK" -> "mavsdkcpp_router_deb"
      "MAVSDK" -> "mavsdkcpp_camera_manager"
      "MAVSDK" -> "mavsdkcpp_container_manager"
      "MAVSDK" -> "mavsdkcpp_router"
   }

For MAVSDK Python applications:

.. graphviz::

   digraph mavsdkpy_containers {
      "grpcio_base" [URL="https://github.com/BeagleSystems/grpc"]
      "mavsdk_python_base" [URL="https://github.com/BeagleSystems/mavsdk_python_base"]
      "mavsdkpy_remote_shutdown" [URL="https://github.com/BeagleSystems/mavsdkpy-remote-shutdown"]
      "mavsdkpy_logfile_download" [URL="https://github.com/BeagleSystems/mavsdkpy-logfile-download"]
      "ubuntu:22.04"
      "ubuntu:22.04" -> "grpcio_base"
      "grpcio_base" -> "mavsdk_python_base"
      "mavsdk_python_base" -> "mavsdkpy_remote_shutdown"
      "mavsdk_python_base" -> "mavsdkpy_logfile_download"
   }

