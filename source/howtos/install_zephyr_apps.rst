Install Zephyr Apps on embedded devices like the Nucleo
=======================================================

Instead of building the apps yourself, you can also download the latest firmwares from the docker builds:

.. code-block:: sh

   curl -k "https://10.8.0.102:443/v2/beaglesystems/gimbal_device_nucleo_nucleo_f446re/blobs/$(curl -k "https://10.8.0.102:443/v2/beaglesystems/gimbal_device_nucleo_nucleo_f446re/manifests/develop" | jq -r .fsLayers[1].blobSum)" | tar --strip-components 5 -Oxzf - home/user/app/build/zephyr/zephyr.bin > zephyr.bin
   st-flash --serial /dev/ttyACM0 write zephyr.bin 0x8000000

Run the following installation process on an Ubuntu 20.04 computer:

.. code-block:: sh

   sudo apt update
   sudo apt install --no-install-recommends git cmake ninja-build gperf   ccache dfu-util device-tree-compiler wget   python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file   make gcc gcc-multilib g++-multilib libsdl2-dev screen
   sudo pip3 install west
   
   cd /tmp
   wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.13.2/zephyr-sdk-0.13.2-linux-x86_64-setup.run
   chmod +x zephyr-sdk-0.13.2-linux-x86_64-setup.run
   ./zephyr-sdk-0.13.2-linux-x86_64-setup.run -- -d ~/zephyr-sdk-0.13.2
   
   mkdir -p ~/Development/beaglesystems/zephyr
   cd ~/Development/beaglesystems/zephyr
   git clone https://github.com/BeagleSystems/zephyr
   west init -m https://github.com/BeagleSystems/zephyr --mr develop
   west update
   west zephyr-export
   pip3 install --user -r ~/Development/beaglesystems/zephyr/zephyr/scripts/requirements.txt
   sudo cp ~/zephyr-sdk-0.13.2/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
   sudo udevadm control --reload
   
   echo "source ~/Development/beaglesystems/zephyr/zephyr/zephyr-env.sh" >> ~/.bashrc
   source ~/.bashrc
   
   cd ~/Development/beaglesystems
   git clone git@github.com:BeagleSystems/zephyr_apps
   cd zephyr_apps/eh2000_mavlink
   ./flash.sh

For debugging, you might want to see the debug output from the nucleo:

.. code-block:: sh

   screen /dev/ttyACM0 115200 8N1

To quit the screen, just type ctrl+a :quit (a colon before quit).

Added for STM32F303 Olimexino

For upload firmware to flash without ST-LINK, first press reset button and press boot button at same time, then release
only one red LED will left on the board, then upload the bin file to flash:

.. code-block:: sh

   dfu-util -a 0 -D build/zephyr/zephyr.bin -s 0x08000000

