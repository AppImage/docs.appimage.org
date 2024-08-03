.. _manually-fully-creating-appdir-structure:

Manually creating the entire AppDir structure
=============================================

.. warning::
   While manually creating a directory structure and copying some files might be necessary depending on the used tool, manually packaging *everything* should only be used as a last resort if all other methods aren't applicable.

   Using one of the :ref:`appimage-creation-tools` is usually much more convenient.

   The main reason it's explained nevertheless is to illustrate how things work under the hood.

   If you only want to manually create an AppDir structure as the chosen AppImage creation tool requires an existing AppDir structure, go to :ref:`manually-creating-appdir-structure`.


If you want to manually create the entire AppDir structure and copy all files to their correct places in the structure without using any :ref:`AppImage creation tool <appimage-creation-tools>`, you first have to follow the steps described in :ref:`manually-creating-appdir-structure`.


Adding shared libraries
-----------------------

Additionally to that, you have to place all necessary shared libraries into the AppDir. This step would usually be done by an AppImage creation tool. The shared libraries have to be placed in the AppDir under ``MyApp.AppDir/usr/lib/``. For example, a shared library called ``libfoo.so.0`` would be placed in the AppDir under ``MyApp.AppDir/usr/lib/libfoo.so.0``.


Removing hard-coded paths
-------------------------

In order to be packaged as AppImages, applications must load the resources relative to their main binary, and not from a hardcoded path (usually ``/usr/...``). This is called relocatability.

.. note::

   If your app doesn't load resources from the AppImage, but e.g., shows errors it couldn't find resources, it is most likely not relocatable.

You can check whether your app is relocatable by running

.. code-block:: shell

	strings MyApp.AppDir/usr/bin/myapp | grep /usr

Should this return something, then you need to modify your app programmatically (e.g., by using relative paths, using `binreloc <https://github.com/limbahq/binreloc>`__, or using the `GNU relocatable-prog module <https://www.gnu.org/software/gnulib/manual/html_node/Supporting-Relocation.html>`_). Many modern frameworks such as Qt even provide functionality (e.g. :code:`QString QCoreApplication::applicationDirPath()`) to implement this easily. In some cases, there are also flags you can specify when building from source to make applications relocatable.

If you prefer not to change the source code of your app and/or would not like to recompile your app, you can also patch the binary, for example using the command

.. code-block:: shell

    sed -i -e 's#/usr#././#g' MyApp.AppDir/usr/bin/myapp

which replaces all occurrences of :code:`/usr` with :code:`././`, which simply means "here".

This usually works as long as the application is not calling :code:`chdir()` (changing the current working directory). Such a call would break this workaround as :code:`././` would then not be pointing to :code:`$APPDIR/usr` anymore. You can run the following command to see whether the application is calling :code:`chdir()` (99% of GUI applications don't):

.. code-block:: shell

	strace -echdir -f ./AppRun

The same applies to all other binaries (executables and libraries) in the AppDir that the application depends on. To patch all binaries in your AppDir, execute

.. code-block:: shell

	cd MyApp.AppDir/usr/
	find . -type f -exec sed -i -e 's#/usr#././#g' {} \;
	cd -


Creating an AppImage from the AppDir
------------------------------------

To create an AppImage from the AppDir, you need :code:`appimagetool`. The recommended way to get it is to use `the latest release <https://github.com/AppImage/AppImageKit/releases/latest>`_. After downloading the AppImage, you have to make it executable as usual:

.. code-block:: bash

   > wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
   > chmod +x linuxdeploy-x86_64.AppImage

After that, you can call it with the AppDir path as parameter in order to turn it into an AppImage:

.. code-block:: bash

   > ./appimage-tool-x86_64.AppImage MyApp.AppDir
