C++ library for Google Genomics
===============================

This directory contains the C++ code for this R package. Almost all the code here is to bind into
the gRPC C++ stubs for Google Genomics API.

Code Organization
-----------------

google/
  This directory contains the protocol buffer files for Google Genomics and dependencies. They were
  copied as-is from the `googleapis repo <https://github.com/googleapis/googleapis>`_ with the same 
  directory structure. If you are updating the protocol buffer files, please only copy the files 
  needed by the genomics API as otherwise it increases the package compilation time. If there are 
  new methods, then the corresponding client-\*.cc file will need to add that method, and the method
  will need to be registered in init.cc.

client-common.*
  These files contain utility functions, templated functions, and macros to interface any given 
  C++ stub method with an R object that is either a JSON string or an RProtoBuf object. It also
  handles passing authentication to gRPC from the R package.

client-\*.cc
  These are Genomics API services that have a macro each for each service method. The macros will 
  check if this is a paginated RPC or not, and handle accordingly.

init.*
  Package initialization and visible method registration. Any new C++ method to be made visible to R
  code (including new service methods) will need to be registered here.

rprotobuf.*
  Methods to wrap and unwrap RProtoBuf objects, and create a new RProtoBuf object using the
  descriptor pool of this shared library. RProtoBuf shared library that is loaded when the RProtoBuf
  package is loaded will not be able to search genomics protocol buffer names as each shared
  library has its own internal descriptor pool.
