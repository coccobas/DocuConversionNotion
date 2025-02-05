# Build all the docker images locally

### How to build locally

In simulation folder, we can build all the images locally

```
cd simulation
./build_local.sh
```

__Note__: when local build runs, it will take 100% CPU and RAM, remember to save all the files and close unneccessary applications.


### Bash Script explain

```
docker buildx bake -f docker-bake.json --pull=false --load
```

Before running, make sure buildx is available on your local environment

check docker build x by command:

```
docker buildx ls
```
you will see the following:

```
docker buildx ls
NAME/NODE                                       DRIVER/ENDPOINT             STATUS   PLATFORMS
builder-4de94c0f-3935-4b2f-ba63-fbd462af75e9    docker-container                     
  builder-4de94c0f-3935-4b2f-ba63-fbd462af75e90 unix:///var/run/docker.sock inactive 
builder-bcc61c7b-9c9c-469b-93fe-848dbbf152df    docker-container                     
  builder-bcc61c7b-9c9c-469b-93fe-848dbbf152df0 unix:///var/run/docker.sock inactive 
localbuilder *                                  docker-container                     
  localbuilder0                                 unix:///var/run/docker.sock running  linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/amd64/v4, linux/arm64, linux/riscv64, linux/ppc64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
default                                         docker                               
  default                                       default                     running  linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/amd64/v4, linux/arm64, linux/riscv64, linux/ppc64, linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64, linux/arm/v7, linux/arm/v6
```



