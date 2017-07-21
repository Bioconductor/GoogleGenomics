AC_PREREQ(2.69)

AC_INIT([GoogleGenomics],[2.0.0]) dnl package name, version

dnl Find the compiler and compiler flags to use
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  AC_MSG_ERROR("could not determine R_HOME")
fi
CC=`"${R_HOME}/bin/R" CMD config CC`
CPP=`"${R_HOME}/bin/R" CMD config CPP`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
CXX=`"${R_HOME}/bin/R" CMD config CXX`
CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXXFLAGS`
LIBS=`"${R_HOME}/bin/R" CMD CONFIG LDFLAGS`

CPPFLAGS="${CPPFLAGS} -I."

AC_ARG_VAR(PROTO_HEADER_PATH, "Location of protobuf header files")

dnl Check for user supplied include paths, from a configure option or
dnl from an environment variable
AC_ARG_WITH([grpc-include],
            AC_HELP_STRING([--with-grpc-include=INCLUDE_PATH],
                           [the location of GRPC header files]),
            [grpc_include_path=$withval])
if test -n "$grpc_include_path"; then
  CPPFLAGS="${CPPFLAGS} -I${grpc_include_path}"
  PROTO_HEADER_PATH="-I${grpc_include_path}"
else
  if test -n "${GRPC_INCLUDE_PATH}"; then
    CPPFLAGS="${CPPFLAGS} -I${GRPC_INCLUDE_PATH}"
    PROTO_HEADER_PATH="-I${GRPC_INCLUDE_PATH}"
  fi
fi

dnl Same for library search paths
AC_ARG_WITH([grpc-lib],
            AC_HELP_STRING([--with-grpc-lib=LIB_PATH],
                           [the location of GRPC libraries]),
            [grpc_lib_path=$withval])
if test -n "$grpc_lib_path"; then
  LIBS="${LIBS} -L$grpc_lib_path"
else
  if test -n "${GRPC_LIBS_PATH}"; then
    LIBS="${LIBS} -L${GRPC_LIBS_PATH}"
  fi
fi

DEFAULT_LIBS="${LIBS}"
AC_LANG(C++)
AC_REQUIRE_CPP

dnl use pkg-config for ProtoBuf settings if available
AC_ARG_VAR(PKGCONFIG, "Whether pkg-config exists or not")
PKGCONFIG=0
AC_CHECK_PROG(PKGCONFIG, pkg-config, 1)
if test "${PKGCONFIG}" -eq 1 && pkg-config --exists protobuf; then
  CPPFLAGS="${CPPFLAGS} "`pkg-config --cflags protobuf`
  PROTO_HEADER_PATH=`pkg-config --cflags-only-I protobuf`
  LIBS="${LIBS} "`pkg-config --libs protobuf`
else
  LIBS="${LIBS} -lprotobuf"
fi

AC_MSG_CHECKING([if ProtoBuf version >= 3.0.0])
AC_RUN_IFELSE([AC_LANG_PROGRAM(
               [#include <google/protobuf/stubs/common.h>
                #include <google/protobuf/descriptor.pb.h>],
              [exit(GOOGLE_PROTOBUF_VERSION < 3000000)])],
              [AC_MSG_RESULT("yes"); HAVE_PROTOBUF=1],
              [AC_MSG_RESULT("no"); HAVE_PROTOBUF=0])

HAVE_GRPC=0
if test "${HAVE_PROTOBUF}" -eq 1; then
  AC_ARG_VAR(PROTOC_BINARY, "Absolute path of the protoc binary")
  AC_PATH_PROG(PROTOC_BINARY, protoc,
               AC_MSG_ERROR("protoc binary not found in $PATH"))

  dnl Use pkg-config for gRPC settings 
  if test "${PKGCONFIG}" -eq 1 && pkg-config --exists grpc grpc; then
    CPPFLAGS="${CPPFLAGS} "`pkg-config --cflags grpc grpc++`
    LIBS="${LIBS} "`pkg-config --libs grpc grpc++`
  else
    LIBS="${LIBS} -lgrpc -lgrpc++"
  fi

  AC_MSG_CHECKING([gRPC])
  AC_RUN_IFELSE([AC_LANG_PROGRAM(
                 [#include <grpc++/client_context.h>],
                 [::grpc::ClientContext context])],
                 [AC_MSG_RESULT("yes"); HAVE_GRPC=1],
                 [AC_MSG_RESULT("no")])
  fi

AC_ARG_VAR(GRPC_PLUGIN, "Absolute path of the grpc plugin binary")

dnl Some final checks
if test "${HAVE_GRPC}" -eq 1; then
  AC_PATH_PROG(GRPC_PLUGIN, grpc_cpp_plugin,
               AC_MSG_ERROR("grpc_cpp_plugin binary not found in $PATH"))

  dnl Try some common directories for protobuf header paths
  if test -z "${PROTO_HEADER_PATH}"; then
    AC_CHECK_FILE("/usr/include/google/protobuf/descriptor.proto",
                  PROTO_HEADER_PATH="-I/usr/include")
    AC_CHECK_FILE("/usr/local/include/google/protobuf/descriptor.proto",
                  PROTO_HEADER_PATH="-I/usr/local/include")
    AC_CHECK_FILE("/opt/local/include/google/protobuf/descriptor.proto",
                  PROTO_HEADER_PATH="-I/opt/local/include")
    if test -z "${PROTO_HEADER_PATH}"; then
      HAVE_GRPC=0
    fi
  fi
fi

if test "${HAVE_GRPC}" -eq 0; then
  LIBS=${DEFAULT_LIBS}
  AC_MSG_WARN("[
gRPC installation could not be found,
or protocol buffer library is not >= 3.0.0.
If your installation is in a non-standard location,
please see installation instructions at 
https://github.com/Bioconductor/GoogleGenomics/blob/master/README.rst
"])
fi

AC_SUBST(HAVE_GRPC)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
