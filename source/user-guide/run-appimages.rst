Running AppImages
=================

This page shows how a user can run AppImages, on their favorite distribution using the desktop environment tools or via the terminal. Also, it explains the concept of desktop integration, and presents tools that can be used for this purpose.


.. contents:: Contents
   :local:
   :depth: 2


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

Please refer to our :ref:`Troubleshooting page <ug-troubleshooting>`.
