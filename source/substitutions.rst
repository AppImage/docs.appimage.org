.. |appimage_preferred_source| replace:: In general, AppImages should be officially distributed by application authors. If application authors don't provide an AppImage, you should create an issue and ask them to start packaging the application as AppImage, or make a pull / merge request to add the creation of one if possible. Converting existing packages should only be used as a last resort if the application authors won't provide an officially distributed AppImage.
.. |valid_resolutions| replace:: ``8x8``, ``16x16``, ``20x20``, ``22x22``, ``24x24``, ``28x28``, ``32x32``, ``36x36``, ``42x42``, ``48x48``, ``64x64``, ``72x72``, ``96x96``, ``128x128``, ``160x160``, ``192x192``, ``256x256``, ``384x384``, ``480x480`` and ``512x512``
.. |supported_icon_formats| replace:: Supported icon formats are ``png`` and ``svg``. (``xpm`` is also supported, but deprecated and shouldn't be used for new packages). The valid resolutions for raster icons are |valid_resolutions|.
.. |old_compile_version_reason| replace:: The reason for this is that other included shared libraries and executables might reference these core libraries - this often doesn't work if the system libraries are older than the libraries that are referenced at compile-time. By compiling on the oldest supported Linux distribution version, your application can be run on all supported Linux distribution versions.
.. |build_on_old_version| replace:: all binaries bundled in the AppImage should be built on the oldest supported LTS distribution version to make sure that the resulted AppImage works on all current (newer) distribution versions, see :ref:`exclude-expected-libraries`
.. |appimage_standalone_bundles| replace:: AppImages are standalone bundles, and do not need to be installed. After downloading an AppImage (and marking it as executable), you can simply double-click to run it without having to install anything.
.. |desktop_integration| replace:: However, users may want their AppImages to be integrated into the system so that they show up in menus with their icons, have their MIME types associated, can be launched from the desktop environment's launcher, etc.
.. |contact| replace:: If you're new to AppImage, or have any problems with or questions about AppImages, please don't hesitate to contact the AppImage team and their community. They're happy to help! Please see the :ref:`Contact page <contact>` for more information.
.. |group_user_add| replace:: After adding a user to a group, that user must logout and login again for the change to take effect!
.. |fuse_docker| replace:: Most docker containers don't permit to use FUSE inside containers for security reasons. In that case, you will see this or a similar error:
.. |recent_type_2| replace:: but every reasonably recent AppImage is type 2
.. |linuxdeploy_bundle_appimages| replace:: As of December 2024, :ref:`linuxdeploy` has a `bug <https://github.com/linuxdeploy/linuxdeploy/issues/301>`__ that causes it to corrupt AppImages when they're given as additional executables that should be bundled. Therefore, when using it, other bundled AppImages have to manually be copied into the AppDir and ``appimagetool`` has to be used to create the AppImage.
.. |upstream_advantage| replace:: This ensures that the software works exactly the way the original application author has envisioned it to work.
.. |software_catalogs_short| replace:: They basically work as app stores in which you can look through a list of all indexed AppImages, read their description and search for something specific or even filter by categories.
.. |shell_command| replace:: The way how you can execute such a shell command depends on the programming language. For example, in Rust you can do this with
.. |apprun_c_warning| replace:: ``AppRun.c`` (and its compiled binary in the AppImageKit releases) is legacy technology and should be avoided if possible. Using a modern :ref:`AppImage creation tool <appimage-creation-tools>` is strongly preferred; they made ``AppRun.c`` obsolete in most cases.
.. |why_apprun_c| replace:: if an existing application must not be altered (e.g. if the licence prohibits any modification)
.. |introduction_content| replace:: the ideas behind AppImage, its advantages and underlying core concepts
.. |packaging_optional| replace:: and explains further optional features like making your AppImages updateable or adding additional metadata.
.. |reference_content| replace:: the formal specification, reference implementation and history of AppImages as well as the AppDir specification
.. |appimages_without_fuse| replace:: without FUSE by using the ``--appimage-extract-and-run`` parameter (like ``./MyApp.AppImage --appimage-extract-and-run``)
.. |appimage_implementations_practice| replace:: basically all modern AppImage creation tools use one of only two implementations (the reference implementation and a related experimental implementation with new features)
.. |appimage_history_link| replace:: have changed and might be changed in the future (e.g. to add new features), there might be some older AppImages that lack certain features. To learn more about the different types of AppImages and their history, see :ref:`appimage-types-history`. However, backwards compatibility is maintained
.. |specification_advantage| replace:: Having a specification means that different tools can deal with AppImages and rely on them behaving consistently and fulfilling the defined requirements. It also helps maintaining compatibility between different tools and components.
.. |new_type_2_features| replace:: from a user perspective are not due to specification changes but rather due to new features that have been added to the implementation while adapting it to the new specification
.. |specification_broad| replace:: However, the specification is pretty broad, which means that there are some things the implementation can decide.
.. |appimage_not_starting_1| replace:: If you double-click your AppImage and it doesn't start / nothing happens, you should open it with the terminal as it prints additional error information there if it crashes. This information can help to determine the issue with your AppImage.
.. |appimage_not_starting_2| replace:: To do that, simply enter its full path in a terminal (command line) like this: ``~/Downloads/MyApplication.AppImage``.
.. |appimage_content| replace:: an application and everything the application needs to run on all modern Linux distribution versions (e.g. libraries, icons and fonts)


.. _AppImageUpdate: https://github.com/AppImageCommunity/AppImageUpdate
.. _AM / AppMan: https://github.com/ivan-hc/AM
.. _Soar: https://github.com/pkgforge/soar
