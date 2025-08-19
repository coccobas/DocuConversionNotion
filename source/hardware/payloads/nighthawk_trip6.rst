.. _nighthawk_trip6-label:

#####################
Nighthawk Trip6 Setup
#####################

Redis settings
--------------

Add a new camera to `root:payload:configuration`. The broadcast port has to be modified
as well to a value given to you by someone taking care of the media server (Matt or David).

.. code-block:: json

   {
       ... ,
       "cam1": {
           "type": "pilot",
           "enabled": true,
           "mavlink_com_id": 100,
           "gimbal_comp_id": 171,
           "flip": false,
           "stream": {
               "bitrate": 200000,
               "sensor_id": 0,
               "framerate": 25,
               "stream_height": 1080,
               "stream_width": 1920,
               "gcs_port": 5600,
               "type": "rtsp",
               "location": "rtsp://192.168.0.203:554/live0",
               "allow_broadcast": true,
               "allow_record": true,
               "record_udp_port": 40101,
               "broadcast_address": "10.8.1.68",
               "broadcast_port": 5801
           }
       }
   }






