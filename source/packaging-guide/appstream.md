# Shipping AppStream metadata

AppStream is a cross-distro effort for providing metadata for software in the (Linux) ecosystem.
It provides a convenient way to get information about not installed software,
and is one of the building blocks for software centers.

Desktop environments, file managers, AppImage catalogs, software centers, and app stores can use metadata about the application from inside the AppImage to get a description, URLs, screenshots, and other information that describes the application. This optional metadata travels inside the AppImage. So if you would like your applicatoin to show a nice screenshot in app centers, you should add an AppStream metainfo file to your AppImage. AppStream is a format that exists independently of AppImage and can be used in conjunction with other packaging formats as well. Many open source applications already come with AppStream metainfo files by default.

More information: https://www.freedesktop.org/software/appstream/docs/chap-Quickstart.html#sect-Quickstart-DesktopApps.

## Using AppStrean generator

An easy way to generate an AppStream metainfo file is to use the online generator at http://output.jsbin.com/qoqukof.

# Embedding AppStream metadata

Once you have generated a suitable AppStream metainfo file, place it into `usr/share/metainfo/myapp.appdata.xml` in your AppDir, and generate an AppImage from it. It is generally a good idea to check AppStream metainfo files for errors using the `appstreamcli` and/or `appstream-util` command line tools. `appimagetool` will automatically attempt to validate the AppStream metainfo file if `appstreamcli` and/or `appstream-util` are available on the `$PATH`.
