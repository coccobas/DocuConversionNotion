How to debug USB
================

.. code-block:: sh

   sudo apt install libboost-dev libpcap-dev
   git clone https://github.com/aguinet/usbtop
   cd usbtop
   mkdir build && cd build
   cmake -DCMAKE_BUILD_TYPE=Release ..
   make
   sudo make install
   sudo modprobe usbmon
   sudo usbtop

Compare that with the USB devices found via lsusb.

USB devices can fail if the voltage drops below 5V. To check the voltage on Jetson Nano, run:

.. code-block::

   cat /sys/bus/i2c/drivers/ina3221x/6-0040/iio:device0/in_voltage0_input
