Motivation
==========

There's two different points of view when looking at AppImages: the user's and the developer's. The following section explains both of them.


Why would I as a user want to use AppImages?
----------------------------------------------------------------------------------------

Consider the following user stories:

   "I as a user want to run the latest version of my favorite app on my stable distribution, which ships only with an old outdated version."

   "I as a user need to use multiple versions of an application in parallel."

   "I as a user want to take my favorite applications with me on a portable disk together with my data, allowing me to use any Linux computer to work with my files."

All these use cases can be accomplished by using AppImages.

AppImages provide a easy and unified user experience, have a large user base and eco system, and there's a lot of tools that improve the users' user experience.


Why would I as a developer want to make and distribute AppImages?
----------------------------------------------------------------------------------------

Many developers have found that they can deploy their apps to most operating systems with viable efforts. They can say, "I make binaries for Windows", or "I make binaries for macOS". However, when trying to do the same for Linux, they commonly face a situation where they cannot "make binaries for Linux", but they have to make them for Ubuntu, Debian, CentOS, openSUSE etc. Read: they have to make binaries for every distribution.

The problem with this is that Linux is just the kernel, but the operating systems users run are separate projects with separate goals and concerns. They all ship with different versions and combinations of certain libraries, and most of them require software to be shipped separately, linking to binaries in the distribution. Therefore, in order to be able to run a certain binary, that binary must be compiled *against* the distribution's set of libraries. As soon as another distribution's collection of libraries is not the same as the one the binary was built on, it will crash or even refuse to run.

To fix this issue, one has to do the same one would do to prevent issues like missing shared libraries (or version incompatibilities) that is used on other platforms: ship the dependency libraries along with the own software's binaries.

This can be accomplished using traditional tarballs that contain all the libraries and maybe some sort of "run script" that makes sure only those libraries are run, but it has a few major disadvantages. First of all, it is hard to get the right set of libraries that must be shipped, excluding the ones that would cause issues (lowest level dependencies such as ``libc``, ``libdl``, etc.). But even worse, the user is presented with an archive that they must extract, and they must be explained how to actually run the software within it. Furthermore, they now have that data on their hard drive, and have to manage it themselves, without any kind of helpers.

In order to improve the usability and reduce the maintenance effort, AppImage was created. AppImages are bundles of programs, their dependency libraries and all the resources they need during the runtime. They're single binaries, following the ":ref:`one app = one file <one-app-one-file-principle>`" core principle.

Making AppImages is very simple for a developer. There's tools which generate an AppImage from a so-called :ref:`AppDir`. There's simple tools to create such an AppDir for an existing software, which are aware of potential cross distro incompatibilities, and try to avoid them. And once the AppImage has been built, it will "just run" on all major desktop distributions.

Stop making binaries "for distributions" and start making binaries "for Linux" today!
