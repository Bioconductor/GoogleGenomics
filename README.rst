GoogleGenomics  |Build Status|_
===============================

.. |Build Status| image:: http://img.shields.io/travis/Bioconductor/GoogleGenomics.svg?style=flat
.. _Build Status: https://travis-ci.org/Bioconductor/GoogleGenomics

.. role:: r(code)
   :language: r

.. role:: sh(code)
   :language: sh

This R client fetches reads and variants data from the `Google Genomics API`_
and provides converters to obtain `Bioconductor`_ S4 classes like GAlignments,
and GRanges and VRanges.

.. _Google Genomics API: https://cloud.google.com/genomics
.. _Bioconductor: http://www.bioconductor.org/
.. _gRPC: https://grpc.io/
.. _Homebrew: https://brew.sh/

Installing
----------

Use the Bioconductor repositories to install this package.

If you have `gRPC`_ installed, you will be able to access the entire v1
Google Genomics API through the :r:`callGRPCMethod` function provided in
the package. Without gRPC support, you will still be able to query reads
and variants; see the vignettes for sample usage.

The set of fields returned might be different with gRPC but all essential
fields should be present in both methods, and will have the same names.

There is no gRPC support available for Windows currently.

* [Optional] Installing gRPC

  For MacOS with the `Homebrew`_ package manager system set up, you can simply
  use :sh:`brew install grpc`. No additional steps are needed and you can skip
  to installing the R package.

  For installing from source for all platforms, please refer to
  `these instructions <https://github.com/grpc/grpc/blob/master/INSTALL.md>`_.
  Also make sure to install the latest protobuf libraries from within the grpc
  source code directory by:

  :sh:`make -C third_party/protobuf install`

  Be sure to select :r:`type="source"` when installing the R package below.
  Depending on your gRPC and protobuf install location, you may need to
  specify the path manually (or install :sh:`pkg-config` on your system,
  so we can ask it where the files are located).
  For example, if your install location is :sh:`/opt/local/`:

  .. code:: r

    biocLite("GoogleGenomics", type="source",
             configure.args=paste("--with-grpc-include='/opt/local/include'",
                                  "--with-grpc-lib='/opt/local/lib'"))

  Or from github:

  .. code:: r

    devtools::install_github("Bioconductor/GoogleGenomics", force=TRUE,
        args=paste0("--configure-args='",
                    "--with-grpc-include=/opt/local/include ",
                    "--with-grpc-lib=/opt/local/lib'"))

* Installing R package

  .. code:: r

    source("http://bioconductor.org/biocLite.R")
    useDevel(TRUE) # Skip this step if you do not want the devel version.

    biocLite("GoogleGenomics")  # If gRPC is not installed.
    biocLite("GoogleGenomics", type="source")  # If gRPC is installed.
    library(GoogleGenomics)

Authentication
--------------

Call :r:`authenticate` to set up credentials. Check the function
documentation for details on various available options. The function will
return :r:`TRUE` on successful authentication.

Examples
--------

See the following examples for more detail:

* `Working with Reads <http://bioconductor.org/packages/devel/bioc/vignettes/GoogleGenomics/inst/doc/PlottingAlignments.html>`_

* `Working with Variants <http://bioconductor.org/packages/devel/bioc/vignettes/GoogleGenomics/inst/doc/AnnotatingVariants.html>`_

* `Variant Annotation Comparison Test <http://bioconductor.org/packages/devel/bioc/vignettes/GoogleGenomics/inst/doc/VariantAnnotation-comparison-test.html>`_

* and also the `integration tests <./tests/testthat>`_

Project status
--------------

The package is integrated with gRPC when available on the system where the
package was built. With gRPC support, the entire v1 API is accessible.
Without gRPC support, this package can be used to search for reads and
variants, and convert them to various Bioconductor formats.
