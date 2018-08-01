Bundling your Travis CI builds as AppImages
===========================================

Services such as Travis CI make it easy to build software automatically whenever a new commit is pushed to the source code repository. How you turn your build products into an AppImage depends on how your application is built. Generally there are two main methods, namely producing an application directory using bash scripts, and using the :code:`linuxdeployqt` tool.

Producing an application directory using bash scripts
-----------------------------------------------------

Some types of applications can best be converted into application directories using custom bash script. However, to facilitate this, there is a collection of convenience functions in https://github.com/AppImage/AppImages/blob/master/functions.sh which can use in your own scripts.

.. todo::

	Document the functions in :code:`functions.sh` that are for public consumption based on comments in the file.


.. note::

	For most types of applications, especially those compiled with compilers such as :code:`gcc` or :code:`g++` using a tool like :code:`linuxdeployqt` is much easier than doing this in a bash script because it automates much of the process.


Producing an application directory using the `linuxdeployqt` tool
-----------------------------------------------------------------

Please refer to the chapter on :code:`linuxdeployqt`.


Uploading the generated AppImage
--------------------------------

Once an Appimage has been generated, you want to upload it to GitHub Releases. For this, you can use the :code:`upload.sh` script available at https://github.com/probonopd/uploadtool.

.. note::

	It is best practice to upload binaries (such as AppImages) to GitHub Releases rather than committing them into the repository itself.


Super simple uploading of continuous builds (each push) to GitHub Releases. If this is not the easiest way to upload continuous builds to GitHub Releases, then it is a bug.


Using `upload.sh`
^^^^^^^^^^^^^^^^^

The :code:`upload.sh` script is designed to be called from Travis CI after a successful build. By default, this script will *delete* any pre-existing release tagged with :code:`continuous`, tag the current state with the name :code:`continuous`, create a new release with that name, and upload the specified binaries there. For pull requests, it will upload the binaries to transfer.sh instead and post the resulting download URL to the pull request page on GitHub.

- On https://github.com/settings/tokens, click on "Generate new token" and generate a token with at least the :code:`public_repo`, :code:`repo:status`, and :code:`repo_deployment` scopes
- On Travis CI, go to the settings of your project at :code:`https://travis-ci.org/yourusername/yourrepository/settings`
- Under "Environment Variables", add key :code:`GITHUB_TOKEN` and the token you generated above as the value. **Make sure that "Display value in build log" is set to "OFF"!**
- In the :code:`.travis.yml` of your GitHub repository, add something like this (assuming the build artifacts to be uploaded are in out/):

.. code-block:: yaml

  after_success:
    - ls -lh out/* # Assuming you have some files in out/ that you would like to upload
    - wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
    - bash upload.sh out/*

  branches:
    except:
      - # Do not build tags that we create when we upload to GitHub Releases
      - /^(?i:continuous)$/


Environment variables
#####################

:code:`upload.sh` normally only creates one stream of continuous releases for the latest commits that are pushed into (or merged into) the repository.

It's possible to use :code:`upload.sh` in a more complex manner by setting the environment variable :code:`UPLOADTOOL_SUFFIX`. If this variable is set to the name of the current tag, then :code:`upload.sh` will upload a release to the repository (basically reproducing the :cdoe:`deploy:` feature in :code:`.travis.yml`).

If :code:`UPLOADTOOL_SUFFIX` is set to a different text, then this text is used as suffix for the :code:`continuous` tag that is created for continuous releases. This way, a project can customize what releases are being created.

One possible use case for this is to set up continuous builds for feature or test branches:

.. code-block:: shell

	if [ ! -z $TRAVIS_BRANCH ] && [ "$TRAVIS_BRANCH" != "master" ] ; then
		export UPLOADTOOL_SUFFIX=$TRAVIS_BRANCH
	fi


This will create builds tagged with :code:`continuous` for pushes/merges to :code:`master` and with :code:`continuous-<branch-name>` for pushes / merges to other branches.

The two environment variables :code:`UPLOADTOOL_PR_BODY` and :code:`UPLOADTOOL_BODY` allow the calling script to customize the messages that are posted either for pull requests or merges/pushes. If these variables aren't set, generic default texts are used.
