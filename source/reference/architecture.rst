.. _ref-architecture:
Architecture
============

AppImage follows a very simple architecture, which is explained in this section.


Overview
--------

An AppImage consists of two parts: a *runtime* and a *filesystem image*. For the current type 2, the filesystem in use is SquashFS.

.. figure:: /_static/img/reference/architecture-overview.svg
   :width: 300px
   :align: center

   AppImage file structure. Copyright © `@probonopd <https://github.com/probonopd>`_ 2017.

What happens when an AppImage is run is that the operating system runs the AppImage as an executable. The runtime, the executable part, tries to mount the filesystem image using :ref:`FUSE <ref-fuse>`. If that succeeds, the :ref:`AppDir <ref-appdir>` is available in a :ref:`temporary mountpoint <ref-temporary-mountpoint>`, and can be used like a read-only directory.

The runtime continues by calling the AppDir's "entrypoint" :ref:`AppRun <ref-apprun>` using the operating system facilities. There are no checks performed by the runtime, the operating system is simply tasked with the execution of ``<AppDir mountpoint>/AppRun``. This provides a lot of flexibility, as AppRun can be an arbitrary executable, a script with a shebang_, or even a simple symlink to another executable within the AppDir. The file must be executable.

.. _shebang: https://en.wikipedia.org/wiki/Shebang_(Unix)

The contents of an AppDir are completely user-specified, although there are tools that help with packaging. For more information, see the :ref:packaging guide <ref-packaging-guide>`.

