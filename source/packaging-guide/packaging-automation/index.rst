Packaging automation
====================

Packaging an Application is a repetitive effort. Once you packaged the application, you need to do the same for every new version you release. Depending on the :ref:`chosen AppImage creation method <appimage-creation-tools>`, this might be executing a list of several specific commands. Always manually entering them to build your AppImage is a bad idea: You might forget something or mix something up and produce a flawed AppImage, or even forget how to do it alltogether.

So, to avoid this, it's (obviously) better to write down the list of commands and create a (usually shell) script which builds the AppImage when executed. However, you still have to manually build your application and then execute the script for every new version, which is an (unnecessary) repetitive effort.

The solution to this is packaging automation. This means connecting a system (a so-called CI pipeline) to your repository which then builds the AppImage on its own (e.g. for each tag, commit or at certain intervals). This also has the advantages of documenting exactly how your AppImages are built and making the process more transparent. Additionally, you can carry out tests on the pipeline to make sure the AppImage continues to work as expected.

There are many systems you can use, for example GitHub Actions, GitLab CI, Gitea CI, Travis CI, Jenkins, or the Open Build Service. This section explains how to use some of them.


GitHub Actions
--------------

GitHub Actions is now one of the most wildly used CI pipelines, mainly due to its very good integration with GitHub repositories and it being free to use (with a maximum number of minutes per month for private repositories). Therefore, it's the recommended CI pipeline. To start using GitHub Actions, read the `official guide <https://docs.github.com/en/actions/writing-workflows/quickstart>`__.

Often, it's easier to learn from examples and adapt them. To help starting with GitHub Actions, we provide an example on how to build an AppImage using GitHub Actions and :ref:`linuxdeploy`, which serves as a good starting point:

.. code-block:: yaml

    name: GitHub Actions Demo
    run-name: Package AppImage with linuxdeploy
    on: [push]
    jobs:
        create_tag:
            name: Create tag and release
            runs-on: ubuntu-latest
            outputs:
                tag_name: ${{ steps.create_tag.outputs.tag_name }}
            steps:
                - name: Clone repository
                  uses: actions/checkout@v4
                - name: Create tag and release
                  id: create_tag
                  run: |
                      tag_name="test-tag"
                      gh release create $tag_name --title "Test Release"
                      echo "tag_name=$tag_name" >> $GITHUB_OUTPUT
                  env:
                      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

        build_and_publish:
            name: Build and publish the application
            needs: create_tag
            runs-on: ubuntu-latest
            steps:
                - name: Clone repository
                  uses: actions/checkout@v4
                - name: Install project dependencies
                  run: |
                      apt update
                      apt install -y # Install your project dependencies
                - name: Build project
                  run: # Invoke your compiler, e.g. cargo for Rust or gcc / clang for C
                - name: Create AppImage
                  run: |
                      wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
                      chmod +x linuxdeploy-x86_64.AppImage
                      LINUXDEPLOY_OUTPUT_APP_NAME="MyApplication.AppImage" ./linuxdeploy-x86_64.AppImage -e my_application -d packaging/my_application.desktop -i packaging/my_application.png -a AppDir --output appimage
                - name: Upload AppImage
                  run: gh release upload "${{ needs.create_tag.outputs.tag_name }}" "MyApplication.AppImage"



Travis CI
---------

Travis CI is a historically important CI pipeline. It gained popularity as it was the first CI pipeline that was free to use for open source projects. However, since an acquisition in 2019, it no longer is, and **it's recommended to not use it anymore as CI pipeline**. `Existing users should migrate off of it, e.g. to GitHub actions. <https://earthly.dev/blog/migrating-from-travis/>`__


Open Build Service
------------------

The Open Build Service is another system that can be used to automate the packaging. It allows you to leverage the existing Open Build Service infrastructure, security and licence compliance processes. If you're already using the Open Build Service to build other packages, it makes most sense to use it for AppImages as well.

For more specific information on how to use the Open Build Service, see :ref:`open-build-service`.


.. _convenience-functions-script:

Convenience functions
---------------------

There is a collection of convenience functions in https://github.com/AppImage/pkg2appimage/blob/master/functions.sh. To use them in your own scripts, you need to source ``functions.sh`` like this:

.. code:: bash

   > wget -q https://github.com/AppImage/AppImages/raw/master/functions.sh -O ./functions.sh
   > . ./functions.sh

.. todo::
   Document the functions in ``functions.sh`` that are for public consumption based on comments in the file.


.. toctree::
   open-build-service
   :hidden:
   :maxdepth: 2
