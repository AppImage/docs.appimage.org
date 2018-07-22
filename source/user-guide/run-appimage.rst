Running an AppImage
===================

This page shows how a user can run AppImages, on their favorite distribution using the desktop environment tools or via the terminal. Also, it explains the concept of desktop integration, and presents tools that can be used for this purpose.


.. _download-make-executable-run:

Download, make executable, run
------------------------------

It's quite simple to run AppImages. As the heading says, just download them, make them executable and run them. This can either be done using the GUI or via the command line.


Using the GUI
*************

#. Open your file manager and browse to the location of the AppImage
#. Right-click on the AppImage and click the ‘Properties’ entry
#. Switch to the Permissions tab and
#. Click the ‘Allow executing file as program’ checkbox if you are using a Nautilus-based file manager (Files, Nemo, Caja), or click the ‘Is executable’ checkbox if you are using Dolphin, or change the ‘Execute’ drop down list to ‘Anyone’ if you are using PCManFM
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

Translated versions are available in a `post in the AppImage forum <https://discourse.appimage.org/t/how-to-make-an-appimage-executable/80>`_.


.. _desktop-integration:

Integrating AppImages into the desktop
--------------------------------------

AppImages are standalone bundles, and do not need to be *installed*. However, some users may want their AppImages to be available like distribution provided applications. This primarily involves being able to launch desktop applications from their desktop environments' launchers. This concept is called *desktop integration*.

appimaged
*********

`appimaged <https://github.com/AppImage/appimaged>`_ is a daemon that monitors the system and integrates AppImages. It monitors a predefined set of directories on the user's system searching for AppImages, and integrates them into the system using :ref:`libappimage`.

.. seealso::
   More information on appimaged can be found in :ref:`appimaged`.


AppImageLauncher
****************

`AppImageLauncher <https://github.com/TheAssassin/AppImageLauncher>`_ is a helper application for Linux distributions serving as a kind of "entry point" for running and integrating AppImages. It makes a user's system AppImage-ready™.

.. seealso::
   More information about AppImageLauncher can be found in :ref:`sec-appimagelauncher`.


