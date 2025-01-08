AppImage for macOS switchers
============================

.. image:: /_static/img/dmg-AppImage.png

This page compares the AppImage terms to its macOS equivalents. It should help macOS to Linux switchers to "get" AppImage concepts quickly.

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - AppImage concept
     - Rough macOS equivalent
   * - ``.AppImage`` file
     - ``.app`` directory (treated as a file)
   * - ``.AppDir`` directory
     - ``.app`` directory content (in ``.app/Contents``)
   * - ``.desktop`` file
     - ``Info.plist`` file
   * - ``*.metainfo.xml`` file and  ``package.json`` file (for  Electron apps)
     - ``Info.plist`` file (more elaborate version thereof)
   * - ``usr/`` inside the AppDir
     - ``Resources/`` inside ``.app/Contents``
   * - `AppImageUpdate <https://github.com/AppImage/AppImageUpdate>`_
     - `Sparkle Framework <https://sparkle-project.org/>`_
   * - No direct equivalent, but `update information <https://github.com/AppImage/AppImageSpec/blob/master/draft.md#update-information>`_ in ELF section ``.upd_info``
     - `Sparkle appcast <https://sparkle-project.org/>`_
   * - Optional ``appimaged`` daemon
     - `Launch Services <https://developer.apple.com/documentation/coreservices/launch_services>`_ to register applications in the system (e.g. MIME types or icons)
   * - :ref:`Software catalogs <software-catalogs-user>` of available AppImages
     - Mac App Store
   * - Optional signature in ELF section
     - Signatures in ``/Contents/_CodeSignature/``
   * - :ref:`appimage-creation-tools` that generate an AppImage from the executable
     - **Xcode** IDE generates ``.app``  when you click "compile"

..
   TODO: Link signatures page
