Overview
========

There are different ways to create AppImages. The following section gives you an overview of which ways are available, their advantages and disadvantages, and where to find more information.


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
   There are a lot of examples on GitHub that can be found using the `GitHub search <https://github.com/search?utf8=%E2%9C%93&q=%22Package+the+binaries+built+on+Travis-CI+as+an+AppImage%22&type=Code&ref=searchresults>`_.


.. _sec-electron-builder:
Using electron-builder
**********************

For `Electron`_ based applications, a tool called electron-builder_ can be used to create AppImages.

With electron-builder, making AppImages is as simple as defining ``AppImage`` as a target for Linux (default in the latest version of electron-builder). This should yield usable results for most applications.

.. seealso::
   More information can be found in the `documentation on AppImage <https://www.electron.build/configuration/appimage.html>`_ and `the documentation on distributable formats <https://www.electron.build/index.html#pack-only-in-a-distributable-format>`_ in the `electron-builder manual <https://www.electron.build>`_.

   There are a lot of examples on GitHub that can be found using the `GitHub search <https://github.com/search?utf8=%E2%9C%93&q=electron-builder+linux+target+appimage&type=Code&ref=searchresults>`_.

.. _Electron: https://electronjs.org/
.. _electron-builder: https://www.electron.build/


.. _sec-convert-packages:
Converting existing binary packages
-----------------------------------

This option might be the easiest if you already have up-to-date packages in place, ideally a PPA for the oldest still-supported Ubuntu LTS release (xenial as of 2019, see https://en.wikipedia.org/wiki/Ubuntu#Releases for up to date information) or earlier or a debian repository for oldstable. In this case, you can write a small :code:`.yml` recipe and in many cases are done with the package to AppImage conversion. See :ref:`convert-existing-binary-packages` for more information.


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
