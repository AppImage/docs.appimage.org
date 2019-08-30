Running AppImages
=================

This page shows how a user can run AppImages, on their favorite distribution using the desktop environment tools or via the terminal. Also, it explains the concept of desktop integration, and presents tools that can be used for this purpose.

.. _ref-download-make-executable-run:
Download, make executable, run
------------------------------

It's quite simple to run AppImages. As the heading says, just download them, make them executable and run them. This can either be done using the GUI or via the command line.

.. seealso::

   Information on how to run AppImages was moved into our :ref:`ref-quickstart` page.

   Please see :ref:`ref-how-to-run-appimage` for more information.


Mount or extract AppImages
--------------------------

To inspect the contents of any AppImage, it is possible to either mount them without running them, or extract the contents to a directory in the current working directory..


Mount an AppImage
*****************

AppImages can be mounted in the system to provide *read-only* access for users to allow for inspecting the contents.

To mount an AppImage temporarily, you have two options. The easiest way to do so is to call AppImages with the special parameter ``--appimage-mount``, for example::

    > my.AppImage --appimage-mount
    /tmp/mount_myXXXX
    # now, use another terminal or file manager to inspect the contents in the directory printed by --appimage-mount

The AppImage is unmounted when the application called in the example is interrupted (e.g., by pressing :kbd:`Ctrl+C`, closing the terminal etc.).

.. note::
   This is only available for type 2 AppImages. Type 1 AppImages do not provide any self-mounting mechanism. To mount type 1 AppImages, use ``mount -o loop``.

This method is to be preferable, as other methods have some major disadvantages explained below.

Another way to mount AppImages is to use the normal ``mount`` command toolchain of your Linux distribution. Mounting and unmounting devices, files, images and also AppImages requires root permissions. Also, you need to provide a mountpoint. Please see the following example:

For type 1 AppImages::

    > mkdir mountpoint
    > sudo mount my.AppImage mountpoint/
    # you can now inspect the contents
    > sudo umount mountpoint/

For type 2 AppImages::

    > mkdir mountpoint
    > my.AppImage --appimage-offset
    > 123456
    > sudo mount my.AppImage mountpoint/ -o offset=123456
    # you can now inspect the contents
    > sudo umount mountpoint/
    
Note that the number `123456` is just an example here, you will likely see another number.

.. warning::
   AppImages mounted using this method are not unmounted automatically. Please do not forget to call ``umount`` the AppImage as soon as you don't need it mounted any more.

   If an AppImage is not unmounted properly, and is moved to a new location, a so-called "dangling mount" can be created. This should be avoided by properly unmounting the AppImages.

   .. note::
      Type 2 AppImages which are mounted using the ``--appimage-mount`` parameter are **not** affected by this problem!

.. include:: notes/external-tool-to-mount-and-extract-appimages.rst


Extract the contents of an AppImage
***********************************

An alternative to mounting the AppImages is to extract their contents. This allows for modifying the contents. The resulting directory is a valid :ref:`AppDir`, and users can create AppImages from them again using :ref:`ref-appimagetool`.

Analog to mounting AppImages, there is a simple commandline switch to extract the contents of type 2 AppImages without external tools. Just call the AppImage with the parameter :code:`--appimage-extract`. This will cause the :ref:`ref-runtime` to create a new directory called :code:`squashfs-root`, containing the contents of the AppImage's :ref:`ref-appdir`.

Type 1 AppImages require the deprecated tool AppImageExtract_ to extract the contents of an AppImage. It's very limited functionality wise, and requires a GUI to run. It creates a new directory in the user's desktop directory.

.. _AppImageExtract: https://github.com/AppImage/AppImageKit/releases/6

.. include:: notes/external-tool-to-mount-and-extract-appimages.rst


.. _ref-desktop-integration:
Integrating AppImages into the desktop
--------------------------------------

AppImages are standalone bundles, and do not need to be *installed*. However, some users may want their AppImages to be available like distribution provided applications. This primarily involves being able to launch desktop applications from their desktop environments' launchers. This concept is called *desktop integration*.

appimaged
*********

`appimaged <https://github.com/AppImage/appimaged>`_ is a daemon that monitors the system and integrates AppImages. It monitors a predefined set of directories on the user's system searching for AppImages, and integrates them into the system using :ref:`libappimage`.

.. seealso::
   More information on appimaged can be found in :ref:`appimaged`.


AppImageLauncher
****************

AppImageLauncher_ is a helper application for Linux distributions serving as a kind of "entry point" for running and integrating AppImages. It makes a user's system AppImage-ready™.

AppImageLauncher must be installed into the system to be able to integrate into the system properly. It uses technologies that are independent from any desktop environment features, and therefore should be able to run on most distributions.

After install AppImageLauncher, you can simply double-click AppImages in file managers, browsers etc. You will be prompted whether to integrate the AppImage, or run it just once. When you choose to integrate your AppImage, the file will be moved into the directory :code:`~/Applications`. This helps reducing the mess of AppImages on your file system and prevents you from having to search for the actual AppImage file if you want to e.g., remove it.

To provide a complete solution for managing AppImages on the system, AppImageLauncher furthermore provides solutions for updating and removing AppImages from the system. These functions can be found in the context menus of the entries in the desktop's launcher.

.. _AppImageLauncher: https://github.com/TheAssassin/AppImageLauncher

.. seealso::
   More information about AppImageLauncher can be found in :ref:`ref-appimagelauncher`.


Troubleshooting
---------------

I get some errors related to something called "FUSE"
****************************************************

AppImages require a Linux technology called *Filesystem in Userspace* (or short *FUSE*). The majority of systems ships with a working FUSE setup. However, sometimes, it doesn't quite work. This section explains a few solutions that fix the most frequently reported problems.

The AppImage tells me it needs FUSE to run
##########################################

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

Install FUSE
############

Most Linux distributions come with a functional FUSE setup. However, if it is not working for you, you may have to install and configure FUSE yourself.

The process of installing FUSE highly differs from distribution to distribution. This section shows how to install FUSE on the most common distributions.

.. note::
   If your distribution is not listed, please ask the distribution developers for instructions.

.. rubric:: Setting up FUSE on Ubuntu, Debian and their derivatives

Install the required package::

  > sudo apt-get install fuse

Now, FUSE should be working. On some older distributions, you will have to run some additional configuration steps:

Make sure the FUSE kernel module is loaded::

  > sudo modprobe -v fuse

Then, add the required group (should be created by the install command, if this is the case, this call *will* fail), and add your own user account to this group::

  > sudo addgroup fuse
  > sudo adduser $USER fuse

.. include:: notes/user-group-modifications.rst

.. rubric:: Setting up FUSE on openSUSE

Install the required package::

  > sudo zypper install fuse

FUSE should now be working.

.. rubric:: Setting up FUSE on CentOS and RHEL

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

.. seealso::
   For more information on how AppImages use FUSE, please see :ref:`ref-fuse`.
