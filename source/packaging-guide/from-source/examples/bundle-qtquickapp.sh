#! /bin/bash

set -e
set -x

git clone https://github.com/probonopd/QtQuickApp.git

pushd QtQuickApp

# build out of source
mkdir build
pushd build

# configure project using qmake, and build it
qmake ..
make -j$(nproc)

# download linuxdeploy and its Qt plugin
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage

# make them executable
chmod +x linuxdeploy*.AppImage

# QtQuickApp doesn't support "make install", therefore we'll show the manual packaging approach in this example
# initialize AppDir, bundle shared libraries, add desktop file and icon, use Qt plugin to bundle additional resources, and build AppImage, all in one command
./linuxdeploy-x86_64.AppImage --appdir AppDir -e QtQuickApp -i ../qtquickapp.png -d ../qtquickapp.desktop --plugin qt --output appimage

# move built AppImage to original working directory
mv QtQuickApp*.AppImage ../../
popd

# and finally have a look at the AppImage we just built
ls -al QtQuickApp*.AppImage
