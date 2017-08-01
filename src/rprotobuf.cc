// Copyright 2017 GoogleGenomics R package authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <rprotobuf.h>

#include <google/protobuf/descriptor.h>

using ::google::protobuf::Message;

extern "C" {

void DeleteMessage(SEXP object) {
  Message* pointer = static_cast<Message*>(R_ExternalPtrAddr(object));
  delete pointer;
  R_ClearExternalPtr(object);
}

SEXP MakeRProtoBufObject(Message* message) {
  // Allocate the object.
  SEXP klass = PROTECT(R_do_MAKE_CLASS("Message"));
  SEXP result = PROTECT(R_do_new_object(klass));

  // Set the pointer slot.
  SEXP pointer = PROTECT(R_MakeExternalPtr(message, R_NilValue, R_NilValue));
  R_RegisterCFinalizer(pointer, &DeleteMessage);
  R_do_slot_assign(result, Rf_install("pointer"), pointer);

  // Set the type slot.
  const char* message_type = message->GetDescriptor()->full_name().c_str();
  R_do_slot_assign(result, Rf_install("type"),
                   PROTECT(Rf_mkString(message_type)));

  UNPROTECT(4);
  return result;
}

// Returns the protocol buffer contained in a RProtoBuf S4 Message object.
Message* GetMessageFromRProtoBufObject(SEXP object) {
  const char* messageClasses[] = {"Message", ""};
  if (R_check_class_etc(object, messageClasses) != 0) {
    REprintf("Object of unknown type provided as request.");
    return nullptr;
  };
  SEXP pointer = R_do_slot(object, Rf_install("pointer"));
  return static_cast<Message*>(R_ExternalPtrAddr(pointer));
}

//
SEXP GetRProtoBufMessage(SEXP type) {
  const char* type_name = CHAR(STRING_ELT(type, 0));

  auto* desc = const_cast<::google::protobuf::Descriptor*>(
      ::google::protobuf::DescriptorPool::generated_pool()
          ->FindMessageTypeByName(type_name));
  if (!desc) {
    REprintf("Message of type %s not found", type_name);
    return R_NilValue;
  }

  Message* msg = ::google::protobuf::MessageFactory::generated_factory()
                     ->GetPrototype(desc)
                     ->New();
  return MakeRProtoBufObject(msg);
}
}  // extern C
