.. _ref-testing-appimages:

Testing your AppImage
=====================

Testing your AppImage is a very important step in producing an AppImage. Since AppImage files are supposed to run on a variety of Linux distributions, it is important to test your AppImage on a wide variety of distributions.

.. centered::
   **Test your AppImage on all base operating systems you are targeting!**

This is an important step which you should not skip. Subtle differences in distributions make this a must. While it is possible in most cases to create AppImages that run on various distributions, this does not come automatically, but requires careful hand-tuning.

To ensure that the AppImage runs on the intended base systems, it should be thoroughly tested on each of them. The following testing procedure is both efficient and effective: Get the current and the oldest still-supported version of Ubuntu, Fedora, and openSUSE Live CDs and test your AppImage there. Using the three largest distributions increases the chances that your AppImage will run on other distributions as well. Using the current and then oldest still-supported versions ensures that your end users can still run your AppImage as long as they use a supported version.

Using Live CDs has the advantage that unlike installed systems, you always have a system that is in a factory-fresh condition that can be easily reproduced. Most developers just test their software on their main working systems, which tend to be heavily customized through the installation of additional packages. By testing on Live CDs, you can be sure that end users will get the best experience possible.


.. contents:: Contents
   :local:
   :depth: 1


Using testappimage
------------------

You can use ISOs of Live CDs, loop-mount them, chroot into them, and run the AppImage there. This way, you need approximately 700 MB per supported base system (distribution) and can easily upgrade to newer versions by just exchanging one ISO file. The following script automates this for Ubuntu-like (Casper-based) and Fedora-like (Dract-based) Live ISOs:

.. code-block:: shell

   $ wget https://raw.githubusercontent.com/AppImage/AppImageKit/master/testappimage
   $ sudo bash testappimage /path/to/elementary-0.2-20110926.iso AppImageAssistant.AppImage


Using the Docker-based appimage-testsuite
-----------------------------------------

In addition to Live CD ISOs, it is possible to use Docker containers to test an AppImage package on a large variety of Linux distributions. This approach works for virtually any Linux distribution for which a base Docker container is available. For each of the supported distributions, there is a corresponding DockerFile that allows to build a container with a minimal set of dependencies needed to run an AppImage package.

Currently, only type2 AppImages that provide the ``--appimage-extract`` option are supported.

For example, to test an AppImage package on Ubuntu 18.04, the steps to be followed are:

.. code-block:: shell

   $ git clone https://github.com/aferrero2707/appimage-testsuite.git
   $ cd appimage-testsuite
   $ ./run.sh PATH_TO_APPIMAGE/package.AppImage ubuntu-18.04
   # /aitest/aitest.sh

The ``run.sh`` script will build the corresponding Docker container, determine the IP address of the host system, and run the container with convenient parameters. The host ``HOME`` folder is mapped to the ``/shared`` folder in the running container, and the X server is forwarded to the host system so that graphical applications can be correctly executed.

The following Linux distributions are supported out-of-the-box:

* Ubuntu 14.04, 16.04 and 18.04
* CentOS 6 and 7
* Fedora 26 and 27
* Debian stable and testing
* Manjaro (Arch Linux derivative)
* Sabayon (Gentoo Linux derivative)

Other distributions can be added by writing an appropriate Dockerfile.

Users might need to modify the ``run.sh`` script and change the line used to guess the host IP address:

.. code-block:: shell

   IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
