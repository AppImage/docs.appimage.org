.. include:: ../substitutions.rst

.. _faq:

Frequently Asked Questions
==========================

The most common questions are answered directly here to save you from having to read the entire user guide.


.. contents:: Contents
   :local:
   :depth: 1


|question| What is an AppImage?
-------------------------------

An AppImage is a downloadable file for Linux that contains an application and everything the application needs to run (libraries, icons, fonts, translations, etc.) that cannot be reasonably expected to be part of each target system.


|question| How do I run an AppImage?
------------------------------------

Make it executable (using the GUI or via command line) and double-click it. See :ref:`ref-how-to-run-appimage` for detailed instructions on how to do this.


|question| How can I integrate AppImages with the system?
---------------------------------------------------------

|appimage_standalone_bundles|

|desktop_integration| This can easily be done with one of the desktop integration tools that are introduced in :ref:`ref-desktop-integration`.


|question| Where can I download AppImages?
------------------------------------------

If you want to download a specific application, the easiest way to do so is to go to the application releases (e.g. on GitHub or the application website) and download the newest release as an AppImage.

If you want to have a central catalog of available AppImages, e.g. to know what's available, check out AppImageHub. AppImageHub is a crowd-sourced directory of available AppImages. It doesn't provide the AppImages directly, but instead links to the original author's download URLs, so you can be sure to download the originally packaged applications. Its database can also be used by other third party app stores, which is done by e.g. the `Nitrux <https://nxos.org>`_ OS.

..
   TODO: Add links (see the TODO in the AppImageHub section)
   Improve this section when improving the AppImageHub section


|question| Where do I store my AppImages?
-----------------------------------------

An important point about the AppImage format is that you can store AppImage files wherever you want. This includes your home directory, your downloads directory, a dedicated applications directory, a USB drive, or even a network file share. No matter where you keep your AppImages, you are still able to run them. This is very similar to how applications work on macOS. Unlike with traditional Linux packages, you do not need to install AppImages or put them into some special location in order for them to work.

If you don't want to leave them in :code:`~/Downloads`, then :code:`~/Applications` is a good choice. Many third-party tools (e.g. the ones managing desktop integration) use this location, too.

For CLI tools, :code:`~/.local/bin` and :code:`~/bin` are also good places, as these are usually included in the path, meaning that you can simply type the application name into the terminal to start it.


|question| Where can I request AppImages?
-----------------------------------------

If there is no AppImage of your favorite application available, you should request it from the author(s) of the application, e.g. as a feature request in the issue tracker of the application.

For example, if you would like to see an AppImage of Mozilla Firefox, then leave a comment at https://bugzilla.mozilla.org/show_bug.cgi?id=1249971. The more people request an AppImage from the upstream authors, the more likely is that an AppImage will be provided.


|question| Where do I get support?
----------------------------------

|contact|


.. |question| image:: /_static/img/question.png
