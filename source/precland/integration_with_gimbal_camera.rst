Precision Landing Integration with Gimbal Camera
==========================================

.. mermaid::

    sequenceDiagram
        participant ORB as uORB
        participant VMN as gimbal_vmount
        participant GL as gimbal_lock_precland
        participant LT as landing_target_estimator
        participant PLD as precland
        participant ML as Mavlink
        
        participant GDC as gimbal_device_controller

        participant MR as mavros
        participant AR as aruco_map

        ORB --> GL: sub commander_state
        ORB --> GL: sub vtol_vehicle_status

        GL --> GL: if control in RTL mode and VTOL in MC mode

        rect rgb(120, 100, 200)
        loop if gimbal feedback status check timeout in 5s
            
            GL --> ORB: pub set_camera_focus
            ORB --> ML: MAV_CMD_SET_CAMERA_FOCUS (#532)
            ML --> GDC: MAV_CMD_SET_CAMERA_FOCUS (#532)
            GL --> ORB: pub set_camera_zoom
            ORB --> ML: MAV_CMD_SET_CAMERA_ZOOM (#531)
            ML --> GDC: MAV_CMD_SET_CAMERA_ZOOM (#531)

            GL --> ORB: pub gimbal_manager_set_attitude
            ORB --> VMN: GIMBAL_MANAGER_SET_ATTITUDE ( #282 )
            VMN --> ML: GIMBAL_DEVICE_SET_ATTITUDE ( #284 )
            ML --> GDC: GIMBAL_DEVICE_SET_ATTITUDE ( #284 )

            GDC --> ML: GIMBAL_DEVICE_ATTITUDE_STATUS ( #285 )
            ML --> VMN: GIMBAL_DEVICE_ATTITUDE_STATUS ( #285 )

            VMN --> ORB: gimbal_device_attitude_status
            ORB --> GL: sub gimbal_device_attitude_status

            GL --> GL: check if gimbal is lock to pitch -90 deg
            GL --> ORB: pub gimbal_lock_status
        end
        end

        rect rgb(100, 150, 200)
        alt PrecLand

            ORB --> LT: sub gimbal_lock_status
            LT --> LT: if using gimbal and locked:start the estimator

            AR --> MR: LANDING_TARGET (#149)
            MR --> ML: LANDING_TARGET (#149)

            ML --> ORB: irlock_report
            ORB --> LT: irlock_report
            LT --> PLD: pub landing_target_pose_filtered
            PLD --> PLD: do precland inside navigator

            PLD --> ORB: pub precland_status
        end
        end

        rect rgb(120, 100, 200)
        alt rest gimbal to safe position
            ORB --> GL: sub precland_status
            GL --> GL: check if gimbal can be free from precland
            GL --> ORB: pub gimbal_manager_set_attitude
            ORB --> VMN: GIMBAL_MANAGER_SET_ATTITUDE ( #282 )
            VMN --> ML: GIMBAL_DEVICE_SET_ATTITUDE ( #284 )
            ML --> GDC: GIMBAL_DEVICE_SET_ATTITUDE ( #284 )

            ORB --> GL: sub gimbal_device_attitude_status
            GL --> GL: check if gimbal is returned
            GL --> ORB: pub update gimbal_lock_status

        end
        end
