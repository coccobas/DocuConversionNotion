#######
Sentera
#######

Network configuration
=====================

.. code-block:: sh

   sudo nmcli con add type ethernet con-name sentera ifname enx60a4b7b3325a ip4 192.168.5.10/24
   sudo nmcli con edit sentera
   set ipv4.method manual
   set connection.autoconnect yes
   save
   quit
   sudo nmcli con up sentera

Test commands for the NuttX shell
=================================

Do a camera trigger test:

.. code-block:: sh

   camera_trigger test

Do a interval-based camera trigger test until stopped:

.. code-block:: sh

   camera_trigger test_interval
   camera_trigger test_interval stop

Do a continuous photo shooting test for 20 seconds:

.. code-block:: sh

   camera_trigger test continuous

B. Set up QGroundControl

1. Go to General Page under Application Setting.
2. Set the video stream to UDP H264..
