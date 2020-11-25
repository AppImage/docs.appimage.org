.. _ref-manual:

Manual packaging
================

Create an AppDir manually, then turn it into an AppImage. Start out with the example below, then check the examples on bundling certain applications or type of applications as AppImages from the right-hand side **"Pages"** menu.


.. contents:: Contents
   :local:
   :depth: 1


.. _ref-creating-an-appdir-manually:

Creating an AppDir manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In practice, you will probably never do this by hand. So this is mainly to illustrate the concept.

Create an AppDir structure that looks (as a minimum) like this::

	MyApp.AppDir/
	MyApp.AppDir/AppRun
	MyApp.AppDir/myapp.desktop
	MyApp.AppDir/myapp.png
	MyApp.AppDir/usr/bin/myapp
	MyApp.AppDir/usr/lib/libfoo.so.0

The :code:`AppRun` file can be a script or executable. It sets up required environment variables such as :code:`$PATH` and launches the payload application. You can write your own, but in most cases it is easiest (and most error-proof) to use a precompiled one from this repository.

Of course you can leave out the library if your app does not need one, or if all libraries your app needs are already contained in every base operating system you are targeting.


.. _ref-no-hard-coded-paths:

No hard-coded paths
^^^^^^^^^^^^^^^^^^^

Your binary, myapp, must not contain any hardcoded paths that would prevent it from being relocateable. You can check this by running

.. code-block:: shell

	strings MyApp.AppDir/usr/bin/myapp | grep /usr

Should this return something, then you need to modify your app programmatically (e.g., by using relative paths, using `binreloc <https://github.com/limbahq/binreloc>`__, or using :code:`QString QCoreApplication::applicationDirPath()`).

If you prefer not to change the source code of your app and/or would not like to recompile your app, you can also patch the binary, for example using the command

.. code-block:: shell

    sed -i -e 's#/usr#././#g' MyApp.AppDir/usr/bin/myapp

This usually works as long as the application is not doing a :code:`chdir()` which would break this workaround, because then :code:`././` would not be pointing to :code:`$APPDIR/usr` any more. You can run the following command to see whether the application is doing a :code:`chdir()` (99% of GUI applications don't)

.. code-block:: shell

	strace -echdir -f ./AppRun

Also see:
	https://www.gnu.org/software/gnulib/manual/html_node/Supporting-Relocation.html


It has been a pain for many users of GNU packages for a long time that packages are not relocatable. The relocatable-prog module aims to ease the process of making a GNU program relocatable.

.. note::
	The same is true for any helper binaries and/or libraries that your app depends on. You check this and patch it with

	.. code-block:: shell

		cd MyApp.AppDir/usr/
		find . -type f -exec sed -i -e 's#/usr#././#g' {} \;
		cd -

	which replaces all occurrences of :code:`/usr` with :code:`././`, which simply means "here".

myapp.desktop should contain (as a minimum):

.. code-block:: ini

	[Desktop Entry]
	Name=MyApp
	Exec=myapp
	Icon=myapp
	Type=Application
	Categories=Utility;

Be sure to pick one of the `Registered Categories`_, and be sure that your desktop file passes validation by using :code:`desktop-file-validate your.desktop`. If you are not deploying an application with a graphical user interface (GUI) but a command line tool (for the terminal), make sure to add :code:`Terminal=true`.


Creating an AppImage from the AppDir
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To create an AppImage, run :code:`appimagetool` on the AppDir in order to turn it into an AppImage. You can get it from this repository's `Releases`_ page (it comes as an AppImage itself; yes, we eat our own dogfood).

.. _Registered Categories: https://standards.freedesktop.org/menu-spec/latest/apa.html
.. _Releases: https://github.com/AppImage/AppImageKit/releases

Bundling GTK libraries
^^^^^^^^^^^^^^^^^^^^^^

The following steps allow bundling the GTK libraries and configuration files in a relocatable way, without the need to patch the files and replace hard-coded paths. The full set of bundling commands, in the form of a bash script, can be found `here <https://github.com/aferrero2707/appimage-helper-scripts/blob/master/bundle-gtk2.sh>`__. They assume the existence of an :code:`APPDIR` environment variable that points to the root folder of the AppImage bundle.

GDK-Pixbuf modules and cache file
"""""""""""""""""""""""""""""""""

.. code-block:: shell

   gdk_pixbuf_moduledir="$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)"
   gdk_pixbuf_cache_file="$(pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0)"
   gdk_pixbuf_libdir_bundle="lib/gdk-pixbuf-2.0"
   gdk_pixbuf_cache_file_bundle="$APPDIR/usr/${gdk_pixbuf_libdir_bundle}/loaders.cache"
   mkdir -p "$APPDIR/usr/${gdk_pixbuf_libdir_bundle}"
   cp -a "$gdk_pixbuf_moduledir" "$APPDIR/usr/${gdk_pixbuf_libdir_bundle}"
   cp -a "$gdk_pixbuf_cache_file" "$APPDIR/usr/${gdk_pixbuf_libdir_bundle}"
   sed -i -e "s|${gdk_pixbuf_moduledir}/||g" "$gdk_pixbuf_cache_file_bundle"

The hard-coded paths in the cache file are removed by the :code:`sed` command. At run time, the :code:`$APPDIR/usr/ib/gdk-pixbuf-2.0/loaders` folder has to be added to the :code:`LD_LIBRARY_PATH` environment variable, so that the bundled GDK-Pixbuf loaders can be correctly found by the linker.

GLib schemas
""""""""""""

.. code-block:: shell

   glib_prefix="$(pkg-config --variable=prefix glib-2.0)"
   mkdir -p "$APPDIR/usr/share/glib-2.0/schemas/"
   cp -a ${glib_prefix}/share/glib-2.0/schemas/* "$APPDIR/usr/share/glib-2.0/schemas"
   cd "$APPDIR/usr/share/glib-2.0/schemas/"
   glib-compile-schemas .

Theme engines
"""""""""""""

.. code-block:: shell

   mkdir -p "$APPDIR/usr/lib/gtk-2.0"
   GTK_LIBDIR=$(pkg-config --variable=libdir gtk+-2.0)
   GTK_BINARY_VERSION=$(pkg-config --variable=gtk_binary_version gtk+-2.0)
   cp -a "${GTK_LIBDIR}/gtk-2.0/${GTK_BINARY_VERSION}"/* "$APPDIR/usr/lib/gtk-2.0"

RSVG library
""""""""""""
This library is not automatically picked, because it is a dependency of the GDK-Pixbuf loaders and not of the global GTK libraries.

.. code-block:: shell

   export GDK_PIXBUF_MODULEDIR="${APPDIR}/usr/lib/gdk-pixbuf-2.0/loaders"

   mkdir -p "$APPDIR/usr/lib"
   RSVG_LIBDIR=$(pkg-config --variable=libdir librsvg-2.0)
   if [ x"${RSVG_LIBDIR}" != "x" ]; then
   export GDK_PIXBUF_MODULE_FILE="${APPDIR}/usr/lib/gdk-pixbuf-2.0/loaders.cache"
	echo "cp -a ${RSVG_LIBDIR}/librsvg*.so* $APPDIR/usr/lib"
	cp -a "${RSVG_LIBDIR}"/librsvg*.so* "$APPDIR/usr/lib"
   fi

Run-time environment variables
""""""""""""""""""""""""""""""
The following environment variables need to be set when running the AppImage:

.. code-block:: shell

     export GDK_PIXBUF_MODULEDIR="${APPDIR}/usr/lib/gdk-pixbuf-2.0/loaders"
     export GDK_PIXBUF_MODULE_FILE="${APPDIR}/usr/lib/gdk-pixbuf-2.0/loaders.cache"
     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GDK_PIXBUF_MODULEDIR"
     export GTK_PATH="$APPDIR/usr/lib/gtk-2.0"
     export GTK_IM_MODULE_FILE="$APPDIR/usr/lib/gtk-2.0:$GTK_PATH"
     export PANGO_LIBDIR="$APPDIR/usr/lib"
  
