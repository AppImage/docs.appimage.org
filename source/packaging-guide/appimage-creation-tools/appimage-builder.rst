.. include:: ../../substitutions.rst

.. _sec-using-appimage-builder:

appimage-builder
================

appimgage-builder is a tool that can be used by both application authors to package their projects as AppImages and other people to turn existing Debian packages into AppImages if none are officially distributed.

It does this by using the system package manager to resolve the application dependencies (instead of relying on them being installed on the host system like most other tools do).

It requires a manual creation of the AppDir folder structure and file placement (if make isn't used). For more information on how to use make accordingly, or manually create the necessary structure, see :ref:`creating-appdir-structure`.

Using appimage-builder, you write a so-called *recipe* that is then used to create the AppImage or convert the package into an AppImage. As some (mostly proprietary) applications don't allow redistribution, you can distribute these recipes to allow other users to easily convert existing packages to AppImages.

appimage-builder creates a complete bundle. This means that it includes all dependencies, even core system libraries like glibc. This results in an increased AppImage size (at least 30MB more). On the other hand, this removes the limitation of requiring an *old system* (meaning the oldest supported LTS distribution version) to compile the binaries. It should only be used if linuxdeploy can't be used, e.g. if the AppImage can't be built on the oldest supported LTS distribution version.

The officially supported distributions for AppImages created with appimage-builder are Debian, Ubuntu and Arch.

|appimage_preferred_source|

For more information about appimage-builder and how to use it, please visit: https://appimage-builder.readthedocs.io.
