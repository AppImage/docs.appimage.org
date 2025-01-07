.. _testing-appimages:

Testing your AppImage
=====================

Testing your AppImage is an important step you shouldn't skip when producing it. Since AppImages are supposed to run on a variety of Linux distributions, it is important to test your AppImage on a wide variety of distributions.

.. centered::
   **Test your AppImage on all base operating systems you are targeting!**

Subtle differences in distributions make this necessary. While most AppImages run on various distributions, this can sometimes require hand-tuning; therefore AppImages should always be thoroughly tested on several base systems.

We recommend to test your AppImage on both the current and the oldest still-supported version of Ubuntu, Fedora and openSUSE each. Using three of the largest distributions increases the chances that your AppImage will run on other distributions as well. Using the current and the oldest still-supported versions ensures that your end users can still run your AppImage as long as they use a supported version.

.. contents:: Contents
   :local:
   :depth: 1


Using live images
-----------------

Using live images has the advantage that unlike installed systems, you always have a system that is in a factory-fresh condition that can be easily reproduced. Many developers just test their software on their main working systems, which tend to be heavily customized through the installation of additional packages. By testing on live images, you can be sure that the AppImage will also work on different systems.

If you use live images, you should get one of each base system version you want to test your AppImage on. You can then boot each live image (as ISO file) in a virtual machine (using a virtual machine application) to test your AppImage on it.


Using Docker
------------

Alternatively to live images, you can use docker containers to test an AppImage on different Linux distributions.

The following script can be used to run the given AppImage in the given distribution docker container. The distribution container must be either locally installed or available on `Docker Hub <https://hub.docker.com>`_. Your system must use X.Org for this to work with GUI AppImages.

.. code-block:: shell

   # Take the given AppImage path and distribution container
   appimage="MyApplication.AppImage"
   distro="ubuntu:latest"

   # Allow the docker container to connect to your host X11 server (required for GUI applications)
   xhost + local:

   # Start the docker container and enter its shell
   sudo docker run --rm -it -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$appimage":/AppImage -v "$HOME":/shared --cap-add=SYS_PTRACE --security-opt seccomp:unconfined ${distro} bash

   # Install system packages and default packages that are expected on any target OS (inside the docker container)
   # You can see the full excludelist of packages that may be expected at https://github.com/AppImage/pkg2appimage/blob/master/excludelist
   # Some examples of packages that could be installed are:
   # On Ubuntu:
   apt update && apt install -y software-properties-common libx11-6 libgl1 libglx-mesa0 expat binutils fontconfig libsm6 libgomp1 dbus desktop-file-utils xorg libasound2t64
   # On Fedora:
   dnf update -y && dnf install -y xorg-x11-server-Xorg fontconfig binutils findutils mesa-libEGL libSM dbus-tools mesa-dri-drivers

   # Run the AppImage (inside the docker container)
   /AppImage --appimage-extract-and-run

(Credits: `Original scripts <https://github.com/aferrero2707/appimage-testsuite>`_ by `aferrero2707 <https://github.com/aferrero2707>`_; improvements by `Korne127 <https://github.com/Korne127>`_.)

.. todo::
   Update this script to also support Wayland.
