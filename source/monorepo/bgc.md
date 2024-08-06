# BeagleGroundControl

### Folder in monorepo

```
/tools/bgc/
```

### How to get the latest release version

* from github release page: [Github Release](https://github.com/BeagleSystems/monorepo/releases)

* from file share server: [BGC Releases](http://10.8.0.102:36363/bgc/refs/tags/)

### How to build locally

For developer, sometime we have to build a local version to test before push to repository

1. Build the build environment docker image

    ```
    cd tools/bgc
    ./setup_local_docker.sh
    ```

1. Local build

    ```
    ./build_local.sh
    ```

1. after the build complete, start the local BGC and test

    ```
    cd build/staging
    ./QGroundControl
    ```

### related workflow actions

* Develop workflow:

    * Build docker build environment and publish to docker registry (tagged with develop)
    * Use the docker image to build 

* Release workflow:

    * Build docker build environment and publish to docker registry (tagged with release version)
    * Use the docker image to build 
    * package the build folder to appImage
    * 