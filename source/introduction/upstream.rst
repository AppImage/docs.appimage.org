.. _upstream-packaging:

A word on upstream packaging
============================

The AppImage ecosystem is built around the notion of "upstream packaging". With AppImage, typically the application author is who packages and distributes the application. This is different from the traditional Linux distribution model, where the application author and the application packager (also called the maintainer) are often different people.

AppimageKit is designed with “upstream packaging” in mind. This means that we want the original author of an application to be the person that packages it as an AppImage, distributes it to end users, and supports it.

In this regard, an AppImage is very similar to an :code:`.exe` file on Windows or a :code:`.dmg` file on the Mac. These files are normally prepared by the original application authors rather than by third parties. This ensures that the software works exactly the way the original application author has envisioned it to work. It also means that the application author does not have to follow arbitrary rules set by Linux distributions.

.. note::

    Before you package an application as an AppImage, ask yourself whether you are either the application author or a member of the application team. If not, it is most likely better to ask the original author of the application or the application team to provide an official AppImage.


.. contents:: Contents
   :local:
   :depth: 1


Advantages
----------

Upstream packaging has a lot of advantages: First and foremost, it allows the application author to control the entire user experience from how the user gets the application to how it works. It also allows the original author of an application to support the application since no unauthorised changes are made to it by third parties. For end-users, it is clear that the original application author is who is responsible for fixing bugs as there is no shared responsibility between the application author and the third party, e.g. a Linux distribution, that has distributed the application.


Disadvantages
-------------

However, upstream packaging also has disadvantages: Most prominently, there is no curator who assesses the quality and integrity of the application. Hence, the end user has to trust the application author when running an application that has been distributed directly by the original application author.


If upstream packaging is not possible
-------------------------------------

In some cases, the original application author or application team may not be interested in providing an official AppImage. In this case you have the following options: For open source projects, you can often make and send a pull / merge request, and for closed source applications, you can use :ref:`appimage-creation-tools` to create a yml recipe that can be used to convert the existing Linux binaries into an AppImage.


Open source projects
^^^^^^^^^^^^^^^^^^^^

For open source projects, you can often make and send a pull request (GitHub) or merge request (GitLab) that generates an AppImage as part of the project's build pipeline. Most open source projects will gladly accept such pull requests, especially if you indicate that you are willing to maintain the AppImage generation going forward.

Many open source projects already use continuous integration on systems such as GitHub Actions, GitLab CI, Gitea CI, Travis CI, Jenkins, or the :ref:`Open Build Service <ref-obs>`. If a project already uses one of those services, it is most beneficial to generate the AppImage on that service.


Closed source applications
^^^^^^^^^^^^^^^^^^^^^^^^^^

For closed source applications, you can use :ref:`appimage-creation-tools` to create a yml recipe that can be used to convert the existing Linux binaries into an AppImage.

Note that you may not be allowed to redistribute the AppImage of the application. In this case, you can distribute :code:`.yml` recipes that end users can use to produce their own AppImages of the application easily. This applies to applications such as Google Chrome, Spotify, Skype, and others.
