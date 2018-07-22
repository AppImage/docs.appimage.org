# Making AppImages updateable

AppImages can be updated 
* Via external tools (e.g., `AppImageUpdate` or the `appimageupdatetool` command line tool)
* Via an updater tool built into the AppImage itself
* By consuming `libappimageupdate` functionality inside the payload application

## Making AppImages updateable via external tools

To make an AppImage updatable, you need to embed information that describes where to check for updates and how into the AppImage. Unlike other Linux distribution methods, the information where to look for updates is not contained in separate repository description files such as `sources.list` that need to be managed by the user, but is directly embedded inside the AppImage by the author of the respective AppImage. This has the advantage that the update information always travels alongside the application, so that the end user does not have to do anything special in order to be able to check for updates.

### Using appimagetool

Use `appimagetool -u` to embed update information (as specified in the AppImageSpec).

```
appimagetool videocapture.AppDir/usr/share/applications/*.desktop -u "zsync|https://lyrion.ch/opensource/repositories/videocapture/uv/videocapture.AppImage.zsync"
```

The string `zsync|https://lyrion.ch/opensource/repositories/videocapture/uv/videocapture.AppImage.zsync` is called the _update information_.

Please see https://github.com/AppImage/AppImageSpec/blob/master/draft.md#update-information for a description of allowable types of update information.

### Using linuxdeployqt

`linuxdeployqt` uses `appimagetool` internally. If it recognizes that it is running on Travis CI, then it automatically generates the matching update information.

## Making AppImages self-updateable

Once you have made your AppImage updateable via external tools as described above, you may optionally go one step further and bundle everything that is required to update an AppImage inside the AppImage itself, so that the user can get updates without needing anything besides the AppImage itself. This is conceptually similar to how the [Sparkle Framework](https://sparkle-project.org/) works on macOS.

### Via AppImageUpdate built into the AppImage

You can bundle `AppImageUpdate` itself inside the AppImage of your application. In order to have the bundled AppImageUpdate update your running AppImage when the user invokes some command in your applcation (e.g., an "Update..." menu) in your GUI, simply have your application invoke `AppImageUpdate $APPIMAGE`. If `AppImageUpdate` is bundled inside the AppImage and is on the `$PATH`, this will work.

### By using `libappimageupdate`

#### Building and linking libappimageupdate

*This guide assumes you are using Git and CMake to build your project.*

There's two options how to add libappimageupdate to your project: Either you use a Git submodule (the preferred way), or you use CMake's `ExternalProject`. The latter is a more complex issue and has some implications, therefore this guide focuses on the former option.

The guide assumes the following directory layout:

```
/                       # repository root
    lib/                # external libraries
        ...             # other libraries that might be used
        CMakeLists.txt  # manages the dependencies for CMake
    src/                # source files
        CMakeLists.txt  # defines the binaries to build
        main.cpp        # main application
    CMakeLists.txt      # top level CMake configuration
```

First of all, add the AppImageUpdate repository as a submodule.

```
git submodule add https://github.com/AppImage/AppImageUpdate lib/AppImageUpdate
```

You will have to initialize your submodule. AppImageUpdate pulls in some dependencies as well. Therefore, anyone using your repository will have to run the following command after cloning (unless they called `git clone --recursive`):

```
git submodule update --init --recursive
```

Please refer to the [Git book](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for more information about submodules and how they work, how to update them etc.

Next, instruct CMake that you want to use the library. Add `add_subdirectory(AppImageUpdate)` to `lib/CMakeLists.txt`.

*Note: You need to call `add_subdirectory(lib)` within the top-level `CMakeLists.txt` near the top before defining executables etc. to make this work. Furthermore, somewhere below, CMakeLists.txt needs to include the `src` directory. Like with the `lib` directory, there should be a `add_subdirectory(src)` call.*

Now instruct CMake to link your libraries and/or executables to libappimageupdate. AppImageUpdate's CMake build infrastructure defines a target `libappimageupdate`.

Open `src/CMakeLists.txt`, find your `add_library/add_executable` call, and add the following snippet below:

```
target_link_libraries(mytarget PRIVATE libappimageupdate)
```

Now everything should be up and running! Congratulations!


#### Using libappimageupdate within app store like applications

Consider the following scenario:

You have an app store app managing AppImages. As you know, AppImages don't require an installation. The only thing you have to do is download them and make them executable, and your users can run them. To remove them from the system, all that has to be done is removing a single file from the file system.

So far, so good. But what about updates? Ideally, the upstream projects are actively developed, and publish releases regularly. However, with technologies like Electron becoming more and more popular, AppImage file sizes of several 10s of MiB are pretty common. Games even have a few 100 MiB, bundling all the data.

To mitigate those problems, AppImageUpdate provides an efficient solution to these problems. It compares the local AppImage with the remote, up to date file, uses all usable data from the existing file, and downloads the remaining data only. This does not only save a lot of bandwidth, but also speeds up the update processes.

libappimageupdate provides a class called `appimage::update::Updater` capable of updating a single AppImage. It contains features like an update check, running updates in a separate thread, a status message system, progress indicator support and a lot more.

Basic usage:

```
using namespace appimage::update;
using namespace std;

Updater updater("test.AppImage");
```

Now, you can use the `updater` object to perform operations. The API is built on the principle of *pervasive error handling*, i.e., all operations that might fail in any way provide error handling. In libappimageupdate, this is implemented by making such methods become boolean, and accept a reference to the result type which is set in case of success. The method returns either `true`, which means the operation succeeded, or `false` otherwise.

See this easy example for an update check:

```cpp
// check for update
bool updateAvailable;

if (!updater.checkForChanges(updateAvailable)) {
    // return error state
    return 1;
}

if (updateAvailable) {
    // perform update ...
```

This is faster and less verbose than an exception based workflow, however, you can't see what caused the update check to fail.

This can be found out using the built in status message system. Every `Updater` instance contains a message queue. All methods within the updater and the systems it uses (like e.g., [ZSync2](https://travis-ci.org/TheAssassin/zsync2/), which is one of the backends for the binary delta updates) add messages to this queue, which means that all kinds of status messages ever generated by any of the libraries will end up there.

*Beware that this is a totally optional system, and it might not necessarily improve the user experience to show those messages. It is recommended to show them only in case of errors to help debugging. There is also no guarantee on the order of these messages.*

All messages are preserved, so if they are not fetched, they might stack up. However, that shouldn't be a problem really. Just make sure to clean up (`delete`) your `Updater` objects as soon as you don't need them any more.

Let's rewrite the update check code from above, with advanced error handling:

```cpp
// check for update
bool updateAvailable;

if (!updater.checkForChanges(updateAvailable)) {
    // log status messages before exiting

    // nextStatusMessage will return true as long as there are status messages
    // by calling it in a loop as follows, all available messages will be fetched
    string nextMessage;
    while (updater.nextStatusMessage(nextMessage)) {
        // imagine log() to do something meaningful
        log(nextMessage);
    }

    // return error state
    return 1;
}

if (updateAvailable) {
    // perform update ...
```

Now, in case the update check fails, the messages are logged.

At the moment, the update check is performed synchronously as it won't take too long. This might be changed eventually, but now allows for running an update check without modifying the updater state.

Talking about updater states, the state is modified by running an update. As mentioned previously, updates are performed in their own thread automatically, using C++11 threading functionality. This allows for displaying progress, status messages etc. in a UI without any blocking issues or the need to run your own thread.

**Important: Before actually performing an upgrade, it is recommended to check for updates first. The update check only performs reading IO, but a pointless update will create an entirely new file, even if it copies all the data from its predecessor.**

Here's some code how to run an update, and log progress and status messages until the update has finished:

```cpp
updater.start()

// isDone() returns true as soon as the update has finished
// error handling is performed later
while (!updater.isDone()) {
    // sleep for e.g., 100ms, to prevent 100% CPU usage
    this_thread::sleep_for(chrono::milliseconds(100));
    
    double progress;
    // as with all methods, check for error
    if (!updater.progress(progress)) {
        log("Call to progress() failed");
        // return error state
        return 1;
    }
    
    // progress() returns a double between 0 and 1
    // you might have to scale its return value accordingly
    // this assumes that the progress bar expects a percentage
    updateProgressBar(progress * 100);
    
    // fetch all status messages
    // this is basically the same as before
    string nextMessage;
    while (updater.nextStatusMessage(nextMessage)) {
        log(nextMessage);
    }
}
```

As you will have noticed, this code will just run until the update is done. However, there is no way to verify that the update actually worked. Therefore, you need to check for errors in the next step:

```
if (updater.hasError()) {
    log("Error occurred. See previous messages for details.");
    // return error state
    return 1;
}
```

As the background work has finished, and `hasError()` itself doesn't log any messages, all messages from the status message queue are displayed already, hence the note about checking the previous messages. It was mentioned previously that logging all messages might not be good for the user experience, so you could as well move the little loop fetching the messages to this error handler, and show a modal dialog containing all the messages issued during the update process. But this is up to you.

One last thing to notice is that AppImageUpdate by default takes the filename of the remote file for creating the updated AppImage file instead of overwriting the local file. This is done on purpose for several reasons. First, it might not be intended to overwrite previous versions of an AppImage, allowing to have different versions in parallel, or testing the current version versus the update that has just been downloaded.

This behavior implies the need for a method to actually fetch the path to this new file from the updater. This can be done as follows:

```
ostringstream oss;

string pathToUpdatedFile;

// this method shouldn't fail at this point(1) any more
// but it's better to check for its return value to make sure everything's alright
// (1) when calling this before or while the update is running, the new path is not
// available, causing this method to return false, but we're past those points already
if (!updater.pathToNewFile(pathToUpdatedFile))

oss << "Path to updated AppImage: " << pathToUpdatedFile;
log(oss.str());
```

*Note: The updater takes care of putting the new file in the same directory as the previous one.*

As you might not be interested in this feature, and probably don't trust on remote filenames and choose your own ones when "installing" (well, downloading) AppImages to make it easier to find them again, you can override this feature. You can instantiate the `Updater` object with an optional flag:

```cpp
// constructor signature as of 2017/11/14:
// Updater::Updater(std::string path, bool overwrite = false);

Updater updater("my.AppImage", true);
```

Now, the updater will perform the update and move the new file to the original file's location after successfully verifying the file integrity (and, as soon as it is implemented, validating the file's signature, see [the related issue on GitHub](https://github.com/AppImage/AppImageUpdate/issues/16)).

**Important note: The updater will never overwrite a file before all validation mechanisms report success.**

ZSync2 based methods will furthermore always keep the old file as a backup. If the `overwrite` flag is `true`, the current file will be moved to `my.AppImage.zs-old`. If it is `false`, the old file will remain untouched. Furthermore, if there is a file with the new filename, that file will be backed up with the `.zs-old` suffix. This behavior is not ideal, the standalone UI has error handling code specific to this problem. This behavior is going to be subject of a GitHub issue soon. It is recommended to watch the discussion before implementing any code dealing with backups. Thad said, it is probably safe to check whether a `.zs-old` file is created when using `overwrite = true`, and delete it.
