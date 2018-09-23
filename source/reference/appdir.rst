.. _appdir-description:
.. _appdir:
.. _ref-appdir:

AppDir description
====================

This page describes the *AppDir* format. AppDirs are the "source" of AppImages. When building an AppImage, a filesystem image is built from such a directory, to which a runtime is prepended.


History
-------

The AppDir format has first been described by `ROX Filer`_, and has since been extended by the AppImage project to suit their needs.

.. _ROX Filer: http://rox.sourceforge.net/desktop/AppDirs.html


General description
-------------------

As the name intends, AppDirs are normal directories with some special contents:

``AppRun``
   A file (executable, script, etc.) or symlink, serving as the "entry point" for a specific application. It is located in the root directory that makes up an AppDir, so it can be used to calculate paths relative to the (later mounted) AppDir.

.. _ref-diricon:
``.DirIcon``
   Symlink to an icon, normally located in the root directory. Can be used by e.g., thumbnailers, to display application icons rather than a generic filetype symbol.

These two entries have been re-used from `ROX Filer`_'s specification. `ROX Filer`_ actually specifies additional (but optional) entries, however, AppImage doesn't use these. Instead, the following ones have been introduced:

``myapp.desktop``
   A desktop file located in the root directory, describing the payload application. As AppImage is following the principle :ref:`one app = one file <one-app-one-file-principle>`, one desktop file is enough to describe the entire AppImage. There |must not| be more than one desktop file in the root directory. The name of the file doesn't matter, as long as it carries the ``.desktop`` extension. Can be a symlink to subdirectories such as ``usr/share/applications/...``

.. _root-icon:
``myapp.<icon ext>`` (e.g., ``myapp.png``, ``myapp.svg``)
   Application's icon in the best available quality, ideally a vector graphic. Can be a symlink to subdirectories such as ``usr/share/icons/hicolor/...``. In most cases, :ref:`ref-diricon` is a symlink to this file. The filename must be equal to what is set in the ``Icon=`` entry in the desktop file. It is recommended by AppImage and also the XDG icon specifications to use a lower-case filename which is equal to the desktop file's name.

   .. note::
      The ``Icon=`` entry |should not| contain the file extension, the actual file's filename however |should| carry the extension.

These four types of entries |must| be contained in the AppDir to conform to this specification.


Conventions
-----------

In contrary to the rules in the previous section, the ones introduced in this section are no basic requirement. However, this is the recommended structure to put applications into AppDirs. It's picking up ideas from well-known, widely spread Linux standards such as the `Filesystem Hierarchy Standard`_ (part of the `Linux Standards Base`_).

.. seealso::
   A very good summary of the FHS can be found on `Wikipedia <https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard>`_.

.. _Filesystem Hierarchy Standard: https://wiki.linuxfoundation.org/lsb/fhs
.. _Linux Standards Base: https://wiki.linuxfoundation.org/lsb/start


``usr`` subdirectory
''''''''''''''''''''

Analog to the FHS, most AppDirs, especially the ones created by the official tools such as :ref:`linuxdeploy <ref-linuxdeploy>`, contain a ``usr`` directory.

``usr`` originally abbreviated *unix system resources*. According to the FHS, it contains shared, read-only data, which perfectly suits AppImage's needs, as AppImages are read-only, too.

The directory contains applications, (shared) libraries, desktop files, icons etc., in separate directories. Only a few of them are useful for AppDirs:

``bin``
   Executables that can be called by a user.

``lib``
   (Shared) libraries used by applications in ``bin``.

``share``
   Architecture-independent (shared) data. Inside this directory, some special directories are commonly placed:

   ``applications``
      Contains desktop files for applications in ``bin``. Normally, there's just one desktop file in this directory, which is symlinked in the root directory.

   ``icons``
      Directory containing so-called `icon themes`_. Contains at least one, but often a set of icons for the main application. The icons are referred to by the root desktop file, which means the :ref:`same constraints <root-icon>` apply.
      Example path: ``<root>/usr/share/icons/<theme>/<resolution>/apps/myapp.<ext>``, e.g., ``<root>/usr/share/icons/hicolor/256x256/apps/myapp.png``
      Icon themes placed in this directory are copied to the system during so-called :ref:`desktop integration <ref-desktop-integration>`.

.. _icon themes: https://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html


Summary
'''''''

The modern packaging tools such as :ref:`linuxdeploy <ref-linuxdeploy>` create these directories by default to standardize and harmonize AppDir creation. If you intend to :ref:`create AppDirs manually <ref-manual>`, you are recommended to follow these recommendations.


.. |must| replace:: **MUST**
.. |must not| replace:: **MUST NOT**
.. |should| replace:: **SHOULD**
.. |should not| replace:: **SHOULD NOT**

