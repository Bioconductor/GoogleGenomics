How to contribute
===================================

First of all, thank you for contributing!

The mailing list
----------------

For general questions or if you are having trouble getting started, try the
`Google Genomics Discuss mailing list <https://groups.google.com/forum/#!forum/google-genomics-discuss>`_.
It's a good way to sync up with other people who use googlegenomics including the core developers. You can subscribe
by sending an email to ``google-genomics-discuss+subscribe@googlegroups.com`` or just post using
the `web forum page <https://groups.google.com/forum/#!forum/google-genomics-discuss>`_.


Submitting issues
-----------------

If you are encountering a bug in the code or have a feature request in mind - file away!


Submitting a pull request
-------------------------

If you are ready to contribute code, Github provides a nice `overview on how to create a pull request
<https://help.github.com/articles/creating-a-pull-request>`_.

Some general rules to follow:

* Do your work in `a fork <https://help.github.com/articles/fork-a-repo>`_ of this repo.
* Create a branch for each update that you're working on.
  These branches are often called "feature" or "topic" branches. Any changes
  that you push to your feature branch will automatically be shown in the pull request.
* Keep your pull requests as small as possible. Large pull requests are hard to review.
  Try to break up your changes into self-contained and incremental pull requests.
* The first line of commit messages should be a short (<80 character) summary,
  followed by an empty line and then any details that you want to share about the commit.
* Please try to follow the existing syntax style.

When testing your changes, setup the environment variable GOOGLE_API_KEY to contain the public API
key from your Google Developer Console with the Genomics API enabled. This will enable the tests
and the vignettes to be run, which are otherwise short-circuited in the absence of auth credentials.
With the environment variable set, build the package and run checks as follows:

.. code:: sh

  export GOOGLE_API_KEY=<your public API key>
  R CMD build api-client-r
  R CMD check GoogleGenomics_<version>.tar.gz

Optionally, you can also enable Travis for your fork and set up the environment variable in your
`Travis settings <http://docs.travis-ci.com/user/environment-variables/#Using-Settings>`_ so that
these tests are run automatically whenever you push to your feature branch.

When you submit or change your pull request, the Travis build system will automatically build the
package and run standard tests. A pull request does not acquire secure environment variables and
will skip running unit tests and vignettes. If you set up Travis for your fork, a link to your
Travis build in the pull request will speed up the review process. If your pull request fails to
pass tests, review the test log, make changes and then push them to your feature branch to be tested
again.
