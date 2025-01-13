.. include:: ../substitutions.rst

.. _inspect-appimage-content:

Inspect AppImage content
===========================

To inspect the content of any AppImage, it is possible to extract their content to a directory or to temporarily mount them	on the system for read-only access. The resulting directory is a valid :ref:`AppDir <appdir-specification>`, and users can create AppImages from it again using an :ref:`AppImage creation tool <appimage-creation-tools>`. This page describes the different ways to inspect the content of an AppImage, their advantages and disadvantages.

.. contents:: Contents
   :local:
   :depth: 1


Calling the AppImage with special parameters
--------------------------------------------

The most convenient way to inspect the content of an AppImage is to call it with the ``--appimage-extract`` or ``--appimage-mount`` option. (This only works for type 2 AppImages, |recent_type_2|. If you have to inspect a type 1 AppImage, see the other options described on this page. |different_types|)

.. warning::
   You should only do this if you trust the AppImage (as the runtime could be altered to execute different code, even if you use these parameters). If you want to inspect the AppImage as you don't trust it, you should follow the instructions in the section :ref:`inspect-using-external-tools`.


\-\-appimage-extract
++++++++++++++++++++

To extract the content of a type 2 AppImage without an external tool, call the AppImage with the parameter ``--appimage-extract``. This will cause the :ref:`runtime` to create a new directory called ``squashfs-root`` in the current working directory, containing the content of the AppImage's :ref:`AppDir <appdir-specification>`.


\-\-appimage-mount
++++++++++++++++++

To mount the content of a type 2 AppImage without an external tool, call the AppImage with the parameter ``--appimage-mount``. This will cause the :ref:`runtime` to mount the AppImage content with read-only access and return the directory it is mounted on, which can then be inspected with a file manager or another terminal window.

The AppImage is unmounted when the application called in the example is interrupted (e.g. by pressing :kbd:`Ctrl+C` or closing the terminal window).

.. _inspect-using-external-tools:


Using external tools
--------------------

This is the safest way to inspect the content of an AppImage. You should use this way if you don't trust the AppImage and don't want to call it.

|depends_on_appimage_type|


Type 2 AppImages
++++++++++++++++

You can safely inspect the content of a type 2 AppImage with these commands (replace ``path/to/AppImage`` with the path of your AppImage):

.. code-block:: shell

   > wget -c "https://github.com/AppImage/type2-runtime/releases/download/continuous/runtime-x86_64"
   > chmod +x runtime-x86_64
   > TARGET_APPIMAGE=path/to/AppImage ./runtime --appimage-extract ./runtime-x86_64

This will call ``--appimage-extract`` on the downloaded AppImage runtime to extract your AppImage without having to rely on the (possibly tampered) runtime of your AppImage.

You can also use ``--appimage-mount`` instead of ``--appimage-extract`` if you rather want to temporarily mount the AppImage content.


Type 1 AppImages
++++++++++++++++

Type 1 AppImages are legacy; however you still might want to inspect the content of an old AppImage. To do this safely, you can rename them to ``.iso`` instead of ``.AppImage`` and then extract them by using a tool like ``Iso7z`` or ``bsdtar`` that can handle ``zisofs``.


Mounting with root permissions
------------------------------

Another possible way to inspect the content of an AppImage is to use the normal ``mount`` toolchain of your Linux distribution. This requires root permissions.

The other options described on this page are usually preferred. This is primarily useful if you have to inspect a type 1 AppImage without any external tools.

.. code-block:: shell

    > mkdir mountpoint
    > sudo mount -o loop my.AppImage mountpoint/
    # You can now inspect the AppImage content in mountpoint/
    > sudo umount mountpoint/

.. note::
   This only works for type 1 AppImages. To mount a type 2 AppImage, see the other options described on this page.

.. warning::
   AppImages mounted using this method are not unmounted automatically. Please do not forget to call ``umount`` the AppImage as soon as you don't need it mounted any more.

   If an AppImage is not unmounted properly, and is moved to a new location, a so-called "dangling mount" can be created. This should be avoided by properly unmounting the AppImages.
