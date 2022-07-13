Compile and install MAVSDK
==========================

Install MAVSDK by docker/deb
----------------------------

.. code-block:: sh

   cd ~/Development/beaglesystems/MAVSDK
   pushd docker
   docker build -f Dockerfile.dockcross-linux-arm64-custom -t mavsdk/mavsdk-dockcross-linux-arm64-custom .
   popd
   docker run --rm mavsdk/mavsdk-dockcross-linux-arm64-custom > ./dockcross-linux-arm64-custom
   chmod +x ./dockcross-linux-arm64-custom
   ./docker/dockcross-linux-arm64-custom /bin/bash -c "cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=build/linux-arm64/install -DBUILD_MAVSDK_SERVER=ON -DBUILD_SHARED_LIBS=ON -DWERROR=OFF -Bbuild/linux-arm64 -H."
   ./docker/dockcross-linux-arm64-custom /bin/bash -c "cmake --build build/linux-arm64 --target install -- -j4" && rm *.deb && ./docker/dockcross-linux-arm64-custom tools/create_packages.sh ./build/linux-arm64/install . arm64 libmavsdk-dev && mv libmavsdk-dev_*_arm64.deb libmavsdk-dev_arm64.deb
   tar czf - libmavsdk-dev_arm64.deb | ssh beagle@192.168.178.44 "tar -xvzf - -C /tmp"

   # Deploy it on hangar (TODO use github hosted .deb files, e.g. in release tags):
   scp libmavsdk-dev_arm64.deb house@10.8.0.66:~/BeagleHouse/addendums/MAVSDK/libmavsdk-dev_arm64.deb

[DEPRECATED] Install MAVSDK by source
-------------------------------------

.. code-block:: sh

   sudo apt-get install build-essential cmake git
   sudo pip3 install protoc_gen_mavsdk
   cd ~/Development/beaglesystems
   git clone git@github.com:BeagleSystems/MAVSDK -b develop --recursive
   cd MAVSDK
   cmake -Bbuild/default -DCMAKE_BUILD_TYPE=Release -H.
   sudo cmake --build build/default -j8 --target install

If modifying the proto files, make sure to generate the corresponding .h and .cpp files:

note: if you did not install clang-format before, please install it before you run "tools/fix_style.sh .", otherwise you will see thousands of differences related to style

.. code-block:: sh
   sudo apt install clang-format
   cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DBUILD_MAVSDK_SERVER=ON -Bbuild/default -H. && tools/generate_from_protos.sh && tools/fix_style.sh .
   sudo cmake --build build/default -j8 --target install


To compile an example (e.g. logfile_download), go to the ./examples/logfile_download directory and run the following:

.. code-block:: sh

   cmake -Bbuild -H. && cmake --build build -j4 && ./build/logfile_download udp://:24541

To install MAVSDK-Python:

.. code-block:: sh

   git clone git@github.com:BeagleSystems/MAVSDK-Python --recursive
   cd MAVSDK-Python
   sudo pip3 install -r requirements.txt
   sudo pip3 install -r requirements-dev.txt
   ./other/tools/run_protoc.sh
   cp ../MAVSDK/build/default/src/mavsdk_server/src/mavsdk_server mavsdk/bin/
   MAVSDK_BUILD_PURE=ON python3 setup.py build
   pip3 install -e .
