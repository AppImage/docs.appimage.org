.. include:: ../../substitutions.rst

.. _appimage-specification:

AppImage specification
======================

.. contents:: Contents
   :local:
   :depth: 1


.. _architecture:

Architecture
------------

AppImages follow a very simple architecture, which is explained in this section:

An AppImage consists of two parts: a *runtime* and a *file system image*. For current :ref:`type 2 AppImages <differences-type-1-type-2>`, SquashFS is usually used as the file system (although that's not a strict specification requirement but rather a decision made in the :ref:`reference implementation <reference-implementation>`).

.. figure:: /_static/img/reference/architecture-overview.svg
   :align: center

   AppImage file structure. Copyright © `@TheAssassin <https://github.com/TheAssassin>`__ 2019. Licensed under CC-By-SA Intl 4.0.

When launching an AppImage, the operating system initially runs the executable runtime part. The runtime then tries to mount the file system image part. If that succeeds, the :ref:`AppDir <appdir-specification>` is available at a temporary mountpoint, and can be used like a read-only directory.

The runtime then calls the AppDir's "entrypoint" :ref:`AppRun <apprun-specification>` using the operating system facilities. While the AppRun of a modern AppImage is often a symlink to the main executable, this provides a lot of flexibility, as the AppRun can be an arbitrary executable, e.g. a script with a `shebang <https://en.wikipedia.org/wiki/Shebang_(Unix)>`__. However, it must be executable.

The content of an AppDir is completely user-specified, although tools that help with packaging are usually used. For more information, see the :ref:`packaging guide <packaging-guide>`.


Specification development
-------------------------

The specification's repository contains a description of the current :ref:`type 2 <differences-type-1-type-2>` format. You can find the `full text <https://github.com/AppImage/AppImageSpec/blob/master/draft.md>`__ in its `GitHub repository <https://github.com/AppImage/AppImageSpec>`__.

The documentation receives updates regularly, e.g. to fix bugs or document new features. For type 2, a decision was made to not release specific versions but work with continuous releases.

As both the AppImage specification and its reference implementation |appimage_history_link|.

Please feel free to file `issues on GitHub <https://github.com/AppImage/AppImageSpec/issues>`__ if you encounter bugs or have ideas for additional features. Improvements on wording and such are also highly appreciated.
