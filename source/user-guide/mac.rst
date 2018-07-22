AppImage for macOS switchers
============================

.. image:: https://user-images.githubusercontent.com/2480569/29998412-7f0f9416-902a-11e7-9d5f-472649e1af34.png

This chapter compares the AppImage terms to its macOS equivalents. It
should help macOS to Linux switchers to "get" AppImage concepts quickly.

+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| AppImage concept                                                                | Rough macOS equivalent                                                                    |
+=================================================================================+===========================================================================================+
| ``.AppImage`` file                                                              | ``.app`` inside a ``.dmg`` file                                                           |
|                                                                                 | that mounts itself automatically                                                          |
|                                                                                 | when executed                                                                             |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| ``.AppDir`` directory                                                           | ``.app`` directory                                                                        |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| ``.desktop`` file                                                               | ``Info.plist`` file                                                                       |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| ``*.metainfo.xml`` file and  ``package.json`` file (for  Electron apps)         | ``Info.plist`` file (more elaborate version thereof)                                      |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| ``usr/`` inside the AppDir                                                      | ``Resources/`` inside the ``.app``                                                        |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| `AppImageUpdate`_                                                               | `Sparkle Framework`_                                                                      |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| No direct equivalent, but `update information`_ in ELF section ``.upd_info``    | `Sparkle appcast`_                                                                        |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| Optional ``appimaged`` daemon                                                   | `Launch Services`_ to register applications in the system (e.g., MIME types, icons, etc.) |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| No direct equivalent, but AppImageHub_ central directory of available AppImages | Mac App Store                                                                             |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| Optional signature in ELF section                                               | Signatures in ``/Contents/_MASReceipt/``                                                  |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| No direct equivalent (yet?), but use `linuxdeployqt`_ (for Qt, C++, C) or       | **Xcode** IDE generates ``.app``  when you click "compile"                                |
| `electron-builder`_ for Electron apps in the build chain                        |                                                                                           |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+
| ``appimagetool my.AppDir my.AppImage``                                          | ``hdiutil create -volname myApp -srcfolder my.app/../ -ov -format UDZO myApp.dmg``        |
+---------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------+


.. _AppImageUpdate: https://github.com/AppImage/AppImageUpdate
.. _AppImageHub: https://github.com/appimage/appimage.github.io
.. _Sparkle Framework: https://sparkle-project.org/
.. _update information: https://github.com/AppImage/AppImageSpec/blob/master/draft.md#update-information
.. _Sparkle appcast: https://sparkle-project.org/
.. _Launch Services: https://developer.apple.com/documentation/coreservices/launch_services
.. _linuxdeployqt: https://github.com/probonopd/linuxdeployqt
.. _electron-builder: https://github.com/electron-userland/electron-builder
