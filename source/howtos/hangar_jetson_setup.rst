Documentation for Preparing the Hangar’s jetson:

1.  | Grant yourself access to your github account:

.. code-block:: sh
    
    ssh-keygen -t ed25519 -C "altalmas.abdallah@gmail.com"       
    cd ~/.ssh       
    ll       
    cat id_ed25519.pub``

2.  Add the shown ssh code into your github account:

.. code-block:: sh

    github account > settings > Access, SSH and GPG keys > SSH keys, New SSH key

3.  Download the openvpn (clientXX.ovpn) from google drive `profiles
    folder <https://drive.google.com/drive/folders/1wEnOl0tgbS9RErSNfXNNYCdGY0wY7Qsi>`__
    and update the openvpn `Excel
    Sheet <https://docs.google.com/spreadsheets/d/1xsuI9HG9QYv79Dmpvhj1xvi7siXjnXox/edit#gid=1639621132>`__.


4.  Configure the openvpn ip address:
    
.. code-block:: sh

    sudo apt install openvpn       
    cd /etc/openvpn/       
    ls -al       
    sudo cp ~/Downloads/clientXX.ovpn /etc/openvpn/       
    sudo mv clientXX.ovpn client.conf       
    sudo systemctl status openvpn@client.service       
    sudo systemctl restart openvpn@client.service       
    sudo systemctl status openvpn@client.service       
    ifconfig tun0       
    ping 10.8.0.1

5.  Clone the rtk-server repository:

.. code-block:: sh

    cd ~       
    git clone git@github.com:beaglesystems/rtk-server --recursive

6.  add the udev_rules:

.. code-block:: sh

       cd ~/beaglehouse/udev_rules
       sudo cp 99* /etc/udev/rules.d/
       ll /etc/udev/rules.d/

       cd ~/rtk-server/udev
       ll
       sudo cp 90* /etc/udev/rules.d/

7.  Here you need to compare between each udev_rule that you copied to
    (/etc/udev/rules.d) with each device parameters. And make sure the
    following matche:

    -  {idVendor}
    -  {idProduct}

    To check for the device parameters:
-  For Arduino & rtk:
    
.. code-block:: sh

    sudo udevadm info -a /dev/ttyACM0
    
-  For Heisha:

.. code-block:: sh

    sudo udevadm info -a /dev/ttyUSB0

 (optional) How to check whether it is ttyACM0/ttyUSB0: After plugging the usb:
    
.. code-block:: sh

    dmesg

8.  Activate the udev_rules:

.. code-block:: sh

    sudo udevadm control --reload

9.  Unplug and plug the usb devices again to trigger them.


10. Jump to
    `BeagleHouse <https://github.com/BeagleSystems/BeagleHouse>`__ and
    follow the README.md file and follow it in the following order:

    1. **Install docker-compose on Jetson Series**
    2. **Install and deploy with docker-compose**
