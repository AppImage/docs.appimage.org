Concepts
========

The AppImage development follows a few easy to understand core principles and concepts that keep it simple to use for developers and users. In this section, the most prominent concepts are explained.


.. _one-app-one-file-principle:

One app = one file
-------------------

AppImages are simple to understand. Every AppImage is a regular file, and every AppImage contains exactly one app with all its dependencies. Once the AppImage is :ref:`made executable <howto-make-AppImage-executable>`, a user can just run it, either by double clicking it in their desktop environment's file manager, by running it from the console etc.


.. _no-external-dependencies:

Do not depend on system-provided resources
------------------------------------------

To be able to run on any Linux distribution, an AppImage should bundle all the resources it needs during the runtime. The most common resources are the actual binaries, shared library dependencies, icons and other graphics and of course one or more desktop files for desktop integration.

This doesn't mean an AppImage must not use resources provided by the system, like for example specific libraries (e.g., graphics libraries), user interface themes or the like. However, an AppImage should not have any hard dependencies, and should provide a good user experience even if those resources are not available. This is the only way to ensure the AppImage's compatibility with as many distributions as possible.


.. _build-on-old-systems:

Build on old systems, run on newer systems
------------------------------------------

AppImages are supposed to be built on the oldest possible system, allowing them to run on newer system. This allows the exclusion of certain "base libraries", which can be expected to be present on all major desktop Linux distributions, reducing the overhead of :ref:`one app = one file <one-app-one-file-principle>`. These dependencies are mostly shared libraries and involve low level libraries like :code:`libc.so.6` (the GNU C library, the C language standard library the majority of all Linux distributions use), but also common libraries like zlib_ or the GLib_ libraries are normally present.

It may seem contradictory to :ref:`the previous section <no-external-dependencies>` to rely on distribution provided resources. This is a trade-off between trying to reduce redundancies while at the same time being as self-contained as possible.

In some cases, including the libraries might even break the AppImage on the target system. Those libraries involve, among others, hardware dependent libraries such as graphics card drivers provided libraries (e.g., :code:`libGL.so.1`, (`source <libgl-excludelist>`_)), or libraries that are build and linked differently on different distributions (e.g., :code:`libharfbuzz.so.0` and :code:`libfreetype.so.6` (`source <harfbuzz-freetype-excludelist>`_).

The list of libraries that can resp. have to be excluded, the so-called :ref:`excludelist <excludelist>`, is carefully curated by the AppImage team, and is regularly updated.

.. _zlib: https://zlib.net/
.. _GLib: https://developer.gnome.org/glib/

.. _libgl-excludelist: https://github.com/AppImage/AppImages/blob/14c255b528dd88ef3e00ae0446ac6d84a20ac798/excludelist#L38-L41
.. _harfbuzz-freetype-excludelist: https://github.com/AppImage/AppImages/blob/14c255b528dd88ef3e00ae0446ac6d84a20ac798/excludelist#L98-L102

