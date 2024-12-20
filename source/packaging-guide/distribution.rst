Distributing AppImages
======================

This sections contains some details on how AppImages can be distributed and what you should consider when doing so.

.. contents:: Contents
   :local:
   :depth: 1


Hosting AppImages
-----------------

The most accessible way to host AppImages is on a project website.

We recommend that you put the AppImage for Linux on your project's download page alongside the dmg for macOS and the exe for Windows, like this:

.. image:: /_static/img/packaging-guide/release-page-screenshot.png
	:width: 80%
	:align: center
	:alt: Download page overview, showing Windows, MacOS, Linux and Source code downloads

If your project is open source and located on GitHub, we recommend that you also publish your AppImage on `GitHub Releases <https://help.github.com/en/articles/creating-releases/>`_.

.. note::
   For :ref:`AppImageUpdate <ref-updates>` to work properly, it is required that the web server supports HTTP range requests. While most web hosts support this, some hosted services are known not to support range requests right now. These include

      - `Gitlab releases <https://gitlab.com>`_

   If you use such a service and wish to use :ref:`AppImageUpdate <ref-updates>` with it, please ask the providers to enable range requests.

'Download as an AppImage' button
++++++++++++++++++++++++++++++++

You can use a "Download as an AppImage" button alongside other similar buttons:

.. image:: /_static/img/download-appimage-banner.svg
    :alt: Download as an AppImage

Link this button directly to the latest version of your AppImage or to a download page with the latest version of your AppImage.

Button by `Khushraj Rathod <https://github.com/Khushraj/>`__ under the `CC0 license <https://creativecommons.org/share-your-work/public-domain/cc0/>`_ (Public Domain).


.. _software-catalogs-dev:

Software catalogs
-----------------

Additionally to hosting your AppImage, you may want to add your AppImage to a software catalog. Those are crowd-sources lists of available AppImages with data that 3rd party app stores and software centers can use. This way, users can also find your AppImage when browsing through such catalogs and stores or searching for a specific tool.

These software catalogs use the :ref:`AppStream metadata <ref-appstream>` inside the AppImage, therefore your AppImage will be presented consistently across them and you don't have to input information manually.

The following software catalogs are known to us:


AppImage.github.io
++++++++++++++++++

AppImage.github.io (`source code <https://github.com/AppImage/appimage.github.io>`_) is the oldest software catalog. It automatically inspects and tests all added AppImages to make sure they are functioning correctly.

You can see the list of all AppImages in it in alphabetical order under https://appimage.github.io/apps/. There also is a more modern frontend under https://g.srev.in/get-appimage/all/p/0 (`source code <https://github.com/srevinsaju/get-appimage>`_). Each entry links to the original download location (usually GitHub releases) where you can download it.

To get your own AppImage included, see the `detailed tutorial on its readme <https://github.com/AppImage/appimage.github.io?tab=readme-ov-file#how-to-submit-appimages-to-the-catalog>`_. If you want to add your AppImage to this catalog, you have to host it raw, and not inside another archive like a ``.zip`` or ``.tar.gz``.

To use the dataset, simply parse https://appimage.github.io/feed.json.

Projects using this data include:

* Bauh (https://github.com/vinifmor/bauh)
* LiureX Software Store (https://github.com/lliurex/lliurex-store)
* Zap (https://github.com/srevinsaju/zap)


AppImageHub.com
+++++++++++++++

AppImageHub.com is a software catalog that is related to opendesktop.org.

You can see the list of all AppImages in it in alphabetical order under https://www.appimagehub.com/browse?ord=alphabetical. Each entry contains a download button which will download the AppImage from its original location (usually GitHub releases).

To get your own AppImage included, you have to register / login on the site with your opendesktop.org - Account and then add it via the website GUI.

To use the dataset, you have to use the official API which is located at ``https://api.appimagehub.com/ocs/v1``. The API is following the `OCS <https://en.wikipedia.org/wiki/Open_Collaboration_Services>`_ standard (`specification <https://www.freedesktop.org/wiki/Specifications/open-collaboration-services/>`_). Sadly as of December 2024, there is no good tutorial on how to use the API. If you want to use it, it's best to look at `this <https://github.com/Nitrux/nx-software-center/blob/2be15522c039c0a1c73aa647433a8a16d1734259/src/stores/opendesktopstore.cpp>`_ and test the API yourself with ``/content/categories`` and ``/content/data``.

Projects using this data include:

* NX Software Center (Nitrux OS) (https://github.com/Nitrux/nx-software-center)
* appimage-cli-tool (https://github.com/AppImageCrafters/appimage-cli-tool)
* AppImagePool (https://github.com/prateekmedia/appimagepool)


Portable Linux Apps / AM
++++++++++++++++++++++++

Portable Linux apps (`source code <https://github.com/Portable-Linux-Apps/Portable-Linux-Apps.github.io>`_) is another AppImage software catalog that has been created because of `dissatisfaction <https://portable-linux-apps.github.io/#how-is-this-site-different-from-other-sites-that-list-appimage-packages>`_ with appimage.github.io and appimagehub.com.

Differently to those two, its main purpose is not to provide links to download the original AppImages, but rather to be used through `AM / AppMan <https://github.com/ivan-hc/AM>`_, a related package manager that can install, update and manage the AppImages from this catalog. Therefore, PLA contains an install script (which uses the original AppImage location) for each AppImage, which is used by AM.

Nevertheless, you can see the list of all AppImages in it in alphabetical order under https://portable-linux-apps.github.io/apps.html. To download an AppImage from the original location, navigate to its website over the entry description or install script.

To get your own AppImage included, you have to `make a pull request <https://github.com/ivan-hc/AM/pulls>`_ in which you add your AppImage to the `index <https://github.com/ivan-hc/AM/blob/main/programs/x86_64-apps>`_ and create an installer script (see `this tutorial <https://github.com/ivan-hc/AM/blob/main/docs/guides-and-tutorials/template.md>`_).


SoarPkgs
++++++++

SoarPkgs is another software catalog with AppImages as well as other package types, following a similar approach to PLA.

As PLA, its main purpose is not to provide links to download the original AppImage, but rather to be used through a related package manager called `Soar <https://github.com/pkgforge/soar>`_, which can install, update and manage the packages from this catalog. Like PLA, SoarPkgs contains an install script (which uses the original AppImage location) for each AppImage, which is used by Soar.

You can see the list of all AppImages in it in alphabetical order under https://github.com/pkgforge/soarpkgs/tree/main/packages (SoarPkgs doesn't have a website displaying the list). To download an AppImage from the original location, navigate to its website over the entry install script.

To get your own AppImage included, see the `detailed tutorial in its documentation <https://docs.pkgforge.dev/orgs/readme/projects/soarpkgs/package-request>`_


Complying with licenses
-----------------------

Even under open source licenses, distributing and/or using code in source or binary form may create certain legal obligations, such as the distribution of the corresponding source code and build instructions for GPL licensed binaries, and displaying copyright statements and disclaimers. As the author of an application which you are distributing as an AppImage, you are responsible to obey all licenses for any third-party dependencies that you include in your AppImage, and ensure that their licenses and source code are made available, where required, together with the release binaries. AppImageKit itself is released under the permissive MIT license.


Recommendations
---------------

Don't put "Linux" into the Appimage file name
++++++++++++++++++++++++++++++++++++++++++++++

You shouldn't put "linux" into the file name of an AppImage. It is clear that an :code:`.exe` is for Windows, an :code:`.app` is for macOS and that an :code:`.AppImage` is for Linux (and compatible systems such as Windows with WSL2 and FreeBSD with the Linuxulator). Especially as this is the file your users will always have on their system, you shouldn't put redundant information in its name.

Make your AppImage discoverable
+++++++++++++++++++++++++++++++

To help users to easily find your AppImage, you can post about it on social media, e.g. on a blog. You can use the ``#AppImage`` hashtag for discoverability.
