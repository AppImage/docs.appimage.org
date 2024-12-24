.. include:: ../substitutions.rst

.. _ref-appimagekit:

AppImageKit
===========

.. warning::

   Previously, there has been one `AppImageKit repository <https://github.com/AppImage/AppImageKit>`_ containing all components of the AppImage specification. However, as of December 2024, it is in the process of being replaced by new repositories for the individual components, including `appimagetool <https://github.com/AppImage/appimagetool/releases>`_ and `type2 runtime <https://github.com/AppImage/type2-runtime>`_.

   This is related to the change to a new static runtime. TODO: Own page with different AppImage types and history.

AppImageKit is the reference implementation of the :ref:`AppImage specification <appimage-specification>`. It is split up into several components, which are described on this page.

These tools are low-level and should usually not be directly used by end users or application authors. However, if you still want to download them, you can get them from GitHub releases.

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

The runtime provides the "executable header" of every AppImage. When executing an AppImage, the runtime within the AppImage is run, which mounts the embedded file system image read-only in a temporary location, and launches the payload application (the AppDir's AppRun) within there. After the payload application exited, the runtime unmounts the squashfs image and cleans up the temporary resources (such as, the temporary mountpoint directory).

Keep in mind that on its own it does nothing; it needs to be combined with a filesystem image to form a valid AppImage, which is what appimagetool does.


.. _ref-appimagetool:

appimagetool
------------

appimagetool can be used to create AppImages from complete pre-existing :ref:`AppDirs <ref-appdir>`. It creates the AppImage by embedding the :ref:`runtime <ref-runtime>`, and creating and appending the filesystem image.

appimagetool implements all optional features, like for instance :ref:`update information <ref-updates>`, :ref:`signing <signing-appimages>`, and some linting options to make sure the information in the AppImage is valid (for instance, it validates :ref:`AppStream files <ref-appstream>`).

However, appimagetool shouldn't be directly used to create AppImages. Instead, using one of the modern :ref:`appimage-creation-tools` is strongly preferred as they're much more convenient and help with creating the AppDir. These tools usually use appimagetool under the hood.

appimagetool should not be confused with the alternative `go implementation <https://github.com/probonopd/go-appimage>`_, which offers a :ref:`wider feature set <sec-go-appimagetool>`.


.. _apprun.c:

AppRun.c (Legacy)
-----------------

``AppRun.c`` (also available as precompiled binary `here <https://github.com/AppImage/AppImageKit/releases/continuous>`_) is a program that attempts to make the application relocatable without modifying it in any way. This can be necessary in some cases, e.g. if its licence prohibits any modifications. It does this by manipulating environment variables, so that the bundled shared libraries are used and related warnings are suppressed. However, using it doesn't guarantee the application to run correctly.

.. warning::

   |apprun_c_warning|

   There are some edge cases where :code:`AppRun.c` might be useful and is still in use. However, it suffers from many limitations and requires some workarounds which themselves require troublesome mechanisms. For example, :code:`AppRun` force-changes the current working directory, and therefore applications cannot detect where the AppImage was originally called. This may be especially annoying for CLI tools, but can also be a problem for GUI applications expecting paths via parameters. This and other workarounds & mechanisms can cause a lot of trouble while trying to debug an AppImage. Please beware of that before thinking about using :code:`AppRun.c` in your AppImage.


Helpers
-------

AppImageKit ships with a few helpers that can be used by AppImage developers to verify and validate some AppImage features, mostly for debugging.

Note that these helpers currently need to be built from source. In the future, they may become bundled with or have their functionality integrated into appimagetool.

digest-md5
++++++++++

:code:`digest-md5` calculates the MD5 digest used for desktop integration purposes for a given AppImage. This digest depends on the path, not on the content. Its source code is available under https://github.com/AppImage/AppImageKit/blob/master/src/digest_md5.c.
