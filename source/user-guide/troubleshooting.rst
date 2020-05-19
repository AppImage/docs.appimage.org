.. _ref-ug-troubleshooting:

Troubleshooting
===============

This page covers some of the most common problems with AppImages users might face, and provides solutions and links to external references. This page is not considered to be exhaustive. For additional help, please see the :ref:`Contact page <ref-contact>`.

.. note::

   If you as a user think there are errors on this page or you would like to have some additional problems covered, please do not hesitate to `create an issue <https://github.com/AppImage/docs.appimage.org/issues/new>`_ on `GitHub <https://github.com/AppImage/docs.appimage.org>`_ (or ideally send a pull request right away). We're always open for feedback!


I get some errors related to something called "FUSE"
****************************************************

AppImages require a Linux technology called *Filesystem in Userspace* (or short *FUSE*). The majority of systems ships with a working FUSE setup. However, sometimes, it doesn't quite work. This section explains a few solutions that fix the most frequently reported problems.

The AppImage tells me it needs FUSE to run
##########################################

Sometimes, an AppImage writes the following message to the console:

.. can not use :: syntax to highlight raw text blocks, as pygments usually recognizes some language even if there is no code
.. code-block:: text

   AppImages require FUSE to run.
   You might still be able to extract the contents of this AppImage
   if you run it with the --appimage-extract option.
   See https://github.com/AppImage/AppImageKit/wiki/FUSE
   for more information

In this case, FUSE is not properly set up on your system. You will have to :ref:`install FUSE <ref-install-fuse>` in order to fix the problem.

.. note::
   When trying to run AppImages which weren't built specifically for your platform, you might see this message as well, even if it doesn't occur while using AppImages built for your platform. Please see :ref:`these instructions <ref-warning-fuse-cross-architecture>` on how to fix the issue.

.. _ref-install-fuse:

Install FUSE
############

Most Linux distributions come with a functional FUSE setup. However, if it is not working for you, you may have to install and configure FUSE yourself.

The process of installing FUSE highly differs from distribution to distribution. This section shows how to install FUSE on the most common distributions.

.. note::
   If your distribution is not listed, please ask the distribution developers for instructions.

.. rubric:: Setting up FUSE on Ubuntu, Debian and their derivatives

Install the required package::

  > sudo apt-get install fuse

Now, FUSE should be working. On some older distributions, you will have to run some additional configuration steps:

Make sure the FUSE kernel module is loaded::

  > sudo modprobe -v fuse

Then, add the required group (should be created by the install command, if this is the case, this call *will* fail), and add your own user account to this group::

  > sudo addgroup fuse
  > sudo adduser $USER fuse

.. include:: notes/user-group-modifications.rst

.. rubric:: Setting up FUSE on openSUSE

Install the required package::

  > sudo zypper install fuse

FUSE should now be working.

.. rubric:: Setting up FUSE on CentOS and RHEL

.. note::
   The following instructions may be out of date. Contributions welcome!

Install FUSE from EPEL::

  > yum --enablerepo=epel install fuse-sshfs

Now, add yourself to the related group in order to authorize yourself for using FUSE::

  > usermod -a -G fuse $(whoami)

.. include:: notes/user-group-modifications.rst

.. _ref-warning-fuse-cross-architecture:
.. warning::
   If you are on a 64-bit system and want to run 32-bit AppImages (e.g., ``x86_64``/``amd64`` to ``i386``, or ``arm64`` to ``armhf``), you will have to install the FUSE runtime libraries for those architectures.::

     > sudo apt-get install libfuse2:i386
     > sudo apt-get install libfuse2:armhf

.. seealso::
   For more information on how AppImages use FUSE, please see :ref:`ref-fuse`.



.. _ref-troubleshooting-electron:

I have issues with Electron-based AppImages and their sandboxing
****************************************************

AppImages based on `Electron <https://www.electron.build/>`_ require the kernel to be configured in a certain way to allow for its sandboxing to work as intended (specifically, the kernel needs to be allowed to provide "unprivileged namespaces"). Many distributions come with this configured out of the box (like `Ubuntu <https://ubuntu.com>` for instance), but some do not (for example `Debian <https://debian.org>`).

.. warning::

   Please note that the AppImage team does not provide any guarantees that enabling this feature is secure and safe. If in doubt, you need to contact your distribution first. If they enable those securely by default, all users can benefit from this feature.


Check if kernel is configured correctly already
###############################################

To check if your distribution has unprivileged namespaces enabled, please run::

   > sysctl kernel.unprivileged_userns_clone
   kernel.unprivileged_userns_clone = 1

A ``1`` means that the unprivileged namespaces are enabled already, and you do not have to take any action.
A ``0`` indicates that the feature is available, but not enabled at the moment. Please see the following sections on how to enable it.

.. note::

   The command does not need to be run as ``root``.


.. _ref-electron-sandboxing-configure-temporarily:

Configure unprivileged sandboxes
################################

To temporarily enable unprivileged namespaces, you can run this command::

   sudo sysctl -w kernel.unprivileged_userns_clone=1

You can run the same command, swapping the ``1`` for a ``0``, to disable this again.


To permanently enable the feature, it is recommended to create a new file in ``/etc/sysctl.d/``. For your convenience, we have prepared the following command which creates the file on the fly::

   echo kernel.unprivileged_userns_clone = 1 | sudo tee /etc/sysctl.d/00-local-userns.conf

.. note::

   This command will take effect only on the next reboot. To change this on a running system, please refer to the :ref:`previous section <ref-electron-sandboxing-configure-temporarily>`.



More information on unprivileged namespaces
###########################################

For more information on unprivileged namespaces, please see https://lwn.net/Articles/673597/.

