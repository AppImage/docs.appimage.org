.. include:: ../substitutions.rst

Concepts
========

The AppImage development follows a few easy-to-understand core principles and concepts that keep it simple to use for developers and users. In this section, the most prominent concepts are explained.


.. contents:: Contents
   :local:
   :depth: 1


.. _one-app-one-file-principle:

One app = one file
------------------

AppImages are simple to understand. Every AppImage is a regular file, and every AppImage contains exactly one app with all its dependencies. Once the AppImage is :ref:`made executable <how-to-run-appimage>`, a user can just run it, e.g. by double clicking it in their desktop environment's file manager or by running it from the console.

.. note::
   On a regular basis, `users ask <https://github.com/AppImage/AppImageKit/issues/848>`__ about implementing support for some sort of "reusable/shared frameworks". These frameworks are supposed to contain bundles of libraries which are needed by more than one AppImage, and hence could save some disk space. For management, they suggest complex automagic systems that will automatically fetch the "frameworks" from the Internet if they're not available, or some complicated, mostly manual methods how users could bundle frameworks together with the AppImages on portable disks like USB drives.

   These may be good ideas for some people, and even if they worked perfectly fine, they'd break with our most important concept: :ref:`one app = one file <one-app-one-file-principle>`. AppImages are so simple to understand *because* every application is a single file. There's no complexity in this approach, even grandma could understand it. And after all, disk space is cheap nowadays, right?

   If you prefer this approach or absolutely need it, please check out alternative approaches like Flatpak or Snap. AppImage will never implement such a feature.


.. _no-external-dependencies:

Bundle all required dependencies
--------------------------------

To be able to run on any Linux distribution, an AppImage has to bundle all resources it needs at runtime that cannot reasonably be expected to come with every still-supported target system (Linux distribution) in its default installation in a recent enough version. The most common resources that have to be bundled are the actual binaries, shared library dependencies, icons and other graphics and of course a :ref:`desktop file <desktop-entry-files>` for desktop integration.

This doesn't mean an AppImage must not use resources provided by the system, like for example basic libraries that can be assumed to be part of every target system (e.g., the C standard library or graphics libraries), user interface themes or the like. See the `excludelist <https://github.com/AppImage/pkg2appimage/blob/master/excludelist>`__ for a list of the libraries we consider to currently be part of every still-supported target system.


.. _exclude-expected-libraries:

Exclude expected core libraries (Recommended, but optional)
-----------------------------------------------------------

AppImages should usually exclude certain "core libraries", which can be expected to be present on all major desktop Linux distributions, reducing the overhead of :ref:`one app = one file <one-app-one-file-principle>`. These dependencies are mostly shared libraries and involve low level libraries like ``libc.so.6`` (the GNU C library, the C language standard library the majority of all Linux distributions use), but also common libraries like `zlib <https://zlib.net/>`__ that are normally present.

It may seem contradictory to :ref:`the previous section <no-external-dependencies>` to rely on distribution provided resources. This is a trade-off between trying to reduce redundancies while at the same time being as self-contained as possible.

In some cases, including the libraries might even break the AppImage on the target system. Those libraries involve, among others, hardware dependent libraries such as graphics card drivers provided libraries (e.g., ``libGL.so.1``, (`source <https://github.com/AppImage/pkg2appimage/blob/14c255b528dd88ef3e00ae0446ac6d84a20ac798/excludelist\#L38-L41>`__)), or libraries that are built and linked differently on different distributions (e.g., ``libharfbuzz.so.0`` and ``libfreetype.so.6`` (`source <https://github.com/AppImage/pkg2appimage/blob/14c255b528dd88ef3e00ae0446ac6d84a20ac798/excludelist\#L98-L102>`__)).

The list of libraries that should be excluded, the so-called `excludelist <https://github.com/AppImage/pkg2appimage/blob/master/excludelist>`__, is carefully curated by the AppImage team, and is regularly updated.

**However, excluding these core libraries requires you to compile the application on the oldest still-supported Linux distribution version that we can assume users to still use.** For example, the oldest still-supported LTS release of Ubuntu is a good choice to build applications on. |old_compile_version_reason|

.. note::
   If you don't use any dynamic linking, and your application does not reference any of these core libraries, you don't have to build the application on an old system.

   However, even when using a programming language that usually links everything statically like Rust or Go, some libraries might still be dynamically linked, e.g. by including C code or dependencies that do so. You should test whether your application references any shared libraries with ``ldd`` before building and packaging on a newer system, and it's usually still better to build the application on an old system (to be safe in case of future changes).

Some :ref:`appimage-creation-tools` can also include these expected core libraries. This considerably increases the AppImage size (by at least 30MB), but removes the limitation of requiring the oldest supported LTS distribution version to compile the binaries (since all referenced libraries are included, the used distribution version is irrelevant). This should only be done if there are issues with the exclusion of the core libraries, e.g. if the AppImage can't be built on the oldest supported LTS distribution version, as the inclusion of some core libraries can also lead to other issues. If a considerable base of your users uses a system configuration without some of these core libraries (e.g. a custom Gentoo configuration), it's also an option to provide both AppImage versions.

There are also **experimental** tools that try to use an old version of ``glibc`` when compiling on a new system (`1 <https://github.com/AppImage/AppImageKit/tree/stable/v1.0/LibcWrapGenerator>`__, `2 <https://github.com/wheybags/glibc_version_header>`__, `3 <https://github.com/sulix/bingcc>`__), but they don't always work and as they only adapt ``glibc`` and not other expected core libraries, the application might still crash when referencing a different core library.


AppImage specification
----------------------

The term *AppImage* does not refer to some software project, but is actually a standard specified in the :ref:`AppImage specification <appimage-specification>`. There also is a :ref:`reference implementation <reference-implementation>` that confirms to the specification.

|specification_advantage|


AppDirs
-------

The term *AppDir* refers to an application directory. These directories are the "source" of AppImages. When :ref:`appimagetool` builds an AppImage, it creates a read-only image of such a directory, prepends the :ref:`runtime`, and marks the file executable.

The AppDir format is described in the :ref:`appdir-specification`.
