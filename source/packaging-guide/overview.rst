Overview
========

There are different ways to create AppDirs and the corresponding AppImages.

The following table gives an overview of the different methods and their advantages, disadvantages and differences. For each of these methods, there is a corresponding section in this packaging guide, explaining how to use it.

If you are unsure which one to use, linuxdeploy and go-appimagetool are the best options in most cases.

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
       | AppImages should be built on the oldest supported LTS distribution versions when using it.
       | More mature; supports additional options (e.g. not deploying specific libraries or copyright files) go-appimagetool doesn't support (yet).
       | Repository link: https://github.com/linuxdeploy/linuxdeploy
       | Packaging guide: TODO LINK!
   * - go-appimagetool
     - | A tool that can be used by application authors to package their projects as AppImages.
       | Requires manual creation of the AppDir folder structure and file placement (if make isn't used).
       | Allows for both including core system libraries like glibc and not including them.
       | Doesn't require AppImages to be built on the oldest supported LTS distribution versions.
       | Less mature; doesn't support some options linuxdeploy does.
       | Repository link: https://github.com/probonopd/go-appimage
       | Packaging guide: TODO LINK!
   * - appimage-builder
     - | A tool that can be used by both application authors to package their projects as AppImages and other people to turn existing Debian packages into AppImages if none are officially distributed.
       | Requires manual creation of the AppDir folder structure and file placement (if make isn't used).
       | Includes core system libraries like glibc. This results in an increased AppImage size (+ >30MB).
       | Officially supports Debian, Ubuntu and Arch.
       | Doesn't require AppImages to be built on the oldest supported LTS distribution versions.
       | Should only be used if linuxdeploy can't be used (e.g. if the AppImage can't be built on the oldest supported LTS distribution version).
       | Repository link: https://github.com/AppImageCrafters/appimage-builder
       | Packaging guide: TODO LINK!
   * - electron-builder
     - | A tool that can be used by application authors to easily package their Electron projects not only as AppImages but also as other application formats for Linux (e.g. Flatpak or Snap), macOS (e.g. DMG) and Windows (e.g. Installer or Portable).
       | Creates the AppDir from scratch and doesn't require any existing AppDir structure or manual file placement.
       | Recommended solution if your app is Electron based, **otherwise not applicable**.
       | Repository link: https://github.com/electron-userland/electron-builder
       | Packaging guide: TODO LINK!
   * - pkg2appimage
     - | A tool that can be used by people other than the application authors to convert officially distributed binary packages (archives, .deb packages and PPAs) into AppImages if none are officially distributed.
       | Requires manual creation of the AppDir folder structure and file placement (if make isn't used).
       | **Do not use pkg2appimage if you are the application author. pkg2appimage should only be used if there is no officially distributed AppImage.** Upstream developers should use one of the other creation methods.
       | pkg2appimage has a major `security issue <https://github.com/AppImageCommunity/pkg2appimage/issues/197>`_; therefore it's only recommended for personal use.
       | Repository link: https://github.com/AppImageCommunity/pkg2appimage
       | Packaging guide: TODO LINK!
   * - Manual packaging
     - | Manual packaging means manually creating the entire AppDir structure and copying all files to their correct places in the structure.
       | While manually creating a directory structure and copying some files might be necessary depending on the used tool, manually packaging *everything* should only be used as a last resort if all other methods aren't applicable.
       | Using one of the tools above like linuxdeploy or go-appimagetool is usually much more convenient.
       | It is explained nevertheless, mainly to illustrate how things work under the hood.
       | Packaging guide: TODO LINK!
   * - linuxdeployqt
     - | Deprecated. Succeeded by linuxdeploy and go-appimagetool.
       | **Do not use linuxdeployqt to create new AppImages.**


..
   TODO: Create a section for each packaging method
   TODO: Remove the rest of the overview and move it into the respective sections


.. contents:: Contents
   :local:
   :depth: 1


.. _sec-from-source:

Packaging from source
---------------------

The recommended approach is to package software from source. Ideally, upstream application authors take over maintenance of AppImages, and provide them on their release pages.

To learn more about how packaging from source works, please refer to :ref:`ref-packaging-from-source`.

The process of packaging from source can and should be automated. CI systems like Travis CI can help with that.


.. _sec-travis-ci:

Automated continuous builds on Travis CI
****************************************

This option might be the easiest if you already have continuous builds on Travis CI in place. In this case, you can write a small scriptfile and in many cases are done with the AppImage generation.

More information on using Travis CI for making AppImages can be found in :ref:`ref-travis-ci`.

.. seealso::
   There are a lot of examples on GitHub that can be found using the `GitHub search <https://github.com/search?utf8=%E2%9C%93&q=%22Package+the+binaries+built+on+Travis-CI+as+an+AppImage%22&type=Code&ref=searchresults>`__.


.. _sec-electron-builder:

Using electron-builder
**********************

For `Electron`_ based applications, a tool called electron-builder_ can be used to create AppImages.

With electron-builder, making AppImages is as simple as defining ``AppImage`` as a target for Linux (default in the latest version of electron-builder). This should yield usable results for most applications.

.. seealso::
   More information can be found in the `documentation on AppImage <https://www.electron.build/configuration/appimage.html>`__ and `the documentation on distributable formats <https://www.electron.build/index.html#pack-only-in-a-distributable-format>`__ in the `electron-builder manual <https://www.electron.build>`__.

   There are a lot of examples on GitHub that can be found using the `GitHub search <https://github.com/search?utf8=%E2%9C%93&q=electron-builder+linux+target+appimage&type=Code&ref=searchresults>`__.

.. _Electron: https://electronjs.org/
.. _electron-builder: https://www.electron.build/


.. _sec-convert-packages:

Converting existing binary packages
-----------------------------------

This option might be the easiest if you already have up-to-date packages in place, ideally a PPA for the oldest still-supported Ubuntu LTS release (xenial as of 2019, see https://en.wikipedia.org/wiki/Ubuntu#Releases for up to date information) or earlier or a debian repository for oldstable. In this case, you can write a small :code:`.yml` recipe and in many cases are done with the package to AppImage conversion. See :ref:`ref-convert-existing-binary-packages` for more information.


.. _sec-using-obs:

Using the Open Build Service
----------------------------

This option is recommended for open source projects because it allows you to leverage the existing Open Build Service infrastructure, security and license compliance processes.

More information on using OBS for making AppImages can be found in :ref:`ref-obs`.


.. _sec-using-appimage-builder:

Using appimage-builder
----------------------

appimage-builder is a novel tool for creating AppImages. It uses the system package manager to resolve the
application dependencies and creates a complete bundle. It can be used to pack almost any kinds of applications
including those made using: C/C++, Python, and Java.

This tool removes the limitations of requiring an *old system* to compile the binaries. It can be used to
pack an application from sources or to turn an existing Debian package into an AppImage.

For more information about appimage-builder please visit: https://appimage-builder.readthedocs.io


.. _sec-create-appdir-manually:

Manually creating an AppDir
---------------------------

Create an AppDir manually, then turn it into an AppImage. Please note that this method should only be your last resort, as the other methods are much more convenient in most cases. Manually creating an AppDir is explained mainly to illustrate how things work under the hood.

See :ref:`ref-manual` for more information.
