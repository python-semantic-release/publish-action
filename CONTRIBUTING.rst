Contributing
============

If you want to contribute that is awesome. Remember to be nice to others in issues and reviews.

Unsure about something? No worries, `ask a question`__.

__ https://github.com/python-semantic-release/publish-action/issues/new

Development Notes
=================

Building the Action Environment
-------------------------------

.. code:: bash

    docker build -t psr-publish-action:latest ./src

Local Testing
-------------

To test make sure to first build the action container with the appropriate tag. Then
run the tests with the following command:

.. code:: bash

    TEST_CONTAINER_TAG="psr-publish-action:latest" bash tests/run.sh

.. note::
    The tests will clean up after themselves with the ``--rm`` flag for the container
    run command and will automatically remove the test project directory on completion.
