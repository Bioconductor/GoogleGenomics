AC_PREREQ(2.69)

AC_INIT([GoogleGenomics],[2.0.0]) dnl package name, version

dnl Find the compiler and compiler flags to use.
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

dnl Check for user supplied include paths, from a configure option or
dnl from an environment variable.
AC_ARG_WITH([grpc-include],
            AC_HELP_STRING([--with-grpc-include=INCLUDE_PATH],
                           [the location of GRPC header files]),
            [grpc_include_path=$withval])
if test -n "$grpc_include_path"; then
  CPPFLAGS="${CPPFLAGS} -I${grpc_include_path}"
else
  if test -n "${GRPC_INCLUDE_PATH}"; then
    CPPFLAGS="${CPPFLAGS} -I${GRPC_INCLUDE_PATH}"
  fi
fi

dnl Same for library search paths.
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

AC_LANG(C++)
AC_REQUIRE_CPP

DEFAULT_LIBS="${LIBS}"
LIBS="${LIBS} -lprotobuf"
AC_MSG_CHECKING([if ProtoBuf version >= 3.0.0])
AC_RUN_IFELSE([AC_LANG_PROGRAM(
               [#include <google/protobuf/stubs/common.h>],
               [exit(GOOGLE_PROTOBUF_VERSION < 3000000)])],
              [AC_MSG_RESULT("yes"); HAVE_PROTOBUF=1],
              [AC_MSG_RESULT("no"); HAVE_PROTOBUF=0])

HAVE_GRPC=0
if test [ ${HAVE_PROTOBUF} -eq 1 ] ; then
  LIBS="${LIBS} -lgrpc -lgrpc++"
  AC_MSG_CHECKING([gRPC])
  AC_RUN_IFELSE([AC_LANG_PROGRAM(
                 [#include <grpc++/client_context.h>],
                 [::grpc::ClientContext context])],
                 [AC_MSG_RESULT("yes"); HAVE_GRPC=1],
                 [AC_MSG_RESULT("no")])
fi

if test [ ${HAVE_GRPC} -eq 0 ] ; then
  LIBS=${DEFAULT_LIBS}
  AC_MSG_WARN("[
gRPC installation could not be found,
or protocol buffer library is not >= 3.0.0.
If your installation is in a non-standard location,
please set the environment variables
GRPC_INCLUDE_PATH and GRPC_LIBS_PATH.
See configure.vars argument in install.packages."])
else
  CPPFLAGS="${CPPFLAGS} -DHAVE_GRPC"
fi

AC_SUBST(HAVE_GRPC)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
