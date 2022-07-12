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
   
List all images in the registry and show all tags for a certain image:

..code-block:: sh

   curl -k https://10.8.0.102:443/v2/_catalog
   curl -k https://127.0.0.1:443/v2/mavlink_router/tags/list
