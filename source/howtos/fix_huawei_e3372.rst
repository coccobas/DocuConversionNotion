Fix HUAWEI E3372 USB MODEM on Ubuntu
====================================


**Problem**: HUAWEI E3372 USB MODEM is not working on Ubuntu 20.04/22.04

**Solution**: switch the usb device mode from default "mass storage" to "modem"

1. Install usb_modeswitch

    .. code-block:: bash

        sudo apt-get install usb-modeswitch

2. find the right vendor and product id with `lsusb`

    .. code-block:: bash

        $ lsusb
        Bus 001 Device 004: ID 12d1:1f01 Huawei Technologies Co., Ltd. E353/E3131 (Mass storage mode)

    0x12d1 is the vendor id and 0x1f01 is the product id

3. add the following to /etc/usb_modeswitch.conf

    .. code-block:: bash
    
        # Huawei E353 (3.se) and others
        TargetVendor=0x12d1
        TargetProductList="1f01"
        HuaweiNewMode=1
        NoDriverLoading=1

4. run modeswitching command

    .. code-block:: bash

        sudo usb_modeswitch -v 12d1 -p 1f01 -c /etc/usb_modeswitch.conf 

5. check the device status with 'lsusb' again

    .. code-block:: bash

        $ lsusb
        Bus 001 Device 004: ID 12d1:1f01 Huawei Technologies Co., Ltd. E3372 LTE/UMTS/GSM HiLink Modem/Networkcard

