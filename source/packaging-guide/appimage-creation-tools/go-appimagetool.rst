.. include:: ../../substitutions.rst

.. _go-appimagetool:

go-appimagetool
===============

`go-appimagetool <https://github.com/probonopd/go-appimage>`__ (the appimagetool part of the go-appimage project) is a tool that can be used by application authors to package their projects as AppImages.

It requires a manual creation of the AppDir folder structure and file placement (if make isn't used). For more information on how to use make accordingly, or manually create the necessary structure, see :ref:`creating-appdir-structure`.

.. note::
   go-appimagetool is not using the :ref:`reference implementation <reference-implementation>` (called appimagetool) to create AppImages; instead, it creates them itself. This means that it might choose different :ref:`implementation decisions <appimagetool>` (e.g. CLI options like ``--appimage-extract`` the resulting AppImage supports), resulting in AppImages that behave differently to the usual ones (created with the reference implementation).

   |alternative_implementation_decisions|

   See :ref:`this <reference-implementation>` for more information on the implementations and their decisions.

It allows for both including core system libraries like glibc and not including them. If the core system libraries aren't included, |build_on_old_version|.

However, it is less mature than linuxdeploy and doesn't support some advanced options (like not deploying specific libraries or copyright files).


Downloading go-appimagetool
---------------------------

Start by downloading go-appimagetool. The recommended way to get it is to use the latest continuous AppImage build provided on its `GitHub release page <https://github.com/probonopd/go-appimage/releases>`__. After downloading the AppImage, you have to make it executable as usual:

.. code-block:: shell

   > chmod +x appimagetool-*-x86_64.AppImage

After that, you can use go-appimagetool.


Usage
-----

To use go-appimagetool, you need to already have an AppDir with the main executable and the desktop, icon, etc. files. go-appimagetool will only deploy the dependency of the executables and libraries into this AppDir and create an AppImage out of it.

To bundle the dependencies with go-appimagetool, use the ``deploy`` command with the desktop file as parameter like this:

.. code-block:: shell

   > ./appimagetool-*.AppImage deploy appdir/usr/share/applications/*.desktop

You can use the ``-s`` command line argument to bundle everything, including core system libraries like glibc. Otherwise, core system libraries are not included.

To then turn your complete AppDir into an AppImage, call go-appimagetool with the AppDir as parameter like this:

.. code-block:: shell

   > ./appimagetool-*.AppImage Some.AppDir

.. todo::
   Include documentation on appimagetool environment variables like VERSION

For more information, see `the project's README file <https://github.com/probonopd/go-appimage/blob/master/src/appimagetool/README.md>`__


.. _go-appimagetool-update-information:

Embedding update information
----------------------------

You can find the basic explanation on how the AppImage update system works, what update information is and how AppImages can be updated at :ref:`appimage-updates`.

Sadly, as of December 2024, go-appimagetool doesn't yet support embedding updating information from a custom updating information string. Instead, it always embeds updating information dependent on the CI pipeline. See `this issue <https://github.com/probonopd/go-appimage/issues/318>`__ for more information.


.. _go-appimagetool-signing:

Signing the AppImage
--------------------

You can find the basic explanation on how the AppImage signatures works and how they can be validated at :ref:`signing-appimages`. If you already know that, this section explains on how to use go-appimagetool to sign the AppImage.

When creating an AppImage from an AppDir, go-appimagetool always tries to sign the resulting AppImage. However, in order to be able to do that, go-appimagetool (`as of December 2024 <https://github.com/probonopd/go-appimage/issues/318>`__) requires the public key to be stored in the root directory of the git repository as ``pubkey.asc``, the encrypted private key to be stored in the current working directory as ``privkey.asc.enc`` and the environment variables ``$super_secret_password`` to be set to the passphrase to encrypt the private key. This could look like the following:

.. code-block:: shell

   # Export the public key to the current working directory
   # This assumes we are in the root directory of the git repository
   > gpg --export --armor <Key ID> > pubkey.asc

   # Export the encrypted private key to the current working directory
   > gpg --export-secret-keys --armor <Key ID> > privkey.asc.enc

   # Set the environment variable to the key passphrase
   > export super_secret_password="..."

   # Call go-appimagetool
   > ./appimagetool-*.AppImage Some.AppDir
