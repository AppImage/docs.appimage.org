AppImage advantages
===================

.. todo::

   The structure and purpose of this page is very similar to :ref:`motivation`. These two pages should be merged.

This chapter compares AppImage with traditional application packaging formats on Linux and explains the advantages of the AppImage format. You can skip this chapter if you already know why AppImages are useful.

Traditionally, applications have been installed on Linux systems by using the package manager that comes with the Linux distribution. However, this model does not scale well for long-tail applications, applications that are only used by a few users, or in cases where users want to use the very latest applications immediately after they are published by their developers. It also is very cumbersome for application developers that want to reach a large audience quickly.


.. contents:: Contents
   :local:
   :depth: 1


Advantages for users
--------------------

On the desktop, users are used to installing an operating system, using that operating systems for many years, and running the most recent applications whenever they feel like it. However, many Linux distributions restrict the availability of applications to those that were already published at the point in time when the Linux distribution was published. This effectively means that if the user wants to use a stable operating system, then the user is locked into a set of applications that was recent at the point when the operating system was released. While this may be reasonable for enterprise-critical applications or server side processes, it is not the model users expect from a desktop operating system.

So-called "rolling release" distributions exist that provide latest versions of software. However, they make no distinction between the core operating system and applications. So, with a "rolling release" distribution users don’t only get the latest applications, but also an ever-changing base system. While this may be suitable for hobbyists and technology enthusiasts, it is hardly suitable for productive use where the base system has to be supportable.

The combination of a long-term stable base operating system with the latest applications delivered in AppImage format can provide an elegant solution to this dilemma. While the base operating system can stay stable and only change every few years, users can download and run the very latest applications whenever they appear.

AppImage also makes it easy to try out new versions of applications. Since versions can exist alongside each other, the user can simply download a new version of an application and try it out. If the new version proves to be superior, the user can then delete the old version and work with the new one. However, should the new version have bugs or be otherwise unusable, the user can simply delete the new version and continue using the old version. This is also very useful for testing nightly or continuous builds and for giving feedback to the application development team.


Advantages for system administrators
------------------------------------

System administrators in corporate, educational or institutional settings usually need to support a large number of desktop systems, where they either need to lock down the system so that users cannot make changes such as application installations, or need to find a way to leave the base system supportable while users can run applications on top.

AppImages provide an elegant solution here: Since the core operating system is not changed through the installation of applications, the system stays pristine and supportable no matter what kind of applications end users run on the system. Users are happy because they can run their favorite applications without having to ask a system administrator to install them. System administrators are happy because they have less work.


Advantages for application authors
----------------------------------

Application authors may want to reach as many users as possible, regardless of the operating system and version users are running.  With the traditional model, application authors either need to get their application into Linux distributions by creating packages according to the rules of distributions, which can be a lengthy and time-consuming process, or need to find someone who creates the application package for them. It does not help that different Linux distributions have very different rules for packaging applications. This means that if an author is successful to package an application according to the rules of one distribution, it may well not be suitable for inclusion in another distribution. In any case, it is not a quick and easy operation to get a new application into every Linux distribution. And even if an author gets an application into a Linux distribution, it will only appear in the soon-to-be-released version of that Linux distribution, which means that all the currently existing users using older versions of the Linux distribution are left out in the cold.

If a third party (the distribution's "maintainer") packages the application for inclusion in the distribution, the third party may make unintended changes to the application not authorized by the original author. This has led to some application authors to ask Linux distributions to no longer distribute their software because they did not like the changes.

Some developers do not want their applications to be distributed randomly, but be in full control over who downloads what and when. For example an application author may want users to fill in a survey before downloading the application. Also, the author may want to count the number of downloads.  In other cases still, the application author may want to ask for a donation or even a required payment before the user can download the application through services such as Gumroad, PayPal, or Patreon. In the traditional Linux distribution model, this is not possible.

Providing an AppImage solves these kinds of issues, since the application author is in full control over the application distribution and the user experience connected to it.

Some applications require certain versions of dependencies in order to function properly. For example, an application may run only on a certain version of the Qt framework and may run into unexpected issues if another version is used. In the traditional Linux distribution model, an application has to use whatever version of a library the Linux distribution happens to provide, whereas with AppImage, the application author can exactly decide which version of a dependency should be used by the application.


Advantages for software testers
-------------------------------

Successful application projects run a lot of tests. Whereas some tests may be automated, manual tests are always important to ensure both functionality and usability. In regression testing, different versions of an application are compared to each other concerning features and bugs. AppImage makes it easy to conduct application tests on local machines, since it allows to run various different versions of applications alongside each other. With :ref:`portable mode <portable-mode>`, it is also possible to isolate the settings of each version of the application from each other, allowing for clean testing environments.

The LibreOffice_ project, for example, uses AppImages to test new application versions.

.. _LibreOffice: https://www.libreoffice.org/download/appimage/
