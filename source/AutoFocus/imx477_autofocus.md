# Auto Focus Feature for ArduCam IMX477 (B0273)

### Hardware

* [Arducam 12MP 477P Motorized Focus High Quality Camera for NVIDIA® Jetson AGX Orin/Orin Nano/Orin NX](https://www.arducam.com/product/arducam-12mp-imx477-motorized-focus-high-quality-camera-for-jetson/)

### Official Support

* [demo](https://docs.arducam.com/Nvidia-Jetson-Camera/Motorized-Focus-Camera/quick-start/#demonstration)

* [MIPI_Camera](https://github.com/ArduCAM/MIPI_Camera/blob/master/Jetson/IMX477/AF_LENS/Autofocus.py)

### Integration with Monorepo

1. Fits in /container/ros_precland, because video capture processes are handled inside here, and we have OpenCV and gstreamer ready, also "i2cset" is easier using Python instead C++.

1. In another hand, set focus should be one function for camera_manager if we create a default driver for the camera, but camera_manager only handles SONY and EH2000 camera payload for now.

1. So we decided to keep this feature along inside ros_precland, but running it as a separate ROS node.

### Solution diagram

```{mermaid}

    sequenceDiagram
      participant BGC
      participant Redis
      participant camera_manager
      participant ros_precland
      BGC->camera_manager: set focus value (auto or some values, default is auto)
      camera_manager->Redis: root:autofocus:set_val

      Redis->ros_precland: set_val for i2cset
      ros_precland->ros_precland: if set_val=auto, do autofocus; else use set_val
      ros_precland->Redis: root:autofocus:current
```

In this way, the focus mode and value can be set through Redis


| redis key | camera_manager | ros_precland |
|-----------|----------------|--------------|
| root:autofocus:set_val | write | read only|
| root:autofocus:current | - | write |

### Redis configuration guide

| Key | value | comment |
| --- | ----- | ------- |
| root:autofocus:bus_id | 7 | if on CAM0, i2c-bus = 7, validate with dmesg |
| root:autofocus:set_value| 0 - 1000 | 0: auto; 10-1000: focus_distance |
| root:autofocus:current | 10-1000 | last i2cset value, <10 means error |