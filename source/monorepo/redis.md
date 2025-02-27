# Redis

### Overview

**Basic rules for redis:**

- common parameters should under <feature>:configuration,
    
        e.g. root:payload:configuration,  
             root:mqtt:configuration, 
    
- only unique key/value for each drone/hangar directly under root
    
        e.g   root:vehicle_name

- any pubsub value should be a separate key outside the top configuration value

        e.g root:payload:cam1:focus:set

- if we try to keep all the options inside redis, and make a key to choose from one or more from the options, then some folder should be read only, e.g. root:cameras:* contains calibration matrix. redis_ui might not be a good choice for us anymore in this case, we should consider adding another layer as better user interface on top of redis.


### Structure

```plaintext
redis:6379
├── root
│   ├── vehicle_name
│   ├── payload
│   │   └── configuration
│   │   └── <payload_id>*
│   │       ├── focus
│   │       │   └── set(%)
│   │       │   └── current
│   │       │   └── clarity
│   │       └── bitrate(%)
│   ├── mqtt
│   │   └── configuration
│   ├── log_uploader
│   │   ├── configuration
│   │   └── state(%)
│   ├── rtk
│   │   ├── configuration
│   │   └── debug_value
│   └── cameras
│       └── <camera_id>**
│           └── camera_info
```
*<payload_id> should be included in root:payload:configuration

**<camera_id> folder only contains static parameter related to the camera hardware, like the calibration_matrix etc.

% this redis key is for pubsub

### Table View

| Key                                      | Reader          | Writer          | PubSub |
|------------------------------------------|-----------------|-----------------|--------|
| root:vehicle_name                        | all containers  | redis_ui        | No     |
| root:payload:configuration               | payload_manager | redis_ui        | No     |
| root:payload:<payload_id>:record:set     | camera_handler  | camera_manager  | Yes    |
| root:payload:<payload_id>:record:current | camera_manager  | camera_handler  | Yes    |
| root:payload:<payload_id>:focus:set      | camera_handler  | redis_ui        | Yes    |
| root:payload:<payload_id>:focus:current  | debug           | camera_handler  | No     |
| root:payload:<payload_id>:focus:clarity  | debug           | camera_handler  | No     |
| root:payload:<payload_id>:bitrate        | -               | stream          | Yes    |
| root:mqtt:configuration                  | -               | redis_ui        | No     |
| root:log_uploader:configuration          | log_uploader    | redis_ui        | No     |
| root:log_uploader:state                  | debug           | log_uploader    | Yes    |
| root:rtk:configuration                   | rtk_client      | redis_ui        | No     |
| root:rtk:debug_value                     | -               | rtk_client      | No     |
| root:cameras:<camera_id>:camera_info     | cv_camera       | redis_ui        | No     |
