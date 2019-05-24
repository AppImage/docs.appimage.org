.. _ref-linuxdeploy:

linuxdeploy user guide
----------------------

This page illustrates how linuxdeploy can be used.

.. todo::
   - Write introduction
   - Add references to examples in packaging guide

linuxdeploy is capable of packaging dependencies of resources in an existing AppDir, or creating the AppDir from scratch, bundling resources into the right locations that the user passes to it.

linuxdeploy describes itself as an `"AppDir maintenance tool" <https://github.com/linuxdeploy/linuxdeploy/blob/master/README.md>`_. Its primary focus is on AppDirs, and it uses plugins to create output formats such as AppImages.


Packaging dependencies of files in an existing AppDir
+++++++++++++++++++++++++++++++++++++++++++++++++++++

Sometimes, the build system can be used to :ref:`install resources into an AppDir-like structure`. If this so-called "install configuration" is feature complete, i.e., all the resources an AppImage needs (a binary, an icon and a desktop file), all linuxdeploy has to do is bundle the dependencies of these files.

This workflow is described in :ref:`ref-make-install-workflow`.

In case some of the required files described above are *not* installed by ``make install``, you can instruct linuxdeploy to bundle these resources manually. Please see the next section for more information.


.. _linuxdeploy-package-manually:

Packaging binaries and other resources manually
++++++++++++++++++++++++++++++++++++++++++++++++

Unlike the old tools, linuxdeploy doesn't need any existing directory with files in the right positions, etc. Instead, it puts files specified via CLI parameters into the right positions. This makes bundling easier than ever before, as users don't need to know where to put files any more.

linuxdeploy provides different flags to bundle different kinds of resources. Only resources whose destination can be calculated by linuxdeploy can be bundled this way. Additional resources applications need, which linuxdeploy can not know about, must be bundled by hand. However, the most common resources are covered by the parameters.

``--executable``/``-e``
   Bundle a native binary executable. |rpath-comment|

``--library``/``-l``
   Bundle a shared library (:code:`.so` file) into the AppDir. |rpath-comment|

``--desktop-file``/``-d``
   Bundle a desktop file into the AppDir. These are required for desktop integration, and there must always be at least one of them in the AppDir. Please see :ref:`creating-desktop-file` for a guide how they can be created, and for best practices related to AppImages.

``--icon``/``-i``
   Bundle icon file. Supported are all formats which the `Icon Theme Specification <https://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>`_ lists. linuxdeploy will automatically calculate the right output path, which depends on file format and resolution. You can specify multiple icons for multiple resolutions in the form of ``<resolution>/<app_name>.<ext>``. If you have all the files in the same directory, e.g., like ``*<resolution>*.<ext>``, you can specify the optional ``--app-name``/``-n`` parameter, and have linuxdeploy change the filename to the provided value when it copies the files into the AppDir.

.. |rpath-comment| replace:: Set up everything so that other libraries, executables etc. use this one instead of a system one.

The following example illustrates how an existing binary can be bundled into an AppDir:

.. code::bash


.. _linuxdeploy-plugin-system:

Plugin system
+++++++++++++

linuxdeploy provides a flexible packaging system for both bundling additional resources that cannot be discovered automatically by linuxdeploy (i.e., plugins loaded during runtime using ``dlopen()``, icon themes, etc.), and to convert the AppDir into an output format such as AppImage.

Plugins are automatically recognized by linuxdeploy. They are executable files (scripts, native binaries, etc.), which must be in one of the following locations:

  - in case the linuxdeploy AppImage is used: next to the AppImage
  - next to the linuxdeploy binary
  - in any of the directories in ``$PATH``

Therefore, when downloading additional plugins, just put them into one of these locations, and linuxdeploy can use them.

Plugins are standalone executable files. This means they must be made executable by the user before they can be used by linuxdeploy. On the other hand, this also allows for calling plugins manually.

The plugin system works by calling external executables, hence the only communication linuxdeploy can perform with plugins is via CLI parameters (communication via the ``stdin``/``stdout`` pipes would be a lot more complex to implement for both linuxdeploy and the plugin). Therefore, to influence plugin behavior, plugins may implement environment variables that the user can set *before* calling linuxdeploy. Examples how this works are shown in the following sections.

You can use the ``--list-plugins`` flag to see what plugins are visible to linuxdeploy. This can come in handy when debugging plugin related issues. It lists the name of the plugin (i.e., what linuxdeploy refers to them as), the full path and the API level they implement.

.. warning::
   Some plugins might be bundled in the linuxdeploy AppImage already for convenience. They're likely out of date, but should be stable. In case there are any issues or you need to use a newer version, please download the latest version of the respective plugin, and put it next to the linuxdeploy AppImage. linuxdeploy prefers plugins next to the AppImage over bundled ones.

.. note::
   More information on plugins can be found in the `plugin specification`_.

.. _plugin specification: https://github.com/linuxdeploy/linuxdeploy/wiki/Plugin-system


.. _linuxdeploy-input-plugins:

Using input plugins
'''''''''''''''''''

Input plugins can simply be switched on using the ``--plugin`` flag. For example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --plugin qt

This causes linuxdeploy to call a plugin called ``qt``, if available.

.. note::
   An (incomplete) list of plugins can be found in the `linuxdeploy README`_ and in the `linuxdeploy wiki`_.

.. _linuxdeploy README: https://github.com/linuxdeploy/linuxdeploy/blob/master/README.md
.. _linuxdeploy wiki: https://github.com/linuxdeploy/linuxdeploy/wiki/


.. _linuxdeploy-input-plugins-environment-variables:

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

Most users are interested in generating AppImages, therefore the AppImage plugin is bundled in the official linuxdeploy AppImage. Please see the :ref:`plugin's user guide <linuxdeploy-plugin-appimage-user-guide>` for more information.


Using environment variables to change plugins' behavior
*******************************************************

Users can use environment variables to :ref:`change input plugins' behavior <linuxdeploy-input-plugins-environment-variables>` or enable additional features. Output plugins use the same method to provide similar functionality. Just set an environment variable *before* calling linuxdeploy with the respective plugin enabled. For example:

.. code:: bash

   # set environment variable to embed update information in an AppImage
   > export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"

   # call linuxdeploy with the AppImage plugin enabled
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --output appimage


.. todo::

   Document environment variables of existing output plugins
