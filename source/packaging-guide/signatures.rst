.. _signing-appimages:

Signing AppImages
=================

AppImages can optionally be digitally signed by the person that has produced the AppImage. This ensures that the AppImage comes from the person who pretends to be the author, and ensures that the file has not been tampered with.

The AppImages specification allows the AppImage file to carry a digital signature built into the AppImages. This means that the signature does not need to be an external file, but can be carried inside the AppImage itself, similar to how signatures work for traditional Linux packages (such as ``.deb`` or ``.rpm`` files).

.. contents:: Contents
   :local:
   :depth: 1


Embedding a signature inside an AppImage
----------------------------------------

To embed a signature, you have to have ``gpg`` (GnuPG 2) installed.

You first need to prepare a key for signing. If the machine on which the AppImage is generated doesn't have a valid signing key, you can generate a new one using ``gpg --full-gen-key`` (see the gpg documentation for more information about this). You should also make sure to backup your private and public keys in a secure location.

If you use an :ref:`AppImage creation tool <appimage-creation-tools>`, you should use its built-in feature to sign the AppImage. However, if your AppImage creation tool doesn't support signing the AppImage, or if you create your AppImage manually, you can also use :ref:`appimagetool` directly to manually sign the AppImage.

Using an AppImage creation tool
+++++++++++++++++++++++++++++++

Most AppImage creation tools come with a built-in feature to sign the AppImage at AppImage creation time.

| To see how sign an AppImage with :ref:`linuxdeploy`, see :ref:`this <linuxdeploy-signing>` section of the linuxdeploy guide.
| To see how to sign an AppImage with :ref:`go-appimagetool`, see :ref:`this <go-appimagetool-signing>` section of the go-appimagetool guide.
| To see how to sign an AppImage with :ref:`electron-builder`, see :ref:`this <electron-builder-signing>` section of the electron-builder guide.

.. todo::
   Research whether a corresponding feature exists for all other AppImage creation tool and add an updating section to each guide.


.. _signing-using-appimagetool:

Using ``appimagetool`` directly
+++++++++++++++++++++++++++++++

If you use an AppImage creation tool that doesn't support signing the AppImage, you have to extract the created AppImage by calling it with the ``--appimage-extract`` option (for more information, see :ref:`inspect-appimage-content`) and then recreate the AppImage with the embedded signature using :ref:`appimagetool`.

To (re)create an AppImage from the AppDir and embed its signature in it, use the ``--sign`` flag. That command could for example look like this: ``appimagetool MyApplication.AppDir --sign``. Keep in mind that you also have to use the ``-u`` parameter if you want to add updating information to your AppImage, see :ref:`updating-using-appimagetool`.


Validating the signature
------------------------

To validate the signature of an AppImage and make sure it hasn't been compromised, you have to use an external tool. This can be done by ``validate``, which you can download from the `AppImage Update release page <https://github.com/AppImageCommunity/AppImageUpdate/releases>`__:

.. code-block:: shell

    > chmod +x ./validate
    > ./validate ./XChat_IRC-x86_64.AppImage

    gpg: Signature made Sun 25 Sep 2016 10:41:24 PM CEST using RSA key ID 86C3DFDD
    gpg: Good signature from "Testkey" [ultimate]

Signature validation can also be integrated into higher level software. For example, ``AppImageUpdate`` uses it to ensure that an updated AppImage has been signed by the same person who signed the original version.


Reading the signature
---------------------

You can display the digital signature that is embedded in an AppImage by running the AppImage with the ``--appimage-signature`` option like this:

.. code-block:: shell

    > ./XChat_IRC-x86_64.AppImage --appimage-signature

    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v2

    iQEcBAABCAAGBQJX6CN9AAoJENBdKWeGw9/dsvoH/RgEggMiNTwgyA4io2Dyy1j1
    6U3CQST9HVmh9PjeFKZCgFCZbHvpFz9mzhLTPlOAbczBnSmmbgqROINaLW+1tqEx
    stOy67D3Z1cySzRTOhSkjiUOP5unmZL6QTNPxRHmuRkyihv7YfAlkrogXQlYbZ1h
    Ilt6jU1b97GSPox/EE3Z002iZGJYQ3FfjAlp9o947goY5koA5KYqyzTCvEjhTk/L
    wz1mFcjEkzHt9CaHZfrZCE3QVSBTq071wzsHCFHaJswPhA6iI0psCnFY56PPResi
    uljTQr3nOBaqNyUgU3y4Tbd+36cwggSaTpGAzlhgNoalIwB1ltFSdPeRPe4Q3Qc=
    =MR0w
    -----END PGP SIGNATURE-----


.. note::
    Please note that while this displays the signature, it does not validate the signature. This means that it doesn't tell you whether the signature is valid or whether the file has been tampered with. To validate the signature, see the previous section.
