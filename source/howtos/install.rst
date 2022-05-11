Install the BeagleSystems Software on a drone
=============================================

To gain access to the repository, we first have to do some setup:

.. code-block:: sh

   $ git config --global http.postBuffer 524288000
   $ ssh-keygen -t rsa -b 4096 -C "your_email@beaglesystems.com"
   $ cat ~/.ssh/id_rsa.pub

Upload the public key to your github settings to be able to download the repository.

.. code-block:: sh

   $ mkdir Development
   $ cd Development
   $ git clone git@github.com:BeagleSystems/BeagleComrade -b develop

Create the file ~/.beaglerc with the following content.

.. code-block:: sh

   #!/bin/bash
   
   # !!! Double check that these paths are correctly set !!!
   source /opt/ros/noetic/setup.bash
   source /home/david/Development/beaglesystems/BeagleComrade/devel/setup.bash
   export ROS_PACKAGE_PATH=/home/david/Development/beaglesystems/PX4-Autopilot:/home/david/Development/beaglesystems/PX4-Autopilot/Tools/sitl_gazebo:$ROS_PACKAGE_PATH
   
   # These exports are necessary if you try to run ROS debugging tools connected via WiFi to the drone. Use the same exports on your local computer
   #export ROS_HOSTNAME=192.168.8.100
   #export ROS_IP=$ROS_HOSTNAME
   #export ROS_MASTER_URI=http://$ROS_HOSTNAME:11311
   
   export GST_PLUGIN_PATH=/usr/local/lib/aarch64-linux-gnu/gstreamer-1.0:/usr/lib/aarch64-linux-gnu/gstreamer-1.0
   export LD_LIBRARY_PATH=/usr/local/lib/aarch64-linux-gnu:$LD_LIBRARY_PATH

