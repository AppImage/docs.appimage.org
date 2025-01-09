Using make to create the AppDir structure
=========================================

.. note::
   This is only necessary if you use an :ref:`AppImage creation tool <appimage-creation-tools>` that requires prior creation of the AppDir folder structure and file placement.

   If you use a tool that doesn't require this, you don't have to do this.

Alternatively to :ref:`manually creating the AppDir structure <manually-creating-appdir-structure>`, you can use make `make <https://en.wikipedia.org/wiki/Make_(software)>`_ to create the AppDir structure. However, this only works if you use Makefiles to build your project (which is mostly done for C/C++-based projects).

If you use a modern make-based meta build system such as CMake_ or qmake_, you can use the provided `make install` command to create the AppDir structuer. To do this, you have to set up an install configuration in your build system. The configuration should install all binaries, libraries, resources, etc. as well as the desktop and icon files (TODO LINK).

.. todo::
   This page is missing the most important part: How to set up the install configuration. This should be added.


CMake
-----

CMake provides an additional parameter to configure where the files are installed when running ``make install`` called |destdir|. If |destdir| is specified, CMake will "install" the files into the given directory instead of the filesystem root (``/``).

.. note::
   By default, CMake sets an internal variable called |cmake-install-prefix| to a path other than ``/usr`` to prevent users calling e.g., ``sudo make install`` from damaging their system. The variable must explicitly be set to ``/usr`` therefore.

.. |destdir| replace:: ``DESTDIR``
.. |cmake-install-prefix| replace:: ``CMAKE_INSTALL_PREFIX``

Here's an example how to use this method:

.. code-block:: shell

   # Download project (you can use that project to test this method)
   > git clone https://github.com/linuxdeploy/QtQuickApp.git
   > cd QtQuickApp

   # Configure build system and build application on all CPU cores
   # The used flag is the bare mimimum that's needed
   # Depending on the app, other variables might have to be set as well
   > mkdir build
   > cd build
   > cmake .. -DCMAKE_INSTALL_PREFIX=/usr
   > make -j$(nproc)

   # Create the AppDir structure
   > make install DESTDIR=AppDir

|make_result|.


qmake
-----

Qt's qmake_ also provides a variable to change the "target" of ``make install`` calls called ``INSTALL_ROOT``. The qmake-based method is very similar to the CMake one. There's just one major difference: qmake does install into ``/usr`` by default already.

Preparing a basic application is very simple, as the following example illustrates:

.. code-block:: shell

   # Download project (you can use that project to test this method)
   > git clone https://github.com/linuxdeploy/QtQuickApp.git
   > cd QtQuickApp

   # Configure build system and build application on all CPU cores
   # Depending on the app, some variables might have to be set
   > mkdir build
   > cd build
   > qmake ..
   > make -j$(nproc)

   # Create the AppDir structure
   > make install INSTALL_ROOT=AppDir

|make_result|, just like after executing the CMake commands.

.. |make_result| replace:: This creates a new directory called ``AppDir`` in the build directory, which should contain all binaries, shared libraries, etc.
