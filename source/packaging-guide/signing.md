# Signing AppImages

AppImages can be digitally signed by the person that has produced the AppImage. This ensures that the AppImage comes from the person who pretends to be the author, and ensures that the file has not been tampered with.

The AppImages specification allows the AppImage file to carry a digital signature built into the AppImages. This means that the signature does not need to be an external file, but can be carried inside the AppImage itself, similar to how signatures work for traditional Linux packages (such as `.deb` or `.rpm` files).

While it would be possible to embed signatures manually, the easiest way to produce a digitally signed AppImage is to use the `appimagetool` command line tool. The internally uses `gpg` or `gpg2` if it is installed and configured on the system.

```
./appimagetool-x86_64.AppImage some.AppDir --sign
```

will sign the AppImage with `gpg[2]`.
