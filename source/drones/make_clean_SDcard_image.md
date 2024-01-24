# Make an Image of SD Card from scratch for Drones 

## Introduction
In this guide, we will walk through the steps to create an SD card image contains all the software we need on Beagle Drones' Companion computer(Nvidia Jetson NANO).
This image can be used for deploy new drones quickly.

## Prerequisites
Before you begin, make sure you have the following:
- Ubuntu 20.04 or 22.04
- SD card reader
- Jetson NANO

## Steps

1. Follow the [Nvidia Jetson NANO quick start guide](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit) to set up your Jetson NANO board and download the original JetPack image file.

1. Flash JetPack image onto a new SD card (or reformated empty SD card) using Etcher.(This step is also the same as in the quick start guide)

1. Insert the SD card into Jetson NANO, connect a wifi dongle, keyboard and monitor.

1. Going through all the basic settings of ubuntu installation.

1. Install basic dependencies for drone software

    ```bash
    sudo apt-get update
    sudo apt-get install git make cmake libusb-dev python3 python3-dev python3-pip -y
    sudo apt-get install gcc build-essential -y
    sudo python3 -m pip install --upgrade pip
    ```

1. since we are not using python2 anymore, but in ubuntu18.04, the default python is still python2.7, so we need to replace the default python to python3.6+

    ```bash
    which python
    cd /usr/bin/
    sudo rm python
    sudo ln -s python3 python
    ```

1. setup personal ssh key for git, add id_rsa.pub to github account.

1. Install st-flash from source code to flash NUCLEO

    ```bash
    mkdir -p ~/Development && cd ~/Development
    git clone https://github.com/stlink-org/stlink
    cd stlink
    # checkout the latest release tag
    cmake .
    make

    # install the built result to right folder
    cd bin
    sudo cp st-* /usr/local/bin
    cd ../lib
    sudo cp *.so* /lib
    ```

1. Get all the neccessary file from BeagleDroneContainers [Install Drone](target "install-drone")

1. 1. clean the cache and free up space on ubuntu [Free up space ubuntu](target "free-up-space-ubuntu") before making the image.

1. Identify the device name of the source SD card by running the following command:
    ```bash
    lsblk
    ```
    Look for the entry that corresponds to your SD card (e.g., `/dev/mmcblk0`).
1. Once you have identified the device name, unmount any mounted partitions on the SD card by running the following command:
    ```bash
    umount /dev/mmcblk0*
    ```
    Replace `/dev/mmcblk0` with the appropriate device name.
1. Create an image of the SD card by running the following command:
    ```bash
    dd if=/dev/mmcblk0 of=/path/to/destination/image.img bs=4M status=progress
    ```
    Replace `/dev/sdb` with the appropriate device name and `/path/to/destination/image.img` with the desired path and filename for the image.
1. Wait for the `dd` command to complete. This may take some time depending on the size of the SD card.
1. Once the image creation is complete, safely remove the SD card from the reader.


## Conclusion
You have successfully created an image of SD card contains everything we need to run on the beagle drone. This image can now be used for backup or replication purposes.

## Additional Notes
- Make sure you have enough free disk space on your computer to store the image file.
- Take note of the device name of the source SD card to avoid accidentally overwriting data on other devices.
- Be cautious when using the `dd` command, as it can overwrite data if used incorrectly.
