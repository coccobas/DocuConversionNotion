############
Wiring check
############

Flight Controller Cables
========================

Most wiring checks for the flight controller are done in the PX4 shell.

GPS/compass cable
-----------------

The Here 3 GPS module is connected via uavcan to the flight controller. If the module is already blinking green or blue, we can assume that the module is connected properly. The following command gives insights about erroneous signals in this connection:

.. code-block:: sh

   uavcan status

UART cables
-----------

Currently, the only UART cables connected to the flight controller are for gimbal control. They always use the MAVLink protocol. The Nucleo F446RE or the Olimexino STM32F3 act as "MAVLink gimbal devices" and convert the incoming MAVLink gimbal v2 messages to the respective protocols used by the actual gimbal. The Gremsy Pixy U connection runs on a 115200 baudrate and the connection to the Nucleo F446RE/Olimexino STM32F3 runs on a 230400 baudrate. The following command can be used to check the UART connectivity, specifically by testing whether there is any incoming data on the RX pin.

.. code-block:: sh

   mavlink status

To also test the TX pin, you can give a command to the gimbal (either nighthawk or eh2000) and see if it reacts:

.. code-block:: sh

   nighthawk test lookleft
   eh2000 test lookleft

All gimbal devices report the angle of the gimbal to the flight controller. This can be checked by running the following command, which might have to be run a few times to differentiate between multiple gimbals. You can distinguish them by checkng for component IDs 154 and 171.

.. code-block:: sh

   listener gimbal_device_attitude_status

PWM cables
----------

This test is dangerous. Make sure the propellers are all detached.
The 8 main PWM channels are accessible as /dev/pwm_output0 in the PX4 shell, and the 6 aux PWM channels as /dev/pwm_output1. To test a certain value (e.g. 1200) on one or multiple PWM channels (e.g. 123), run the following command and cancel by typing "c" and pressing enter afterwards.

.. code-block:: sh

   pwm test -d /dev/pwm_output0 -c 123 -p 1200
   c <enter>
