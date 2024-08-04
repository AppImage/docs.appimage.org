.. _software-overview:

Software Overview
=================

This page gives an overview of official AppImage software. However, this software is low-level and most of it should usually not be directly used by end users or application authors.

For packaging software that should be used by application authors to create AppImages, see :ref:`appimage-creation-tools`.

For desktop integration tools that can be used by end users to improve the AppImage user experience, see :ref:`ref-desktop-integration`.

.. contents:: Contents
   :local:
   :depth: 2


.. _ref-appimagekit:

AppImageKit
-----------

`AppImageKit <https://github.com/AppImage/AppImageKit>`__ is the reference implementation of the :ref:`AppImage specification <appimage-specification>`. It is split up into several components, which are described in this section.

These tools should usually not be directly used by application authors or end users. However, if you still want to download them, you can get them from https://github.com/AppImage/AppImageKit/releases/continuous.


.. _ref-runtime:

runtime
+++++++

The runtime provides the "executable header" of every AppImage. When executing an AppImage, the runtime within the AppImage is run, which mounts the embedded file system image read-only in a temporary location, and launches the payload application within there. After the payload application exited, the runtime unmounts the squashfs image and cleans up the temporary resources (such as, the temporary mountpoint directory).

Keep in mind that on its own it does nothing; it needs to be combined with a filesystem image to form a valid AppImage, which is what appimagetool does.


.. _ref-appimagetool:

appimagetool
++++++++++++

appimagetool can be used to create AppImages from complete pre-existing :ref:`AppDirs <ref-appdir>`. It creates the AppImage by embedding the :ref:`runtime <ref-runtime>`, and creating and appending the filesystem image.

appimagetool implements all optional features, like for instance `update information <https://github.com/AppImage/AppImageSpec/blob/master/draft.md#update-information>`__, :ref:`signing <ref-signing>`, and some linting options to make sure the information in the AppImage is valid (for instance, it validates :ref:`AppStream files <appstream-support>`).

However, appimagetool shouldn't be directly used to create AppImages. Instead, using one of the modern :ref:`appimage-creation-tools` is strongly preferred as they're much more convenient and help with creating the AppDir. These tools usually use appimagetool under the hood.

appimagetool should not be confused with the alternative `go implementation <https://github.com/probonopd/go-appimage>`_, which offers a :ref:`wider feature set <sec-go-appimagetool>`.


AppRun.c
++++++++

`AppRun.c` (also available as precompiled binary) is a program that attempts to make the application binary relocatable by manipulating environment variables. However, it is legacy technology and should be avoided. Modern :ref:`appimage-creation-tools` use a better approach to make the binaries relocatable and made :code:`AppRun.c` obsolete in most cases.


Helpers
+++++++

AppImageKit ships with a few helpers that can be used by AppImage developers to verify and validate some AppImage features, mostly for debugging.

Note that these helpers currently need to be built from source. In the future, they may become bundled with, or their functionality integrated into, appimagetool.


validate
########

:code:`validate` can validate the PGP signatures inside AppImages. Its source code is available under https://github.com/AppImage/AppImageKit/blob/master/src/validate.c.


digest-md5
##########

:code:`digest-md5` calculates the MD5 digest used for desktop integration purposes for a given AppImage. This digest depends on the path, not on the content. Its source code is available under https://github.com/AppImage/AppImageKit/blob/master/src/digest_md5.c.


.. _ref-appimageupdate:

AppImageUpdate
--------------

AppImageUpdate_ lets you update AppImages in a decentralized way using information embedded in the AppImage itself.

The project consists of two tools: :code:`appimageupdatetool`, a full-featured CLI tool for updating AppImages and dealing with `update information`_, and :code:`AppImageUpdate`, a user interface for updating AppImages written in Qt.

.. _AppImageUpdate: https://github.com/AppImage/AppImageUpdate
.. _update information: https://github.com/AppImage/AppImageSpec/blob/master/draft.md\#update-information

**Download:** You can get it as an AppImage from https://github.com/AppImage/AppImageUpdate/releases/continuous.
