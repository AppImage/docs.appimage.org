.. include:: ../../substitutions.rst

AppImage
========

This section contains the AppImage specification, reference implementation and history.

The AppImage specification defines the format of an AppImage file: What AppImages consist of and the way the application data is bundled together with a runtime executing the actual application.
|specification_advantage|

The reference implementation is the actual first party implementation of both a conforming runtime and a tool that creates AppImages (with given application data) conforming to the specification.

While in theory, many different tools could independently create AppImages conforming to the specification, in practice, |appimage_implementations_practice|, making their implementation details very important.

..
   TODO: When / if go-appimagetool becomes or uses the reference implementation, change this to
   basically all modern AppImage creation tools use the reference implementation under the hood, making its implementation details very important

Historical changes in both the specification and reference implementation are also covered here.

.. toctree::
   Specification <appimage-specification>
   Reference implementation <reference-implementation>
   Types and history <appimage-types>
   :maxdepth: 2
   :caption: Contents:
