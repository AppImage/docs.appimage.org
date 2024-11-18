.. include:: ../substitutions.rst

.. _ref-quickstart:

Quickstart
==========

This page contains information for users new to AppImage, and want to get started.


.. contents:: Contents
   :local:
   :depth: 1


.. _ref-how-to-run-appimage:

How to run an AppImage
----------------------

It's quite simple to run AppImages. All you have to do is download them, make them executable and run them. This can either be done using the GUI or via the command line.


Using the GUI
*************

#. Open your file manager and browse to the location of the AppImage
#. Right-click on the AppImage and click the ‘Properties’ entry
#. Switch to the Permissions tab and
#. Click the ‘Allow executing file as program’ checkbox if you are using a Nautilus-based file manager (Files, Nemo, Caja), click the ‘Is executable’ checkbox if you are using Dolphin, or change the ‘Execute’ drop down list to ‘Anyone’ if you are using PCManFM
#. Close the dialog
#. Double-click on the AppImage file to run

Please see also the video below:

.. image:: /_static/img/make-executable.gif


Using the Terminal
******************

#. Open a terminal
#. Change to the directory containing the AppImage, e.g., using :code:`cd <my directory>`
#. Make the AppImage executable: :code:`chmod +x my.AppImage`
#. Run the AppImage: :code:`./my.AppImage`

That's it! The AppImage should now be executed.


Translated versions of this guide
*********************************

Translated versions are available in a `post in the AppImage forum <https://discourse.appimage.org/t/how-to-run-an-appimage/80>`__.


Getting help
------------

|contact|

