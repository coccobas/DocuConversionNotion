Compile and install MAVSDK
==========================

.. code-block:: sh

   sudo apt-get install build-essential cmake git
   sudo pip3 install protoc_gen_mavsdk
   cd ~/Development/beaglesystems
   git clone git@github.com:BeagleSystems/MAVSDK -b develop --recursive
   cd MAVSDK
   cmake -Bbuild/default -DCMAKE_BUILD_TYPE=Release -H.
   sudo cmake --build build/default --target install

If modifying the proto files, make sure to generate the corresponding .h and .cpp files:

.. code-block:: sh

   cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_MAVSDK_SERVER=ON -Bbuild/default -H. && tools/generate_from_protos.sh && tools/fix_style.sh .
   cmake --build build/default -j8 && sudo cmake --build build/default --target install


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
