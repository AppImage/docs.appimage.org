.. _ref-distribution:

Distributing AppImages
======================

There are several ways to distribute AppImages to users. Most likely, AppImages are distributed from their creator to the users.

The following section contains some details on how AppImages are commonly distributed.


.. _ref-hosting-appimages:

Hosting AppImages
-----------------

Most commonly, AppImage creators host the files on a standard webserver. This is the easiest and most accessible way.

We recommend that you put the AppImage for Linux on your project's download page alongside the dmg for macOS and the exe for Windows, like so:

.. image:: /_static/img/packaging-guide/release-page-screenshot.png
	:width: 80%
	:align: center
	:alt: Download page overview, showing Windows, MacOS, Linux and Source code downloads

For open source projects, if your project is located on GitHub, we recommend that you publish your AppImage in addition on `GitHub Releases`_.

.. note::
   For :ref:`AppImageUpdate` to work properly, it is required that the web server supports HTTP range requests. Most web hosts support this, as the same technology is used for navigating an MP3 files, for example.

   Some hosted services are known not to support range requests right now. These involve:

      - `Gitlab releases <https://gitlab.com>`_

   If you use such a service and wish to use :ref:`AppImageUpdate` with it, please ask the providers to enable range requests.

.. _GitHub Releases: https://help.github.com/articles/creating-releases/


.. _ref-complying-with-licenses:

Complying with licenses
-----------------------

Even under open source licenses, distributing and/or using code in source or binary form may create certain legal obligations, such as the distribution of the corresponding source code and build instructions for GPL licensed binaries, and displaying copyright statements and disclaimers. As the author of an application which you are distributing as an AppImage, you are responsible to obey all licenses for any third-party dependencies that you include in your AppImage, and ensure that their licenses and source code are made available, where required, together with the release binaries. AppImageKit itself is released under the permissive MIT license.


.. _ref-no-appimages-in-archives:

Do not put AppImages into other archives
----------------------------------------

Please **DO NOT** put an AppImage into another archive like a :code:`.zip` or :code:`.tar.gz`.

While it may be tempting to avoid users having to set permission, this breaks desktop integration with the optional :code:`appimaged` daemon, among other things. Besides, the beauty of the AppImage format is that you never need to unpack anything. Furthermore, packing an AppImage into some form of archive prevents the AppImage from being added to the central catalog of available AppImages at https://github.com/AppImage/AppImageHub.
