Ports on the drone
==================

The following ports are used on the drone, all the ports are bidirectional:

.. graphviz::

    digraph Ports {
        "/dev/cubeorange"
        "mavsdk_router_1"
        "simulation SITL"
        "mavlink_router_px4"
        "mavsdk_server_px4"
        "mavsdkpy application"
        "mavsdk_server_gcs"
        "mavsdkcpp_camera_manager"
        "mavros"
        "ROS"
        "gcs_ping"
        "api_to_ros"
        "mavsdk_router_2"
        "mavlink_router_hangar"
        "mavlink_router_gcs"

        "/dev/cubeorange" -> "mavsdk_router_1"
        "mavsdk_router_1" -> "mavlink_router_px4" [ label="5006 if on drones" ]
        "simulation SITL" -> "mavlink_router_px4" [ label="14540 if on simulation" ]
        "mavlink_router_px4" -> "mavsdk_router_2" [ label="27550" ]
        "mavsdk_router_2" -> "mavlink_router_hangar" [ label="47550" ]
        "mavsdk_router_2" -> "mavlink_router_gcs" [ label="37550" ]
        "mavlink_router_gcs" -> "mavsdk_server_gcs" [ label="35550" ]
        "mavsdk_server_gcs" -> "mavsdkpy application" [ label="50052" ]
        "mavsdk_server_gcs" -> "mavsdkcpp_camera_manager" [ label="36550" ]
        "mavlink_router_px4" -> "mavsdk_server_px4" [ label="25550" ]
        "mavsdk_server_px4" -> "mavsdkpy application" [ label="50051" ]
        "mavlink_router_px4" -> "mavsdkcpp_camera_manager" [ label="26550" ]
        "mavlink_router_px4" -> "mavros" [ label="24550" ]
        "mavros" -> "ROS" [ label="11311" ]
        "gcs_ping" -> "mavros" [ label="5005" ]
        "api_to_ros" -> "ROS" [ label="5020" ]
    }