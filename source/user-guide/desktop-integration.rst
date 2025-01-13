.. include:: ../substitutions.rst

.. _desktop-integration:

Desktop integration
===================

|appimage_standalone_bundles|

|desktop_integration| This concept is called *desktop integration*.

This page presents several tools that can be used for this purpose.

.. contents:: Contents
   :local:
   :depth: 1


Gear Lever
----------

`Gear Lever <https://github.com/mijorus/gearlever>`__ is an AppImage desktop integration tool. It allows to easily integrate AppImages into the desktop by just dragging them into its GUI and optionally moves them into a (configurable) application directory.

Gear Lever also contains other features that make it easier to use AppImages, such as allowing users to update one or all AppImages with it or optionally renaming CLI tools to their executable name to open them more easily with the terminal.

**Download:** You can get it as a Flatpak from `Flathub <https://flathub.org/apps/it.mijorus.gearlever>`__ or as an unofficial AppImage `here <https://github.com/ivan-hc/Database-of-pkg2appimaged-packages/releases/tag/gearlever>`__.


appimaged
---------

`appimaged <https://github.com/probonopd/go-appimage>`__ is a daemon that monitors a predefined set of directories on the system and detects new and removed AppImages. It automatically integrates all AppImages it can find during an initial search, and then continues to watch for new and removed AppImages and (dis-)integrates these immediately.

Using appimaged, AppImages still need to be marked as executables and moved into the user's application directory manually; only the integration works automatically.

.. warning::
   As of January 2025, the directories monitored by appimaged are not configurable, but hardcoded. Therefore, it might not be suitable for every use case.

   One of the monitored directories is ``~/Downloads``. If this directory is very large, appimaged usually needs quite some time to visit all files. It is likely to slow down the system (specifically, the filesystem).

**Download:** You can get it as an AppImage from its `Github release page <https://github.com/probonopd/go-appimage/releases>`__.


AppImageLauncher
----------------

.. warning::
   As of January 2025, AppImageLauncher doesn't support AppImages created with the current :ref:`reference implementation <reference-implementation>` (after it has been changed to the new static runtime).

`AppImageLauncher <https://github.com/TheAssassin/AppImageLauncher>`__ contains a daemon internally, appimagelauncherd, that works similarly to appimaged, automatically integrating and disintegrating all new and removed AppImages. But unlike appimaged, the list of monitored directories in which AppImages are stored, is configurable.

Additionally to that, AppImageLauncher integrates into the system itself so that when any AppImage is double-clicked (no matter whether it's marked as executable or not), it will open via AppImageLauncher. The first time any AppImage is opened, you'll be prompted whether to integrate the AppImage or to just run it once. When you choose to integrate your AppImage, the file will be moved into ``~/Applications``, a monitored directory in which it's automatically integrated by the daemon. This also helps to keep a clean place for all your AppImages and prevents you from having to search through a haystack of files for a specific AppImage.

This means that AppImages don't have to be marked as executable and moved into the application directory manually, but just be double-clicked once to fully integrate them into the system.

Furthermore, AppImageLauncher can be opened itself and provides an overview of all detected AppImages. You can run and delete any AppImage through this overview and even update AppImages that support it.

To be able to do this all, AppImageLauncher must be installed into the system. It should run on most distributions. A Lite version with reduced functionality exists as AppImage itself, but it's recommended to use the full version.

| **Download:** You can get AppImageLauncher as a ``.deb`` or ``.rpm`` file from its `GitHub release page <https://github.com/TheAssassin/AppImageLauncher/releases>`__ or download it from the community-managed packages in the Arch User Repository (AUR), see `this wiki-entry <https://github.com/TheAssassin/AppImageLauncher/wiki#aur-package-arch-linux-and-derivatives-such-as-endeavouros-kaos-et-al>`__.
| You can get AppImageLauncher-Lite as an AppImage from its `Github release page <https://github.com/TheAssassin/AppImageLauncher/releases>`__ as well.


AppImage package managers
-------------------------

There also exist several AppImage package managers. Those allow for installing AppImages on the command line while simultaneously integrating them into the desktop:

- **zap**

  `zap <https://github.com/srevinsaju/zap>`__ is a package manager that can install an AppImage from any URL as well as all AppImages from the appimage.github.io :ref:`software catalog <software-catalogs-user>`.

  When downloading & installing an AppImage with zap, it will automatically integrate it into the desktop. Users can update one or all AppImages with zap.

  **Download:** You can get it as a CLI binary from its `Github release page <https://github.com/srevinsaju/zap/releases>`__ or alternatively install it via a shell script (see its `README <https://github.com/srevinsaju/zap/blob/main/README.md#getting-started->`__).

- **Soar**

  `Soar`_ is a package manager that can install AppImages as well as static binaries and other portable formats from its own :ref:`software catalog <software-catalogs-user>` (called PkgForge). However, it can't install AppImages from arbitrary URLs.

  When downloading & installing an AppImage with Soar, it will automatically integrate it into the desktop. Users can update one or all AppImages with Soar.

  **Download:** You can get it as a CLI binary from its `Github release page <https://github.com/pkgforge/soar/releases>`__ or alternatively install it via a shell script (see its `documentation <https://soar.qaidvoid.dev/installation>`__).

- **AM / AppMan**

  `AM / AppMan`_ is a package manager that can install AppImages as well as other application formats from its own own :ref:`software catalog <software-catalogs-user>` (called Portable Linux Apps). However, it can't install AppImages from arbitrary URLs.

  When downloading & installing an AppImage with AM, it will automatically integrate it into the desktop. Users can update one or all AppImages with AM.

  **Download:** You can install it via a shell script (see its `README <https://github.com/ivan-hc/AM/blob/main/README.md#installation>`__).
