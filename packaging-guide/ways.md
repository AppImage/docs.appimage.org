# Different ways to create AppImages

There are different ways to create AppImages:

1. Use Open Build Service (OBS)
1. Convert existing binary packages (.deb, .rpm, ...)
1. Use Travis CI
1. Run `linuxdeployqt` on your Qt application
1. Use `electron-builder` for Electron-based apps
1. Create an AppDir manually

## 1. Use the Open Build Service

This option is recommended for open source projects because it allows you to leverage the existing Open Build Service infrastructure, security and license compliance processes. See https://github.com/probonopd/AppImageKit/wiki/Using-Open-Build-Service for how to use this.

## 2. Convert existing binary packages

This option might be the easiest if you already have up-to-date packages in place, ideally a ppa for trusty or earlier or a debian repository for oldstable. In this case, you can write a small `.yml` recipe and in many cases are done with the package to AppImage conversion. [The pkg2appimage script](https://raw.githubusercontent.com/probonopd/AppImages/master/pkg2appimage) can run .yml recipes. [See examples](https://github.com/probonopd/AppImages/tree/master/recipes).

## 3. Bundle your Travis CI builds as AppImages

This option might be the easiest if you already have continuous builds on Travis CI in place. In this case, you can write a small scriptfile and in many cases are done with the AppImage generation. [See examples](https://github.com/search?utf8=%E2%9C%93&q=%22Package+the+binaries+built+on+Travis-CI+as+an+AppImage%22&type=Code&ref=searchresults).

## 4. Run linuxdeployqt on your Qt application

This option might be the easiest if you build your application from source code using using `cmake`, `qmake`, or `make`, and/or if you have a Qt-based application. In the latter case, you are probably already using `windeployqt` and `macdeployqt` and now can use `linuxdeployqt` in the same fashion with the `-appimage` argument and in many cases are done with the AppImage generation [See example](https://github.com/coryo/amphetype2/blob/2d41de3b0c19ab9286672ff0d6a7c11eadc13d9c/.travis/deploy.sh).

## 5. Use electron-builder

This option might be the easiest if you have an Electron-based application. In this case, you define AppImage as a target for Linux (default in the latest version of electron-builder) and in many cases are done with the AppImage generation. [See examples](https://github.com/search?utf8=%E2%9C%93&q=electron-builder+linux+target+appimage&type=Code&ref=searchresults).

## 6. Manually create an AppDir

Create an AppDir manually, then turn it into an AppImage. Start out with the example below, then check the examples on bundling certain applications or type of applications as AppImages from the right-hand side **"Pages"** menu.
