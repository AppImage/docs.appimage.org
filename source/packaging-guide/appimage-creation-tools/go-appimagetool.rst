.. include:: ../../substitutions.rst

.. _sec-go-appimagetool:

go-appimagetool
===============

go-appimagetool (the appimagetool part of the go-appimage project) is a tool that can be used by application authors to package their projects as AppImages.

It requires a manual creation of the AppDir folder structure and file placement (if make isn't used). For more information on how to use make accordingly, or manually create the necessary structure, see :ref:`creating-appdir-structure`.

It allows for both including core system libraries like glibc and not including them. If the core system libraries aren't included, |build_on_old_version|.

However, it is less mature than linuxdeploy and doesn't support some advanced options (like not deploying specific libraries or copyright files).

Usage
-----

To use go-appimagetool, you need to already have an AppDir with the main executable and the desktop, icon, etc. files. go-appimagetool will only deploy the dependency of the executables and libraries into this AppDir and create an AppImage out of it.

To bundle the dependencies with go-appimagetool, use the :code:`deploy` command with the desktop file as parameter like this:

.. code-block:: bash

   > ./appimagetool-*.AppImage deploy appdir/usr/share/applications/*.desktop

You can use the :code:`-s` command line argument to bundle everything, including core system libraries like glibc. Otherwise, core system libraries are not included.

To then turn your complete AppDir into an AppImage, call go-appimagetool with the AppDir as parameter like this:

.. code-block:: bash

   > ./appimagetool-*.AppImage Some.AppDir

TODO: Include documentation on appimagetool environment variables like VERSION and how to add it to desktop files

For more information, see `the project's README file <https://github.com/probonopd/go-appimage/blob/master/src/appimagetool/README.md>`_
