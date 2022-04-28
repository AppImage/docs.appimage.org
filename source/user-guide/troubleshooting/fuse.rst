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

Most Linux distributions come with a functional FUSE 2.x setup. However, if it is not working for you, you may have to install and configure FUSE 2.y yourself.

The process of installing FUSE highly differs from distribution to distribution. This section shows how to install FUSE on the most common distributions.

.. note::
   If your distribution is not listed, please ask the distribution developers for instructions.


Setting up FUSE 2.x on Ubuntu (pre-22.04), Debian and their derivatives
***********************************************************************

.. warning::
    This is valid only for distributions **not having** `fuse3` installed by default.  
    
    To be sure, enter `dpkg -l|grep fuse3`  
    
    If you see a line starting with `ii  fuse3`, please refer to the next section.

Install the required packages::

  > sudo apt-get install fuse libfuse2

Now, FUSE should be working. On some older distributions, you will have to run some additional configuration steps:

Make sure the FUSE kernel module is loaded::

  > sudo modprobe -v fuse

Then, add the required group (should be created by the install command, if this is the case, this call *will* fail), and add your own user account to this group::

  > sudo addgroup fuse
  > sudo adduser $USER fuse

.. include:: notes/user-group-modifications.rst

Setting up FUSE 2.x alongside of FUSE 3.x on recent Ubuntu (>=22.04), Debian and their derivatives 
**************************************************************************************************

.. warning::
    This is valid only for recent distributions **having** `fuse3` installed by default.  
    
    To be sure, enter `dpkg -l|grep fuse3`  
    
    If you see a line starting with `ii  fuse3`, be sure **not to install** the `fuse` package which would remove packages very important for your system.  

Install the required package::

  > sudo apt install libfuse2

Now, FUSE 2.x should be working alongside of FUSE 3.x without breaking your system.

Setting up FUSE 2.x on openSUSE
*******************************

Install the required package::

  > sudo zypper install fuse libfuse2

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

On Clear Linux OS, FUSE *should* be enabled by default. However, if you see the error message mentioned before nevertheless, you can try the following trick:

.. code-block:: shell

   sudo mkdir -p /etc/modules-load.d/
   echo "fuse" | sudo tee /etc/modules-load.d/fuse.conf
   sudo reboot

.. seealso::

   This bug was also reported on `reported on GitHub <https://github.com/clearlinux/distribution/issues/273>`__.


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


.. _ref-fuse-fallback:

Fallback (if FUSE can't be made working)
----------------------------------------

If you do not want to (or cannot) set up FUSE, there are fallback solutions. Depending on the AppImage type, you can either mount the AppImage, or extract it and run the contents.


.. _ref-extract-and-run-type-2:

Extract and run type 2 AppImages
********************************

Most AppImages nowadays are type 2 AppImages. The easiest way to run such an AppImage, if FUSE is not available, is to extract it and then run its contents.

.. warning::
   Extracting an AppImage to run its contents is pretty expensive. It should only be done if you have no other options left.


The AppImage runtime has a built-in feature we call "extract-and-run". It extracts the AppImage, runs the contents, waits until the app closes, and then cleans up the files again:

.. code-block:: shell

   # using a parameter
   ./my.AppImage --appimage-extract-and-run [...]

   # using an environment variable (which is usually forwarded to AppImage child processes, too)
   # note that this was implemented a while after we introduced the parameter
   # for older AppImages, you might have to use the parameter nevertheless
   export APPIMAGE_EXTRACT_AND_RUN=1
   ./my.AppImage [...]

   # optionally, you can disable the cleanup if you need to run the AppImage more than once
   export APPIMAGE_EXTRACT_AND_RUN=1
   env NO_CLEANUP=1 ./my.AppImage

In case you have a very old AppImage (i.e., it uses a runtime from the time before "extract-and-run" was implemented), you can extract the AppImage manually:

.. code-block:: shell

   ./my.AppImage --appimage-extract
   # the contents are extracted into the directory "squashfs-root" in the current working directory
   # you can now run the "AppRun" entry point
   squashfs-root/AppRun [...]
   # optionally, you can clean up the directory again
   rm -r squashfs-root/


Mount or extract type 1 AppImages
*********************************

If the process described in the :ref:`previous section <ref-extract-and-run-type-2>` does not work, you likely have a type 1 AppImage.

Type 1 AppImages are regular ISO9660 files. They can therefore be *loop-mounted*. Note that you need ``root`` permissions to do so.

.. code-block:: shell

   sudo mount -o loop my.AppImage /mnt
   # now, you can run the contents
   /mnt/AppRun
   # when you're done, you can unmount the AppImage again
   sudo unmount /mnt

You can alternatively extract the AppImage, either using `AppImageExtract <https://github.com/AppImage/AppImageKit/releases/tag/6>`__ or using an extraction tool which supports ISO9660 images (e.g., ``bsdtar``):

.. code-block:: shell

   # install bsdtar
   sudo apt install libarchive-tools
   # create target directory
   mkdir AppDir
   # extract the contents into the new directory
   cd AppDir
   bsdtar xfp .../my.AppImage
   # now, you can run the entry point
   ./AppRun


FUSE and Docker
---------------

Most Docker installations do not permit the use FUSE inside containers for security reasons. Instead, you can extract and run AppImages as described in the :ref:`previous section <ref-fuse-fallback>`.

.. warning::

   There's a lot of advice on the internet that follows the scheme, "just add the arguments ``--cap-add SYS_ADMIN --cap-add MKNOD --device /dev/fuse:mrw`` and it will work". It is, however, insecure to do so. There's a reason why Docker doesn't support FUSE by default.















