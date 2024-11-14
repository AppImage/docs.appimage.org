.. _ref-desktop-integration:

Desktop integration
===================

AppImages are standalone bundles, and do not need to be installed. After downloading an AppImage (and marking it as executable), you can simply double-click to run it.

However, users may want their AppImages to be integrated into the system so that they show up in menus with their icons, have their MIME types associated, can be launched from the desktop environment's launcher, etc. This concept is called *desktop integration*.

This page presents several tools that can be used for this purpose.

.. contents:: Contents
   :local:
   :depth: 1


appimaged
---------

`appimaged <https://github.com/probonopd/go-appimage/releases>`_ is a daemon that monitors a predefined set of directories on the system and detects new and removed AppImages. It automatically integrates all AppImages it can find during an initial search, and then continues to watch for new and removed AppImages and (dis-)integrates these immediately.

Using appimaged, AppImages still need to be marked as executables and moved into the user's application directory manually; only the integration works automatically.

.. warning::

   One of the monitored directories is ``~/Downloads``. If the directory is very large, appimaged usually needs quite some time to visit all files. It is likely to slow down the system (specifically, the filesystem).

**Download:** You can get it as an AppImage from its `Github release page <https://github.com/probonopd/go-appimage/releases/continuous>`_.


AppImageLauncher
----------------

`AppImageLauncher <https://github.com/TheAssassin/AppImageLauncher>`_ contains a daemon internally, appimagelauncherd, that works similarly to appimaged, automatically integrating and disintegrating all new and removed AppImages. But unlike appimaged, the list of monitored directories in which AppImages are stored, is configurable.

Additionally to that, AppImageLauncher integrates into the system itself so that when any AppImage is double-clicked (no matter whether it's marked as executable or not), it will open via the AppImageLauncher. The first time any AppImage is opened, you'll be prompted whether to integrate the AppImage or to just run it once. When you choose to integrate your AppImage, the file will be moved into ``~/Applications``, a monitored directory in which it's automatically integrated by the daemon. This also helps to keep a clean place for all your AppImages and prevents you from having to search through a haystack of files for a specific AppImage.

This means that AppImages don't have to be marked as executable and moved into the application directory manually, but just be double-clicked once to fully integrate them into the system.

Furthermore, the AppImageLauncher can be opened itself and provides an overview of all detected AppImages. You can run and delete any AppImage through this overview and even update AppImages that support it.

To be able to do this all, AppImageLauncher must be installed into the system. It should run on most distributions. A Lite version with reduced functionality exists as AppImage itself, but it's recommended to use the full version.

| **Download:** You can get AppImageLauncher as a ``.deb`` or ``.rpm`` file from its `GitHub release page <https://github.com/TheAssassin/AppImageLauncher/releases/continuous>`_ or download it from the community-managed packages in the Arch User Repository (AUR), see `this wiki-entry <https://github.com/TheAssassin/AppImageLauncher/wiki#aur-package-arch-linux-and-derivatives-such-as-endeavouros-kaos-et-al>`_.
| You can get AppImageLauncher-Lite as an AppImage from its `Github release page <https://github.com/TheAssassin/AppImageLauncher/releases/continuous>`_ as well.
