# Debugging for PX4 remote update firmware

### Requirements for installation

1. download the release package from github release page and extract all the folders under _releases_ folder.

1. run init.sh (or init_develop.sh for development)
   the script will install all the required libraries and mavsdk-router locally
    ```
    bash init.sh
    ```

### Run the remote update firmware webUI

```
cd releases/px4/
python manager.py
```

Then open browser, go to <drone_ip>:5000/update_firmware

select ".px4" file and click "update" button

cubeorange will automatically reboot after file uploaded, 
and start erase and flash afterwards.

### Debugging

1. check if the socat service is still running, this service has to be stopped for firmware update
    ```
        sudo systemctl stop socat-cubeorange.service
    ```
   and remember to restart it after the firmware update completes.
    ```
        sudo systemctl restart socat-cubeorange.service
    ```

2. check if the usb existed
    ```
        ls /dev/cubeorange
    ```
   if /dev/cubeorange is missing, check if the udev rule matches the usb info
   rules folder:
   ```
        cat /etc/udev/rules.d/90-beaglesystem.rules
   ```
   usb info:
   ```
        udevadm info -a /dev/serial/by-id/usb-CubePilot_CubeOrange_0-if00
   ```
   VendorID and ProductID have to match in these two.

   **This problem usually comes with a new batch of hardware that they renew the ProductID in latest batch.**


3. If file upload stuck on the webpage for 5 minutes, and the logs in "python manager" did not show any more information after the filename, need to check the libraries again by:

```
    pip3 install --user pyserial empty toml numpy pandas jinja2 pyyaml pyros-genmsg packaging
```

4. If it reporting python error, need to check the python version and make sure it's at least python3

    ```
        python --version
    ```
    if it shows python2.7, then we have to use python3 as default
    ```
        which python
        # usually it's /usr/bin/python
        sudo rm /usr/bin/python
        sudo ln -s /usr/bin/python3 /usr/bin/python
    ```


