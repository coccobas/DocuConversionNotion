Setup WiFi on the drone
=======================

.. code-block:: sh

   sudo nmcli c add type wifi con-name HangarCon ifname wlan0 ssid BeagleHangar
   sudo nmcli con modify HangarCon wifi-sec.key-mgmt wpa-psk
   sudo nmcli con modify HangarCon wifi-sec.psk bestbeagleever
   sudo nmcli con modify HangarCon connection.autoconnect yes
   sudo nmcli con modify HangarCon connection.autoconnect-priority 10
   sudo nmcli con up HangarCon
   sudo nmcli device wifi connect BeagleHangar --ask

Show autoconnect priorities:

.. code-block:: sh

   sudo nmcli -f NAME,UUID,AUTOCONNECT,AUTOCONNECT-PRIORITY c

Driver installation for TP-Link:

.. code-block:: sh

   git clone https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959
   cd rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959
   VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
   sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
   sudo dkms add -m rtl88x2bu -v ${VER}
   sudo dkms build -m rtl88x2bu -v ${VER}
   sudo dkms install -m rtl88x2bu -v ${VER}
   sudo modprobe 88x2bu


On the hangar we need a static IP address for the wifi:

.. code-block:: sh

   sudo nmcli con mod "Wired connection 1" ipv4.address 192.168.20.100
