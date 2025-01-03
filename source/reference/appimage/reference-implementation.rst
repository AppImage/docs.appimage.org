.. include:: ../../substitutions.rst

.. _reference-implementation:

AppImage reference implementation
=================================

The reference implementation of the :ref:`AppImage specification <appimage-specification>` is split up into several components, which are described on this page.

It is formerly known as *AppImageKit* (more information on its history can be found :ref:`here <appimage-types-history>`).

These tools are low-level and should usually not be directly used by end users or application authors. However, if you still want to download them, you can get them from the GitHub releases page of the respective repository.

For packaging software that should be used by application authors to create AppImages, see :ref:`appimage-creation-tools`.

For desktop integration tools that can be used by end users to improve the AppImage user experience, see :ref:`ref-desktop-integration`.

.. seealso::
   The AppImage updating mechanism is implemented in `AppImageUpdate <https://github.com/AppImageCommunity/AppImageUpdate>`_. For more information on updating AppImages, see :ref:`updates-user`.

.. contents:: Contents
   :local:
   :depth: 2


.. _ref-runtime:

runtime
-------

The runtime (`source code <https://github.com/AppImage/type2-runtime>`_) provides the “executable header” of every AppImage. The general way the runtime works is described in the :ref:`specification section <ref-architecture>`.

|specification_broad| The following are some of the decisions the runtime reference implementation made:

- The runtime sets specific :ref:`environment variables <ref-env_vars>` that can be used in the application before invoking it.
- The file system is mounted with FUSE.
- The runtime is statically linked, which means that there are no dependencies (like ``glibc``) required on the system.
- The runtime doesn't check the AppRun file in any way before running it; it simply tasks the operating system to execute it.
- After the AppRun file exited, the runtime unmounts the image and cleans up the temporary resources (such as the temporary mountpoint directory).

As both the AppImage specification and those implementation decisions |appimage_history_link|.

Keep in mind that on its own it does nothing; it needs to be combined with a file system image to form a valid AppImage, which is what ``appimagetool`` does.


.. _ref-appimagetool:

appimagetool
------------

appimagetool (`source code <https://github.com/AppImage/appimagetool>`_) can be used to create AppImages from complete pre-existing :ref:`AppDirs <ref-appdir>`. It creates the AppImage by embedding the :ref:`reference implementation runtime <ref-runtime>`, and creating and appending the file system image.

appimagetool implements all specification features, like :ref:`embedding update information <ref-updates>` or :ref:`signing the AppImage<signing-appimages>`.

|specification_broad| The following are some of the decisions appimagetool made as reference implementation:

- appimagetool checks some of the information in the AppDir to make sure it's valid (for example, it validates :ref:`AppStream files <ref-appstream>`)
- appimagetool uses SquashFS as the file system for the file system image.

As both the AppImage specification and those implementation decisions |appimage_history_link|.

appimagetool shouldn't be directly used to create AppImages. Instead, using one of the modern :ref:`appimage-creation-tools` is strongly preferred as they're much more convenient and help with creating the AppDir. These tools usually use appimagetool under the hood.

appimagetool should also not be confused with the alternative `go implementation <https://github.com/probonopd/go-appimage>`_, which offers a :ref:`wider feature set <sec-go-appimagetool>`.

.. todo::
   Add more information about the differences to the go implementation. Maybe even add an own Alternative implementation section.


Helpers
-------

There also are helper tools that can be used to verify and validate some AppImage features (mostly for debugging).

.. _apprun.c:

AppRun.c (Legacy)
+++++++++++++++++

``AppRun.c`` is a deprecated program that attempts to make the application relocatable without modifying it in any way. This can be necessary in some cases, e.g. if its licence prohibits any modifications. It does this by manipulating environment variables, so that the bundled shared libraries are used and related warnings are suppressed. However, using it doesn't guarantee the application to run correctly. It is available as precompiled binary `here <https://github.com/AppImage/AppImageKit/releases/continuous>`_.

.. warning::

   |apprun_c_warning|

   There are some edge cases where :code:`AppRun.c` might be useful and is still in use. However, it suffers from many limitations and requires some workarounds which themselves require troublesome mechanisms. For example, :code:`AppRun` force-changes the current working directory, and therefore applications cannot detect where the AppImage was originally called. This may be especially annoying for CLI tools, but can also be a problem for GUI applications expecting paths via parameters. This and other workarounds & mechanisms can cause a lot of trouble while trying to debug an AppImage. Please beware of that before thinking about using :code:`AppRun.c` in your AppImage.

..
   TODO: Update this section when AppRun.c is moved into pkg2appimage

digest-md5
++++++++++

:code:`digest-md5` calculates the MD5 digest used for desktop integration purposes for a given AppImage. This digest depends on the path, not on the content. Its source code is available under https://github.com/AppImage/AppImageKit/blob/master/src/digest_md5.c. It currently needs to be built from source and is not available as a pre-compiled binary.

validate
++++++++

.. note::
   The ``validate`` tool has been moved into the ``AppImageUpdate`` project and is available as a pre-compiled binary there.

.. todo::
   Add other old helper tools such as testappimage, LibcWrapGenerator and the ones available in the AppImageKit repository (old master branch).
