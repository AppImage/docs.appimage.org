Best practices
==============

This section contains some best practices and recommendations how to generally design and write software so that it can be easily put into AppImages.


.. contents:: Contents
   :local:
   :depth: 2


General Recommendations
'''''''''''''''''''''''

It is crucial to understand that AppImage is merely a format for distributing applications. In this regard, AppImage is like a :code:`.zip` file or an :code:`.iso` file. It does not define how to compile applications. It it is also not a build system.

It is crucial to put binaries inside AppImages that are compatible with a variety of target systems. What goes into the AppImage is called the “payload”, or the “ingredients”. Producing the payload requires some thought, as you want your AppImage to run on as many targets systems as possible.

For an AppImage to run on most systems, the following conditions need to be met:

#. :ref:`Binaries must not use compiled-in absolute paths <ref-binaries-no-abs-paths>` (and if they do, they need to be binary-patched)
#. The AppImage needs to include all libraries and other dependencies that are not part of all of the base systems that the AppImage is intended to run on.
#. The binaries contained in the AppImage need to be compiled on a system not newer than the oldest base system that the AppImage is intended to run on.
#. The AppImage should actually be tested on the base systems that it is intended to run on.

.. _ref-binaries-no-abs-paths:

Binaries must not use compiled-in absolute paths
------------------------------------------------

Since an AppImage is mounted at a different location in the filesystem
every time it is run, it is crucial not to use compiled in absolute
paths. For example, if the application accesses a resource such as an
image, it should do so from a location relative to the main
executable. Unfortunately, many applications have absolute paths
compiled in (:code:`$PREFIX`, most commonly :code:`/usr`) at compile
time.

If your app doesn't load resources from the AppImage, but e.g., shows
errors it couldn't find resources, it is most likely not relocatable.
In this case, you must ask the author of the application to make it
relocatable (or make the changes yourself). In some cases, there are
flags you can specify when building from source to make applications
relocatable.

The canonical way on Linux to construct a relative path is to first
resolve ``proc/self/exe``, which provides the path to the main
executable. As a result, it should work both in normal installations
and in relocatable installations such as AppImages.

.. _ref-open-source-applications:

Open source applications
^^^^^^^^^^^^^^^^^^^^^^^^

You can check for hard-coded absolute paths:

.. code-block:: shell

	strings MyApp.AppDir/usr/bin/myapp | grep /usr

Should this return something, then you need to modify your app
programmatically (e.g., by using relative paths, or a :ref:`library <ref-relocation-libraries>`).

If you prefer not to change the source code of your app and/or would not like to recompile your app, you can also patch the binary, for example using the command

.. code-block:: shell

    sed -i -e 's#/usr#././#g' MyApp.AppDir/usr/bin/myapp

.. note::
	:code:`././` simply means "here", and points to :code:`$APPDIR/usr`

This usually works as long as the application is not doing a :code:`chdir()` which would break this workaround, because then :code:`././` would not be pointing to :code:`$APPDIR/usr` any more. You can run the following command to see whether the application is doing a :code:`chdir()` (99% of GUI applications don't)

.. code-block:: shell

	strace -echdir -f ./AppRun

.. note::
	Paths in helper binaries and/or libraries may also need changing. You check this and patch it with

	.. code-block:: shell

		cd MyApp.AppDir/usr/
		find . -type f -exec sed -i -e 's#/usr#././#g' {} \;
		cd -


.. _ref-relocation-libraries:


Translations
^^^^^^^^^^^^^^^^^^^^^^^^

Often when a package includes translations, :code:`LOCALEDIR` is defined as an absolute path.

.. warning::
	When testing your appimage, everything may seem fine, but be
	sure to also test by `changing the language in your environment <https://www.shellhacks.com/linux-define-locale-language-settings/>`__.


Relocation Libraries
^^^^^^^^^^^^^^^^^^^^^^^^

Some libraries can help make relocatable packages:

* Qt
  For example in :code:`QString
  QCoreApplication::applicationDirPath()` (`see documentation`_), and
  construct a *relative* path to :code:`../share/kaidan/images/` from
  there.

.. seealso::
  https://github.com/KaidanIM/Kaidan/commit/da38011b55a1aa5d17764647ecd699deb4be437f

.. warning::

   :code:`QStandardPaths::standardLocations(QStandardPaths::AppDataLocation)` **does not work reliably.**

   According to the `Qt documentation`_, this resolves to
   :code:`~/.local/share/<APPNAME>`,
   :code:`/usr/local/share/<APPNAME>`, :code:`/usr/share/<APPNAME>`,
   but clearly :code:`/usr` is not where these things are located in
   an AppImage.

* `Supporting Relocation
  <https://www.gnu.org/software/gnulib/manual/html_node/Supporting-Relocation.html>`__
  from the Gnulib manual

.. note::
	Instructions are for use with automake files and don't cover
	other build systems

* `Resourceful`_, a project to study of cross-platform techniques for
  building applications and libraries that use resource files (e.g.
  icons, configuration, data).


Other Alternatives
^^^^^^^^^^^^^^^^^^^^^^^^

If for some reason you're unable to get your appimage working with
relative paths, you may choose to use getenv() and read the
:ref:`APPDIR environmental variable <ref-env_vars>` which is set at
runtime.

.. _Resourceful: https://github.com/drbenmorgan/Resourceful
.. _Qt documentation: https://doc.qt.io/qt-5/qstandardpaths.html
.. _see documentation: https://doc.qt.io/qt-5/qcoreapplication.html#applicationDirPath


.. _ref-closed-source-apps-abs-paths:

Closed source applications with compiled-in absolute paths
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In case it is not possible to change the source code of the application, for example because it is a closed source application, you could binary patch the executable.

The trick is to search for :code:`/usr` in the binary and replace it by the same length string :code:`././` which means “here”. This can be done by using the following command::

	find usr/ -type f -executable -exec sed -i -e "s|/usr|././|g" {} \;

This command is also available as part of the bash function collection at `AppImage/pkg2appimage/functions.sh#L79`_. For the binary-patched application to work, you need to change to the :code:`usr/` directory inside the application directory before you launch the application.

.. _AppImage/pkg2appimage/functions.sh\#L79: https://github.com/AppImage/pkg2appimage/blob/9249a99e653272416c8ee8f42cecdde12573ba3e/functions.sh#L79


.. _ref-binaries-compiled-on-old-system:

Binaries compiled on old enough base system
-------------------------------------------

The ingredients used in your AppImage should not be built on a more recent base system than the oldest base system your AppImage is intended to run on.

Some core libraries, such as glibc, tend to break compatibility with older base systems quite frequently, which means that binaries will run on newer, but not on older base systems than the one the binaries were compiled on.

If you run into errors like this::

	failed to initialize: /lib/tls/i686/cmov/libc.so.6: version `GLIBC_2.11' not found

then the binary is compiled on a newer system than the one you are trying to run it on. You should use a binary that has been compiled on an older system. Unfortunately, the complication is that distributions usually compile the latest versions of applications only on the latest systems, which means that you will have a hard time finding binaries of bleeding-edge software that runs on older systems. A way around this is to compile dependencies yourself on a not too recent base system, and/or to use LibcWrapGenerator_ or glibc_version_header_ or bingcc_.

When producing AppImages for the Subsurface project, we have had very good results by using **CentOS 7**, which is the oldest still-supported Linux distribution at the time of writing. This distribution is not too recent. However, there are still the most recent Qt and modern compilers available in the EPEL_ and devtools-2_ repositories (the community equivalent of the Red Hat Developer Toolset 2). Binaries built on this distribution run on nearly any distribution, including **Debian oldstable**.

Be sure to check https://github.com/AppImage/pkg2appimage, this is how I build and host my AppImages and the build systems to produce them in the cloud using travis-ci, docker, docker-hub, and bintray. Especially check the recipes for Subsurface and Scribus.

See https://github.com/AppImage/AppImageKit/wiki/Docker-Hub-Travis-CI-Workflow for a description on how to set up a workflow involving your GitHub repository, Docker Hub, and Travis CI for a fully automated continuous build workflow.

You could also consider to link some exotic libraries statically. Yes, even Debian does that:
https://lintian.debian.org/tags/embedded-library.html

.. _LibcWrapGenerator: https://github.com/AppImage/AppImageKit/tree/stable/v1.0/LibcWrapGenerator
.. _bingcc: https://github.com/sulix/bingcc
.. _glibc_version_header: https://github.com/wheybags/glibc_version_header
.. _EPEL: https://fedoraproject.org/wiki/EPEL
.. _devtools-2: http://people.centos.org/tru/devtools-2/

.. seealso::

   This concept is also described in :ref:`build-on-old-systems`.


.. _ref-libstdc++.so.6:

libstdc++.so.6
--------------

.. note::
	**As a general rule of thumb, please use no libstdc++.so.6 newer than the one that comes with the oldest distribution that you still want to support, i.e., the oldest still-supported LTS version of Ubuntu**.
