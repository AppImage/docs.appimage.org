.. _creating-appdir-structure:

Creating the AppDir structure
=============================

As seen in the :ref:`table comparing the different AppImage creation methods <comparison-table>`, some tools require you to create the AppDir structure and place files in it prior to invoking the tool. There are two ways to do this:

1. Manually creating the AppDir structure and copying files to their correct places
2. Using make (this only works if you use Makefiles to build the project)

This section explains both ways to do this.

Additionally, it explains how to manually package *everything*. This should only be used as a last resort if all other methods aren't applicable. Using one of the :ref:`appimage-creation-tools` is usually much more convenient. The main reason it's explained nevertheless is to illustrate how things work under the hood.

.. toctree::
   Manually <manually>
   Using make <make>
   Manually creating everything <manually-full>
   :caption: Contents:
   :maxdepth: 1
