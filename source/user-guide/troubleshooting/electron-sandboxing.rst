I have issues with Electron-based AppImages and their sandboxing
================================================================

AppImages based on `Electron <https://www.electron.build/>`__ require the kernel to be configured in a certain way to allow for its sandboxing to work as intended (specifically, the kernel needs to be allowed to provide "unprivileged namespaces"). Many distributions come with this configured out of the box (like `Ubuntu <https://ubuntu.com>`__ prior to `24.04 <https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890#unprivileged-user-namespace-restrictions-15>`__), but some do not (for example `Debian <https://debian.org>`__).

This page explains how to check your kernel configuration and change it for Electron AppImages to work on your system. If an AppImage suffers from this issues, you should ask the developers to implement the workaround described in :ref:`this section <electron_without_sandboxing>` so this won't be a problem for other users in the future anymore.

.. warning::
   Please note that the AppImage team does not provide any guarantees that enabling this kernel feature is secure and safe. If in doubt, you should contact your distribution first. If they enable it securely by default, all users can benefit from this feature.

.. contents:: Contents
   :local:
   :depth: 2


Check if the kernel is configured correctly already
---------------------------------------------------

To check if your distribution has unprivileged namespaces enabled, please run::

   > sysctl kernel.unprivileged_userns_clone
   kernel.unprivileged_userns_clone = 1


This command does not need to be run as ``root``.

A ``1`` means that the unprivileged namespaces are already enabled, and you do not have to take any action.
A ``0`` indicates that the feature is available, but not enabled at the moment. Please see the following sections on how to enable it.


.. _electron-configure-sandboxing:

Configure unprivileged sandboxes
--------------------------------

To temporarily (until the system is rebooted) enable unprivileged namespaces, you can run this command::

   sudo sysctl -w kernel.unprivileged_userns_clone=1

You can run the same command, swapping the ``1`` for a ``0``, to disable it again.


To permanently enable the feature, you should create a new file with this setting in ``/etc/sysctl.d/``. You can do that by using the following command::

   echo "kernel.unprivileged_userns_clone = 1" > /etc/sysctl.d/enable-unprivileged-namespaces.conf

.. note::
   This command will take effect after the next reboot. To change this on a running system, please refer to the :ref:`previous section <electron-configure-sandboxing>`.


.. _electron_without_sandboxing:

Allow Electron AppImages to run without unprivileged namespaces
---------------------------------------------------------------

`@gergof <https://github.com/gergof>`_ made a tool that automatically applies the ``--no-sandbox`` flag when the ``unprivileged_userns_clone`` kernel feature is not enabled: https://www.npmjs.com/package/electron-builder-sandbox-fix


More information on unprivileged namespaces
-------------------------------------------

For more information on unprivileged namespaces, see https://lwn.net/Articles/673597/.
