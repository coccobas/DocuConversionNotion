Manage GIT repositories
=======================

https://gitolite.com/archived/special-branches.html
https://gitolite.com/archived/special-branch-fixups.html

How to do hotfixes
==================


.. code-block:: bash

    git checkout -b master
    git flow hotfix start 'name_of_the_problem'
    # do whatever is necessary to hotfix your problem
    git add .
    git commit -m "resolved name of the problem"
    git push -u origin name_of_the_problem

The following steps should be done by only one person. If multiple people would work on merging hotfixes at the same time, this could lead to conflicts.

.. code-block:: bash
    # wait for review. do NOT merge the PR after review
    git flow hotfix finish 'name_of_the_problem'

    # overwrite the previous version
    git tag -d v3.2.0
    git tag -a v3.2.0
    git push
    git push --tags -f
