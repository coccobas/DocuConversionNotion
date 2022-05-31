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

