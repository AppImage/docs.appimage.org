.. include:: ../substitutions.rst

.. _quickstart:

Quickstart
==========

This page contains information for users new to AppImage that helps them to get started quickly and easily.

It also answers the most common questions to save you from having to read the entire user guide.

.. contents:: Contents
   :local:
   :depth: 1


What is an AppImage?
--------------------

An AppImage is a downloadable file for Linux that contains |appimage_content|.

The AppImage format is standardized. However, the specification doesn't define to compile applications in a specific way: It's not a build system, but rather like a ``.zip`` file, just that the application data is bundled in a specific way.


.. _how-to-run-appimage:

How to run an AppImage
----------------------

It's very easy to run an AppImage. All you have to do is to download it, make it executable and run it (e.g. by double-clicking it).

Making a file executable can both be done using the terminal or the file manager:


Using the terminal
++++++++++++++++++

#. Open a terminal (command line)
#. Make the AppImage executable: ``chmod +x ~/Downloads/MyApplication.AppImage``
#. Run the AppImage by entering its path: ``~/Downloads/MyApplication.AppImage``


Using the file manager
++++++++++++++++++++++

#. Open your file manager and browse to the location of the AppImage
#. Right-click the AppImage and select "Properties"
#. Switch to the "Permissions" tab
#. Check the box to set executable permissions. Depending on your file manager, this might be called **"Allow executing file as program"** or **"Is executable"**.
   In some file managers, you might not have such a checkbox, but instead have to change an "Execute" drop down list to "Anyone" or an "Access" drop down list to "Read, Write & Execute".
#. Close the dialog and double-click the AppImage to run it

The following video also shows how to do this: (This might look slightly different for you, depending on your file manager.)

.. image:: /_static/img/make-executable.gif

This guide is also available in other languages `here <https://discourse.appimage.org/t/how-to-run-an-appimage/80>`_.


How to run an AppImage in a docker container
--------------------------------------------

Most docker containers don't permit something called :ref:`FUSE <fuse-troubleshooting>`, which is usually required for AppImages to run. However, you can run AppImages |appimages_without_fuse|. For more information on that, see :ref:`fuse-fallback`.


The AppImage doesn't start / work
---------------------------------

|appimage_not_starting_1|

|appimage_not_starting_2|

If the error information includes "Fuse", e.g. "AppImages require FUSE to run.", :ref:`this page <fuse-troubleshooting>` can help you fixing this issue.

Otherwise, report this issue with the printed error messages to the application author or :ref:`contact us <contact>` for further help.


How to integrate AppImages into the system
------------------------------------------

|appimage_standalone_bundles|

|desktop_integration| This can easily be done with one of the desktop integration tools that are introduced in :ref:`desktop-integration`.


Where to store AppImages
------------------------

An important point about the AppImage format is that you can store AppImage files wherever you want. This includes your home directory, your downloads directory, a dedicated applications directory, a USB drive, or even a network file share. No matter where you keep your AppImages, you are still able to run them. This is very similar to how applications work on macOS. Unlike with traditional Linux packages, you do not need to install AppImages or put them into some special location in order for them to work.

If you don't want to leave them in ``~/Downloads``, then ``~/Applications`` is a good choice. Many third-party tools (e.g. the ones managing desktop integration) use this location, too.

For CLI tools, ``~/.local/bin`` and ``~/bin`` are also good places, as these are usually included in the path, meaning that you can simply type the application name into the terminal to start it.


Getting help
------------

|contact|
