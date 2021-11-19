Precision Landing Integration with Gimbal Camera
================================================

.. mermaid::

    sequenceDiagram
        participant AR as aruco_map

        participant LT as landing_target_estimator
        participant PLD as precland
        participant GL as gimbal_lock_precland
        participant VMN as gimbal_vmount
        
        participant GDC as gimbal_device_controller


        GL ->> GL: if control in RTL mode and VTOL in MC mode

        rect rgb(120, 100, 200)
        loop if gimbal feedback status check timeout in 5s
            
            GL ->> GDC: MAV_CMD_SET_CAMERA_FOCUS
            GL ->> GDC: MAV_CMD_SET_CAMERA_ZOOM

            GL ->> VMN: gimbal_manager_set_attitude
            VMN ->> GDC: GIMBAL_DEVICE_SET_ATTITUDE

            GDC ->> GL: GIMBAL_DEVICE_ATTITUDE_STATUS

            GL ->> GL: check if gimbal is lock to pitch -90 deg
            GL ->> LT: gimbal_lock_status
        end
        end

        rect rgb(100, 150, 200)
        alt PrecLand

            LT ->> LT: if gimbal locked facing down: start the estimator

            AR ->> LT: LANDING_TARGET/irlock_report
            LT ->> PLD: landing_target_pose_filtered
            PLD ->> PLD: do precland inside navigator

            PLD ->> GL: precland_status
        end
        end

        rect rgb(120, 100, 200)
        alt reset gimbal to safe position
            GL ->> GL: check if gimbal can be free from precland
            GL ->> VMN: gimbal_manager_set_attitude: look forward
            VMN ->> GDC: GIMBAL_DEVICE_SET_ATTITUDE

            GDC ->> GL: GIMBAL_DEVICE_ATTITUDE_STATUS
            GL ->> GL: check if gimbal is looking forward

        end
        end
