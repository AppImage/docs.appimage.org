.. include:: ../../substitutions.rst

.. _pkg2appimage:

pkg2appimage
============

`pkg2appimage <https://github.com/AppImage/pkg2appimage>`_ is a tool that can be used by people other than the application authors to convert officially distributed binary packages (archives, .deb packages and PPAs) into AppImages if none are officially distributed. It doesn't require dependencies to be installed on your system; instead, they are downloaded during the packaging process from distribution repositories. To convert an existing package, you write a `.yml description file <https://github.com/AppImage/pkg2appimage/tree/master/recipes>`_ (called recipe) and run it with pkg2appimage. As some (mostly proprietary) applications don't allow redistribution, you can distribute these recipes to allow other users to easily convert existing packages to AppImages.

pkg2appimage doesn't include core system libraries like glibc. This results in a reduced AppImage size. However, as the recipes use binary packages that have already been built, invoking a recipe doesn't require using an old system (see :ref:`compiling-on-old-system`).

|appimage_preferred_source|

.. cssclass:: bold-link

**Do not use pkg2appimage if you are the application author. Application authors should use one of the other creation methods, see** :ref:`appimage-creation-tools`\ **.**

pkg2appimage requires a manual creation of the AppDir folder structure and file placement inside the recipe, see :ref:`manually-creating-appdir-structure`.

.. contents:: Contents
   :local:
   :depth: 1


Using a recipe
--------------

To use a distributed recipe (a ``.yml`` description file), you first have to download pkg2appimage. You can get it as an AppImage from its from its `GitHub release page <https://github.com/AppImageCommunity/pkg2appimage/releases>`_.

To then build an AppImage from the recipe, simply run pkg2appimage with the file as parameter: ``./pkg2appimage-*.AppImage Receipe.yml``.


Introduction
------------

The so-called recipe files (which are :code:`.yml` description files) tell pkg2appimage where to get the ingredients from and how to convert them to an AppImage (besides the general steps that pkg2appimage always performs). Study some `examples <https://github.com/AppImage/pkg2appimage/tree/master/recipes>`__ to see how it works.

.. warning::
   pkg2appimage suffers from a few notable issues:

     - It is likely to add lots of bloat to the final AppImage. As it simply extracts the contents of packages, there is no check whether any of these resources are actually used by the application or not. You are recommended to check final AppImages, and add ``rm`` commands to your recipes to remove unused data.
     - pkg2appimage uses distribution packages downloaded using the package managers, however, the packages are not authenticated, as most security functionality has been deactivated. This is a major security issue. pkg2appimage is therefore recommended for personal use only. Upstream authors should consider :ref:`other packaging methods <appimage-creation-tools>`.

   .. seealso::
      See `this GitHub issue <https://github.com/AppImage/pkg2appimage/issues/197>`__ for more information on the security issue.


Recipe files
------------

To convert a binary package into an AppImage, you have to write a so-called recipe, a specific ``.yml`` description file. This format describes how to build an AppImage by re-using pre-built binaries, e.g. from Debian packages, to save time for both creating and building an AppImage.

``.yml`` is an extension used for *YAML*, a format to describe data. Similarly to JSON, it combines associative lists (key-value pairs, also known as maps or dicts), lists and scalar values (like strings).

The format of these :code:`.yml` files is not part of the AppImage :ref:`specification <appimage-specification>` (which describes the AppImage container format) or :ref:`reference implementation <reference-implementation>` (which implements a conforming runtime and a tool to create conforming AppImages); it is just defined and used by the pkg2appimage project.

This section provides an introduction to the recipe structure and a few examples describing how to use all the advanced features.


General anatomy of ``.yml`` files
---------------------------------

The general format of :code:`.yml` files is as follows:

.. code-block:: yaml

  app: (name of the application)
    (optional flags)

  ingredients:
    (instructions that describe from where to get
    the binary ingredients used for the AppImage)

  script:
    (instructions on how to convert these ingredients to an AppImage)


As you can see, the :code:`.yml` file consists of three sections:

1. The **overall section** (containing the name of the application and optional flags)
2. The **ingredients section** (describing from where to get the binary ingredients used for the AppImage)
3. The **script section** (describing how to convert these ingredients to an AppImage)

Note that the sections may contain sub-sections. For example, the ingredients section can also have a script section containing instructions on how to determine the most recent version of the ingredients and how to download them.


Overall section
+++++++++++++++

``app`` key
###########

Mandatory. Contains the name of the application. If the :code:`.yml` file uses ingredients from packages (e.g., :code:`.deb`), then the name must match the package name of the main executable.


Keys that enable ability to relocate
####################################

Optional. Either :code:`binpatch: true` or :code:`union: true`. These keys enable workarounds that make it possible to run applications from different, changing places in the file system (i.e., make them relocateable) that are not made for this. For example, some applications contain hardcoded paths to a compile-time :code:`$PREFIX` such as :code:`/usr`. This is generally discouraged, and application authors are asked to use paths relative to the main executable instead. Libraries like *binreloc* exist to make this easier. Since many applications are not relocateable yet, there are workarounds which can be used by one of these keys:

* :code:`binpatch: true`  indicates that binaries in the AppImage should be patched to replace the string :code:`/usr` by the string :code:`././`,  an :code:`AppRun` file should be put inside the AppImage that does a :code:`chdir()` to the :code:`usr/` directory of inside AppDir before executing the payload application. The net effect is this that applications can find their resources in the  :code:`usr/` directory inside the AppImage as long as they do not internally use :code:`chdir()` operations themselves.
* :code:`union: true` indicates that an :code:`AppRun` file should be put inside the AppImage that tries to create the impression of a union file system, effectively creating the impression to the payload application that the contents of the AppImage are overlayed over :code:`/`. This can be achieved, e.g., using :code:`LD_PRELOAD` and a library that redirects file system calls. This works as long as the payload application is a dynamically linked binary.


Ingredients section
+++++++++++++++++++

Describes how to acquire the binary ingredients that go into the AppImage. Binary ingredients can be archives like :code:`.zip` files, packages like :code:`.deb` files or APT repositories like Debian package archives or PPAs.

.. note::
    In the future, source ingredients could also be included in the :code:`.yml` file definition. Source ingredients could include tarballs and Git repositories. It would probably be advantageous if we could share the definition with other formats like snapcraft's :code:`.yaml` files. Proposals for this are welcome.


:code:`.yml` files are supposed not to hardcode version numbers, but determine the latest version at runtime. If the  :code:`.yml` files describes the released version, it should determine the latest released version at runtime. If the  :code:`.yml` files describes the development version, it might reference the latest nightly or continuous build instead.


Using ingredients from a binary archive
#######################################

The following example ingredients section describes how to get the latest version of a binary archive:

.. code-block:: yaml

  ingredients:
    script:
      - DLD=$(wget -q "https://api.github.com/repos/atom/atom/releases/latest" -O - | grep -E "https.*atom-amd64.tar.gz" | cut -d'"' -f4)
      - wget -c $DLD
      - tar zxvf atom*tar.gz


The :code:`script` section inside the :code:`ingredients` section determines its URL, downloads and extracts the binary archive.


Using ingredients from a debian repository
##########################################

The following example ingredients section describes how to get the latest version of a package from a Debian archive:

.. code-block:: yaml

  ingredients:
    dist: xenial
    sources:
      - deb http://archive.ubuntu.com/ubuntu/ xenial main universe
      - deb http://download.opensuse.org/repositories/isv:/KDAB/xUbuntu_16.04/ /


The :code:`dist` section inside the :code:`ingredients` section defines which Debian distribution should be used as a base. The :code:`sources` section inside the :code:`ingredients` section describes the repositories from which the package should be pulled. The entries are in the same format as lines in a debian :code:`sources.list` file. Note that the :code:`http://download.opensuse.org/repositories/isv:/KDAB/xUbuntu_16.04` repository needs the :code:`http://archive.ubuntu.com/ubuntu/` repository so that the dependencies can be resolved.

.. note::
    In the future, other types of packages like :code:`.rpm` could also be included in the :code:`.yml` file definition. Proposals for this are welcome if the proposer also implements support for this in the `pkg2appimage script <https://github.com/AppImageCommunity/pkg2appimage/blob/master/pkg2appimage>`_.


Using ingredients from an Ubuntu PPA
####################################

This is a special case of a Debian repository. PPAs can be uniquely identified with the pattern :code:`owner/name` and can, for brevity, be specified like this:

.. code-block:: yaml

  ingredients:
    dist: xenial
    sources:
      - deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe
    ppas:
      - geany-dev/ppa


The :code:`ppas` section inside the :code:`ingredients` section lets you specify one or more Ubuntu PPAs. This is equivalent to, but more elegant than, adding the corresponding :code:`sources.list` entries to the :code:`sources` section inside the :code:`ingredients` section.

.. note::
    In the future, similar shortcuts for other types of personal repositories, such as projects on openSUSE build service, could also be included in the :code:`.yml` file definition. Proposals for this are welcome if the proposer also implements support for this in the `pkg2appimage script <https://github.com/AppImageCommunity/pkg2appimage/blob/master/pkg2appimage>`_.


Using local deb files
#####################

This allows the use of local deb files (rather than downloading the deb ingredients)

.. code-block:: yaml

  ingredients:
    dist: xenial
    sources:
      - deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe
    debs:
      - /home/area42/kdenlive.deb
      - /home/area42/kdenlive/*


As you can see, for a single file, just use

.. code-block:: yaml

  - /path/to/file.deb


And for all files in a directory (like local repository). Note that the end of the path ends with :code:`/*`:

.. code-block:: yaml

  - /path/to/local/repo/*


.. note::
    This is for personal use only. If you use it, your recipe will NOT work on another computer if the debs files are not in the specified directory.


Excluding certain packages
##########################

Some packages declare dependencies that are not necessarily required to run the software. The :code:`.yml` format allow overriding these by pretending that the packages are installed already. To exclude these dependencies (and any dependencies they would otherwise pull in), the packages have to be added to the :code:`exclude` key in the :code:`ingredients` section:

.. code-block:: yaml

  ingredients:
    dist: xenial
    packages:
      - multisystem
      - gksu
    sources:
      - deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe
      - deb http://liveusb.info/multisystem/depot all main
    exclude:
      - qemu
      - qemu-kvm
      - cryptsetup
      - libwebkitgtk-3.0-0
      - dmsetup


In this example, excluding :code:`qemu` means that the qemu package and all of its dependencies that it would normally pull into the AppImage will be excluded from the AppImage (unless something else in the AppImage pulls in some of those depdencies already).


Pretending certain versions of dependencies being installed
###########################################################

The dependency information in some packages may result in the package manager to refuse the application to be installed if some **exact** versions of dependencies are not present in the system. In this case, it may be necessary pretend the **exact** version of a dependency to be installed on the target system by using the :code:`pretend` key in the :code:`ingredients` section:

.. code-block:: yaml

  ingredients:
    dist: xenial
    sources:
      - deb http://archive.ubuntu.com/ubuntu/ xenial main universe
    ppas:
      - otto-kesselgulasch/gimp-edge
    pretend:
      - libcups2 1.7.2-0ubuntu1


The assumption here is that every target system has at least the pretended version available, and that newer versions of the pretended package are able to run the application just as well as the pretended version itself. *(If this is not the case, then the pretended package has broken downward compatibility and should be fixed.)*


Arbitrary scripts in the ingredients section
############################################

You may add arbitrary shell commands to the :code:`script` section inside the :code:`ingredients` section in order to facilitate the retrieval of the binary ingredients. This allows building AppImages for complex situations as illustrated in the following example:

.. code-block:: yaml

  ingredients:
    script:
      - URL=$(wget -q https://www.fosshub.com/JabRef.html -O - | grep jar | cut -d '"' -f 10)
      - wget -c "$URL"
      - wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-x64.tar.gz


This downloads the payload application, JabRef, and the required JRE which requires to set a special cookie header.

The script could also be used to fetch pre-built Debian packages from a GitHub release page, or to override the version of a package.

Use :code:`post_script` instead of :code:`script` if you need this to run *after* the other ingredient processing has taken place.


Script section
++++++++++++++

The :code:`script` section may contain arbitrary shell commands that are required to translate the binary ingredients to an :code:`AppDir` suitable for generating an AppImage.


The script section needs to copy ingredients into place
#######################################################

If :code:`.deb` packages, Debian repositories or PPAs have been specified in the :code:`ingredients` section, then their dependencies are resolved automatically (taking a blacklist of packages that are assumed to be present on all target systems in a recent enough version into account, such as glibc) and the packages are extracted into an AppDir. The shell commands contained in the :code:`script` section are executed inside the root directory of this AppDir. However, some packages place things in non-standard locations, i.e. the main executable is outside of :code:`usr/bin`. In these cases, the commands contained in the :code:`script` section should normalize the file system structure. Sometimes it is also necessary to edit further files to reflect the changed file location. The following example illustrates this:

.. code-block:: yaml

  ingredients:
    dist: xenial
    sources:
      - deb http://archive.ubuntu.com/ubuntu/ xenial main universe

    script:
      - DLD=$(wget -q "https://github.com/feross/webtorrent-desktop/releases/" -O - | grep _amd64.deb | head -n 1 | cut -d '"' -f 2)
      - wget -c "https://github.com/$DLD"

  script:
    - mv opt/webtorrent-desktop/* usr/bin/
    - sed -i -e 's|/opt/webtorrent-desktop/||g' webtorrent-desktop.desktop


In the :code:`ingredients` section, a :code:`.deb` package is downloaded. Then, in the :code:`script` section, the main executable is moved to its standard location in the AppDir. Finally, the :code:`.desktop` file is updated to reflect this.

If other types of binary ingredients have been specified, then the shell commands contained in the :code:`script` section need to retrieve these by copying them into place. Note that since the commands contained in the :code:`script` section are executed inside the root directory of the AppDir, the ingredients downloaded in the `ingredients` sections are one directory level above, i.e., in :code:`../`. The following example illustrates this:

.. code-block:: yaml

  ingredients:
    script:
      - wget -c "https://telegram.org/dl/desktop/linux" --trust-server-names
      - tar xf tsetup.*.tar.xz

  script:
    - cp ../Telegram/Telegram ./usr/bin/telegram-desktop


In the :code:`ingredients` section, an archive is downloaded and unpacked. Then, in the :code:`script` section, the main executable is copied into place inside the AppDir.


The script section needs to copy icon and `.desktop` file in place
##################################################################

Since an AppImage may contain more than one executable binary (e.g. helper binaries launched by the main executable) and also may contain multiple :code:`.desktop` files, a clear entry point into the AppImage is required. For this reason, there is the convention that there should be exactly one :code:`$ID.desktop` file and corresponding icon file in the top-level directory of the AppDir.

The script running the :code:`.yml` file tries to do this automatically, which works if the name of the application specified in the :code:`app:` key matches the name of the :code:`$ID.desktop` file and the corresponding icon file. For example, if :code:`app: myapp` is set, and there is :code:`usr/bin/myapp`, :code:`usr/share/applications/myapp.desktop`, and :code:`usr/share/icons/*/myapp.png`, then the :code:`myapp.desktop` and :code:`myapp.png` files are automatically copied into the top-level directory of the AppDir. Unfortunately, many packages are  in their naming. In that case, the shell commands contained in the :code:`script` section must copy exactly one :code:`$ID.desktop` file and the corresponding icon file into the top-level directory of the AppDir. The following example illustrates this:

.. code-block:: yaml

  script:
    - tar xf ../fritzing* -C usr/bin/ --strip 1
    - mv usr/bin/fritzing.desktop .


Unfortunately, many applications don't include a :code:`$ID.desktop` file. If it is missing, the shell commands contained in the :code:`script` section need to create it. The following (simplified) example illustrates this:

.. code-block:: yaml

  script:
    - # Workaround for:
    - # https://bugzilla.mozilla.org/show_bug.cgi?id=296568
    - cat > firefox.desktop <<EOF
    - [Desktop Entry]
    - Type=Application
    - Name=Firefox
    - Icon=firefox
    - Exec=firefox %u
    - Categories=GNOME;GTK;Network;WebBrowser;
    - MimeType=text/html;text/xml;application/xhtml+xml;
    - StartupNotify=true
    - EOF


.. note::
    The optional :code:`desktopintegration` script assumes that the name of the application specified in the :code:`app:` key matches the name of the :code:`$ID.desktop` file and the corresponding main executable (case-sensitive). For example, if :code:`app: myapp` is set, it expects :code:`usr/bin/myapp`and :code:`usr/share/applications/myapp.desktop`. For this reason, if you want to use the optional :code:`desktopintegration` script, you may rearrange the AppDir. The following example illustrates this:

    .. code-block:: yaml

      script:
        - cp ./usr/share/applications/FBReader.desktop fbreader.desktop
        - sed -i -e 's|Exec=FBReader|Exec=fbreader|g' fbreader.desktop
        - sed -i -e 's|Name=.*|Name=FBReader|g' fbreader.desktop
        - sed -i -e 's|Icon=.*|Icon=fbreader|g' fbreader.desktop
        - mv usr/bin/FBReader usr/bin/fbreader
        - cp usr/share/pixmaps/FBReader.png fbreader.png


Converting Python applications packaged with pip
------------------------------------------------

Let's say you have already packaged your Python application using :code:`pip`. in this case, you can use pkg2appimage to generate an AppImage. In the following example, we will convert a Python 3 application using :code:`pip3`.

The following recipe will convert a Python 3 PyQt application using :code:`virtualenv` and :code:`pip3`:

.. code-block:: yaml

    app: mu.codewith.editor
    ingredients:
      dist: xenial
      sources:
        - deb http://us.archive.ubuntu.com/ubuntu/ xenial xenial-updates xenial-security main universe
        - deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main universe
        - deb http://us.archive.ubuntu.com/ubuntu/ xenial-security main universe
      packages:
        - python3.4-venv
      script:
        -  wget -c https://raw.githubusercontent.com/mu-editor/mu/master/conf/mu.codewith.editor.png
        -  wget -c https://raw.githubusercontent.com/mu-editor/mu/master/conf/mu.appdata.xml
    script:
      - cp ../mu.codewith.editor.png ./usr/share/icons/hicolor/256x256/
      - cp ../mu.codewith.editor.png .
      - mkdir -p usr/share/metainfo/ ; cp ../mu.appdata.xml usr/share/metainfo/
      - virtualenv --python=python3 usr
      - ./usr/bin/pip3 install mu-editor
      - cat > usr/share/applications/mu.codewith.editor.desktop <<\EOF
      - [Desktop Entry]
      - Type=Application
      - Name=Mu
      - Comment=A Python editor for beginner programmers
      - Icon=mu.codewith.editor
      - Exec=python3 bin/mu-editor %F
      - Terminal=false
      - Categories=Application;Development;
      - Keywords=Python;Editor;microbit;micro:bit;
      - StartupWMClass=mu
      - MimeType=text/x-python3;text/x-python3;
      - EOF
      - cp usr/share/applications/mu.codewith.editor.desktop .
      - usr/bin/pip3 freeze | grep "mu-editor" | cut -d "=" -f 3 >> ../VERSION


Source:
	https://github.com/AppImage/pkg2appimage/blob/9249a99e653272416c8ee8f42cecdde12573ba3e/recipes/Mu.yml
