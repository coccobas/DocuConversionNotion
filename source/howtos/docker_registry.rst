Using docker registry
=====================

Initially, it's necessary to download the certificate from the registry as it uses a self-signed certificate:

.. code-block:: sh

   sudo mkdir -p /etc/docker/certs.d/10.8.0.102:443
   sudo wget https://gist.githubusercontent.com/dayjaby/0580f38d022d5990907a62a662b253d7/raw/73ffd6108e1014ade9e7e93e71287f2889c42c24/domain.crt -O /etc/docker/certs.d/10.8.0.102\:443/ca.crt

Or, for Malaysia/aerodyne VPN network:

.. code-block:: sh

   sudo mkdir -p /etc/docker/certs.d/10.9.0.3:443
   sudo wget https://gist.githubusercontent.com/dayjaby/0580f38d022d5990907a62a662b253d7/raw/4b4dd1bc14a2b179938e0c1cab506178e8028a66/domain.crt -O /etc/docker/certs.d/10.9.0.3\:443/ca.crt
   
List all images in the registry and show all tags for a certain image:

.. code-block:: sh

   curl -k https://10.8.0.102:443/v2/_catalog
   curl -k https://127.0.0.1:443/v2/mavlink_router/tags/list

Delete images on registry

.. code-block:: sh

   ./bin/regctl image digest 10.8.0.102:443/ros_noetic:latest
   # sha256:72a0286fd1e1a6255df2c31091277d8babab645b38e9efa7ff43a30e6f6972da
   ./bin/regctl image delete 10.8.0.102:443/ros_noetic@sha256:72a0286fd1e1a6255df2c31091277d8babab645b38e9efa7ff43a30e6f6972da

Run garbage-collection on registry (WARNING: can take long)

.. code-block:: sh

   docker exec -it -u root registry bin/registry garbage-collect --delete-untagged /etc/docker/registry/config.yml
