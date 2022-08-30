Install the BeagleSystems Software on a drone Using Docker 
==========================================================

.. code-block:: sh

   $ git clone git@github.com:BeagleSystems/BeagleDroneContainers

Also need access to docker_registry server as in 

:ref:`_docker-registry-label <./docker_registry.rst>`

Pull the docker images from docker registery

.. code-block:: sh

   $ cd BeagleDroneContainers/docker
   $ ./docker-pull.sh
   $ docker images

   $ # Or docker-compose pull will do the same thing
   $ docker-compose pull

Check all the images to tag develop or latest

Start the docker images after Pull

.. code-block:: sh

   $ docker-compose up -d
   $ docker ps
