# Support ArduCAM IMX477 (B0273) FocusLen MIPI camera

### Hardware Specification
[ArduCAM IMX477](https://www.uctronics.com/imx477-12mp-high-quality-camera-motorized-focus-autofocus.html)

### Wiring
[Quickstart](https://docs.arducam.com/Nvidia-Jetson-Camera/Motorized-Focus-Camera/quick-start/)

For using IMX219 along with IMX477 on NANO b00 developer kit:
1. IMX477 should connects to CAM0 port
1. IMX219 should connects to CAM1 port

### Install Driver

```bash
cd ~
wget https://github.com/ArduCAM/MIPI_Camera/releases/download/v0.0.3/install_full.sh
chmod +x install_full.sh
./install_full.sh -m imx477
```

### Fix device tree problem

The default device tree installed by the above script is for a02 developer kit and only have one CAM CSI port, but we are using b00 developer kit, and have two CAM CSI ports.
The I2C bus id is wrong and it cannot control the focus len motor through I2CMux.

Fix Solution using Jetson-IO:

```bash
cat /etc/nv_tegra_release
```
recommend version is 

```
# R32 (release), REVISION: 7.1, GCID: 29818004, BOARD: t210ref, EABI: aarch64, DATE: Sat Feb 19 17:05:08 UTC 2022
```

```bash
sudo /opt/arducam/jetson-io/jetson-io.py
```
1. Select “Configure Jetson Nano CSI Connector” and Enter
1. Select “Configure for compatible hardware” and Enter
1. Select "Camera IMX477-A and IMX219-B" and Enter
1. Select "Save pin changes" and Enter
1. Select "Save and reboot to reconfigure pins" and Enter

you will see the generated dtb file and reboot to make it boot
```
Configuration saved to file
/boot/arducam/dts/tegra210-p3448-0000-p3449-0000-b00-user-custom.dtb
Press any key to reboot the system now or ctrl-c to abort
```

### Test the cameras

1. connect a display monitor

1. Start IMX477 with focus len control

```
cd ~/Development/MIPI_Camera/Jetson/IMX477/AF_LENS
python Autofocus.py -i 7
```

1. Start IMX219
```
gst-launch-v1.0 nvarguscamerasrc sensor_id=1 ! nvoverlaysink
```

### Fix Red Tint with ISP Tuning

* IMX219

```bash
wget https://www.arducam.com/downloads/Jetson/Camera_overrides.tar.gz
tar zxvf Camera_overrides.tar.gz
sudo cp camera_overrides.isp /var/nvidia/nvcam/settings/
sudo chmod 664 /var/nvidia/nvcam/settings/camera_overrides.isp
sudo chown root:root /var/nvidia/nvcam/settings/camera_overrides.isp
```

* IMX477

```bash
wget https://raw.githubusercontent.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3/master/li-camera-calibration-files/camera_overrides.isp
sudo cp camera_overrides.isp /var/nvidia/nvcam/settings/
sudo chmod 664 /var/nvidia/nvcam/settings/camera_overrides.isp
sudo chown root:root /var/nvidia/nvcam/settings/camera_overrides.isp
```
