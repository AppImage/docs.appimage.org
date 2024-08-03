.. _manually-fully-creating-appdir:

Manually creating the entire AppDir
===================================

.. warning::
   While manually creating a directory structure and copying some files might be necessary depending on the used tool, manually packaging *everything* should only be used as a last resort if all other methods aren't applicable.

   Using one of the :ref:`appimage-creation-tools` is usually much more convenient.

   The main reason it's explained nevertheless is to illustrate how things work under the hood.

   If you only want to manually create an AppDir structure as the chosen AppImage creation tool requires an existing AppDir structure, go to :ref:`manually-creating-appdir-structure`.



Manually creating the entire AppDir structure
---------------------------------------------

If you want to manually create the entire AppDir structure and copy all files to their correct places in it without using any :ref:`AppImage creation tool <appimage-creation-tools>`, you first have to follow the steps described in :ref:`manually-creating-appdir-structure`.

Additionally to the AppDir content described there, your AppDir needs to contain the following files::

   	MyApp.AppDir/AppRun
   	MyApp.AppDir/.DirIcon


AppRun
++++++

In modern AppImages, :code:`AppRun` is usually a symlink to the main binary. This works if the binary has been made :ref:`relocatable <removing-hard-coded-paths>` (explained later on this page).

However, if an existing application must not be altered, e.g. if the licence prohibits any modifications, alternatives may be used. For more information, see the :ref:`AppRun specification <apprun-specification>`.

.DirIcon
++++++++

``.DirIcon`` is the actual icon being used as application icon. It is usually a symlink to an icon stored in root or ``usr/share/icons/hicolor/<resolution>/apps/myapp.png``. Notice that ``.DirIcon`` **must be a PNG file**.

For more information on it, see the :ref:`.DirIcon specification <ref-diricon>`.


Adding shared libraries
-----------------------

Additionally to that, you have to place all required shared libraries in the AppDir. The shared libraries have to be placed under ``MyApp.AppDir/usr/lib/``. For example, a shared library called ``libfoo.so.0`` would be placed as ``MyApp.AppDir/usr/lib/libfoo.so.0``.


.. _removing-hard-coded-paths:

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

.. note::

   An alternative approach to making an application relocatable is to use a specific AppRun script, see :ref:`apprun-specification`. This can be used if an existing application must not be altered, e.g. if the licencing prohibits any modifications.

   However, this approach is deprecated and should be avoided if possible.


Creating an AppImage from the AppDir
------------------------------------

To create an AppImage from the AppDir, you need :code:`appimagetool`. You can get it by downloading the `latest release <https://github.com/AppImage/AppImageKit/releases/latest>`_. After downloading the AppImage, you have to make it executable as usual:

.. code-block:: bash

   > wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
   > chmod +x linuxdeploy-x86_64.AppImage

After that, you can call it with the AppDir path as parameter in order to turn it into an AppImage:

.. code-block:: bash

   > ./appimage-tool-x86_64.AppImage MyApp.AppDir
