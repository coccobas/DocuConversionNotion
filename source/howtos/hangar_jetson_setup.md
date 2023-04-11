   Documentation for Preparing the Hangar's jetson:

   1. Grant yourself access to your github account:   
      ```
      $ ssh-keygen -t ed25519 -C "altalmas.abdallah@gmail.com"
      $ cd ~/.ssh
      $ ll
      $ cat id_ed25519.pub 
      ```
   
   1. Add the shown ssh code into your github account:
      ```
      github account > settings > Access, SSH and GPG keys > SSH keys, New SSH key
      ```
   
   1. Download the openvpn (clientXX.ovpn) from google drive [profiles folder](https://drive.google.com/drive/folders/1wEnOl0tgbS9RErSNfXNNYCdGY0wY7Qsi) and update the openvpn [Excel Sheet](https://docs.google.com/spreadsheets/d/1xsuI9HG9QYv79Dmpvhj1xvi7siXjnXox/edit#gid=1639621132).

   1. Configure the openvpn ip address:
      ```
      $ sudo apt install openvpn
      $ cd /etc/openvpn/
      $ ls -al
      $ sudo cp ~/Downloads/clientXX.ovpn /etc/openvpn/
      $ sudo mv clientXX.ovpn client.conf
      $ sudo systemctl status openvpn@client.service
      $ sudo systemctl restart openvpn@client.service
      $ sudo systemctl status openvpn@client.service
      $ ifconfig tun0
      $ ping 10.8.0.1
      ```

   1. Clone the rtk-server repository:
      ```
      $ cd ~
      $ git clone git@github.com:beaglesystems/rtk-server --recursive
      ```
      
   1. add the udev_rules:
      ```
      $ cd ~/beaglehouse/udev_rules
      $ sudo cp 99* /etc/udev/rules.d/
      $ ll /etc/udev/rules.d/

      $ cd ~/rtk-server/udev
      $ ll
      $ sudo cp 90* /etc/udev/rules.d/
      ```
      
   1. Here you need to compare between each udev_rule that you
      copied to (/etc/udev/rules.d) with each device parameters.
      And make sure the following matche:
         * {idVendor}
         * {idProduct}

      To check for the device parameters:
         * For Arduino & rtk:
            $ sudo udevadm info -a /dev/ttyACM0
         * For Heisha:
            $ sudo udevadm info -a /dev/ttyUSB0

      (optional) How to check whether it is ttyACM0/ttyUSB0:
         After plugging the usb:
            $ dmesg

   1. Activate the udev_rules:
      ```
      $ sudo udevadm control --reload
      ```
      
   1. Unplug and plug the usb devices again to trigger them.
      
   1. Jump to [BeagleHouse](https://github.com/BeagleSystems/BeagleHouse) and follow the README.md file and follow it in the following order:
       1. __Install docker-compose on Jetson Series__
       2. __Install and deploy with docker-compose__
