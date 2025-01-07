.. _appstream:

AppStream metadata
==================

AppImages can optionally embed an AppStream file. AppStream is a cross-distribution standard to provide metadata for software in the Linux ecosystem. It is a convenient way to get information about (uninstalled) software and one of the building blocks for software centers.


.. contents:: Contents
   :local:
   :depth: 1


Why should I include an AppStream file in my AppImage?
------------------------------------------------------
While the :ref:`desktop entry file <desktop-entry-files>` provides some very rudimentary metadata (like the application name or icon), it lacks more specific metadata about the project like a description, a licence or screenshots. This all can be included in the optional AppStream file that is bundled inside your AppImage.

While some desktop environments and file managers use this information, e.g. to display the description, it is especially important for app stores, AppImage catalogs and software centers. With an AppStream file, they all can get the metadata necessary to display an application (like a description, URLs and images) out of an AppImage itself without having to rely on manual input.

This also allows your AppImage to be published in different app stores / catalogs with the same consistent descriptions, images, etc., without manual work.

AppStream is a format that exists independently of AppImage and can be used in conjunction with other packaging formats as well. Many open source applications already come with AppStream files by default.

.. seealso::
    More information on AppStream can be found on the `FreeDesktop.org pages <https://www.freedesktop.org/software/appstream/docs/chap-Quickstart.html#sect-Quickstart-DesktopApps>`__.


Generating an AppStream file
----------------------------

An easy way to generate an AppStream file is to use our generator:

.. raw:: html
   :file: appstream-generator.html


Validating an AppStream file
----------------------------
It is generally a good idea to check AppStream files for errors using the `appstreamcli <https://github.com/ximion/appstream>`_ (or ``appstream-util``) CLI tools. ``apppimagetool`` will automatically attempt to validate the AppStream file if one of these are available on the ``$PATH``.


Embedding an AppStream file
---------------------------
If your :ref:`AppImage creation tool <appimage-creation-tools>` automatically creates the AppDir from CLI arguments, look at the guide for the respective tool:

* To see how to embed an AppStream file with :ref:`linuxdeploy`, see :ref:`this <linuxdeploy-appstream>` section of the linuxdeploy guide.

If your AppImage creation tool requires you to manually create an AppDir structure, you have to place the AppStream file under ``AppDir/usr/share/metainfo/myapp.metainfo.xml`` (preferred) or ``AppDir/usr/share/metainfo/myapp.appdata.xml``. After that, you can just generate the AppImage from the AppDir like usual.
