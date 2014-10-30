GoogleGenomics  |Build Status|_
==============================

.. |Build Status| image:: http://img.shields.io/travis/googlegenomics/api-client-r.svg?style=flat
.. _Build Status: https://travis-ci.org/googlegenomics/api-client-r

.. role:: r(code)
   :language: r

api-client-r
========

This R client fetches data from the `Google Genomics API`_ and turns it into a
GAlignments object provided by the `GenomicRanges package`_.

This GAlignments object is then plotted using `ggbio`_ - but it can also be
integrated with any of the other R packages that supports GAlignments or GRanges.

.. _Google Genomics API: https://developers.google.com/genomics
.. _GenomicRanges package: http://master.bioconductor.org/packages/release/bioc/html/GenomicRanges.html
.. _ggbio: http://master.bioconductor.org/packages/release/bioc/html/ggbio.html

Getting started
---------------

* First you'll need to setup an `R environment <http://www.r-project.org/>`_.

* Then you'll need a valid client ID and secret. Follow the `sign up
  instructions <https://developers.google.com/genomics>`_.
  Download the JSON file, or note down the ``Client ID`` and
  ``Client secret`` values.

* To install the developer version of this package::

.. code:: r

  source("http://bioconductor.org/biocLite.R")
  biocLite()
  options(repos=biocinstallRepos())
  install.packages("devtools")
  devtools::install_github("googlegenomics/api-client-r")
  library(GoogleGenomics)

After loading the package, the function :r:`authenticate` needs to be called once.  Alternatively, the following can be placed in `.Rprofile`
```
setHook(packageEvent("GoogleGenomics", "attach"), function(...) {
  GoogleGenomics::authenticate(file="YOUR/PATH/TO/client_secrets.json")
})
```

See the following examples for more detail:
* [Working with Reads](./inst/doc/PlottingAlignments.md)
* [Working with Variants](./inst/doc/VariantAnnotation-comparison-test.md)
* and also the [integration tests](./tests)

Shiny
-----

Inside of the `shiny` directory, the genomics-api.R file has
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
This project is in active development - the current code is very minimal and
a lot of work is left. See GitHub issues for more details.
