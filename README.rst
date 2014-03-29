client-r
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

* Then you'll need a valid client ID and secret. Follow the `authentication
  instructions <https://developers.google.com/genomics#authenticate>`_,
  but instead of downloading the JSON file, you'll pass the ``Client ID`` and
  ``Client secret`` values into the setup function.

* In an R interpreter::

    source("/path/to/genomics-tools/client-r/genomics-api.R")
    setup("<client ID>", "<client secret>")
    getReadData()

``setup`` only needs to be run once. After it has been called, ``getReadData``
can then be run repeatedly. It fetches data from the API
and can be used to search over any set of reads. You can pull up a different
sequence position by specifying additional arguments::

  getReadData(chromosome="chr3", start="121458049", end="121459049")

Or, you can use the ``readsetId`` argument to query a different readset entirely::

  getReadData(readsetId="<myreadset>")

Both ``reads`` and ``alignments`` are exported as global variables so that you
can use other `Bioconductor <http://www.bioconductor.org/>`_ tools to modify the
data as you wish.
