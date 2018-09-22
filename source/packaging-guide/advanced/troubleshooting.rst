

.. _ref-appimagekit-checkrt:

AppImageKit-checkrt
-------------------

Some projects require newer C++ standards to build them. To keep the glibc dependency low you can build a newer GCC version on an older distro and use it to compile the project. If you do this, however, then your compiled application will require a newer version of the :code:`libstdc++.so.6` library than available on that distro.

Bundling :code:`libstdc++.so.6` however will in most cases break compatibility with distros that have a newer library version installed into their system than the bundled one. So blindly bundling the library is not reliable. While this is primarily an issue with :code:`libstdc++.so.6`, in some rare cases this might also occur with :code:`libgcc_s.so.1`. That's because both libraries are part of GCC. You would have to know the library version of the host system and decide whether to use a bundled library or not before the application is started. This is exactly what the patched AppRun binary from https://github.com/darealshinji/AppImageKit-checkrt/ does. It will search for :code:`usr/optional/libstdc++/libstdc++.so.6` and :code:`usr/optional/libgcc_s/libgcc_s.so.1` inside the AppImage or AppDir. If found it will compare their internal versions with the ones found on the system and prepend their paths to :code:`LD_LIBRARY_PATH` if necessary.

Here is a real-world example of how to use it, taken from the https://github.com/probonopd/audacity/blob/AppImage/.travis.yml file. The key lines are:

.. code-block:: shell

 	# Workaround to increase compatibility with older systems; see https://github.com/darealshinji/AppImageKit-checkrt for details
	mkdir -p appdir/usr/optional/
	wget -c https://github.com/darealshinji/AppImageKit-checkrt/releases/download/continuous/exec-x86_64.so -O ./appdir/usr/optional/exec.so

	mkdir -p appdir/usr/optional/libstdc++/
	cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 ./appdir/usr/optional/libstdc++/

	cd appdir
	rm AppRun
	wget -c https://github.com/darealshinji/AppImageKit-checkrt/releases/download/continuous/AppRun-patched-x86_64 -O AppRun
	chmod a+x AppRun

.. code-block:: shell

	# Manually invoke appimagetool so that libstdc++ gets bundled and the modified AppRun stays intact
	./linuxdeployqt*.AppImage --appimage-extract
	export PATH=$(readlink -f ./squashfs-root/usr/bin):$PATH
	./squashfs-root/usr/bin/appimagetool -g ./appdir/ $NAME-$VERSION-x86_64.AppImage
