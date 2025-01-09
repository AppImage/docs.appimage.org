.. include:: ../../substitutions.rst

.. _appimage-creation-tools:

AppImage creation tools
=======================

There are different tools that help with creating AppDirs and the corresponding AppImages. They can help in several ways:

1. Some of them create the AppDir from scratch and don't require manual AppDir creation or file placement.
2. They bundle the application dependencies (shared libraries) into the existing AppDir.
3. They remove hardcoded paths in the executables and libraries.
4. They create an AppImage out of the AppDir (usually by invoking `appimagetool <https://github.com/AppImage/appimagetool>`__ underneath).

Some tools require you to manually create the AppDir structure prior to invoking the tool. :ref:`creating-appdir-structure` explains the different ways to do this.

Additionally, many applications require additional resources, e.g. asset files for drawing a GUI, which have to be included in the AppImage. In this case, a directory with (only) these required resources needs to be created and given to the AppImage creation tool, no matter which tool is used.

This section gives an overview of the different tools and their advantages, disadvantages and differences. For each of them, there is a corresponding page, explaining how to use it.

If you are unsure which one to use, linuxdeploy and go-appimagetool are the best options in most cases.


.. _creation-comparison-table:

Comparison table
----------------

..
   NOTE: When changing the order of the rows, make sure that the rows are correctly formatted
   See custom.css (the table rows are formatted depending on their index)

.. list-table::
   :widths: 25 75
   :header-rows: 1
   :class: formatted-table

   * - AppImage creation method
     - Description and notes
   * - linuxdeploy
     - | A tool that can be used by application authors to package their projects as AppImages.
       | Creates the AppDir from scratch and doesn't require any existing AppDir structure or manual file placement.
       | Doesn't include core system libraries like glibc. This results in a reduced AppImage size.
       | Created AppImages should run on *almost* all modern linux distributions.
       | More mature; supports additional options (e.g. not deploying specific libraries or copyright files) go-appimagetool doesn't support (yet).
       | Repository link: https://github.com/linuxdeploy/linuxdeploy
       | Packaging guide: :ref:`linuxdeploy`
   * - go-appimagetool
     - | A tool that can be used by application authors to package their projects as AppImages.
       | Requires manual creation of the AppDir folder structure and file placement (if make isn't used).
       | Allows for both including core system libraries like glibc and not including them.
       | Less mature; doesn't support some options linuxdeploy does.
       | Repository link: https://github.com/probonopd/go-appimage
       | Packaging guide: :ref:`go-appimagetool`
   * - appimage-builder
     - | A tool that can be used by both application authors to package their projects as AppImages and other people to turn existing Debian packages into AppImages if none are officially distributed.
       | Requires manual creation of the AppDir folder structure and file placement (if make isn't used).
       | Includes core system libraries like glibc. This results in an increased AppImage size (+ >30MB).
       | Officially supports Debian, Ubuntu and Arch.
       | Should only be used if linuxdeploy can't be used (e.g. if the AppImage can't be built on the oldest supported LTS distribution version).
       | Repository link: https://github.com/AppImageCrafters/appimage-builder
       | Packaging guide: :ref:`appimage-builder`
   * - electron-builder
     - | A tool that can be used by application authors to easily package their Electron projects not only as AppImages but also as other application formats for Linux (e.g. Flatpak or Snap), macOS (e.g. DMG) and Windows (e.g. Installer or Portable).
       | Creates the AppDir from scratch and doesn't require any existing AppDir structure or manual file placement.
       | Recommended solution if your app is Electron based, **otherwise not applicable**.
       | Repository link: https://github.com/electron-userland/electron-builder
       | Packaging guide: :ref:`electron-builder`
   * - pkg2appimage
     - | A tool that can be used by people other than the application authors to convert officially distributed binary packages (archives, .deb packages and PPAs) into AppImages if none are officially distributed.
       | Requires manual creation of the AppDir folder structure and file placement.
       | Doesn't include core system libraries like glibc. This results in a reduced AppImage size.
       | **Do not use pkg2appimage if you are the application author. pkg2appimage should only be used if there is no officially distributed AppImage.** Application authors should use one of the other creation methods.
       | pkg2appimage has a major `security issue <https://github.com/AppImageCommunity/pkg2appimage/issues/197>`__; therefore it's only recommended for personal use.
       | Repository link: https://github.com/AppImageCommunity/pkg2appimage
       | Packaging guide: :ref:`pkg2appimage`
   * - Manual packaging
     - | Manual packaging means manually creating the entire AppDir structure and copying all files to their correct places in the structure.
       | While manually creating a directory structure and copying some files might be necessary depending on the used tool, manually packaging *everything* should only be used as a last resort if all other methods aren't applicable.
       | Using one of the tools above like linuxdeploy or go-appimagetool is usually much more convenient.
       | It is explained nevertheless, mainly to illustrate how things work under the hood.
       | Packaging guide: :ref:`manually-fully-creating-appdir`
   * - linuxdeployqt
     - | Deprecated. Succeeded by linuxdeploy and go-appimagetool.
       | **Do not use linuxdeployqt to create new AppImages.**


Packaging as application author vs converting existing packages
---------------------------------------------------------------

There are two ways to create AppImages:

1. Packaging the AppImage as application author (also called packaging from source)
2. Converting existing packages

Ideally, upstream application authors should package the application and provide officially distributed AppImages. This is called packaging from source. The term packaging from source is actually a bit misleading as it's not actually depending on the source code: The project is still compiled like usual and then the resulting binaries are packaged as AppImage. However, the term is used as this method requires all dependencies for the project to be installed on the host system (which usually only applies to the system the source code is also compiled on). This method of packaging can and should be automated by using a CI system.

Converting existing packages, on the other hand, doesn't require the dependencies to be installed on your system. Instead, they are downloaded during the packaging process from distribution repositories. To convert an existing package (ideally a PPA or .deb file), you write a so-called *recipe* that is then used to convert the package into an AppImage. As some (mostly proprietary) applications don't allow redistribution, you can distribute these recipes to allow other users to easily convert existing packages to AppImages.

|appimage_preferred_source|


.. _compiling-on-old-system:

Compiling the application on an old system
------------------------------------------

If the AppImage won't include core libraries like glibc (see the :ref:`creation-comparison-table`), the AppImage usually has to be built on the oldest still-supported Linux distribution version that we can assume users to still use. |old_compile_version_reason|

For more information about this, exceptions to this and alternatives if you can't build your application on the oldest still-supported Linux distribution, see :ref:`exclude-expected-libraries`.

The so-called *excludelist* of all core libraries that aren't included by most AppImage creation tools is available `here <https://github.com/AppImage/pkg2appimage/blob/master/excludelist>`__.


.. toctree::
   linuxdeploy
   go-appimagetool
   appimage-builder
   electron-builder
   pkg2appimage
   :caption: Contents:
   :maxdepth: 1

