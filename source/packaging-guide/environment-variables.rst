.. ref: env_vars

Environment variables
=====================

The AppImage runtimes make some environment variables available that can be used by applications bundled as AppImages
during runtime, e.g., to recognize whether it's currently run from an AppImage, or to get some path information.

Depending on the type of the AppImage, the runtimes offer different feature sets.


Type 1 AppImage runtime
-----------------------

Type 1 is the deprecated/outdated AppImage type that is only in legacy support mode.

.. todo::
   Check whether there are any environment variables and document them here



Type 2 AppImage runtime
-----------------------

The type 2 AppImage runtime makes a few environment variables available for use in e.g., ``AppRun`` scripts:

+------------------+--------------------------------------------------------------------------------------------------+
| Variable name    | Contents                                                                                         |
|                  |                                                                                                  |
+==================+==================================================================================================+
| :code:`APPIMAGE` | (Absolute) path to AppImage file (with symlinks resolved)                                        |
|                  |                                                                                                  |
+------------------+--------------------------------------------------------------------------------------------------+
| :code:`APPDIR`   | Path of mountpoint of the SquashFS image contained in the AppImage                               |
|                  |                                                                                                  |
+------------------+--------------------------------------------------------------------------------------------------+
| :code:`ARGV0`    | Name/path used to execute the script. This corresponds to the value you'd normally receive via   |
|                  | the :code:`argv` argument passed to your :code:`main` method.                                    |
|                  | Usually contains the filename or path to the AppImage, relative to the current working           |
|                  | directory.                                                                                       |
|                  |                                                                                                  |
+------------------+--------------------------------------------------------------------------------------------------+
