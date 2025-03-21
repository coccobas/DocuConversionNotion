Flash Firmware to Murata Type 2BP UWB Modules
=============================================

Flashing from Jetson
--------------------

install dk6prog
~~~~~~~~~~~~~~~

.. code-block:: sh

    pip install spsdk[dk6]


Install pyftdi and create udev rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

https://eblot.github.io/pyftdi/installation.html

.. code-block:: shell

     apt-get install libusb-1.0

create udev rules

.. code-block::

    # /etc/udev/rules.d/11-ftdi.rules

    # FT232AM/FT232BM/FT232R
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", GROUP="plugdev", MODE="0664"
    # FT2232C/FT2232D/FT2232H
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", GROUP="plugdev", MODE="0664"
    # FT4232/FT4232H
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", GROUP="plugdev", MODE="0664"
    # FT232H
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", GROUP="plugdev", MODE="0664"
    # FT230X/FT231X/FT234X
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6015", GROUP="plugdev", MODE="0664"
    # FT4232HA
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6048", GROUP="plugdev", MODE="0664"


reload udev rules

.. code-block:: shell

   sudo udevadm control --reload-rules
   sudo udevadm trigger

Flash Firmware to the Board
~~~~~~~~~~~~~~~~~~~~~~~~~~~

get devide id

.. code-block:: shell

      dk6prog listdev
      sk6prog -d $DEVICE_ID info

flash firmware

.. code-block:: shell

    dk6prog -d $DEVICE_ID write 0x0 $FIRMWARE_FILE
