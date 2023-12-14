PX4 Simulation on Gazebo inside docker containers
=================================================

1. Install docker and docker-compose
------------------------------------

Basic requirements:

- Ubuntu 20.04 (Focal)
- Docker 20.10.21
- Docker-compose 1.29.2

.. code-block:: sh

    sudo apt update && sudo apt install docker.io


.. code-block:: sh

   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo usermod -aG docker $USER

2. Setup docker registry certification
--------------------------------------

.. code-block:: sh

   sudo mkdir -p /etc/docker/certs.d/10.8.0.102:443
   sudo wget https://gist.githubusercontent.com/dayjaby/0580f38d022d5990907a62a662b253d7/raw/4b4dd1bc14a2b179938e0c1cab506178e8028a66/domain.crt -O /etc/docker/certs.d/10.8.0.102\:443/ca.crt


3. Get the docker-comose file from github
-----------------------------------------

then need a github account to visit our organization repository

.. code-block:: sh

   git clone git@github.com:BeagleSystems/BeagleDroneContainers.git

Or only get the docker-compose file

.. code-block:: sh

   https://github.com/BeagleSystems/BeagleDroneContainers/blob/36a23e5226cd9fff9b95c4ae98ad0bf3c36662e3/docker/docker-compose.sim.yml


4. Pull the containers
----------------------

Check if VPN is connected by ping 10.8.0.1, if not, connect to VPN first.

.. code-block:: sh

   cd BeagleDroneContainers/docker
   docker-compose -f docker-compose.sim.yml pull


5. Run the containers
---------------------

.. code-block:: sh

   docker-compose -f docker-compose.sim.yml up -d

Or add alias to ~/.bash_aliases

.. code-block:: sh

   # simulation quick start
   alias px4sim-pull="cd ~/Development/BeagleDroneContainers/docker && docker-compose -f docker-compose.sim.yml pull"
   alias px4sim-up="cd ~/Development/BeagleDroneContainers/docker && docker-compose -f docker-compose.sim.yml up -d"
   alias px4sim-restart="cd ~/Development/BeagleDroneContainers/docker && docker-compose -f docker-compose.sim.yml restart"
   alias px4sim-down="cd ~/Development/BeagleDroneContainers/docker && docker-compose -f docker-compose.sim.yml down"

Then pull / up / down / restart can be called with these short alias from command line

6. Change takeoff location if needed
------------------------------------

Open http://127.0.0.1:7843 in browser

Change sim:home_lat, sim:home_lon, sim:home_alt in the UI, then restart the simulation container

.. code-block:: sh

   docker-compose -f docker-compose.sim.yml restart

7. Simulate Precision Landing
-----------------------------

Set the PX4 parameters for precland


  set LTEST_CAM_MODE to Fixed
    because there is no gimbal attach with the camera in the simulation model yet, will be improved later
  set RTL_PLD_MD to Conditional precision landing (3)
    need to use conditional precision landing mode to trigger our precision landing in Return mode

8. Setup different world mode
-----------------------------

TODO


9. Move around components in simulation world
---------------------------------------------

By default, the drone is spawned (2,2) meters away from the center of the landing map

can move the drone and landing map before takeoff to test different landing scenarios

TODO


