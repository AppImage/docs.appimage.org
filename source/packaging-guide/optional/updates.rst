.. _ref-updates:

Making AppImages updateable
===========================

AppImages can embed information that allows for them to be updated (essentially storing where an update can be fetched from). This information can be used by external tools (e.g. ``AppImageUpdate`` or ``AppImageLauncher``) to update the AppImage, but also by an updater tool build into the AppImage itself (we call this a *self-updateable AppImage*).

This not only makes it easier for users to update their AppImages, but also speeds up the process and saves bandwidth as not the full AppImage is downloaded, but only the update changes.

This page shows how to create an updateable and self-updateable AppImage and what you should consider when making a self-updateable AppImage.

.. contents:: Contents
   :local:
   :depth: 2


Embedded update information
---------------------------

In order for AppImages to be updateable, they need to embed something called update information. That information describes how and where to look for updates. Because this information is embedded in the AppImage itself and not contained in separate description files (like with other Linux distribution methods), the update information always travels alongside the application, so that the end user does not have to do anything special in order to be able to check for updates.

There are two non-deprecated update information types: ``zsync`` (if you use an external server to store the update data) and ``gh-releases-zsync`` (if you upload the update data to Github releases). In both cases, you will store a ``.zsync`` file that contains the update data on a server. In the next section, you'll see how to generate such a file.

| If you want to use an external server, the update information string looks like ``zsync|<update file link>``, e.g. ``zsync|https://server.domain/path/Application-latest_x86-64.AppImage.zsync``.
| If you want to use Github releases, the update information string looks like ``gh-releases-zsync|<Github username>|<Repository name>|latest|<filename>``, e.g. ``gh-releases-zsync|MyAccount|MyProject|latest|MyProject-*_x86-64.AppImage.zsync`` (``*`` can be embedded as a wildcard).

For more detailed information on update information strings and their formal specification, see https://github.com/AppImage/AppImageSpec/blob/master/draft.md#update-information.


Step 1: Making AppImages updateable
-----------------------------------

To make an AppImage updateable, you need to embed this update information into it. You can do this with one command that adds the update information to your AppImage and simultaneously creates the ``.zsync`` file you have to store online.

If you use an :ref:`AppImage creation tool <appimage-creation-tools>`, you should use its built-in feature to add the update information and create the ``.zsync`` file. However, if your AppImage creation tool doesn't support adding update information, or if you create your AppImage manually, you can also use ``appimagetool`` directly to manually add the update information and create the ``.zsync`` file. After doing that, you should upload the ``.zsync`` file to the place mentioned in the update information string.

Using an AppImage Creation tool
+++++++++++++++++++++++++++++++

Most AppImage creation tools come with a built-in feature to add update information to the AppImage and create the ``.zsync`` file.

| To see how to add update information with :ref:`ref-linuxdeploy`, see :ref:`this <linuxdeploy-update-information>` section of the linuxdeploy guide.
| To see how to add update information with :ref:`sec-electron-builder`, see :ref:`this <electron-builder-update-information>` section of the electron-builder guide.

.. todo::
   Research whether a corresponding feature exists for all other AppImage creation tool and add an updating section to each guide.

.. _using-appimagetool-directly:

Using ``appimagetool`` directly
+++++++++++++++++++++++++++++++

If you use an AppImage creation tool that doesn't support adding update information, you have to extract the created AppImage by calling it with the ``--appimage-extract`` option (for more information, see :ref:`inspect_appimage_content`) and then recreate the AppImage with the update information and create the ``.zsync`` file with ``appimagetool``.

To (re)create an AppImage from the AppDir, embed update information in it and create the ``.zsync`` file, use the ``-u`` flag with the update information string. That command could for example look like this: ``appimagetool MyApplication.AppDir/usr/share/applications/MyApplication.desktop -u "zsync|https://server.domain/path/MyApplication-latest_x86-64.AppImage.zsync"``.


Step 2: Making AppImages self-updateable
----------------------------------------

To make the AppImage self-updateable, it needs to be updateable in the first place. Only if the AppImage already embeds the update information, you can additionally bundle everything that is required to update an AppImage in the AppImage itself, so that the user can get updates without needing anything besides the AppImage. (This is conceptually similar to how the `Sparkle Framework <https://sparkle-project.org/>`_ works on macOS.)

By default, `AppImageUpdate <https://github.com/AppImageCommunity/AppImageUpdate>`_ (which is used to achieve self-updateability) creates the updated AppImage file in the same directory as the current AppImage with the filename of the remote file, and doesn't overwrite the current AppImage file. This is done on purpose, as it might not be intended to overwrite previous versions of an AppImage to allow having different versions in parallel or testing the current version against the update that has just been downloaded. However, this behaviour can be overwritten.

Via ``appimageupdatetool`` bundled in the AppImage
++++++++++++++++++++++++++++++++++++++++++++++++++

You can bundle `appimageupdatetool <https://github.com/AppImageCommunity/AppImageUpdate/releases>`_ inside the AppImage of your application to achieve self-updateability. In that case, you have to invoke the bundled ``appimageupdatetool`` to update your running AppImage after corresponding user interaction (e.g. clicking an update button).

To call another bundled executable, you need to know its path. Luckily, when running an AppImage, the :ref:`environment variable <ref-env_vars>` ``$APPDIR`` is set to the location of the mounted AppDir. As bundled executables are usually in ``./usr/lib``, its path should be something like ``$APPDIR/usr/lib/appimageupdatetool.AppImage``

To update your AppImage with ``appimageupdatetool``, you need to give the path of your AppImage as parameter. This path is set as ``$APPIMAGE`` by the runtime. Therefore the whole call should look like ``$APPDIR/usr/lib/appimageupdatetool.AppImage $APPIMAGE``. The way how you can execute such a shell command depends on the programming language. For example, in Rust you can do this with ``Command::new("sh").arg("-c").arg("$APPDIR/usr/bin/appimageupdatetool.AppImage $APPIMAGE").output()``.

.. note::
   As of December 2024, appimageupdatetool requires FUSE 2 to run. If you aren't sure that your users have FUSE 2, you might want to check that before executing it. If a user doesn't have FUSE 2, you can still run appimageupdatetool with ``$APPDIR/usr/bin/appimageupdatetool.AppImage --appimage-extract-and-run $APPIMAGE``.

.. warning::
   As of December 2024, :ref:`ref-linuxdeploy` has a `bug <https://github.com/linuxdeploy/linuxdeploy/issues/301>`_ that causes it to corrupt AppImages when they're given as additional executables that should be bundled.
   Therefore, when using it, other bundled AppImages have to manually be copied into the AppDir and ``appimagetool`` has to be used to create the AppImage.

Via ``libappimageupdate``
+++++++++++++++++++++++++

If bundling ``appimageupdatetool`` requires too much space, you can alternatively also bundle the library internally used, ``libappimageupdate``. This will result in a smaller size, but it's more manual work to do so.

There is currently no precompiled version of this library. Therefore you have to manually compile `AppImageUpdate <https://github.com/AppImageCommunity/AppImageUpdate>`_ with the following commands (this requires you to install a lot of dependencies, see its `build tutorial <https://github.com/AppImageCommunity/AppImageUpdate/blob/main/BUILDING.md>`_):

.. code-block:: shell

   git clone --recursive https://github.com/AppImage/AppImageUpdate
   cd AppImageUpdate
   mkdir build
   cd build
   cmake -DBUILD_QT_UI=OFF -DCMAKE_INSTALL_PREFIX=/usr ..
   make -j $(nproc)
   sudo make install

After you built it, the libraries will be in ``AppImageUpdate/build/src/updater``. These libraries are C++11 - libraries; sadly there is currently no C interface yet, which makes it more difficult to use in other programming languages. To use the library in a different programming language, you can use a C++ FFI if available in your programming language or create a C wrapper, e.g. with `SWIG <https://swig.org>`_ (and then use the C FFI in your programming language).

libappimageupdate provides the class :code:`appimage::update::Updater` which is used to update the AppImage. Using it, you can check for updates (this is currently performed synchronously as it doesn't take long) and run updates in a separate thread. This means that you have to check for the state periodically, but allows for progress indication and status messages without any blocking.

You have to create an ``Updater`` object and then use it to perform operations. All operations that might fail return a boolean that indicates whether it finished successfully (``true``) or an error occurred (``false``). The real result of the operation is given as a parameter which is set in case of success. To see what caused an operation to fail, you can (optionally) read the status message queue (onto which the updater and its systems write messages); this is implemented in ``logStatusMessages`` in the example code.

The following example code (in C++) shows how to use the ``Updater`` class to check for an update, update if available, show the progress until the update is finished and check for an error after it has finished:

.. code-block:: cpp

   using namespace appimage::update;
   using namespace std;

   // Create an Updater object
   Updater updater("MyApplication.AppImage");

   bool updateAvailable;
   if (!updater.checkForChanges(updateAvailable)) {
      log("An error happened while searching for updates.");
      logStatusMessages();
      return 1;
   }

   if (updateAvailable) {
      updater.start();

      while (!updater.isDone()) {
         // Sleep to prevent busy waiting
         this_thread::sleep_for(chrono::milliseconds(100));

         double progress;
         if (!updater.progress(progress)) {
            log("An error happened while updating.");
            logStatusMessages();
            return 1;
         }

         // Use the progress value (between 0 and 1), e.g. in a loading animation
      }
   }

   if (updater.hasError()) {
      log("The update could not be loaded correctly.");
      logStatusMessages();
      return 1;
   }

   delete updater;


   void logStatusMessages(Updater updater) {
      string nextErrorMessage;
      while (updater.nextStatusMessage(nextErrorMessage)) {
         log(nextErrorMessage);
      }
   }


As previously stated, this will create a new updated AppImage file with the remote file name and not overwrite the local file. To get the path of the new AppImage file, you simply use the following code snippet after the update has finished without any errors:

.. code-block:: cpp

   string updatedFilePath;
   if !(updater.pathToNewFile(updatedFilePath)) {
      log("The updated AppImage could not be located.");
      logStatusMessages();
      return 1;
   }

However, if you want to directly replace the local AppImage, this default behaviour can be overwritten by creating the updater with ``Updater updater("MyApplication.AppImage", true);`` instead of ``Updater updater("MyApplication.AppImage");``. This leads to the updater moving the new file to the original file location after successfully downloading and verifying the update. But due to how ZSync2 works, the old file is not deleted; instead, it's moved to ``<name>.zs-old`` and kept as a backup (see `this issue <https://github.com/AppImageCommunity/AppImageUpdate/issues/14>`_). If you don't want the old file hanging around after the update, you can remove ``<name>.zs-old`` after the update finished successfully.

Using an update GUI library
+++++++++++++++++++++++++++

If you don't want to create your own GUI for updating (meaning an update button and optionally features like a progress bar), you can also use specific update GUI libraries that provide a pre-designed GUI managing all that.

Currently, there only exists a GUI library for QT-based applications. We are interested in getting libraries for other popular GUI toolkits like Gtk/Libadwaita, so please contribute if you implement something like this.

libappimageupdate-qt
####################

Like with ``libappimageupdate``, there is currently no precompiled version of this library. Therefore you have to manually compile `AppImageUpdate <https://github.com/AppImageCommunity/AppImageUpdate>`_ (this requires you to install a lot of dependencies).

.. todo::
   Add instructions on how to build ``libappimageupdate`` and how it can be used and integrated in an application.

Recommended user experience
+++++++++++++++++++++++++++

One advantage of the AppImage format is that it gives full control to application authors over the end user experience. In order to maintain a consistent and positive user experience with AppImages and AppImageUpdate, we recommend application authors to follow the following **Golden Rules**:

* Never download updates without the user's explicit consent, either in the form of per-update consent or opt-in consent for automatic updates. Thanks for not killing users' mobile data plans by downloading stuff without asking.
* Don't bother the user with updates directly when the app is opened for the first time. Users should initially see something meaningful to give a positive impression and recognize immediately what the application is all about.
* Ask the user for permission before doing version checks. Some open source users consider forced version checks as a form of tracking which violates their privacy.
* The update UI should ideally be nicely integrated into the GUI of your application, using whatever GUI toolkit you are using.
* During the update process, your application should remain fully usable.
* Releases should always update to releases, nightlies always to nightlies, etc.
* Whenever the application encounters issues (e.g., a crash reporter comes up), it could ask the user to check for updates.

..
   * Respect global flags for "do not check for new versions" and "do not attempt to update". The user may be running a central updating daemon that manages updates for the whole system, in which case any and all attempts to update the application from within itself should be skipped.
   We need to define those flags for 1) per-system configuration, 2) per-user configuration and 3) ENV (similar to how the old :code:`desktopintegration` script was set up not to interfere with :code:`appimaged`).
   TODO: Such a flag currently doesn't exist and isn't documented
