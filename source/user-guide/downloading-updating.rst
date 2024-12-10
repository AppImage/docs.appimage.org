Downloading and updating AppImages
==================================

This page provides an overview on where to download and how to update AppImages.

.. contents:: Contents
   :local:
   :depth: 2

Download AppImages
------------------

.. todo::
   Add this section

Update AppImages
----------------

Many AppImages embed so-called update information. This means that you don't have to manually download a new version, but the AppImages already contain information where an update can be fetched from. Such AppImages can be updated with external tools that use this embedded update information (see below). This also speeds up the process and saves bandwidth as not the full AppImage is downloaded, but only the update changes.

Some AppImages are even self-updateable. This means that they embed not only update information, but also the functionality that automatically downloads and performs the update. If you use a self-updateable AppImage, you can simply update it using the AppImage's user interface / menu.

However, in case you don't find any such option or don't know whether the AppImage is self-updateable, you can update any updateable AppImage with `AppImageUpdate <https://github.com/AppImageCommunity/AppImageUpdate/>`_. AppImageUpdate is a program in which you can select any updateable AppImage and update it. Alternatively, you can also use appimageupdatetool, which allows you to do the same with a CLI.

Both AppImageUpdate and appimageupdatetool can be downloaded at https://github.com/AppImageCommunity/AppImageUpdate/releases.
