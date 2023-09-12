Postprocessing images
=====================

Sentera
-------

We do the sentera postprocessing / geotag CSV creation in a jupyter notebook, running on the workshare station on the upper floor: http://10.8.1.44:8889/lab/tree/sentera.ipynb. For a new dataset only this part of the first cell needs to be modified:

.. code:: ipython3

    log = ULog("/home/david/2xD4K_sync/px4.ulg")
    
    cameras = [
        dict(prefix="L_", image_folder="/home/david/2xD4K_sync/L", rotation=Rotation.from_euler('x', 28, degrees=True) * Rotation.from_euler('z', 180, degrees=True)),
        dict(prefix="R_", image_folder="/home/david/2xD4K_sync/R", rotation=Rotation.from_euler('x', 28, degrees=True))
    ]

For each camera mounting, the rotation is also specified. The left sentera for example is rotated 28 degrees on the roll axis and 180 degrees on the yaw axis.
