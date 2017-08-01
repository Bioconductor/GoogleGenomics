GoogleGenomics with gRPC
========================

.. role:: r(code)
   :language: r

.. role:: sh(code)
   :language: sh

`gRPC`_ is an RPC framework designed to be performant for large streams of data
exchanges with remote services. The framework also allows for easy service
definition in the form of protocol buffers.

Google Genomics API offers gRPC endpoints and recommends using streaming method
equivalents for large streams of reads and variants. With streaming gRPC, there
is no need for paginated responses, and the entire data range is received as
part of one response.

.. _gRPC: https://grpc.io/
.. _Homebrew: https://brew.sh/

Installing
----------

Windows
  This R package currently does not have support for gRPC in Windows.

MacOS
  Our recommendation is to use the `Homebrew`_ package manager to install gRPC
  and all dependencies. Once Homebrew is set up, you can install gRPC by

  :sh:`brew install grpc`

Linux
  Install from source (see below).

Source
  You may need these prerequisites to install from source:

  .. code:: sh

    [sudo] apt-get install build-essential autoconf libtool
    
  Download the current release version of gRPC and install with the included
  SSL libraries. Using the system SSL libraries may not work for you if your
  particular version has not been tested with gRPC.

  .. code:: sh

    git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
    cd grpc
    git submodule update --init
    [sudo] make HAS_SYSTEM_OPENSSL_NPN=false HAS_SYSTEM_OPENSSL_ALPN=false install
    [sudo] make -C third_party/protobuf install


R Package setup
---------------

The R package will look for gRPC libraries during the package configuration
step. Be sure to select :r:`type="source"` when running :r:`biocLite` or
:r:`install.packages`.

The package will search in standard locations, and use the :sh:`pkg-config`
tool, if available on your machine, to get the parameters. If unable to find,
you will need to specify the path manually. For example, if your install
location is :sh:`/opt/local/`:

.. code:: r

  biocLite("GoogleGenomics", type="source",
           configure.args=paste("--with-grpc-include='/opt/local/include'",
                                "--with-grpc-libs='/opt/local/lib'",
                                "--with-grpc-bin='/opt/local/bin'"))

Or from github:

.. code:: r

  devtools::install_github("Bioconductor/GoogleGenomics", force=TRUE,
      args=paste0("--configure-args='",
                  "--with-grpc-include=/opt/local/include ",
                  "--with-grpc-libs=/opt/local/lib ",
                  "--with-grpc-bin=/opt/local/bin'"))

You can also use the environment variables :sh:`GRPC_INCLUDE_PATH`,
:sh:`GRPC_LIBS_PATH` and :sh:`GRPC_BIN_PATH` to specify the same parameters
as above.

Usage
-----

You can use the :r:`callGRPCMethod` method to call any Google Genomics v1 API
method. The request parameters can be supplied as a json string, in which case
the response will also be returned as a json string. The other option is to
use an :r:`RProtoBuf` message suitably modified to contain the request
parameters; use the :r:`getRProtoBufDefaultObject` method to get a default
instance that you can modify. The response will be an :r:`RProtoBuf` object.

The :r:`getReads` and :r:`getVariants` methods will default to using gRPC
streaming methods if the package could find gRPC libraries when installing 
itself. The default behavior can be controlled by the option
:r:`google_genomics_use_grpc`.


Limitations
-----------

- For Google Genomics API, the set of fields returned might be different with
  gRPC but all essential fields should be present in both methods, and will
  have the same names.

- API key mode of authentication does not work with gRPC.

