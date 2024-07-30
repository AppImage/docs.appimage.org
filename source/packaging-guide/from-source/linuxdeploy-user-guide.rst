.. _ref-linuxdeploy:

linuxdeploy user guide
----------------------

linuxdeploy is a tool that can be used to easily create an AppDir (and by extension an AppImage) from scratch and bundle the executable and other resources that are passed as command line arguments into the right locations, as well as packaging dependencies of resources in an existing AppDir.

Its primary focus is on AppDirs, and it uses plugins to create other outputs such as AppImages.

There are two ways how linuxdeploy can be used: Either by using command line arguments to package the resources - this works with every project language and build system. Or by using linuxdeploy with `make <https://en.wikipedia.org/wiki/Make_(software)>`_ - this only works if you use Makefiles for building your project.

The following sections explain both ways to use linuxdeploy.


.. contents:: Contents
   :local:
   :depth: 1


..
   TODO: Remove one of these two

.. _ref-linuxdeploy-bundle-manually:
.. _ref-linuxdeploy-package-manually:

Using linuxdeploy with command line arguments
+++++++++++++++++++++++++++++++++++++++++++++

linuxdeploy uses command line arguments to bundle files, like executables, libraries or icons. It creates the AppDir from scratch and puts all these files in the right positions. The user doesn't need to know the internal AppDir structure and where to put specific files.
The following command line flags are most commonly used:

``--executable``/``-e``
   Bundle a native binary executable. **This is used to bundle your main binary executable.**

   This is also used to bundle executables that may be used by other libraries, executables, etc.

   Set up everything so that other libraries, executables, etc. use this bundled executable instead of a system one (if applicable).

``--library``/``-l``
   Bundle a shared library (:code:`.so` file) into the AppDir.

   Set up everything so that other libraries, executables, etc. use this bundled library instead of a system one (if applicable).

``--desktop-file``/``-d``
   Bundle a desktop file into the AppDir. These are required for desktop integration, and there must always be at least one of them in the AppDir. Please see :ref:`ref-desktop-files` for a guide how they can be created, and for best practices related to AppImages.

``--icon-file``/``-i``
   Bundle one or several icon files into the AppDir. Supported formats are ``png`` and ``svg``. (``xpm`` is also supported, but deprecated and shouldn't be used for new projects). The valid resolutions for raster icons are ``8x8``, ``16x16``, ``20x20``, ``22x22`,` ``24x24``, ``28x28``, ``32x32``, ``36x36``, ``42x42``, ``48x48``, ``64x64``, ``72x72``, ``96x96``, ``128x128``, ``160x160``, ``192x192``, ``256x256``, ``384x384``, ``480x480`` and ``512x512``.

   For more information see the `Icon Theme Specification <https://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>`_.

   linuxdeploy will automatically calculate the image resolution and the correct output path, which depends on file format and resolution.

..
   TODO: Rewrite section about desktop and icon files and provide more information
   TODO: Fix desktop integration links (and improve section separation so that not two sections are both named / linked desktop integration)

``--appstream-file``
   Bundle an AppStream metadata file into the AppDir. For more information on AppStream files, see :ref:`ref-appstream`.

``--appdir``/``-a``
   The path to the AppDir. If this path does not exist, the AppDir is created from scratch.

   This can be used to include additional resources specific applications might need. In that case, you can create a directory containing (only) such specific files in specific positions and then using its path as ``--appdir`` parameter. linuxdeploy then creates the AppDir and bundles all other files like usual.

``--plugin``/``-p``
   Uses an input plugin. Input plugins can be used to bundle additional data for a specific framework. They must be additionally downloaded.

   For more information on plugins, see :ref:`ref-linuxdeploy-plugin-system`.

``--output``/``-o``
   Uses an output plugin. Output plugins can be used to output something different than the raw AppDir. **linuxdeploy always comes with the AppImage output plugin preinstalled.** Other output plugins have to be additionally downloaded.

   For more information on plugins, see :ref:`ref-linuxdeploy-plugin-system`.

This list is not exhaustive and only includes the most commonly used command line argument. To get a full overview of all arguments, use ``--help``.

The following example illustrates how an existing binary can be bundled into an AppDir:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage -e my_application -d my_application.desktop -i my_application.png -a AppDir --output appimage


Using linuxdeploy with make
+++++++++++++++++++++++++++

If Makefiles are used for building the project (common for C/C++-based projects), you can also use linuxdeploy with make.
To do this, you first need to run ``make install DESTDIR=AppDir`` (depending on the build system, preparations for this are necessary, see :ref:`ref-make-install-workflow`). This will create a first basic :ref:`AppDir <ref-appdir>`-like structure with the main executable, libraries and so on.

After that, you need to invoke linuxdeploy like explained in the previous section with the incomplete AppDir as ``--appdir`` argument to bundle the dependencies of these files.

Depending on the install configuration, you might also have to use ``--desktop-file``, ``--icon-file``, ``--appstream-file``, etc. to explicitly bundle such missing items.


.. _ref-linuxdeploy-plugin-system:

Plugin system
+++++++++++++

linuxdeploy provides a flexible packaging system for both bundling additional resources that cannot be discovered automatically by linuxdeploy (i.e., plugins loaded during runtime using ``dlopen()``, icon themes, etc.), and to convert the AppDir into an output format such as AppImage.

Plugins are automatically recognized by linuxdeploy. They are executable files (scripts, native binaries, etc.), which must be in one of the following locations:

  - in case the linuxdeploy AppImage is used: next to the AppImage
  - next to the linuxdeploy binary
  - in any of the directories in ``$PATH``

Therefore, when downloading additional plugins, just put them into one of these locations, and linuxdeploy can use them. Plugins should be kept with their original name; otherwise linuxdeploy might not recognise them!

Plugins are standalone executable files. This means they must be made executable by the user before they can be used by linuxdeploy. On the other hand, this also allows for calling plugins manually.

The plugin system works by calling external executables, hence the only communication linuxdeploy can perform with plugins is via CLI parameters (communication via the ``stdin``/``stdout`` pipes would be a lot more complex to implement for both linuxdeploy and the plugin). Therefore, to influence plugin behavior, plugins may implement environment variables that the user can set *before* calling linuxdeploy. Examples how this works are shown in the following sections.

You can use the ``--list-plugins`` flag to see what plugins are visible to linuxdeploy. This can come in handy when debugging plugin related issues. It lists the name of the plugin (i.e., what linuxdeploy refers to them as), the full path and the API level they implement.

.. warning::
   Some plugins might be bundled in the linuxdeploy AppImage already for convenience. They're likely out of date, but should be stable. In case there are any issues or you need to use a newer version, please download the latest version of the respective plugin, and put it next to the linuxdeploy AppImage. linuxdeploy prefers plugins next to the AppImage over bundled ones.

.. note::
   More information on plugins can be found in the `plugin specification`_.

.. _plugin specification: https://github.com/linuxdeploy/linuxdeploy/wiki/Plugin-system


.. _ref-linuxdeploy-input-plugins:

Using input plugins
'''''''''''''''''''

Input plugins can simply be switched on using the ``--plugin`` flag. For example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --plugin qt

This causes linuxdeploy to call a plugin called ``qt``, if available.

.. note::
   A list of plugins can be found in the `Awesome linuxdeploy README`_.

.. _Awesome linuxdeploy README: https://github.com/linuxdeploy/awesome-linuxdeploy#linuxdeploy-plugins


.. _ref-linuxdeploy-input-plugins-environment-variables:

Using environment variables to change plugins' behavior
*******************************************************

As mentioned previously, some plugins implement additional optional or mandatory parameters in the form of environment variables. These environment variables must be set *before* calling linuxdeploy.

For example:

.. code:: bash

   # set the environment variable
   > export FOOBAR_VAR=example

   # call linuxdeploy with the respective plugin enabled
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --plugin foobar

Please refer to the plugins' documentation to find a list of supported environment variables. If you can't find any, there's probably none.

.. todo::

   Document existing input plugins' environment variables


Creating output files
'''''''''''''''''''''

Similar to the input plugins, output plugins are enabled through a command line parameter. To avoid any possible confusion, a second parameter is used: ``--output``.

Example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage <...> --output appimage

Most users are interested in generating AppImages, therefore the AppImage plugin is bundled in the official linuxdeploy AppImage. Please see the :ref:`plugin's user guide <ref-linuxdeploy-plugin-appimage-user-guide>` for more information.


Using environment variables to change plugins' behavior
*******************************************************

Users can use environment variables to :ref:`change input plugins' behavior <ref-linuxdeploy-input-plugins-environment-variables>` or enable additional features. Output plugins use the same method to provide similar functionality. Just set an environment variable *before* calling linuxdeploy with the respective plugin enabled. For example:

.. code:: bash

   # set environment variable to embed update information in an AppImage
   > export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"

   # call linuxdeploy with the AppImage plugin enabled
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --output appimage


.. todo::

   Document environment variables of existing output plugins



.. _ref-linuxdeploy-iterative-workflow:

Iterative workflow
++++++++++++++++++

.. todo::

   This section is missing. Please consider adding it by filing a pull request against our `repository <https://github.com/AppImage/docs.appimage.org>`__.
