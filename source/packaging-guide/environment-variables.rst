.. include:: ../substitutions.rst

.. _environment-variables:

Environment variables
=====================

The AppImage runtime sets some environment variables available to the applications bundled as AppImages, e.g. to get the path of the mounted AppDir (AppImage content). This can be necessary in some situations, e.g. to call other bundled executables.

This section gives an overview over those environment variables.

.. contents:: Contents
   :local:
   :depth: 1


Environment variables set in every AppImage
-------------------------------------------

The following environment variables are set in every AppImage.

.. list-table::
   :header-rows: 1

   * - Variable name
     - Contents
   * - :code:`APPIMAGE`
     - Absolute path of the AppImage (with symlinks resolved)
   * - :code:`APPDIR`
     - Path of the mounted AppDir (AppImage content)
   * - :code:`OWD`
     - Path of the working directory at the time the AppImage is called

For example, if you want to call another bundled executable from your AppImage, you can do that with ``$APPDIR/usr/lib/other_executable``. |shell_command| ``Command::new("sh").arg("-c").arg("$APPDIR/usr/lib/other_executable").output()``.


``ARGV0``
---------

Type 2 AppImages have another environment variable called ``ARGV0`` set (every reasonably recent AppImage is type 2 as all modern :ref:`appimage-creation-tools` and ``appimagetool`` create type 2 AppImages).

``ARGV0`` is the path used to execute the AppImage. This corresponds to the value you'd normally receive as the ``argv`` argument passed to your ``main`` method. This usually contains the path of the AppImage, relative to the current working directory.

.. note::

   :code:`APPIMAGE` and :code:`ARGV0` have very different use cases.

   :code:`APPIMAGE` should be used every time the path of the AppImage is needed, e.g. if you need to touch the AppImage file to update it.

   :code:`ARGV0` provides information on how the AppImage was called. When you call an AppImage through a symlink for instance, you can get the path to this symlink through :code:`ARGV0`, while :code:`APPIMAGE` would contain the absolute path to the file behind that symlink.

   Scenarios where :code:`ARGV0` is really useful involve so-called multi-binary AppImages, where the filename in :code:`ARGV0` defines which program is called inside the AppImage. This concept is also known from single-binary tools like `BusyBox <https://en.wikipedia.org/wiki/BusyBox>`__, and can be implemented in a custom :code:`AppRun` script (see :ref:`Architecture <architecture>` for more information).
