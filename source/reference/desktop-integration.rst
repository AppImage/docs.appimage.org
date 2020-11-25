Desktop integration
===================

This section discusses how we integrate AppImages into the Linux desktops, what technologies are involved and what customizations and additions we implemented to adapt them to work for AppImages.


.. contents:: Contents
   :local:
   :depth: 2


Desktop files
-------------

A central component of the Linux desktop, so-called *desktop entries* (or, colloquially, *desktop files*) are also relevant for AppImage desktop integration. Every AppImage ships with such a file in its :ref:`AppDir <ref-appdir>`.

The FreeDesktop_ project maintains the so-called `Desktop Entry Specification`_. Desktop Entry files are `INI <https://en.wikipedia.org/wiki/INI_file>`__-style text documents containing key-value pairs, one per line. The file is structured in multiple sections, most notably the :code:`[Desktop Entry]`, where the main information goes into. There's a set of mandatory and optional keys to be set in these documents, and there may be additional sections.

.. _FreeDesktop: https://www.freedesktop.org/
.. _Desktop Entry Specification: https://specifications.freedesktop.org/desktop-entry-spec/latest/


Custom keys introduced for AppImage purposes
********************************************

Aside from the standardized mandatory and optional keys, there may be additional, proprietary keys. They're usually prepended with :code:`X-` to differentiate between standard and custom keys.

The AppImage project defined a few custom keys with special meaning that provide information to enhance our desktop integration algorithm.

X-AppImage-Name
    Name of the application. Used to relate two AppImages of the same application but different versions.

    **Examples:** :code:`Krita`, :code:`Kdenlive`, :code:`Ultimaker Cura`
X-AppImage-Version
    Version of the application bundled in the AppImage.

    **Examples:** :code:`1.0.0-beta-2`, :code:`2019.1.1`
X-AppImage-Arch
    Architecture of the AppImage.

    **Examples:** :code:`x86_64`, :code:`i386`

:ref:`appimagetool` and :ref:`libappimage` currently make use mostly of :code:`X-AppImage-Version`.

.. seealso::

   The following discussions in issue trackers contain some background information:

     * `AppImageKit#59 <https://github.com/AppImage/AppImageKit/issues/59>`_
     * `AppImageKit#662 <https://github.com/AppImage/AppImageKit/issues/662>`_

