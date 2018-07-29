Using portable mode
===================

Sometimes it can be useful for data of an application to travel along with the application, for example to put the application on a USB stick that can be used with different computers. In the windows world, this concept is known as “portable applications”.

Normally the application contained inside an AppImage will store its configuration files wherever it always stores them (most frequently somewhere inside :code:`$HOME`). In other words, the fact that an application is contained inside an AppImage normally does not change where the application stores its data.

However, there is functionality in newer AppImages that can make the application's data travel along with the application, if certain directories are present *next to the AppImage file*.

If you invoke an AppImage built with a recent version of AppImageKit and have one of these special directories in place, then the configuration files will be stored alongside the AppImage. This can be useful for portable use cases, e.g., carrying an AppImage on a USB stick, along with its data.

- If there is a directory with the same name as the AppImage plus :code:`.home`, then :code:`$HOME` will automatically be set to it before executing the payload application
- If there is a directory with the same name as the AppImage plus :code:`.config`, then :code:`$XDG_CONFIG_HOME` will automatically be set to it before executing the payload application


Example
-------

Imagine you want to use the Leafpad text editor, but carry its settings around with the executable. You can do the following:

.. Tell Pygments to use 'shell' syntax, otherwise it defaults to 'pyhton'
.. See http://www.sphinx-doc.org/en/1.4.9/markup/code.html#directive-code-block for more infos
.. code-block:: shell

	# Download Leafpad AppImage and make it executable
	$ wget -c "https://bintray.com/probono/AppImages/download_file?file_path=Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage" -O Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage
	$ chmod a+x Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage

	# Create a directory with the same name as the AppImage plus the ".config" extension
	# in the same directory as the AppImage
	$ mkdir Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config

	# Run Leafpad, change some setting (e.g., change the default font size) then close Leafpad
	$ ./Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage

	# Now, check where the settings were written:
	$ find Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config
	(...)
	Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config/leafpad/leafpadrc


Note that the file :code:`leafpadrc` was written in the directory we have created before.
