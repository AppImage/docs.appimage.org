Motivation & Advantages
=======================

Traditionally, applications have been installed on Linux systems by using the package manager that comes with the Linux distributions. However, this model has numerous disadvantages for users, developers, software testers and system administrators.

This chapter explains the advantages of the AppImage format and compares it with traditional packet managers out of the perspective of all these groups of people.

.. contents:: Contents
   :local:
   :depth: 1


Advantages for users
--------------------

Consider the following user stories:

   "I, as a user, want to run the latest version of my favorite app on my stable distribution, which ships only with an old outdated version."

   "I, as a user, need to use multiple versions of an application in parallel."

   "I, as a user, want to take my favorite applications with me on a portable disk together with my data, allowing me to use any Linux computer to work with my files."

   "I am in a corporate or university environment and want to simply run some specific software, but lack permissions to 'install' applications."

All these use cases can be accomplished by using AppImages:

| While the traditional way of using the distribution's package manager often locks the user into a set of applications that was recent at the point when the operating system was released, using AppImages allows the user to always download and run the latest applications whenever they appear.
| And since AppImages are independent from each other and package all dependencies, the user can also try out several versions of an application in parallel, or use one in :ref:`portable mode <portable-mode>` on a USB drive.
| Additionally, AppImages are designed from the ground to run without super user permissions. Almost all major distributions are compatible with AppImages, without requiring the user to make any modifications to the base system. AppImages ship with their own runtime, and don't require external resources if packaged properly.

Therefore, AppImages provide a simple user experience which guarantees that even less tech-savvy people can get started without any major issues. AppImage is primarily a user-focused way of bundling software.

And as AppImage has been around for a while, a lot of useful, optional features have been developed, ranging from :ref:`efficient updates <updates-user>` over so-called :ref:`desktop integration <desktop-integration>` to :ref:`software catalogs <software-catalogs-user>`. None of these are required for the basic experience, though. AppImages are designed to :ref:`be run in three steps at most <how-to-run-appimage>`.


Advantages for developers & application authors
-----------------------------------------------

Consider the following problems a developer might face when trying to distribute their project with the distribution package managers:

   .. raw:: html

      To reach all Linux users, the developer has to package the application for each distribution individually accordingly to their rules, which is a lengthy and time-consuming process.
      <details>
      <summary><a>Why is the packaging for every distribution different?</a></summary>

   .. note::
      Linux is just the kernel, but the operating systems users run are separate projects with different goals and concerns. They all ship with different versions and combinations of certain libraries, and most of them require software to be linked to the binaries in the distribution. Therefore, in order to be able to run a certain binary, that binary must be compiled *against* the distribution's set of libraries. As soon as another distribution's collection of libraries is not the same as the one the binary was built on, it might crash or even refuse to run.

      Additionally, different distributions have very different rules for packaging applications. This means that if an author successfully packaged an application according to the rules of one distribution, it may well not be suitable for inclusion in another distribution.

   .. raw:: html

      </details><p></p>

   After the developer gets the application into a Linux distribution, it will only appear in the soon-to-be-released version of that Linux distribution, which means that all the currently existing users using older versions of the Linux distribution are left out in the cold.

   If a third party (the distribution's "maintainer") packages the application for inclusion in the distribution, the third party may make unintended changes to the application not authorized by the developer.

   | Some developers want to be in control over who downloads what and when. For example, the developer may require a payment, ask for a donation, or want users to fill out a survey before downloading the application. The developer may also want to count the number of downloads.
   | This is not possible in the traditional Linux distribution model.

   Some applications require certain versions of dependencies in order to function properly. In the traditional Linux distribution model, an application has to use whatever version of a library the distribution happens to provide, which can lead to unexpected issues.


All these issues are solved when using AppImages to package the application:

| The AppImage is independent from the distribution and has to be packaged just once, not for every distribution individually like for their packet managers. It can then be downloaded and run by every user and not only after their distribution has been updated.
| And as AppImages follow the philosophy of :ref:`upstream packaging <upstream-packaging>`, no third party can make any changes to the applications that aren't intended by the original developer. Instead, the developer can exactly control who can download it under which condition.
| As the AppImage contains exactly the versions of dependencies that are required, no version mismatch issues occur when using it either.

.. note::
   These issues can all be accomplished using tarballs that contain all libraries (except :ref:`lowest-level ones that usually shouldn't be shipped <exclude-expected-libraries>`), and maybe some sort of "run script" that makes sure only those libraries are used.
   However, this is not user-friendly as the user has to know how to actually run the software and manage it as a folder of dependencies on their hard-drive.

   AppImages pursue the same idea (bundling the application, their dependencies and runtime resources), but improves the user-experience as they're single binaries that can easily be executed just by double clicking, following the ":ref:`one app = one file <one-app-one-file-principle>`" core principle.

Making AppImages is very simple for a developer. There are different :ref:`tools <appimage-creation-tools>` that help with generating AppImages and even creating AppImages from existing packages, which are aware of potential cross distro incompatibilities, and try to avoid them. And once the AppImage has been built, it will "just run" on all major desktop distributions.


Advantages for software testers
-------------------------------

Successful application projects run a lot of tests. Whereas some tests may be automated, manual tests are always important to ensure both functionality and usability. In regression testing, different versions of an application are compared to each other, concerning features and bugs. AppImage makes it easy to conduct application tests on local machines, since it allows to run various different versions of applications alongside each other. With :ref:`portable mode <portable-mode>`, it is also possible to isolate the settings of each version of the application from each other, allowing for clean testing environments.

The `LibreOffice <https://www.libreoffice.org/download/appimage/>`_ project, for example, uses AppImages to test new application versions.


Advantages for system administrators
------------------------------------

System administrators in corporate, educational or institutional settings usually need to support a large number of desktop systems, where they either need to lock down the system so that users cannot make changes such as application installations, or need to find a way to leave the base system supportable while users can run applications on top.

AppImages provide an elegant solution here: Since the core operating system is not changed through the installation of applications, the system stays pristine and supportable no matter what kind of applications end users run on the system. Users are happy because they can run their favorite applications without having to ask a system administrator to install them. System administrators are happy because they have less work.
