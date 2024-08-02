.. _ref-linuxdeploy:

linuxdeploy
===========

linuxdeploy is a tool that can be used by application authors to easily create an AppDir (and by extension an AppImage) from scratch and bundle the executable and other resources that are passed as command line arguments into the right locations, as well as packaging dependencies of resources in an existing AppDir and making it relocatable. However, it doesn't require any existing AppDir structure or manual file placement.

Its primary focus is on AppDirs, and it uses plugins to create other outputs such as AppImages.

linuxdeploy doesn't include core system libraries like glibc. This results in a reduced AppImage size. AppImages that are created with linuxdeploy should run on *almost* all modern linux distributions.

When using linuxdeploy, AppImages should be built on the oldest supported LTS distribution version to make sure that the resulted AppImage works on all current (newer) distribution versions.

The following sections explain how to use linuxdeploy.


.. contents:: Contents
   :local:
   :depth: 1


Downloading linuxdeploy
-----------------------

Start by downloading linuxdeploy. The recommended way to get it is to use the latest continuous AppImage build provided on the `GitHub release page <https://github.com/linuxdeploy/linuxdeploy/releases>`_. After downloading the AppImage, you have to make it executable as usual:

.. code-block:: bash

   > wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
   > chmod +x linuxdeploy-x86_64.AppImage

After that, you can use linuxdeploy.


..
   TODO: Remove one of these two

.. _ref-linuxdeploy-bundle-manually:
.. _ref-linuxdeploy-package-manually:

Using linuxdeploy with command line arguments
---------------------------------------------

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
   Bundle a desktop file. Desktop files contain metadata and are required for desktop integration; there must be at least one of them in the AppDir / AppImage. Please see :ref:`desktop-entry-files` for a guide on how they can be created and what they should contain.

``--icon-file``/``-i``
   Bundle one or several icon files. Please see :ref:`icon-files` for a guide on which formats, resolutions, etc. are supported.

   linuxdeploy will automatically calculate the image resolution and the correct output path, which depends on file format and resolution.

``--appstream-file``
   Bundle an AppStream metadata file into the AppDir. For more information on AppStream files, see :ref:`ref-appstream`.

``--appdir``/``-a``
   The path to the AppDir. If this path does not exist, the AppDir is created from scratch.

   This can be used to include additional resources many applications might need, e.g. asset files for drawing a GUI. In that case, you can create a directory containing (only) such specific files in specific positions and then use its path as ``--appdir`` parameter. linuxdeploy then creates the AppDir and bundles all other files like usual.

   You can also use this to pass an existing AppDir to linuxdeploy if you only want to bundle its dependencies (shared libraries) and make it relocatable but not create a new AppDir.

``--plugin``/``-p``
   Uses an input plugin. Input plugins can be used to bundle additional resources, such as Qt plugins or translations. They must be additionally downloaded.

   For more information on plugins, see :ref:`ref-linuxdeploy-plugin-system`.

``--output``/``-o``
   .. cssclass:: bold-link

   Uses an output plugin. Output plugins can be used to output something different than the raw AppDir. **linuxdeploy always comes with the** `AppImage output plugin <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage>`_ **preinstalled.** You can use it with ``--output appimage``. Other output plugins have to be additionally downloaded.

   For more information on plugins, see :ref:`ref-linuxdeploy-plugin-system`.

This list is not exhaustive and only includes the most commonly used command line argument. To get a full overview of all arguments, use ``--help``.

The following example illustrates how an existing binary can be bundled into an AppDir:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage -e my_application -d my_application.desktop -i my_application.png -a AppDir --output appimage


.. _ref-linuxdeploy-plugin-system:

Plugin system
-------------

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
   More information on plugins can be found in the `plugin specification <https://github.com/linuxdeploy/linuxdeploy/wiki/Plugin-system>`_.

.. note::
   A list of plugins can be found in the `Awesome linuxdeploy README <https://github.com/linuxdeploy/awesome-linuxdeploy#linuxdeploy-plugins>`_.


Using input plugins
+++++++++++++++++++

Input plugins can simply be switched on using the ``--plugin`` flag. For example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --plugin qt

This causes linuxdeploy to call a plugin called ``qt``, if available.


Using environment variables to change plugins' behavior
'''''''''''''''''''''''''''''''''''''''''''''''''''''''

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
+++++++++++++++++++++

Similar to the input plugins, output plugins are enabled through a command line parameter. To avoid any possible confusion, a second parameter is used: ``--output``.

Example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage <...> --output appimage

Most users are interested in generating AppImages, therefore the AppImage plugin is bundled in the official linuxdeploy AppImage.


Using environment variables to change plugins' behavior
'''''''''''''''''''''''''''''''''''''''''''''''''''''''

Analogous to the input plugins, output plugins usually implement additional optional or mandatory parameters in the form of environment variables. These environment variables must be set *before* calling linuxdeploy. For example:

.. code:: bash

   # Set environment variable to embed update information in an AppImage
   > export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"

   # Call linuxdeploy with the AppImage plugin enabled
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --output appimage


linuxdeploy-plugin-appimage environment variables
*************************************************

As most plugins, linuxdeploy-plugin-appimage provides some environment variables to enable additional functionality, such as:

``SIGN=1``
   Sign AppImage. See :ref:`ref-signing-appimages` for more information.

``UPDATE_INFORMATION=zsync|...``
   Add update information to the AppImage, and generate a ``.zsync`` file.

.. seealso::
   More information on the environment variables can be found in the `README <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/blob/master/README.md>`__, including a complete (and up to date) list of supported environment variables.

.. todo::

   Document environment variables of other existing output plugins


Iterative workflow
------------------

linuxdeploy supports an iterative workflow, i.e., you run it, and it will start to bundle resources. If there is a problem, it will show a detailed error message, and exit with an error code. You can then fix the issue, and call it again to try again.
