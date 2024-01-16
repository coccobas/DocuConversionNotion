# Deploying with SD Card Image

To deploy the image to new SD cards, follow these steps:

1. Insert the new SD card into your computer's SD card reader.

1. Download the SD card image from the our image folder: [Beagle Drone Image](http://.img).

1. Write the image to the SD card using a tool like `dd` or `Etcher`.

    ```bash
    lsblk
    sudo dd if=beagle_drone_clean.img of=/dev/mmcblk0 bs=4M status=progress
    ```

    Replace `/dev/mmcblk0` with the appropriate device identifier for your SD card.

1. Once the image is written, safely eject the SD card from your computer.

1. Insert the SD card into Jetson NANO on the drone and power it on.

1. Check the openvpn profile and replace it with the proper profile file matching the drone

    ```bash
    ifconfig

    # copy the right vpn profile from another laptop to Jetson NANO
    # NOTE:: this command runs on another laptop 
    scp client*.ovpn beagle@<local ip>:/tmp
    
    # back to the Jetson NANO
    sudo cp /tmp/client*.ovpn /etc/openvpn/beagle.conf
    sudo systemctl restart openvpn@beagle.service
    ```

1. Check the docker images and update if needed

    ```bash
    cd ~/Development/BeagleDroneContainers/docker
    docker ps -a
    
    # pull the latest develop images
    docker-compose pull
    ```

1. Change "Vehicle_Name" from redis, so it will run with right name after next restart
   Using the redis UI through web browser, open "<the ip address of Jetson>:7843"
   change "root:vehicle_name" to right id (e.g "M10")
   then restart the docker images

    ```bash
    docker-compose restart
    ```

1. then the new drone should be all set.
