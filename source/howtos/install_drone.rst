Install the BeagleSystems Software on a drone
=============================================

To gain access to the repository, we first have to do some setup:

.. code-block:: sh

   $ git config --global http.postBuffer 524288000
   $ ssh-keygen -t rsa -b 4096 -C "your_email@beaglesystems.com"
   $ cat ~/.ssh/id_rsa.pub

Upload the public key to your github settings to be able to download the repository.

.. code-block:: sh

   mkdir Development
   cd Development
   git clone git@github.com:BeagleSystems/BeagleDroneContainers
   sudo cp BeagleDroneContainers/docker/docker-compose /usr/local/bin/docker-compose
   sudo cp -r BeagleDroneContainers/docker/udev/*.rules /etc/udev/rules.d/
   sudo udevadm control --reload
   sudo udevadm trigger
   

Create a file ~/.gitconfig with similar content as follows.

.. code-block:: sh

   [user]
       email = dayjaby@gmail.com
       name = David Jablonski
   [core]
       editor = vim
   [http]
       postBuffer = 524288000
   [url "git@github.com:"]
       insteadOf = https://github.com/
   [pull]
       rebase = true

Install nvidia docker runtime and docker itself:

.. code-block:: sh

   sudo apt update
   sudo apt install nvidia-container-runtime docker.io curl tmux openvpn
   sudo usermod -aG docker beagle


Create a /etc/systemd/system/socat-cubeorange.service file:

.. code-block:: sh

   [Unit]
   Description=tty to udp
   After=dev-cubeorange.device
   
   [Service]
   Type=simple
   Restart=on-failure
   RestartSec=5s
   ExecStart=socat file:/dev/cubeorange,nonblock,raw,echo=0 udp-sendto:127.0.0.1:5006
   
   [Install]
   WantedBy=cubeorange.target
   WantedBy=dev-cubeorange.device

Copy vpn profile to the drone, activate some services and download docker registry certificate:

.. code-block:: sh

   scp client*.ovpn beagle@192.168.178.125:~/beaglesystems.conf
   # On the drone:
   sudo mv ~/beaglesystems.conf /etc/openvpn/beaglesystems.conf
   sudo systemctl start openvpn@beaglesystems
   sudo systemctl enable openvpn@beaglesystems

   sudo systemctl start socat-cubeorange
   sudo systemctl enable socat-cubeorange

   sudo mkdir -p /etc/docker/certs.d/10.8.0.102:443
   sudo wget https://gist.githubusercontent.com/dayjaby/0580f38d022d5990907a62a662b253d7/raw/4b4dd1bc14a2b179938e0c1cab506178e8028a66/domain.crt -O /etc/docker/certs.d/10.8.0.102\:443/ca.crt
