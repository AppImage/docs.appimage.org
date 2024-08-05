Introduction to Packaging
=========================

So you decided to make an AppImage or two? Great! Or did you just come here to get some insights into how AppImages can be built? Let's have a look.

There are several tools that you can use to build AppImages. But don't worry, this guide goes through all of them and explains their advantages, disadvantages and differences.

All application bundling attempts have one thing in common: They initially create a specific nested directory structure called *AppDir* (which is described in the :ref:`AppDir specification <ref-appdir-specification>`) and then turn this AppDir into an AppImage. You can imagine the AppImage as a container (like a zip file) for the AppDir. If the AppDir is not build correctly, the AppImage won't work.

The following sections explain how to create an AppDir and the corresponding AppImage with the different tools, the necessary preparations for it, e.g. creating desktop entry and icon files, as well as optional features, such as adding more metadata and signing your AppImage.
