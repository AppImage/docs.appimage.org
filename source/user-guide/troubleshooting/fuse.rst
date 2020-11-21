.. _ref-ug-troubleshooting-fuse:

I get some errors related to something called "FUSE"
====================================================

AppImages require a Linux technology called *Filesystem in Userspace* (or short *FUSE*). The majority of systems ships with a working FUSE setup. However, sometimes, it doesn't quite work. This section explains a few solutions that fix the most frequently reported problems.

.. contents:: Contents
   :local:
   :depth: 2


The AppImage tells me it needs FUSE to run
------------------------------------------

Sometimes, an AppImage writes the following message to the console:

.. can not use :: syntax to highlight raw text blocks, as pygments usually recognizes some language even if there is no code
.. code-block:: text

   AppImages require FUSE to run.
   You might still be able to extract the contents of this AppImage
   if you run it with the --appimage-extract option.
   See https://github.com/AppImage/AppImageKit/wiki/FUSE
   for more information

In this case, FUSE is not properly set up on your system. You will have to :ref:`install FUSE <ref-install-fuse>` in order to fix the problem.

.. note::
   When trying to run AppImages which weren't built specifically for your platform, you might see this message as well, even if it doesn't occur while using AppImages built for your platform. Please see :ref:`these instructions <ref-warning-fuse-cross-architecture>` on how to fix the issue.


.. _ref-install-fuse:

How to install FUSE
-------------------

Most Linux distributions come with a functional FUSE setup. However, if it is not working for you, you may have to install and configure FUSE yourself.

The process of installing FUSE highly differs from distribution to distribution. This section shows how to install FUSE on the most common distributions.

.. note::
   If your distribution is not listed, please ask the distribution developers for instructions.


Setting up FUSE on Ubuntu, Debian and their derivatives
*******************************************************

Install the required package::

  > sudo apt-get install fuse

Now, FUSE should be working. On some older distributions, you will have to run some additional configuration steps:

Make sure the FUSE kernel module is loaded::

  > sudo modprobe -v fuse

Then, add the required group (should be created by the install command, if this is the case, this call *will* fail), and add your own user account to this group::

  > sudo addgroup fuse
  > sudo adduser $USER fuse

.. include:: notes/user-group-modifications.rst


Setting up FUSE on openSUSE
***************************

Install the required package::

  > sudo zypper install fuse

FUSE should now be working.


Setting up FUSE on CentOS and RHEL
**********************************

.. note::
   The following instructions may be out of date. Contributions welcome!

Install FUSE from EPEL::

  > yum --enablerepo=epel install fuse-sshfs

Now, add yourself to the related group in order to authorize yourself for using FUSE::

  > usermod -a -G fuse $(whoami)

.. include:: notes/user-group-modifications.rst

.. _ref-warning-fuse-cross-architecture:
.. warning::
   If you are on a 64-bit system and want to run 32-bit AppImages (e.g., ``x86_64``/``amd64`` to ``i386``, or ``arm64`` to ``armhf``), you will have to install the FUSE runtime libraries for those architectures.::

     > sudo apt-get install libfuse2:i386
     > sudo apt-get install libfuse2:armhf


Setting up FUSE on Clear Linux OS
*********************************

On Clear Linux OS, FUSE _should_ be enabled by default. However, if you see the error message mentioned before nevertheless, you can try the following trick:

.. code-block:: shell

   sudo mkdir -p /etc/modules-load.d/
   echo "fuse" | sudo tee /etc/modules-load.d/fuse.conf
   sudo reboot

.. seealso::

   This bug was also reported on `reported on GitHub <https://github.com/clearlinux/distribution/issues/273>`_.


Setting up FUSE on Chromium OS, Chrome OS, Crostini or other derivatives
************************************************************************

FUSE is not operational out of the box. However, starting with release 73, it's fairly easy to install it:

.. code-block:: shell

   sudo apt install fuse


Setting up FUSE on Arch Linux
*****************************

On Arch Linux, FUSE should work already. A common issue, however, is that the ``fusermount`` binary's permissions may be incorrect. Fortunately, there's an easy fix:

.. code-block:: shell

   # bash, dash, bourne shell:
   sudo chmod u+s "$(which fusermount)"

   # fish shell:
   sudo chmod u+s (which fusermount)

