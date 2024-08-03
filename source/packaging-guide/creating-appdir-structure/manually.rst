.. _manually-creating-appdir-structure:

Manually creating the AppDir structure
======================================

.. note::
   This is only necessary if you use an :ref:`AppImage creation tool <appimage-creation-tools>` that requires prior creation of the AppDir folder structure and file placement.

   If you use a tool that doesn't require that, you don't have to do this.

To prepare an AppDir structure for an :ref:`AppImage creation tool <appimage-creation-tools>`, create a structure that looks (at a minimum) like this::

	MyApp.AppDir/
	MyApp.AppDir/myapp.desktop
	MyApp.AppDir/myapp.svg or -.png
	MyApp.AppDir/usr/bin/myapp

.. note::
   There are additional files (``AppRun``, ``.DirIcon`` and shared libraries) that have to be placed in every AppDir. However, they should not be manually copied into the AppDir, but are created by the used :ref:`AppImage creation tool <appimage-creation-tools>`.

For a complete guide on and explanation of the AppDir content, including more advanced options such as to include icon files in multiple resolutions or adapted to other well-known themes to fit in better, see :ref:`the AppDir specification <ref-appdir-specification>`.

This AppDir structure can then be used by the :ref:`appimage-creation-tools` to bundle the application dependencies (shared libraries) and create an AppImage out of the AppDir.

Additionally, many applications require additional resources, e.g. asset files for drawing a GUI, which have to be included in the AppImage. In this case, these required resources need to be copied into the AppDir as well.
