# What goes into an AppImage

It is crucial to understand that AppImage is merely a format for distributing applications. In this regard, AppImage 
is like a `.zip` file or an `.iso` file. It does not define how to compile applications. 
It it is also not a build system.

It is crucial to put binaries inside AppImages that are compatible with a variety of target systems. 
What goes into the AppImage is called the “payload”, or the “ingredients”.
Producing the payload requires some thought, as you want your AppImage to run on as many targets systems as possible.

For an AppImage to run on most systems, the following conditions need to be met:
 1. Binaries must not use compiled-in absolute paths (and if they do, they need to be binary-patched)
 1. The AppImage needs to include all libraries and other dependencies that are not part of all of the base systems that the AppImage is intended to run on.
 1. The binaries contained in the AppImage need to be compiled on a system not newer than the oldest base system that the AppImage is intended to run on.
 1. The AppImage should actually be tested on the base systems that it is intended to run on.


## Binaries must not use compiled-in absolute paths

Since an AppImage is mounted at a different location in the filesystem every time it is run, it is crucial not to use compiled in absolute paths. For example, if the application accesses a resource such as an image, it should do so from a location relative to the main executable. Unfortunately, many applications have absolute paths compiled in (`$PREFIX`, most commonly `/usr`) at compile time.

### Open source applications

Wherever possible you should change the Source Code of the application in order not to use absolute paths. There are several ways to do this. They canonical way on Linux is to resolve `proc/self/exe` to get the path to the main executable and construct a relative path from there. As a result, it should work both in normal installations and in relocatable installations such as AppImages.

There are libraries which make this easier, for example [BinReloc](https://github.com/limbahq/binreloc). Also see [Resourceful](https://github.com/drbenmorgan/Resourceful), a project to study of cross-platform techniques for building applications and libraries that use resource files (e.g. icons, configuration, data).

Some application frameworks such as Qt have this functionality built-in, for example in [`QString QCoreApplication::applicationDirPath()`](http://doc.qt.io/qt-5/qcoreapplication.html#applicationDirPath), and construct a _relative_ path to `../share/kaidan/images/` from there. For an example, see https://github.com/KaidanIM/Kaidan/commit/da38011b55a1aa5d17764647ecd699deb4be437f.

__NOTE:__ __DO NOT USE__ [`QStringList QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);`](http://doc.qt.io/qt-5/qstandardpaths.html). According to the [Qt documentation](http://doc.qt.io/qt-5/qstandardpaths.html), this resolves to `"~/.local/share/<APPNAME>", "/usr/local/share/<APPNAME>", "/usr/share/<APPNAME>"` but clearly `/usr` is not where these things are located in an AppImage.

### Closed source applications with compiled-in absolute paths

In case it is not possible to change the source code of the application, for example because it is a closed source application, you could binary patch the executable.  The trick is to search for `/usr`  in the binary and replace it by the same length string `././`  which means “here”.  This can be done by using the following command: `find usr/ -type f -executable -exec sed -i -e "s|/usr|././|g" {} \;`. This command is also available as part of the bash function collection at https://github.com/AppImage/AppImages/blob/9249a99e653272416c8ee8f42cecdde12573ba3e/functions.sh#L79. For the binary-patched application to work, you need to change to the `usr/` directory inside the application directory before you launch the application.

## Binaries compiled on old enough base system

The ingredients used in your AppImage should not be built on a more recent base system than the oldest base system your AppImage is intended to run on. Some core libaries, such as glibc, tend to break compatibility with older base systems quite frequently, which means that binaries will run on newer, but not on older base systems than the one the binaries were compiled on.

If you run into errors like this

```
failed to initialize: /lib/tls/i686/cmov/libc.so.6: version `GLIBC_2.11' not found
```

then the binary is compiled on a newer system than the one you are trying to run it on. You should use a binary that has been compiled on an older system. Unfortunately, the complication is that distributions usually compile the latest versions of applications only on the latest systems, which means that you will have a hard time finding binaries of bleeding-edge softwares that run on older systems. A way around this is to compile dependencies yourself on a not too recent base system, and/or to use [LibcWrapGenerator](https://github.com/probonopd/AppImageKit/tree/master/LibcWrapGenerator) or [glibc_version_header](https://github.com/wheybags/glibc_version_header).

When producing AppImages for the Subsurface project, I have had very good results by using __CentOS 6__. This distribution is not too recent (current major CentOS version minus 1) while there are still the most recent Qt and modern compilers for it in the [EPEL](https://fedoraproject.org/wiki/EPEL) and [devtools-2](http://people.centos.org/tru/devtools-2/) (the community equvalent of the Red Hat Developer Toolset 2) repositories. When using it for compilation, I found the resulting binaries to run on a wide variety of systems, including __debian oldstable__ (wheezy).

Be sure to check https://github.com/probonopd/AppImages, this is how I build and host my AppImages and the build systems to produce them in the cloud using travis-ci, docker, docker-hub, and bintray. Especially check the recipes for Subsurface and Scribus.

See https://github.com/probonopd/AppImageKit/wiki/Docker-Hub-Travis-CI-Workflow for a description on how to set up a workflow involving your GitHub repository, Docker Hub, and Travis CI for a fully automated continuous build workflow.

You could also consider to link some exotic libraries statically.
Yes, even Debian does that:
https://lintian.debian.org/tags/embedded-library.html

## libstdc++.so.6

__As a general rule of thumb, please use no libstdc++.so.6 newer than the one that comes with the oldest distribution that you still want to support, i.e., the oldest still-supported LTS version__ (at the time of this writing, Ubuntu 14.04).

### AppImageKit-checkrt

Some projects require newer C++ standards to build them. To keep the glibc dependency low you can
build a newer GCC version on an older distro and use it to compile the project. If you do this, however, then your compiled application will require a newer version of the `libstdc++.so.6` library than available on that distro. Bundling `libstdc++.so.6` however will in most cases break compatibility with distros that have a newer library version installed into their system than the bundled one. So blindly bundling the library is not reliable. While this is primarily an issue with `libstdc++.so.6` in some rare cases this might also occur with `libgcc_s.so.1`. That's because both libraries are part of GCC. You would have to know the library version of the host system and decide whether to use a bundled library or not before the application is started. This is exactly what the patched AppRun binary from https://github.com/darealshinji/AppImageKit-checkrt/ does. It will search for `usr/optional/libstdc++/libstdc++.so.6` and `usr/optional/libgcc_s/libgcc_s.so.1` inside the AppImage or AppDir. If found it will compare their internal versions with the ones found on the system and prepend their paths to `LD_LIBRARY_PATH` if necessary.

Here is an example of how to use it, taken from the https://github.com/probonopd/audacity/blob/AppImage/.travis.yml real-world example. The key lines are:

```
  - # Workaround to increase compatibility with older systems; see https://github.com/darealshinji/AppImageKit-checkrt for details
  - mkdir -p appdir/usr/optional/ ; wget -c https://github.com/darealshinji/AppImageKit-checkrt/releases/download/continuous/exec-x86_64.so -O ./appdir/usr/optional/exec.so
  - mkdir -p appdir/usr/optional/libstdc++/ ; cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 ./appdir/usr/optional/libstdc++/
 - ( cd appdir ; rm AppRun ; wget -c https://github.com/darealshinji/AppImageKit-checkrt/releases/download/continuous/AppRun-patched-x86_64 -O AppRun ; chmod a+x AppRun)
...
  - # Manually invoke appimagetool so that libstdc++ gets bundled and the modified AppRun stays intact
  - ./linuxdeployqt*.AppImage --appimage-extract
  - export PATH=$(readlink -f ./squashfs-root/usr/bin):$PATH
  - ./squashfs-root/usr/bin/appimagetool -g ./appdir/ $NAME-$VERSION-x86_64.AppImage
```