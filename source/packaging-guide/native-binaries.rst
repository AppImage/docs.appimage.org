Packaging native binaries
=========================

The most easy packaging methods are available for *native binaries*, like e.g., produced when compiling C++ or C code. Native binaries have a well defined and reliable behavior to find their runtime dependencies, the so-called shared libraries. These are the primary dependencies you will have to ship with your application. Of course, some applications might require additional resources, e.g., icon files. Also, some applications try to load libraries dynamically during the runtime. But for now, let's assume we have a basic binary application (this is the most common type).

The AppImage team provides tools that simplify the packaging process significantly. These tools are semi-automatic, and ship with various features needed to bundle said shared library dependencies correctly. The one we are going to use in this guide is linuxdeploy_.

.. _linuxdeploy: https://github.com/linuxdeploy/linuxdeploy

linuxdeploy is an AppDir maintenance tool. Its primary focus is on AppDirs, AppImage is just one possible output format. It features a plugin system for greater flexibility in use. Plugins can either bundle additional resources for e.g., frameworks such as `Qt <https://github.com/linuxdeploy/linuxdeploy-plugin-qt>`_, but are also used to provide output generators, e.g., for `AppImages <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage>`_.


Packaging from source
---------------------

Building applications from source and packaging them as AppImages is the most common scenario. In this section, it is described how apps that were built from source can be packaged into AppDirs, from which AppImages are being generated.


.. _make-install-workflow:

Using the build system to build the basic AppDir
++++++++++++++++++++++++++++++++++++++++++++++++

If you use a modern build system (such as for instance CMake_ or qmake_), you can use the provided `make install` commands to create an AppDir-like directory that can be used with linuxdeploy.

As install configurations usually install all binaries, libraries, resources etc. in a way defined by the application author, this method provides a very easy and fast way to set up the basic AppDir.

.. note::
   Of course, the application authors need to set up install configurations in their buildsystem, otherwise this method is not usable. Many applications have working install configurations, though. If not, you should ask the authors to add the relevant code to their build system.


CMake
'''''

CMake provides an additional parameter to configure where the files are installed when running ``make install`` called |destdir|. If |destdir| is specified, CMake will "install" the files into the given directory instead of the filesystem root (:code:`/`).

.. note::
   By default, CMake sets an internal variable called |cmake-install-prefix| to a path other than `/usr` to prevent users calling e.g., code:`sudo make install` from damaging their system. The variable must explicitly be set to ``/usr`` therefore.

.. |destdir| replace:: :code:`DESTDIR`
.. |cmake-install-prefix| replace:: :code:`CMAKE_INSTALL_PREFIX`

Here's an example how to use this method:

.. code:: bash

   # fetch sources (you could as well use a tarball etc.)
   > git clone https://github.com/my/app.git
   > cd app

   # build out of source
   > mkdir build
   > cd build

   # configure build system
   # the flags below are the bare minimum that is needed, the app might define additional variables that might have to be set
   > cmake -DCMAKE_INSTALL_PREFIX=/usr

   # build the application on all CPU cores
   > make install -j$(nproc)

   # now "install" resources into future AppDir
   > make install DESTDIR=AppDir

Now, ideally all the binaries and libraries the app needs are installed into a new directory called :code:`AppDir` in your build directory.

.. note::
   The quality of the install configurations will vary from app to app. Please don't be surprised if the application is installed partially only. If the command doesn't exist at all, please fall back to bundling manually, which is described below.


qmake
'''''

Qt's qmake_ also provides a variable to change the "target" of :code:`make install` calls called :code:`INSTALL_ROOT`. The qmake-based method is very similar to the CMake one. There's just one major difference: qmake does install into ``/usr`` by default already.

Preparing a basic application is very simple, as the following example illustrates:

.. code:: bash

   # get the source code
   > git clone https://github.com/probonopd/QtQuickApp.git
   > cd QtQuickApp

   # run qmake to prepare the Makefile
   > qmake .

   # build the application on all CPU cores
   > make -j$(nproc)

   # use make install to prepare the AppDir
   > make install INSTALL_ROOT=AppDir

Now, you have a new directory ``AppDir`` which ideally contains all the binaries, shared libraries etc., just like after finishing the CMake method.


Using linuxdeploy for building AppImages
++++++++++++++++++++++++++++++++++++++++

Now that we have the basic AppDir, we can use linuxdeploy to start bundling dependencies into it and make it a real AppDir.

linuxdeploy describes itself as an `"AppDir maintenance tool" <https://github.com/linuxdeploy/linuxdeploy/blob/master/README.md>`_. Its primary focus is on AppDirs, and it uses plugins to create output formats such as AppImages.

The following section describes how it can be used to deploy dependencies of applications into an AppDir that was created using the methods described in the :ref:`previous section <make-install-workflow>`, and shows how this AppDir can eventually be packaged as an AppImage.


Bundling resources into the AppDir
''''''''''''''''''''''''''''''''''

Start by downloading linuxdeploy. The recommended way to get it is to use the AppImages provided on the `GitHub release page`_.

.. note::
   At the moment, AppImages are provided for :code:`x86/i386` and :code:`x86_64/amd64` architectures, as other platforms cannot be targeted properly on the build service. The tool itself should support all major platforms, including ARM. You can compile linuxdeploy yourself to test it. Contributions adding new platforms welcome!

.. _GitHub release page: https://github.com/linuxdeploy/linuxdeploy/releases/

After downloading the AppImage, you have to make it executable, as usual. Then, you can first run linuxdeploy on your AppDir:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir --init-appdir

The :code:`--init-appdir` parameter creates some basic directory structure that isn't necessarily required, but might be handy when adding resources manually to the AppImage. It can also create empty AppDirs.

.. note::
   linuxdeploy supports an iterative workflow, i.e., you run it, and it will start to bundle resources. If there is a problem, it will show a detailed error message, and exit with an error code. You can then fix the issue, and call it again to try again.

If your application has installed itself properly, it should have installed a desktop file and an icon as well. The desktop file is used for :ref:`AppImage desktop integration <ref-desktop-integration>`, and since desktop files require icons, an icon is always required, too.

Example:

.. code:: bash

   # get linuxdeploy's AppImage
   > wget https://github.com/linuxdeploy/linuxdeploy/releases/downloads/continuous/linuxdeploy-x86_64.AppImage
   > chmod +x linuxdeploy-x86_64.AppImage

   # run linuxdeploy and generate an AppImage
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir --init-appdir

You can bundle additional resources such as icon files, executable and desktop files using the respective flags described in the ``--help`` text or on linuxdeploy's `homepage <https://github.com/linuxdeploy/linuxdeploy>`_.


Plugin system
'''''''''''''

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


Using input plugins
*******************

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
#######################################################

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
*********************

Similar to the input plugins, output plugins are enabled through a command line parameter. To avoid any possible confusion, a second parameter is used: ``--output``.

Example:

.. code:: bash

   > ./linuxdeploy-x86_64.AppImage <...> --output appimage

Most users are interested in generating AppImages, therefore the AppImage plugin is bundled in the official linuxdeploy AppImage.


Using environment variables to change plugins' behavior
#######################################################

Users can use environment variables to :ref:`change input plugins' behavior <linuxdeploy-input-plugins-environment-variables>` or enable additional features. Output plugins use the same method to provide similar functionality. Just set an environment variable *before* calling linuxdeploy with the respective plugin enabled. For example:

.. code:: bash

   # set environment variable to embed update information in an AppImage
   > export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"

   # call linuxdeploy with the AppImage plugin enabled
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir <...> --output appimage


.. todo::

   Document environment variables of existing output plugins

