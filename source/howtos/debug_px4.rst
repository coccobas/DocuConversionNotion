Debug PX4 topics
================

Login to the Jetson connected via USB-to-UART.

.. code-block:: sh

   $ sudo systemctl stop beagle
   $ screen /dev/ttyUSB0 57600 8N1

NuttX shell, list all available commands and list all uORB topics:

.. code-block:: sh

   nsh> help
   nsh> uorb top
   q

If you have GPS problems, please check:

.. code-block:: sh

   nsh> listener vehicle_gps_position

Is jamming indicator below 40? If not, make sure that all USB3.0 cables are far away from the GPS sensor.

In a SITL environment, we can use GDB to analyze. I assume that you run PX4 via a robot_upstarted launch file. Make sure that the PX4 ros node is commented out. First, we have to compile PX4 in GDB mode:

.. code-block:: sh

   DONT_RUN=1 make px4_sitl_default gazebo___gdb

Next, we start the node as root.

.. code-block:: sh

   $ sudo su -
   # export HOME=/home/simadm
   # source $HOME/.hparc
   # gdb --args $HOME/Development/Firmware/build/px4_sitl_default/bin/px4 /$HOME/Development/Firmware/ROMFS/px4fmu_common -s etc/init.d-posix/rcS -t /$HOME/Development/Firmware/test_data
   (gdb) handle SIGCONT noprint nostop
   (gdb) run

One example how to break on certain mavlink messages, e.g. with mavlink message ID 212:

.. code-block:: sh

   <ctrl-c> if GDB is running already
   (gdb) break MavlinkReceiver::handle_message
   (gdb) continue
   Thread 75 "mavlink_rcv_if1" hit Breakpoint 1, MavlinkReceiver::handle_message (this=0x7fff8c000b20, msg=0x7fffc6ffad90)
    at ../../src/modules/mavlink/mavlink_receiver.cpp:132
    132     {
   (gdb) x/20i $pc
   => 0x55555561d420 <MavlinkReceiver::handle_message(__mavlink_message*)>:        push   %rbp
      0x55555561d421 <MavlinkReceiver::handle_message(__mavlink_message*)+1>:      push   %rbx
      0x55555561d422 <MavlinkReceiver::handle_message(__mavlink_message*)+2>:      mov    %rsi,%rbx
      0x55555561d425 <MavlinkReceiver::handle_message(__mavlink_message*)+5>:      mov    %rdi,%rbp
      0x55555561d428 <MavlinkReceiver::handle_message(__mavlink_message*)+8>:      sub    $0x8,%rsp
      0x55555561d42c <MavlinkReceiver::handle_message(__mavlink_message*)+12>:     movzbl 0xa(%rbx),%eax
      0x55555561d430 <MavlinkReceiver::handle_message(__mavlink_message*)+16>:     movzbl 0x9(%rsi),%esi
      0x55555561d434 <MavlinkReceiver::handle_message(__mavlink_message*)+20>:     movzbl 0xb(%rbx),%edx
      0x55555561d438 <MavlinkReceiver::handle_message(__mavlink_message*)+24>:     shl    $0x8,%rax
      0x55555561d43c <MavlinkReceiver::handle_message(__mavlink_message*)+28>:     or     %rsi,%rax
      0x55555561d43f <MavlinkReceiver::handle_message(__mavlink_message*)+31>:     shl    $0x10,%rdx
      0x55555561d443 <MavlinkReceiver::handle_message(__mavlink_message*)+35>:     or     %rdx,%rax
      0x55555561d446 <MavlinkReceiver::handle_message(__mavlink_message*)+38>:     cmp    $0x8a,%eax
      0x55555561d44b <MavlinkReceiver::handle_message(__mavlink_message*)+43>:     je     0x55555561d8d0 <MavlinkReceiver::handle_message(__mavlink_message*)+1200>
   (gdb) delete
   (gdb) break *0x55555561d446 if $eax == 212
   (gdb) info registers $eax
   (gdb) continue
