.. include:: ../../substitutions.rst

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

Additionally to the AppDir content described there, your AppDir needs to contain ``MyApp.AppDir/AppRun`` and ``MyApp.AppDir/.DirIcon``.


AppRun
++++++

In modern AppImages, :code:`AppRun` is usually a symlink to the main binary. This works if the binary has been made relocatable (which is automatically done by modern AppImage creation tools; it's explained :ref:`later on this page <removing-hard-coded-paths>` how to manually do that).

However, |why_apprun_c|, alternatives may be used. For more information, see :ref:`AppRun.c <apprun.c>`.


.DirIcon
++++++++

``.DirIcon`` is the actual icon being used as application icon. It is usually a symlink to an icon stored in root or ``usr/share/icons/hicolor/<resolution>/apps/myapp.png``. Notice that ``.DirIcon`` **must be a PNG file**.

For more information on it, see the :ref:`.DirIcon specification <dir-icon>`.


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

Should this return something, then you need to make your application relocatable, either by modifying the source code or by patching the executable.


Modifying the source code
+++++++++++++++++++++++++

The best way is to modify the source code of the application in order to not use absolute paths. While there are several ways to do this, the canonical way on Linux is to resolve ``/proc/self/exe`` to get the path of the main executable and use a path relative to it. This should work both in normal installations and in relocatable installations such as AppImages. There are also libraries such as `BinReloc <https://github.com/limbahq/binreloc>`_ which make this easier.

Some modern frameworks such as Qt have this functionality built-in, e.g. in ``QString QCoreApplication::applicationDirPath()`` so you don't have to resolve ``/proc/self/exe``. In some cases, there are also flags you can specify when building from source to make applications relocatable.

Another way to make your application relocatable is to use the `GNU relocatable-prog module <https://www.gnu.org/software/gnulib/manual/html_node/Supporting-Relocation.html>`_.


Patching the executable
+++++++++++++++++++++++

If you don't want to or can't change the source code and recompile the application, you can also patch the binaries. This can be done with the following command (which needs to be executed inside the AppDir):

.. code-block:: shell

   find usr/ -type f -executable -exec sed -i -e "s|/usr|././|g" {} \;

It replaces all occurrences of ``/usr`` in each binary with the same length string ``././``, which simply means "here". This command is also available in the :ref:`convenience functions script <convenience-functions-script>`.

..
   TODO: Is this still true? It hasn't been mentioned in this section originally.
   > For the binary-patched application to work, you need to change to the :code:`usr/` directory inside the application directory before you launch the application.

This usually works as long as the application is not calling :code:`chdir()` (changing the current working directory). Such a call would break this workaround as :code:`././` would then not be pointing to :code:`$APPDIR/usr` anymore. You can run the following command to see whether the application is calling :code:`chdir()` (99% of GUI applications don't):

.. code-block:: shell

	strace -echdir -f ./AppRun

.. note::
   An alternative approach to making an application relocatable is to use the AppRun.c script / program, see :ref:`apprun.c`. It can be used |why_apprun_c|. However, this approach is deprecated and should be avoided if possible.


Creating an AppImage from the AppDir
------------------------------------

To create an AppImage from the AppDir, you need :code:`appimagetool`. You can get it by downloading the `latest release <https://github.com/AppImage/appimagetool/releases/latest>`_. After downloading the AppImage, you have to make it executable as usual:

.. code-block:: bash

   > wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
   > chmod +x appimagetool-x86_64.AppImage

After that, you can call it with the AppDir path as parameter in order to turn it into an AppImage:

.. code-block:: bash

   > ./appimage-tool-x86_64.AppImage MyApp.AppDir
