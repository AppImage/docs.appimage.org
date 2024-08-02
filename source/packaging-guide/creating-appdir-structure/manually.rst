.. _manually-creating-appdir-structure:

Manually creating the AppDir structure
======================================

.. note::
   This is only necessary if you use an :ref:`AppImage creation tool <overview-appimage-creation-methods>` that requires prior creation of the AppDir folder structure and file placement.

   If you use a tool that doesn't require that, you don't have to do this.

Create that AppDir structure that looks (at a minimum) like this::

	MyApp.AppDir/
	MyApp.AppDir/AppRun
	MyApp.AppDir/myapp.desktop
	MyApp.AppDir/myapp.png
	MyApp.AppDir/usr/bin/myapp

.. note::
   A shared libraries named ``libfoo.so.0`` would be placed in the AppDir under ``MyApp.AppDir/usr/lib/libfoo.so.0``. However, shared libraries should not be manually copied into the AppDir. Using one of the :ref:`AppImage creation tools <overview-appimage-creation-methods>` is usually much more convenient.

The :code:`AppRun` file can be a script or executable. It sets up required environment variables such as :code:`$PATH` and launches the payload application. You can write your own, but in most cases it is easier (and more error-proof) to use the precompiled AppRun from `the latest release <https://github.com/AppImage/AppImageKit/releases/continuous>`_.

This AppDir structure can then be used by the :ref:`AppImage creation tools <overview-appimage-creation-methods>` to bundle the application dependencies (shared libraries) and create an AppImage out of the AppDir.

Additionally, many applications require additional resources, e.g. asset files for drawing a GUI, which have to be included in the AppImage. In this case, these required resources need to be copied into the AppDir as well.
