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

Important: see the section regarding :ref:`hard-coded absolute paths <ref-binaries-no-abs-paths>`.

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
