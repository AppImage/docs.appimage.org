# Making your AppImages discoverable

## AppImageHub

You may want to add your AppImage to [AppImageHub](https://appimage.github.io/apps/), 
the crowd-sourced directory of available AppImages.

AppImageHub is a crowd-sourced directory of available, automatically tested AppImages with data
that 3rd party app stores and software centers can use. 
Given an URL to an AppImage, it inspects the AppImage and puts it into a community-maintained catalog.

The idea is that all the metadata travels inside the AppImage, so besides adding an URL to this repository
no additional information is asked, since it comes with the AppImage itself.

Create a new file at https://github.com/AppImage/AppImageHub/new/master/data and send a pull request.

The file should contain one line with a link to the GitHub repository that hosts AppImages on its Releases page.

Alternatively, a link to the AppImage. Nothing else.

Then send a pull request. Travis CI will instantly perform an automated review of the AppImage,
and in case it succeeds, you will see a green result in your pull request. If you get a red result,
check the log of the Travis CI build, and fix it.

As a format, AppImage is designed in a way that does not impose restrictions on the person generating AppImages. Basically you are free to put inside an AppImage whatever you want. For AppImageHub, however, additional rules apply. AppImages submitted to AppImage hub undergo automatic and possibly additional manual review.

* Must be downloadable from an URL. Our testing system fetches the AppImage using `wget`. Currently we cannot get AppImages from locations behind authentication and/or cookie-protected locations. For commercial applications we recommend to have a generally downloadable demo/trial version. Please contact us if you would like to add your commercial AppImage to the directory and it is not available for general download
* Must run on the [oldest still-supported Ubuntu LTS release](https://www.ubuntu.com/info/release-end-of-life) (currently Ubuntu 14.04) without the installation of additional packages. Targeting the oldest still-supported LTS is to ensure that the AppImage will run not only on the very latest, but also on older target systems, such as enterprise distributions (not limited to Ubuntu)
* Must execute in our Travis CI based testing environment
* Must pass [appdir-lint.sh](https://github.com/AppImage/AppImages/blob/master/appdir-lint.sh)
* Must have a desktop file that passes `desktop-file-validate`
* Must run without active Internet connection (and at least show some information)
* Should have an [AppStream metainfo file](https://people.freedesktop.org/~hughsient/appdata/) in `usr/share/metainfo`. If it does, must pass `appstreamcli` validation
* Should show a useful screen rather than some crude dialog box since the main window will be used for the main screenshots. Note that you can provide your own screenshots by using an [AppStream metainfo file](https://people.freedesktop.org/~hughsient/appdata/)
* Should be available under a constant URL that does not contain the version number. Alternatively, should be available on GitHub Releases or the openSUSE Build Service (you are free to suggest additional serices like these)

## Future catalogs

In the future, we may want to use decentral peer-to-peer databases for the catalog of AppImages. 
We are currently investigating technologies such as IPFS and would be happy to win contributors in this area.
