#include <google/protobuf/message.h>

#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

extern "C" {

void DeleteMessage(SEXP object);

SEXP MakeRProtoBufObject(::google::protobuf::Message *message);

::google::protobuf::Message *GetMessageFromRProtoBufObject(SEXP object);

SEXP GetRProtoBufMessage(SEXP type);

}  // extern C
