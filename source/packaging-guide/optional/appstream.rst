.. _ref-appstream:

AppStream metadata
==================

AppStream is a cross-distribution effort for providing metadata for software in the (Linux) ecosystem.
It provides a convenient way to get information about not installed software,
and is one of the building blocks for software centers.


.. contents:: Contents
   :local:
   :depth: 1


Why should I include AppStream metadata in my AppImage?
-------------------------------------------------------

Desktop environments, file managers, AppImage catalogs, software centers, and app stores can use metadata about the application from inside the AppImage to get a description, URLs, screenshots, and other information that describes the application. This optional metadata travels inside the AppImage.

So if you would like your application to show a nice screenshot in app centers, you should add an AppStream metainfo file to your AppImage. AppStream is a format that exists independently of AppImage and can be used in conjunction with other packaging formats as well. Many open source applications already come with AppStream metainfo files by default.

.. seealso::
    More information on AppStream can be found on the `FreeDesktop.org pages <https://www.freedesktop.org/software/appstream/docs/chap-Quickstart.html#sect-Quickstart-DesktopApps>`__.


Using the AppStream generator
-----------------------------

An easy way to generate an AppStream metainfo file is to use our generator below.

.. raw:: html
   :file: appstream-generator.html


Embedding the AppStream metadata
--------------------------------

Once you have generated a suitable AppStream metainfo file, place it into :code:`usr/share/metainfo/myapp.appdata.xml` in your AppDir, and generate an AppImage from it. It is generally a good idea to check AppStream metainfo files for errors using the :code:`appstreamcli` and/or :code:`appstream-util` command line tools. :code:`appimagetool` will automatically attempt to validate the AppStream metainfo file if :code:`appstreamcli` and/or :code:`appstream-util` are available on the :code:`$PATH`.
