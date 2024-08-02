.. _desktop-entry-files:

Desktop entry & icon files
==========================

To create an AppImage for your application, you first have to create a desktop entry file, colloquially also called desktop file. A desktop file contains metadata about the application, e.g. name or icon name, but also the executable name, which is used by the user's system to correctly display and execute the application. It's a central component of the Linux desktop and every AppImage must contain one in its :ref:`AppDir <ref-appdir>`.

A desktop entry file is an `INI-style <https://en.wikipedia.org/wiki/INI_file>`_ text document, which means that it contains (mandatory and optional) key-value pairs in the format ``Key=Value`` and group headers in the format ``[Header]``, most notably the ``[Desktop Entry]`` header for the main information. The official `Desktop Entry Specification <https://specifications.freedesktop.org/desktop-entry-spec/latest>`_ describes all possible ways to configure a desktop entry file in detail. An AppImage desktop entry file should at least contain these keys:

.. code-block:: ini

	[Desktop Entry]
	Name=My application
	Exec=my-application
	# Icon name without the file format
	Icon=my-application
	Type=Application
	Terminal=false
	Categories=Utility;TextEditor;

The ``Categories`` value should be a list of all `specific registered categories <https://specifications.freedesktop.org/menu-spec/latest/category-registry.html>`_ that apply to your application.

The list of all keys can be found in the `Desktop Entry Specification (Recognized keys) <https://specifications.freedesktop.org/desktop-entry-spec/latest/recognized-keys.html>`_. Further keys that are recommended for AppImages are ``GenericName`` (the name of the application category, e.g. "Browser" for Firefox), ``Comment`` (an application description) and ``Version`` (not the application version, but the used version of the `Desktop Entry Specification <https://specifications.freedesktop.org/desktop-entry-spec/latest/recognized-keys.html>`_.

The desktop entry file should be named according to the `Reverse domain name notation <https://en.wikipedia.org/wiki/Reverse_domain_name_notation>`_ and have ``.desktop`` as file ending, for example ``org.AppImage.ExampleApp.desktop``.

After creating your desktop file, make sure that it's valid using :code:`desktop-file-validate org.example.application.desktop`.


Custom keys introduced for AppImage purposes
--------------------------------------------

Aside from the standardized mandatory and optional keys, desktop entry files may contain additional, use case dependent keys. They're usually prepended with :code:`X-` to differentiate between standard and custom keys.

The AppImage project defined a few custom keys with special meaning that provide information to enhance our desktop integration algorithm.

X-AppImage-Name
    Name of the application. Used to relate two AppImages of the same application but different versions.

    **Examples:** :code:`Krita`, :code:`Kdenlive`, :code:`Ultimaker Cura`

X-AppImage-Version
    Version of the application bundled in the AppImage.

    **Examples:** :code:`4.9.2`, :code:`1.0.0-beta-2`, :code:`2019.1.1`

X-AppImage-Arch
    Architecture of the AppImage.

    **Examples:** :code:`x86_64`, :code:`aarch64`, :code:`i386`

:ref:`appimagetool <ref-appimagetool>` and :ref:`libappimage <ref-libappimage>` currently make use mostly of :code:`X-AppImage-Version`.

.. seealso::

   The following discussions in issue trackers contain some background information:

     * `AppImageKit#59 <https://github.com/AppImage/AppImageKit/issues/59>`_
     * `AppImageKit#662 <https://github.com/AppImage/AppImageKit/issues/662>`_


.. _icon-files:

Icon files
----------

As a desktop entry file should link to an icon file, you should also create an icon file in one or several resolutions. This icon is used on the user's system to display your application.

Supported icon formats are ``png`` and ``svg``. (``xpm`` is also supported, but deprecated and shouldn't be used for new packages). The valid resolutions for raster icons are ``8x8``, ``16x16``, ``20x20``, ``22x22``, ``24x24``, ``28x28``, ``32x32``, ``36x36``, ``42x42``, ``48x48``, ``64x64``, ``72x72``, ``96x96``, ``128x128``, ``160x160``, ``192x192``, ``256x256``, ``384x384``, ``480x480`` and ``512x512``.

You only have to specify one icon (ideally in the resolution ``512x512``), but it might make sense to also create icon file versions that don't contain as many details in smaller resolutions. An advanced option would be to even include icon files adapted to well-known themes and include them (exchanging ``hicolor`` in the icon path with the theme name, see :ref:`manually-creating-appdir-structure`).

To include the icon in several resolutions or theme styles, each file must be named the same. If they're placed correctly in the AppDir and the icon name (without the file format) is included in the desktop file, the icon will be correctly used by the user's system.

For more information, see the `Icon Theme Specification <https://specifications.freedesktop.org/icon-theme-spec/latest>`_.


Advanced options
----------------

For advanced options of the desktop entry file, e.g. using localized strings to change the application name and description based on the user's system language, see the official `Desktop Entry Specification <https://specifications.freedesktop.org/desktop-entry-spec/latest/recognized-keys.html>`_.
