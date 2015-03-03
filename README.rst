GoogleGenomics  |Build Status|_
==============================

.. |Build Status| image:: http://img.shields.io/travis/googlegenomics/api-client-r.svg?style=flat
.. _Build Status: https://travis-ci.org/googlegenomics/api-client-r

.. role:: r(code)
   :language: r

api-client-r
========

This R client fetches reads and variants data from the `Google Genomics API`_
and provides converters to obtain `BioConductor`_ S4 classes like GAlignments,
and GRanges and VRanges.

.. _Google Genomics API: https://developers.google.com/genomics
.. _BioConductor: http://www.bioconductor.org/

Getting started
---------------

* First you'll need to setup an `R environment <http://www.r-project.org/>`_.

* Then you'll need valid credentials. Follow the `sign up
  instructions <https://developers.google.com/genomics>`_.
  Download the JSON file for the native app or the service account, or note
  down the ``Client ID`` and ``Client secret`` values for the native app. If
  you only want to access public data, you can simply use the public API key.

* To install the developer version of this package::

.. code:: r

  source("http://bioconductor.org/biocLite.R")
  biocLite() # Make sure you are using BioConductor version 3.0 or above.
  options(repos=biocinstallRepos())
  install.packages("devtools")
  devtools::install_github("googlegenomics/api-client-r")
  library(GoogleGenomics)

After loading the package, the function :r:`authenticate` needs to be called once.

See the following examples for more detail:

* `Working with Reads <./inst/doc/PlottingAlignments.md>`_

* `Working with Variants <./inst/doc/VariantAnnotation-comparison-test.md>`_

* and also the `integration tests <./tests/testthat>`_

Shiny
-----

Inside of the `shiny` directory, some basic functionality has
been turned into a Shiny app. You can view the hosted version of the
application on shinyapps.io:

http://googlegenomics.shinyapps.io/reads

See the `README <https://github.com/googlegenomics/api-client-r/tree/master/shiny>`_ for more information.


Project status
--------------

Goals
~~~~~
* Provide an R package that hooks up the Genomics APIs to all of the other
  great existing R tools for biology. This package should be consumable by
  R developers.
* In addition, for non-developers, provide many Read and Variant analysis
  samples that can easily be run on API data without requiring a lot of prior
  biology or cs knowledge.


Current status
~~~~~~~~~~~~~~
This project is in active development - the current code is for a minimum viable package.
See GitHub issues for more details.
