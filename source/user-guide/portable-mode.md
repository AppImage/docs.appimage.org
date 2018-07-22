# Using portable mode

Normally the application contained inside an AppImage will store its configuration files wherever it normally stores them (most frequently somewhere inside `$HOME`). If you invoke an AppImage built with a recent version of AppImageKit and have one of these special directories in place, then the configuration files will be stored alongside the AppImage. This can be useful for portable use cases, e.g., carrying an AppImage on a USB stick, along with its data.

- If there is a directory with the same name as the AppImage plus `.home`, then `$HOME` will automatically be set to it before executing the payload application
- If there is a directory with the same name as the AppImage plus `.config`, then `$XDG_CONFIG_HOME` will automatically be set to it before executing the payload application

## Example

Imagine you want to use the Leafpad text editor, but carry its settings around with the executable. You can do the following:

```bash
# Download Leafpad AppImage and make it executable
wget -c "https://bintray.com/probono/AppImages/download_file?file_path=Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage" -O Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage
chmod a+x Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage

# Create a directory with the same name as the AppImage plus the ".config" extension
# in the same directory as the AppImage
mkdir Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config

# Run Leafpad, change some setting (e.g., change the default font size) then close Leafpad
./Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage

# Now, check where the settings were written:
linux@linux:~> find Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config
(...)
Leafpad-0.8.18.1.glibc2.4-x86_64.AppImage.config/leafpad/leafpadrc
```

Note that the file `leafpadrc` was written in the directory we have created before.
