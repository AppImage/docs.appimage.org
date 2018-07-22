# Distributing AppImages

## Hosting AppImages

You can host AppImage  files on every web host you like.
However, for automatic updates to work properly, it is required that the web server supports HTTP range requests. 
Most web hosts support this, as the same technology is used for navigating an MP3 files, for example.

## Do not put AppImages into other archives

Please __DO NOT__ put an AppImage into another archive like a `.zip` or `.tar.gz`. 
While it may be tempting to avoid users having to set permission, this breaks desktop integration with the 
optional `appimaged` daemon, among other things. Besides, the beauty of the AppImage format 
is that you never need to unpack anything. Furthermore, packing an AppImage into some form of archive 
prevents the AppImage from being added to the central catalog of available AppImages 
at https://github.com/AppImage/AppImageHub.
