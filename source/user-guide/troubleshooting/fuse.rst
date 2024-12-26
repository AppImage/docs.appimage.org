.. include:: ../../substitutions.rst

.. _fuse-troubleshooting:

I get some errors related to something called "FUSE"
====================================================

Most AppImages require the second version of a Linux technology called *Filesystem in Userspace*, or short *FUSE*. Many systems ship with a working FUSE 2 setup out of the box. However, if yours doesn't, your AppImage might write the following message to the console:

.. code-block:: text

   AppImages require FUSE to run.
   You might still be able to extract the contents of this AppImage
   if you run it with the --appimage-extract option.
   See https://github.com/AppImage/AppImageKit/wiki/FUSE
   for more information

In this case, you need to :ref:`install FUSE 2 <install-fuse>` manually or use a workaround to run AppImages without FUSE. This page explains on how to do this.

|fuse_docker|

..
   You can't include code blocks in substitutions; therefore this block is duplicated.

.. code-block:: text

      fuse: failed to open /dev/fuse: Operation not permitted
      Could not mount AppImage
      Please see https://github.com/probonopd/AppImageKit/wiki/FUSE

If you want to run an AppImage inside a docker container, follow the instructions at :ref:`fuse_docker` instead.

.. note::
   When trying to run an AppImages which wasn't built for your architecture (e.g. a 32-bit one), you might see this message as well, even if it doesn't occur while using AppImages built for your architecture. In that case, you have to install the FUSE 2 runtime library for the architecture the AppImage was built for.


.. contents:: Contents
   :local:
   :depth: 2


.. _install-fuse:

How to install FUSE 2
---------------------

Most Linux distributions come with a functional FUSE 2 setup. However, if it's not working for you, you may have to install FUSE 2 yourself.

The process of installing FUSE 2 highly differs from distribution to distribution. This section shows how to install FUSE on the most common distributions.

.. note::
   If your distribution is not listed, please ask the distribution developers for instructions.


.. _fuse_ubuntu_new:

Setting up FUSE 2 alongside of FUSE 3 on recent Ubuntu (>=22.04), Debian and their derivatives
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. note::

   This is valid only for recent distributions having :code:`fuse3` installed by default. To be sure, check whether the :code:`fuse3` package is installed, e.g. by running :code:`dpkg -l | grep fuse3` in the terminal and checking for a line starting with :code:`ii  fuse3` (if there is none, your distribution is not using :code:`fuse3`).

   If your distribution is not using :code:`fuse3`, please refer to the :ref:`next section <fuse_ubuntu_old>`.

First, add the official repository with FUSE 2 with ``sudo add-apt-repository universe``. Then, install it with ``sudo apt install libfuse2t64`` for Ubuntu >= 24.04 or ``sudo apt install libfuse2`` for Ubuntu >= 22.04 and < 24.04 (the package has been renamed in Ubuntu 24.04). Now, FUSE 2 should be working alongside of FUSE 3.

To install the 32-bit version of FUSE 2, use ``sudo apt install libfuse2:i386`` on ``x86_64`` or ``sudo apt install libfuse2:armhf`` on ``arm64``.

.. todo::
   Add information on how to install the 32-bit version on newer versions after the rename.


.. _fuse_ubuntu_old:

Setting up FUSE 2 on old Ubuntu (pre-22.04), Debian and their derivatives
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. warning::

   This is valid only for older distributions *not* having ``fuse3`` installed by default. To be sure, check whether the :code:`fuse3` package is installed, e.g. by running :code:`dpkg -l | grep fuse3` in the terminal and checking for a line starting with :code:`ii  fuse3`.

   If your distribution is using :code:`fuse3`, please refer to the :ref:`previous section <fuse_ubuntu_new>`.

   Installing the ``fuse`` package with ``fuse3`` installed might break your system! If this happened to you, follow `these instructions <https://github.com/orgs/AppImage/discussions/1339>`_ to recover your system.

Install FUSE 2 with ``sudo apt install fuse libfuse2``. Now, it should be working. On some older distributions, you will have to run some additional configuration steps:

.. code-block:: shell

   # Make sure the FUSE kernel module is loaded
   > sudo modprobe -v fuse
   # Then add the required group and add your user account to the group
   # This should usually be created by the install command; if this is the case this will fail
   # Then, you don't have to do anything else
   > sudo groupadd fuse
   > sudo usermod -aG fuse "$(whoami)"

|group_user_add|


Setting up FUSE 2 on Fedora
+++++++++++++++++++++++++++

Install FUSE 2 with ``dnf install fuse fuse-libs``.


Setting up FUSE 2 on RHEL
+++++++++++++++++++++++++

.. note::
   The following instructions might be out of date. Contributions to update them are welcome!

Install FUSE 2 from EPEL with ``yum --enablerepo=epel install fuse-sshfs``. Then, add yourself to the related group in order to authorize yourself for using FUSE with ``sudo usermod -aG fuse "$(whoami)"``. |group_user_add|


Setting up FUSE 2 on Arch Linux
+++++++++++++++++++++++++++++++

Install FUSE 2 with ``sudo pacman -S fuse2``.

A common issue, however, is that the ``fusermount`` binary's permissions may be incorrect. In that case, you would see the error message "fusermount: mount failed: Operation not permitted". Fortunately, you can easily fix this with the command ``sudo chmod u+s "$(which fusermount)"``.


Setting up FUSE 2 on openSUSE
+++++++++++++++++++++++++++++

Install FUSE 2 with ``sudo zypper install fuse libfuse2``.

In order to use ``fusermount`` on openSUSE with the "secure" file permission settings (see ``/etc/permissions.secure``), your user needs to be part of the trusted group. To add yourself, run ``sudo usermod -a -G trusted "$(whoami)"``. |group_user_add|


Setting up FUSE 2 on Chromium OS, Chrome OS, Crostini or other derivatives
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Install FUSE 2 with ``sudo apt install fuse``.


Setting up FUSE 2 on Clear Linux OS
+++++++++++++++++++++++++++++++++++

On Clear Linux OS, FUSE *should* be enabled by default. However, if you see the error message mentioned before nevertheless, you can try the following:

.. code-block:: shell

   sudo mkdir -p /etc/modules-load.d/
   echo "fuse" > /etc/modules-load.d/fuse.conf
   sudo reboot

.. seealso::

   This bug was also `reported on GitHub <https://github.com/clearlinux/distribution/issues/273>`_.


.. _fuse-fallback:

Fallback (if FUSE can't be made working)
----------------------------------------

If you don't want to (or cannot) set up FUSE, there are fallback solutions. Depending on the AppImage type, you can either run it with a specific parameter (which will work for you like it would with FUSE) or manually extract or mount and then execute it. However, this is computationally more expensive, so it should usually only be done if you can't run it normally.


Run type 2 AppImages without FUSE
+++++++++++++++++++++++++++++++++

Newer type 2 AppImages can easily be run |appimages_without_fuse|. This will cause the runtime to automatically extract the AppImage, run its content, wait until the app closes, and then clean up the file again. For an end user, this essentially has the same effect as just running it, although the operations are more expensive.

Alternatively, you could also use an environment variable (``export APPIMAGE_EXTRACT_AND_RUN=1``) (which is forwarded to child processes as well) instead of the parameter (although this has been introduced a while after the parameter, so it might not work for every AppImage).

Optionally, you can also disable the cleanup, e.g. if you need to run the AppImage more than once, with an environmental variable: ``export NO_CLEANUP=1``.


Manually extract and run AppImages
++++++++++++++++++++++++++++++++++

Alternatively, you can manually extract or mount an AppImage in any way described in :ref:`inspect_appimage_content`. After that, you can run the ``AppRun`` entry point in the directory the AppImage has been extracted to or mounted on: ``appimage_directory/AppRun``.

This mostly makes sense if you have an older AppImage which doesn't support the ``--appimage-extract-and-run`` parameter.


.. _fuse_docker:

FUSE and Docker
---------------

|fuse_docker|

..
   You can't include code blocks in substitutions; therefore this block is duplicated.

.. code-block:: text

      fuse: failed to open /dev/fuse: Operation not permitted
      Could not mount AppImage
      Please see https://github.com/probonopd/AppImageKit/wiki/FUSE

Instead, you can extract and run AppImages as described in the :ref:`previous section <fuse-fallback>`.

If you want to decide whether to use the AppImage without FUSE or directly depending on whether you're in a container or not, for example in a build script, you can do that with some `detection code <https://stackoverflow.com/a/23575107>`_.

.. warning::

   There's a lot of advice on the internet that follows the scheme "just add the arguments ``--cap-add SYS_ADMIN --cap-add MKNOD --device /dev/fuse:mrw`` and it will work". It is, however, insecure to do so. There's a reason why Docker doesn't support FUSE by default.
