.. include:: ../substitutions.rst

.. _portable-mode:

Using portable mode
===================

This page describes the portable mode. It allows for bundling an application's data next to the application's AppImage. Only type 2 AppImages provide it, |recent_type_2|. |different_types|

.. contents:: Contents
   :local:
   :depth: 1


Introduction
------------

Sometimes it can be useful for data of an application to travel along with the application, for example to put the application on a USB drive that can be used with different computers. In the Windows world, this concept is known as "portable applications".

Normally, the application contained inside an AppImage will store its application data (e.g. configuration files) wherever it always stores them (most frequently somewhere inside ``$HOME``). In other words, the fact that an application is contained inside an AppImage normally does not change where the application stores its data.

However, there is functionality in type 2 AppImages that can make the application's data travel along with the application. If you invoke a type 2 AppImage and have certain directories present *next to the AppImage file* (in the same directory), the AppImage will store its application data and configuration files alongside the AppImage. This can be useful for portable use cases, e.g., carrying an AppImage on a USB drive, along with its data.

- If there is a directory with the same name as the AppImage plus ``.home``, then ``$HOME`` will automatically be set to it before executing the payload application. This means that all application data that the application would usually store in ``$HOME`` will now be stored in the ``<AppImageName>.home`` folder and can be moved across devices.
- If there is a directory with the same name as the AppImage plus ``.config``, then ``$XDG_CONFIG_HOME`` will automatically be set to it before executing the payload application. This means that all application data that the application would usually store in ``$XDG_CONFIG_HOME`` will now be stored in the ``<AppImageName>.config`` folder and can be moved across devices.


Example
-------

Imagine you want to use Inkscape, but carry its settings around with the executable. You can do the following:

.. code-block:: shell

	# Download the Inkscape AppImage and make it executable
	# This is just an example code; you should use the up to date version of the program
	> wget https://inkscape.org/gallery/item/53678/Inkscape-e7c3feb-x86_64.AppImage -O Inkscape.AppImage
	> chmod +x Inkscape.AppImage

	# Create a directory with the same name as the AppImage plus the ".config" extension
	# in the same directory as the AppImage
	> mkdir Inkscape.AppImage.config

	# Run Inkscape.AppImage, change some setting in the preferences panel (e.g. the interface
	# language) and close it
	> ./Inkscape.AppImage.config

	# Now, check where the settings were written:
	> find Inkscape.AppImage.config
	(...)
	Inkscape.AppImage.config/Inkscape/preferences.xml


Note that the file ``preferences.xml`` was written in the new directory next to the AppImage that can be carried around together with the AppImage itself.
