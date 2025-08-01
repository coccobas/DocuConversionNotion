Docker guidelines
=================

Container base
--------------

When creating a new container, make sure to use one of the container bases in monorepo/containers/base.
This reduces the amount of space needed if multiple containers use the same base as already present layers can be re-used.

Example, instead of using a customer container base like `python:3.8.10-slim`, we can re-use our python container base:

.. code-block:: sh

   $ docker images | grep python
   python                                               3.10.14-alpine    e6dadeca64ce   11 months ago    49.9MB
   python                                               3.8.10-slim       add28abdb01c   4 years ago      114MB

If all containers use our python container base, we will not use more than 50MB for this type of containers in total,
assuming that the size of the python scripts themselves can be neglected.

The only exception to this rule is if trying to get some legacy code to work with older base versions.

More on this topic: https://docs.docker.com/build/building/best-practices/#choose-the-right-base-image

Dockerfile optimization
-----------------------

The biggest improvement can be done by using multi-stage builds. There are hundreds of guides out there
teaching how to do it properly. In our codebase this is especially true for PX4 firmware building:
Simulation builds and firmware builds have a common base stage. So even when trying different things,
like running simulations and building firmwares, many prerequisite layers can be reused.

Another important thing is to consider the order of instructions in the Dockerfile.
Usually it's good to put a `COPY . .` as late as possible to prevent unnecessary cache misses and
allow for faster transfer of the docker images.

On the contrary, any apt installs or similar long running installation commands should be done as soon as possible.



