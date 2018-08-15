Introduction to Packaging AppImages
===================================

So you decided to make an AppImage or two? Great! Or did you just come here to get some insights into how AppImages can be built? Let's have a look.

There are many different approaches how to build AppImages. Often, packaging an AppImage correctly depends on the application that you're trying to put into one, the so-called *payload*. Different programming languages (or, rather, different application types (i.e., native binaries, scripts, bytecode, etc.)) require different methods.

All application bundling attempts have one thing in common: the "input format" which is then turned into an AppImage using :ref:`appimagetool <ref-appimagetool>`. This input format is called AppDir, and is described in the :ref:`AppDir specification <ref-appdir-specification>`.

In a nutshell: packaging AppImages is building an AppDir. This AppDir is then simply turned into an AppImage. But if your AppDir is not built correctly, the AppImage won't work.

Of course, you're not left alone with this challenge. There are official as well as unofficial tools that allow you to create working AppDirs. These are described in the following sections. Just pick the one you think suits your needs, and start making AppImages.

