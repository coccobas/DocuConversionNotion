Using docker registry
=====================

Initially, it's necessary to download the certificate from the registry as it uses a self-signed certificate:
..code-block:: sh
   sudo mkdir -p /etc/docker/certs.d/10.8.0.102:443
   scp david@10.8.0.102:~/certs/domain.crt /etc/docker/certs.d/10.8.0.102\:443/ca.crt

To push an image, it has to be retagged first:
..code-block:: sh
   docker tag mavlink_router:latest 10.8.0.102:443/mavlink_router
   docker push 10.8.0.102:443/mavlink_router
   
