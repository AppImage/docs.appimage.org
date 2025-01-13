.. include:: ../substitutions.rst

Downloading and updating AppImages
==================================

This page provides an overview on where to download and how to update AppImages.

.. contents:: Contents
   :local:
   :depth: 2


Download AppImages
------------------

AppStreams are usually downloaded from the creator themself. The AppImage ecosystem is built around the notion of :ref:`upstream packaging <upstream-packaging>`. |upstream_advantage| However, there still are several ways to get them:

The most common way is to download AppImages directly from the website on which the creator hosts them. This is usually either a project website or GitHub releases (or both). This is intuitive: If you search for a specific application, you just go to its website and download the AppImage of the latest release.


.. _software-catalogs-user:

Software catalogs
+++++++++++++++++

However, there also is a second option: If you don't want to download a specific application, but rather just *an* application that does something you need, e.g. audio editing, it might be frustrating to search for something that fits your needs and is available in the format you want. That's why so-called *software catalogs* exist: |software_catalogs_short|

These stores link to or use the original download location, so that you can be sure to get the originally packaged applications; they merely act as an index of available AppImages to find the applications you need more easily.

You can browse the two most user friendly software catalogs under https://appimage.github.io/apps/ resp. https://www.appimagehub.com/browse?ord=alphabetical. For more specific information on other catalogs, see :ref:`this section <software-catalogs-dev>`.


.. _updates-user:

Update AppImages
----------------

Many AppImages embed so-called update information. This means that you don't have to manually download a new version, but the AppImages already contain information where an update can be fetched from. Such AppImages can be updated with external tools that use this embedded update information (see below). This also speeds up the process and saves bandwidth as not the full AppImage is downloaded, but only the update changes.

Some AppImages are even self-updateable. This means that they embed not only update information, but also the functionality that automatically downloads and performs the update. If you use a self-updateable AppImage, you can simply update it using the AppImage's user interface / menu.

However, in case you don't find any such option or don't know whether the AppImage is self-updateable, you can update any updateable AppImage with `AppImageUpdate`_. AppImageUpdate is a program in which you can select any updateable AppImage and update it. Alternatively, you can also use appimageupdatetool, which allows you to do the same with a CLI.

Both AppImageUpdate and appimageupdatetool can be downloaded at https://github.com/AppImageCommunity/AppImageUpdate/releases.
