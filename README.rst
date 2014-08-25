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
  We have currently only tested with R 3.0.3 and R 3.1.0. There are known issues
  in R 3.0.2.

* Then you'll need a valid client ID and secret. Follow the `sign up
  instructions <https://developers.google.com/genomics>`_,
  but instead of downloading the JSON file, you'll pass the ``Client ID`` and
  ``Client secret`` values into the setup function.

* In an R interpreter::

    source("/path/to/genomics-tools/client-r/genomics-api.R")
    setup("<client ID>", "<client secret>")
    getReadData()
    plotAlignments() # Plot basic alignment and coverage data 

:r:`setup` only needs to be run once. After it has been called, :r:`getReadData`
can then be run repeatedly. It fetches data from the API
and can be used to search over any set of reads. You can pull up a different
sequence position by specifying additional arguments::

  getReadData(chromosome="chr3", start="121458049", end="121459049")

Or, you can use the ``readsetId`` argument to query a different readset entirely::

  getReadData(readsetId="<myreadset>")

Both :r:`reads` and :r:`alignments` are exported as global variables so that you
can use other `Bioconductor <http://www.bioconductor.org/>`_ tools to modify the
data as you wish.

Troubleshooting
---------------
If the sample code does not work with R 3.0.3, please check that your :r:`sessionInfo()`
matches our testing environment.

.. code:: rconsole

  > sessionInfo()
  R version 3.0.3 (2014-03-06)
  Platform: x86_64-apple-darwin10.8.0 (64-bit)

  locale:
  [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

  attached base packages:
  [1] parallel  stats     graphics  grDevices utils     datasets  methods  
  [8] base     

  other attached packages:
   [1] Rsamtools_1.14.3     Biostrings_2.30.1    ggbio_1.10.16       
   [4] ggplot2_0.9.3.1      GenomicRanges_1.14.4 XVector_0.2.0       
   [7] IRanges_1.20.7       BiocGenerics_0.8.0   BiocInstaller_1.12.1
  [10] httr_0.3             rjson_0.2.13        

  loaded via a namespace (and not attached):
   [1] AnnotationDbi_1.24.0     Biobase_2.22.0           biomaRt_2.18.0          
   [4] biovizBase_1.10.8        bitops_1.0-6             BSgenome_1.30.0         
   [7] cluster_1.15.2           colorspace_1.2-4         DBI_0.2-7               
  [10] dichromat_2.0-0          digest_0.6.4             Formula_1.1-1           
  [13] GenomicFeatures_1.14.5   grid_3.0.3               gridExtra_0.9.1         
  [16] gtable_0.1.2             Hmisc_3.14-4             httpuv_1.3.0            
  [19] jsonlite_0.9.6           labeling_0.2             lattice_0.20-29         
  [22] latticeExtra_0.6-26      MASS_7.3-31              munsell_0.4.2           
  [25] plyr_1.8.1               proto_0.3-10             RColorBrewer_1.0-5      
  [28] Rcpp_0.11.1              RCurl_1.95-4.1           reshape2_1.2.2          
  [31] RSQLite_0.11.4           rtracklayer_1.22.7       scales_0.2.3            
  [34] splines_3.0.3            stats4_3.0.3             stringr_0.6.2           
  [37] survival_2.37-7          tcltk_3.0.3              tools_3.0.3             
  [40] VariantAnnotation_1.8.13 XML_3.95-0.2             zlibbioc_1.8.0 


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
a lot or work is left. See GitHub issues for more details.
