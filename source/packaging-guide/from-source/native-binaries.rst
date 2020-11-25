.. _ref-packaging-native-binaries:

Packaging native binaries
=========================

The most easy packaging methods are available for *native binaries*, like e.g., produced when compiling C++ or C code. Native binaries have a well defined and reliable behavior to find their runtime dependencies, the so-called shared libraries. These are the primary dependencies you will have to ship with your application. Of course, some applications might require additional resources, e.g., icon files. Also, some applications try to load libraries dynamically during the runtime. But for now, let's assume we have a basic binary application (this is the most common type).

The AppImage team provides tools that simplify the packaging process significantly. These tools are semi-automatic, and ship with various features needed to bundle said shared library dependencies correctly. The one we are going to use in this guide is linuxdeploy_.

.. _linuxdeploy: https://github.com/linuxdeploy/linuxdeploy

linuxdeploy is an AppDir maintenance tool. Its primary focus is on AppDirs, AppImage is just one possible output format. It features a plugin system for greater flexibility in use. Plugins can either bundle additional resources for e.g., frameworks such as `Qt <https://github.com/linuxdeploy/linuxdeploy-plugin-qt>`__, but are also used to provide output generators, e.g., for `AppImages <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage>`__.


.. contents:: Contents
   :local:
   :depth: 2


Packaging from source
---------------------

Building applications from source and packaging them as AppImages is the most common scenario. In this section, it is described how apps that were built from source can be packaged into AppDirs, from which AppImages are being generated.


.. _ref-make-install-workflow:

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
   By default, CMake sets an internal variable called |cmake-install-prefix| to a path other than ``/usr`` to prevent users calling e.g., :code:`sudo make install` from damaging their system. The variable must explicitly be set to ``/usr`` therefore.

.. |destdir| replace:: :code:`DESTDIR`
.. |cmake-install-prefix| replace:: :code:`CMAKE_INSTALL_PREFIX`

Here's an example how to use this method:

.. code-block:: bash

   # fetch sources (you could as well use a tarball etc.)
   > git clone https://github.com/linuxdeploy/QtQuickApp.git
   > cd QtQuickApp

   # build out of source
   > mkdir build
   > cd build

   # configure build system
   # the flags below are the bare minimum that is needed, the app might define additional variables that might have to be set
   > cmake .. -DCMAKE_INSTALL_PREFIX=/usr

   # build the application on all CPU cores
   > make -j$(nproc)

   # now "install" resources into future AppDir
   > make install DESTDIR=AppDir

Now, ideally all the binaries and libraries the app needs are installed into a new directory called :code:`AppDir` in your build directory.

.. note::
   The quality of the install configurations will vary from app to app. Please don't be surprised if the application is installed partially only. If the command doesn't exist at all, please fall back to bundling manually, which is described below.


qmake
'''''

Qt's qmake_ also provides a variable to change the "target" of :code:`make install` calls called :code:`INSTALL_ROOT`. The qmake-based method is very similar to the CMake one. There's just one major difference: qmake does install into ``/usr`` by default already.

Preparing a basic application is very simple, as the following example illustrates:

.. code-block:: bash

   # get the source code
   > git clone https://github.com/linuxdeploy/QtQuickApp.git
   > cd QtQuickApp

   # create out-of-source build dir and run qmake to prepare the Makefile
   > mkdir build
   > cd build
   > qmake ..

   # build the application on all CPU cores
   > make -j$(nproc)

   # use make install to prepare the AppDir
   > make install INSTALL_ROOT=AppDir

Now, you have a new directory ``AppDir`` which ideally contains all the binaries, shared libraries etc., just like after finishing the CMake method.


Using linuxdeploy for building AppImages
++++++++++++++++++++++++++++++++++++++++

Now that we have the basic AppDir, we need to bundle dependencies into it to make the AppDir self-contained in preparation to make an AppImage from it. The following guide shows how linuxdeploy_ is used for this purpose.

linuxdeploy describes itself as an `"AppDir maintenance tool" <https://github.com/linuxdeploy/linuxdeploy/blob/master/README.md>`__. Its primary focus is on AppDirs, and it uses plugins to create output formats such as AppImages.

The following section describes how it can be used to deploy dependencies of applications into an AppDir that was created using the methods described in the :ref:`previous section <ref-make-install-workflow>`, and shows how this AppDir can eventually be packaged as an AppImage.

.. seealso::
   Please see :ref:`ref-linuxdeploy` for more information on how to use linuxdeploy.


Bundling resources into the AppDir
''''''''''''''''''''''''''''''''''

Start by downloading linuxdeploy. The recommended way to get it is to use the AppImages provided on the `GitHub release page`_.

.. note::
   At the moment, AppImages are provided for :code:`x86/i386` and :code:`x86_64/amd64` architectures, as other platforms cannot be targeted properly on the build service. The tool itself should support all major platforms, including ARM. You can compile linuxdeploy yourself to test it. Contributions adding new platforms welcome!

.. _GitHub release page: https://github.com/linuxdeploy/linuxdeploy/releases/

After downloading the AppImage, you have to make it executable, as usual. Then, you can first run linuxdeploy on your AppDir:

.. code-block:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir

This creates :code:`AppDir` if it doesn't exist yet. Inside :code:`AppDir` some basic directory structure is created that isn't necessarily required, but might be handy when adding resources manually to the AppImage.

.. note::
   linuxdeploy supports an iterative workflow, i.e., you run it, and it will start to bundle resources. If there is a problem, it will show a detailed error message, and exit with an error code. You can then fix the issue, and call it again to try again. See :ref:`ref-linuxdeploy-iterative-workflow` for more information.

If your application has installed itself properly, it should have installed a desktop file and an icon as well. The desktop file is used for :ref:`AppImage desktop integration <ref-desktop-integration>`, and since desktop files require icons, an icon is always required, too.

Example:

.. code-block:: bash

   # get linuxdeploy's AppImage
   > wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
   > chmod +x linuxdeploy-x86_64.AppImage

   # run linuxdeploy and generate an AppDir
   > ./linuxdeploy-x86_64.AppImage --appdir AppDir

You can bundle additional resources such as icon files, executable and desktop files using the respective flags described in the ``--help`` text or on linuxdeploy's `homepage <https://github.com/linuxdeploy/linuxdeploy>`__.

.. note::
   Desktop file and icon are used for so-called :ref:`desktop integration <ref-desktop-integration>`. If your build system didn't install such files into the right location, you can have linuxdeploy put your own files into the right places. Please see :ref:`linuxdeploy-bundle-desktop-files-icons` for more information.


.. _ref-package-existing-binaries:

Packaging existing binaries (or: manually packaging everything)
---------------------------------------------------------------

Packaging existing binaries is very simple as well. As the existing binaries don't provide facilities to :ref:`create a basic AppDir with the build system <ref-make-install-workflow>`, you have to package everything into the right place manually.

Luckily, linuxdeploy supports such a workflow as well. It provides functionalities to automatically put the most common resources an application might use (such as binaries, libraries, desktop files and icons) into the right places without having the user to create any sort of structure or know where to put files. This is described in :ref:`linuxdeploy-package-manually`.

.. note::
   Many applications require more resources during runtime than just the binaries and libraries. Often, they require graphics for drawing a UI, or other files that are normally in a "known good location" on the system. These resources should be bundled into the AppImage as well to make sure the AppImage is as standalone as possible. However, linuxdeploy cannot know which files to bundle.

   Please consult the applications' documentation (e.g., homepage or man pages) to see what kinds of resources must be put into the AppImage. This can involve some trial-and-error, as you need to :ref:`test your AppImages on different systems <ref-testing-appimages>` to find possible errors.

.. warning::
   In order to be packaged as AppImages, applications must load the resources relative to their main binary, and not from a hardcoded path (usually ``/usr/...``). This is called :ref:`relocatability <ref-relocatablility>`.

   If your app doesn't load resources from the AppImage, but e.g., shows errors it couldn't find resources, it is most likely not relocatable. In this case, you must ask the author of the application to make it relocatable. Many modern frameworks such as Qt even provide functionality to implement this easily. In some cases, there's also flags you can specify when building from source to make applications relocatable.


Bundling additional resources using linuxdeploy plugins
-------------------------------------------------------

As mentioned previously, linuxdeploy provides a plugin system. So-called "input" plugins can be used to bundle additional resources, such as Qt plugins, translations, etc.

Please see :ref:`linuxdeploy-input-plugins` for more information.


.. _linuxdeploy-plugin-appimage-user-guide:

Build AppImages from AppDir using linuxdeploy
---------------------------------------------

As mentioned previously, linuxdeploy uses plugins to create actual output files from AppDirs. For AppImages, there's `linuxdeploy-plugin-appimage <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage>`__.

To create AppImages, just add ``--output appimage`` to your linuxdeploy call to enable the plugin. An AppImage will be created using :ref:`ref-appimagetool`.

Minimal example:

.. code-block:: bash

   > ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage

As most plugins, linuxdeploy-plugin-appimage provides some environment variables to enable additional functionality, such as:

``SIGN=1``
   Sign AppImage. See :ref:`ref-signing-appimages` for more information.

``UPDATE_INFORMATION=zsync|...``
   Add update information to the AppImage, and generate a ``.zsync`` file.

.. seealso::
   More information on the environment variables can be found in the `README <https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/blob/master/README.md>`__, including a complete (and up to date) list of supported environment variables.


Examples
--------

In this section, some examples how linuxdeploy can be used are shown.

QtQuickApp
++++++++++

This section contains a few example scripts that showcase how AppImages can be built for `QtQuickApp <https://github.com/linuxdeploy/QtQuickApp>`__, a basic demonstration app based on QtQuick, using some QML internally. It can be built using both CMake and qmake. We use it to show some example scripts how AppImages can be built for it, using the methods introduced in this guide.


Using qmake and ``make install``
''''''''''''''''''''''''''''''''

The following script might be used to create AppImages for QtQuickApp, using qmake and ``make install`` strategy.

.. literalinclude:: examples/bundle-qtquickapp-with-qmake.sh
   :name: bundle-qtquickapp-with-qmake
   :caption: :code:`travis/build-with-qmake.sh`
   :language: bash
   :linenos:

.. note::
   We're using a separate bash script that runs in an isolated, temporary directory to prevent modifications to the existing source code or the system.

   Many examples "hack" those instructions directly into their CI configuration, e.g., ``.travis.yml``. This approach has many problems, most notably that it's impossible to test those scripts locally. By extracting the whole process into a script, it becomes quite simple to test the build script locally as well as run it in the CI system.

   An example :code:`.travis.yml` is included in a later section, showing how the script can be run on Travis CI. It's quite generic, you should be able to copy it without having to make too many modifications.


Using CMake and ``make install``
''''''''''''''''''''''''''''''''

The following script might be used to create AppImages for QtQuickApp, using qmake and ``make install`` strategy. It is effectively the same script as the ``qmake`` one, but uses CMake instead of qmake to build the binaries and install the data into the AppDir.

.. literalinclude:: examples/bundle-qtquickapp-with-cmake.sh
   :name: bundle-qtquickapp-with-cmake
   :caption: :code:`travis/build-with-cmake.sh`
   :language: bash
   :linenos:


Integrate build scripts into CI systems
'''''''''''''''''''''''''''''''''''''''

Travis CI
*********

The scripts introduced in the previous subsections will move the files back into the directory where they're called. Therefore, the :code:`.travis.yml` and especially the :code:`script` file can be kept delightfully short:

.. literalinclude:: examples/.travis.yml
   :name: bundle-qtquickapp
   :caption: :code:`.travis.yml`
   :language: yaml
   :linenos:


.. seealso::

   Please see the :ref:`ref-travis-ci` section in the :ref:`ref-hosted-services` section for more information on Travis CI. It also contains a guide on :ref:`uploadtool <ref-uploadtool>`.

