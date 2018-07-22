# Signing AppImages

AppImages can be digitally signed by the person that has produced the AppImage. This ensures that the AppImage comes from the person who pretends to be the author, and ensures that the file has not been tampered with.

The AppImages specification allows the AppImage file to carry a digital signature built into the AppImages. This means that the signature does not need to be an external file, but can be carried inside the AppImage itself, similar to how signatures work for traditional Linux packages (such as `.deb` or `.rpm` files).

## Embedding a signature into an AppImage

While it would be possible to embed signatures manually, the easiest way to produce a digitally signed AppImage is to use the `appimagetool` command line tool. The internally uses `gpg` or `gpg2` if it is installed and configured on the system.


Especially, a key for signing must be prepared before AppImages can be signed. If the machine on which the AppImage is being generated does not have a valid signing key yet, a new one can be generated using

```
gpg2 --full-gen-key
```

Please refer to the `gpg` or `gpg2` documentation for additional information. You should take additional care to backup your private and public keys in a secure location. 

Once you're signing keys have been set up, you can sign AppImages at AppImage creation time using

```
./appimagetool-x86_64.AppImage some.AppDir --sign
```

This will sign the AppImage with `gpg[2]` and will put the signature into the AppImage.

## Reading the signature

You can display the digital signature that is embedded in AppImage by running the AppImage with the `--appimage-signature` option like this:

```
./XChat_IRC-x86_64.AppImage --appimage-signature

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
```

NOTE: Please note that while this displays the signature, it does not validate the signature. In other words, this does not tell you whether the signature is valid or not, or whether the file has been tampered with or not. To validate the signature, an external tool (which is not part of AppImage that needs to be validated) needs to be used.

## Validating the signature

To validate a signature of an an AppImage and to determine whether an AppImage has been compromised, an external tool needs to be used. There is a very simple tool called `validate` that can do this. 

```
chmod a+x ./validate
./validate ./XChat_IRC-x86_64.AppImage
(...)
gpg: Signature made Sun 25 Sep 2016 10:41:24 PM CEST using RSA key ID 86C3DFDD
gpg: Good signature from "Testkey" [ultimate]
```

Signature validation can also be integrated into higher level software such as the optional `appimaged` demon and/or `AppImageUpdate`. For example the `appimaged` daemon may decide to run applications without a valid signature in a confined sandbox in the future, if the system is set up accordingly.

TODO: It may be desirable to integrate validate functionality into `libappimage` and into tools like  `appimagetool`, the optional `appimaged` demon and/or `AppImageUpdate`.
