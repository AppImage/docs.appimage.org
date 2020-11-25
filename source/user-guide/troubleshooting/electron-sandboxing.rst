.. _ref-troubleshooting-electron:

I have issues with Electron-based AppImages and their sandboxing
================================================================

AppImages based on `Electron <https://www.electron.build/>`__ require the kernel to be configured in a certain way to allow for its sandboxing to work as intended (specifically, the kernel needs to be allowed to provide "unprivileged namespaces"). Many distributions come with this configured out of the box (like `Ubuntu <https://ubuntu.com>`__ for instance), but some do not (for example `Debian <https://debian.org>`__).

.. warning::

   Please note that the AppImage team does not provide any guarantees that enabling this feature is secure and safe. If in doubt, you need to contact your distribution first. If they enable those securely by default, all users can benefit from this feature.


Check if kernel is configured correctly already
-----------------------------------------------

To check if your distribution has unprivileged namespaces enabled, please run::

   > sysctl kernel.unprivileged_userns_clone
   kernel.unprivileged_userns_clone = 1

A ``1`` means that the unprivileged namespaces are enabled already, and you do not have to take any action.
A ``0`` indicates that the feature is available, but not enabled at the moment. Please see the following sections on how to enable it.

.. note::

   The command does not need to be run as ``root``.


.. _ref-electron-sandboxing-configure-temporarily:

Configure unprivileged sandboxes
--------------------------------

To temporarily enable unprivileged namespaces, you can run this command::

   sudo sysctl -w kernel.unprivileged_userns_clone=1

You can run the same command, swapping the ``1`` for a ``0``, to disable this again.


To permanently enable the feature, it is recommended to create a new file in ``/etc/sysctl.d/``. For your convenience, we have prepared the following command which creates the file on the fly::

   echo kernel.unprivileged_userns_clone = 1 | sudo tee /etc/sysctl.d/00-local-userns.conf

.. note::

   This command will take effect only on the next reboot. To change this on a running system, please refer to the :ref:`previous section <ref-electron-sandboxing-configure-temporarily>`.



More information on unprivileged namespaces
-------------------------------------------

For more information on unprivileged namespaces, please see https://lwn.net/Articles/673597/.
