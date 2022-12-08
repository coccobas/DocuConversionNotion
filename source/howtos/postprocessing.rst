Postprocessing images
=====================

Install everything necessary for postprocessing:

.. code-block:: sh

   git clone git@github.com:BeagleSystems/pyulog
   cd pyulog 
   sudo python3 setup.py install
   cd ..

   git clone git@github.com:BeagleSystems/postprocessing
   cd postprocessing
   sudo python3 setup.py install

To run:

.. code-block:: sh

   align_dates

Select the .ulg PX4 log file and the folder containing all the images. The time parameters can be left as default. They only need to be adjusted when the time resolution of the output csv is not good enough.
