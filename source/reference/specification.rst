.. _ref-appimage-specification:
.. _ref-specification:
.. _ref-spec:

AppImage specification
=======================

The AppImage project maintains a work-in-progress specification on the AppImage format.

Being designed as a standard with a reference implementation allows users to implement their own tools to build AppImages, and helps maintaining compatibility between different tools and components.


.. contents:: Contents
   :local:
   :depth: 1


Development
-----------

The specification's repository contains a description of the current **type 2** format. You can find the
`full text <https://github.com/AppImage/AppImageSpec/blob/master/draft.md>`_
in the `GitHub repository <https://github.com/AppImage/AppImageSpec/>`_.

The documentation receives updates regularly, e.g., to fix bugs or document new features. For type 2, a decision was made to not release specific versions but work with continuous releases. This implies there might be some AppImages that lack newer features because they're using an older runtime, etc. Backwards compatibility is maintained by the team in the reference implementation.

Please feel free to file `issues on GitHub <https://github.com/AppImage/AppImageSpec/issues>`_ if you encounter bugs or have ideas for additional features. Also, improvements on wording etc. are highly appreciated.


Reference implementation
------------------------

The project maintains a reference implementation of the standard which is called :ref:`ref-appimagekit`.
