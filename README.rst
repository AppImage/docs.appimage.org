AppImage docs
=============

.. image:: https://github.com/AppImage/docs.appimage.org/workflows/CI/badge.svg
   :alt: CI status
   :target: https://github.com/AppImage/docs.appimage.org/actions

This repository is the home of the AppImage project documentation. This documentation is the central source of information for both AppImage developers and users.

You can view it at https://docs.appimage.org/.


Build
-----

This is a `Sphinx <https://sphinx-doc.org>`_ project, and can be built like any other Sphinx project. If you have never used Sphinx before, this section explains how it can be set up and built.

Convenience script
++++++++++++++++++

The easiest way to set up this project and build the documentation is to use the included convenience script ``make.sh``:

.. code-block:: shell

   # Clone the project
   git clone https://github.com/AppImage/docs.appimage.org.git
   cd docs.appimage.org

   # Set up and build the documentation
   make.sh html

Calling make.sh will build the documentation after setting up the project and everything required to build the documentation (such as creating a Python virtual environment and installing the dependencies in it). It will only perform the preparation steps that haven't been done before, so you can simply call it each time you want to re-build the documentation.

**Live reloading:** You can use ``make.sh watch`` instead of ``make.sh html`` |live_reloading|

Manually
++++++++

If you want to set up the project and build the documentation manually, you can use the following commands. (The ``make.sh`` script does essentially the same, just with additional tests whether these preparation steps have already been done before.)

.. code-block:: shell

   # Clone the project
   git clone https://github.com/AppImage/docs.appimage.org.git
   cd docs.appimage.org

   # Create and activate a Python virtual environment
   mkdir venv
   python3 -m venv venv
   source venv/bin/activate

   # Install the required dependencies into the venv
   pip3 install -r requirements.txt

   # Build the documentation
   make html

After that, you can rebuild the documentation simply with ``make html`` (although you have to execute ``source venv/bin/activate`` before that in every new terminal session).

**Live reloading:** You can use ``make watch`` instead of ``make html`` |live_reloading|


.. |live_reloading| replace:: to set up a live-reloading webserver that automatically rebuilds the documentation and reloads the page in the browser on any change. (This is powered by `sphinx-autobuild <https://github.com/GaretJax/sphinx-autobuild>`_.)
