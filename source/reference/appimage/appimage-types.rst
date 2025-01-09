.. include:: ../../substitutions.rst

.. _appimage-types-history:

AppImage types and history
==========================

In this documentation, you might have already come across things like "In type 2 AppImages". This page explains why such different types and versions of AppImages exist and goes over their differences. It also shows how to determine the type of a specific AppImage.

.. contents:: Contents
   :local:
   :depth: 2


Why are there different AppImage types?
---------------------------------------

There are two main reasons for different AppImage types:

#. **Specification changes**

   When the AppImage concept and the reference implementation creating them got initially released, they were called type 1 AppImages. However, when they were in use, some downsides came apparent over time, resulting in a new improved specification which changed the way AppImages work and were formatted like. Of course, the reference implementation has been adapted to now create those new AppImages that work differently: They were called type 2 AppImages. Type 1 and type 2 AppImages have some fundamental differences.

   Additionally to that, the type 2 specification is continuously updated, e.g. to add more features. Therefore, newer AppImages that are built according to a newer version of the specification might have additional features.

#. **Implementation changes**

   The AppImage specification is relatively broad, which means there are some decisions the implementation (used to create AppImages) can decide, for example which parameters like ``--appimage-extract`` are available. In theory, different implementations can make different decisions, resulting in different AppImages having different features (like CLI flags).

   In practice, however, |appimage_implementations_practice|. Therefore, their implementation details influence almost all AppImages and also change its "type / version". (This is also why this documentation can assume AppImages to follow those implementations and have corresponding features (like CLI flags).)

..
   TODO: When / if go-appimagetool becomes or uses the reference implementation, change this to
   In practice, however, basically all modern AppImage creation tools use ``appimagetool``, the reference implementation. Therefore, its implementation details influence almost all AppImages…


Specification changes
---------------------

Type 1 AppImages vs type 2 AppImages
++++++++++++++++++++++++++++++++++++

Type 1 AppImages have been the original type of AppImages produced by the reference implementation. Nowadays, only old legacy AppImages are type 1. In September of 2016, the new improved specification of type 2 AppImages has been released, and the reference implementation has been adapted to create those new type 2 AppImages.

The following are the main specification differences between type 1 and type 2 AppImages:

- Type 1 AppImages use an ISO 9660 file system with Rock Ridge extensions (and should preferably use ``zisofs`` compression). This means that type 1 AppImages are ISO 9660 files. Meanwhile, type 2 AppImages don't have to use a specific file system (although the type 2 reference implementation uses only SquashFS).
- Type 1 AppImages contain the update information in the ISO 9660 Volume Descriptor field while type 2 AppImages contain it in the ELF section ``.upd_info``.
- Type 2 AppImages can also contain a digital signature in the ELF section ``.sha256_sig``.

However, many of the important changes |new_type_2_features|. For more information on those changes, see :ref:`new-type-2-features`.


Notable type 2 changes
++++++++++++++++++++++

The following are notable changes that have been made to the type 2 specification:

- The type 2 specification originally didn't define how type 2 AppImages can contain a digital signature.

For all specification changes, see the git history of the `specification repository <https://github.com/AppImage/AppImageSpec>`__.


Implementation changes
----------------------

.. _new-type-2-features:

New type 2 features
+++++++++++++++++++

Many of the important changes between type 1 and type 2 AppImages |new_type_2_features|. The following are some of those new features:

- The runtime of type 2 AppImages sets an additional :ref:`environment variable <environment-variables>` called ``ARGV0``.
- The runtime of type 2 AppImages uses SquashFS as file system.
- Type 2 AppImages support the ``--appimage-extract`` and ``--appimage-mount`` :ref:`command line options <inspect_appimage_content>`.
- Type 2 AppImages support the :ref:`portable mode <portable-mode>`.

.. todo::
   Make sure all of these features are actually available for all type 2 AppImages and not new features that have been added to the implementation at some point.


.. _new-generation-appimages:

New Generation AppImages
++++++++++++++++++++++++

While the specification doesn't explicitly mention how the AppImage runtime mounts the AppDir filesystem, the reference implementation has originally done this with FUSE 2 (linked dynamically).

However, due to most distributions dropping FUSE 2 from their default installed libraries after 2021, this has created a dependency that has to be installed manually in many cases in order to run AppImages - a direct contradiction to :ref:`our goals <no-external-dependencies>`.

Therefore, the (runtime) reference implementation has been rewritten in order to link to all dependencies statically and therefore contain the necessary FUSE 2 parts in every AppImage. These new AppImages can be run on any system, no matter whether FUSE 2 is installed on it or not.

This also has the additional benefit that the runtime has no dynamically linked dependencies (like ``glibc``) anymore, so that the new runtime can also work on non-glibc systems (like Alpine Linux, FreeBSD or NixOS) without having to manually install libraries.

While it's not an official name, these new AppImages with a statically linked runtime are also known as "New Generation" AppImages.


Adaption problems & history
###########################

When distributions started dropping FUSE 2 support in 2022, the AppImage team started to develop a new static runtime, whose first experimental version was available in May of 2022.
This version has been embedded in go-appimagetool, an experimental alternative to the reference implementation.
There were still discussions about potential other solutions in 2022 and early 2023 until it became clear in February of 2023 that this static version would become the future reference implementation.

After testing the runtime for a while, it was supposed to "be made official" (replace the old reference implementation) in April of 2023. But that didn't happen due to multiple issues:

- Some software that worked with AppImages (mainly the AppImageLauncher) were not compatible with this new runtime. This also resulted in bad error messages.
- There were aspirations to officially create a new specification type that's adapted to the new runtime and helps other tools to have full compatibility.

However, the efforts stalled in 2023. Because of the importance of this issue, many people switched to go-appimagetool as it already used the static runtime instead of the (old) reference implementation.

In `December 2024 <https://github.com/AppImage/AppImageKit/issues/877#issuecomment-2563872416>`__, the new runtime has been made the official runtime reference implementation; the other :ref:`AppImage creation tools <appimage-creation-tools>` are in the process of being adapted to use it.

For more detailed information on the exact history, see the related issues (`1 <https://github.com/AppImage/AppImageKit/issues/1120>`__, `2 <https://github.com/AppImage/AppImageKit/issues/877>`__, `3 <https://github.com/AppImage/AppImageSpec/issues/34>`__, `4 <https://github.com/AppImage/AppImageSpec/issues/38>`__).


Repository change
#################

This partial recode of the reference implementation has been taken as an opportunity to change the repository structure: While prior to it, there has only been one repository containing all parts of the reference implementation, called `AppImageKit <https://github.com/AppImage/AppImageKit>`__, with the change to the new statically linked runtime, it has been replaced with new repositories for the individual components of the reference implementation (see :ref:`reference-implementation`).


Other implementation changes
++++++++++++++++++++++++++++

As the reference implementation is being continously changed, there are also other features that only AppImages built with a newer reference implementation version might support. The following are some of the features that have been added to the type 2 reference implementation:

- Newer type 2 runtimes support the ``--appimage-extract-and-run`` :ref:`command line option <inspect_appimage_content>`.
- The ``APPIMAGE_EXTRACT_AND_RUN`` environment variable that does the same has been introduced even later.

.. todo::
   Update this page (without removing information) if / after the `new versioning scheme <https://github.com/AppImage/AppImageSpec/issues/39>`__ has been implemented and if / after the specification has been majorly changed `due to the static runtime <https://github.com/AppImage/AppImageSpec/issues/34>`__.


How to determine the type of an AppImage
----------------------------------------

This section shows how you can determine the type / version of a specific AppImage:


Type 1 or type 2
++++++++++++++++

As every reasonably recent AppImage should be type 2, you shouldn't need to determine whether your AppImage is type 1 or type 2. However, if you need it nevertheless, you can use the command ``xxd ./YourApplication.AppImage | head -n 1`` (with the path to your real AppImage) in the terminal (command line).

This returns a bunch of numbers and should look like ``00000000: 7f45 4c46 0201 0100 4149 0200 0000 0000  .ELF....AI......``.

- If you see ``4149 02`` in there, the AppImage is type 2.
- If you see ``4149 01`` in there, the AppImage is type 1.
- If you don't see either there, the AppImage is *most likely* type 1.


Dynamic runtime (old) or static runtime (new generation)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. todo::
   Add this section and explain how to determine whether the AppImage uses the dynamically linked or statically linked runtime.
