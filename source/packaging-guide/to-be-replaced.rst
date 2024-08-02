To be replaced
==============

TODO: Pieces from removed files that should be moved to a desktop file section:

Desktop file and icon are used for so-called :ref:`desktop integration <ref-desktop-integration>`.

myapp.desktop should contain (as a minimum):

.. code-block:: ini

	[Desktop Entry]
	Name=MyApp
	Exec=myapp
	Icon=myapp
	Type=Application
	Categories=Utility;

Be sure to pick one of the `Registered Categories <https://standards.freedesktop.org/menu-spec/latest/apa.html>`_, and be sure that your desktop file passes validation by using :code:`desktop-file-validate your.desktop`. If you are not deploying an application with a graphical user interface (GUI) but a command line tool (for the terminal), make sure to add :code:`Terminal=true`.

The desktop file is used for :ref:`AppImage desktop integration <ref-desktop-integration>`, and since desktop files require icons, an icon is always required, too.
