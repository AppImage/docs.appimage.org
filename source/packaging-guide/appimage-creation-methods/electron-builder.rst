.. _sec-electron-builder:

electron-builder
======================

electron-builder is a tool that can be used by application authors to easily package their `Electron <https://electronjs.org>`_ projects not only as AppImages but also as other application formats for Linux (e.g. Flatpak or Snap), macOS (e.g. DMG) and Windows (e.g. Installer or Portable).

With electron-builder, making AppImages is as simple as defining ``AppImage`` as a target for Linux (which is the default in the latest version of electron-builder). This should yield usable results for most applications.

Therefore, it's the recommended solution if your app is Electron based. Otherwise, this AppImage creation method is not applicable.

More information can be found in the `documentation on AppImage <https://www.electron.build/configuration/appimage.html>`_ and the `documentation on distributable formats <https://www.electron.build/index>`_ in the `electron-builder manual <https://www.electron.build>`_.

There are also a lot of examples on GitHub that can be found using the `GitHub search <https://github.com/search?utf8=%E2%9C%93&q=electron-builder+linux+target+appimage&type=Code&ref=searchresults>`_.
