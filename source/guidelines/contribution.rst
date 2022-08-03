Contribution guidelines
=======================

Step 1: Fork the repository
---------------------------

Only necessary if planning to modify code from other repositories. The policy is to fork (or private clone) all external repositories that we use. To fork an repository, click on the Button **Fork** on the Github repository page.

Step 2: Clone the repository
----------------------------

.. code-block:: sh

   git clone git@github.com:BeagleSystems/REPOSITORY_NAME

If creating a private clone from some other repository, please create a new repository under BeagleSystems with the same repository name. Then proceed by uploading the cloned code to the new url to the develop branch.

.. code-block:: sh

   git clone git@github.com:ORIGINAL_OWNER/REPOSITORY_NAME
   git remote set-url origin git@github.com:BeagleSystems/REPOSITORY_NAME
   git checkout -b develop
   git push -u origin develop

Step 3: Initialize git-flow
---------------------------

.. code-block:: sh

   git flow init

Please make sure that the branch name for production releases is `master` and the branch name for development is `develop`!

Step 4: Make changes and push code
----------------------------------

If you would like to fix issues, please use issue number as feature branch name.

.. code-block:: sh

   git flow feature start <name of your feature>
   # code your changes
   git add .
   git commit -m "<describe your changes as well as possible!>"
   git flow feature publish <name of your feature>
   # if adding more changes:
   git add .
   git commit -m "<describe your changes as well as possible!>"
   git push

Step 5: Create a pull request on Github
---------------------------------------

After publishing the feature, make sure to create a pull request. Go to https://github.com/BeagleSystems/REPOSITORY_NAME/compare and compare your feature branch to the develop branch and create a pull request. Be as descriptive as possible on how to use your features, which setup steps are necessary and any test flight/simulation logs!

Please make sure that you ALWAYS create pull request for the `develop` branch. Pull requests to the `master` branch will be closed.

The only exception are `hotfix` branches which are fixing critical bugs on the existing release.


Step 6: Review the pull request
-------------------------------

The lead developers of the module have to review the pull request by going through the single commits. If the pull request is acceptable, they either rebase or squash (if too many commits) the pull request in the code base of the respective module.
