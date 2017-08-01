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

#ifndef GOOGLE_GENOMICS_CLIENT_COMMON_H
#define GOOGLE_GENOMICS_CLIENT_COMMON_H

#include <memory>
#include <string>

#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <google/protobuf/util/json_util.h>
#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/security/credentials.h>
#include <grpc++/support/status.h>
#include <grpc++/support/sync_stream.h>
#include <grpc/grpc.h>

#include <rprotobuf.h>

namespace googlegenomics {
using ::grpc::Channel;
using ::grpc::ClientContext;
using ::grpc::Status;
using ::grpc::StatusCode;

std::shared_ptr<Channel> getChannel();

class ApiKeyCredentialsPlugin : public grpc::MetadataCredentialsPlugin {
 public:
  ApiKeyCredentialsPlugin(std::string api_key) : api_key_(api_key) {}

  Status GetMetadata(
      grpc::string_ref, grpc::string_ref, const grpc::AuthContext&,
      std::multimap<grpc::string, grpc::string>* metadata) override;

 private:
  std::string api_key_;
};

void InitContext(SEXP credentialsList, ClientContext* context);

void ExplainError(const Status& status);

// Checker for the presence of a page token field.
template <typename Request, typename = void>
struct has_page_token : std::false_type {};
template <typename Request>
struct has_page_token<
    Request,
    typename std::enable_if<std::is_same<
        decltype(std::declval<Request>().clear_page_token()), void>::value>::type>
    : std::true_type {};

// Checks the R request type and returns a protocol buffer request.
template <typename Request>
Request* GetMessageObjectFromRequest(SEXP request) {
  if (!(TYPEOF(request) == STRSXP || TYPEOF(request) == CHARSXP)) {
    return static_cast<Request*>(GetMessageFromRProtoBufObject(request));
  }

  std::string request_json;
  switch (TYPEOF(request)) {
    case CHARSXP:
      request_json = std::string(CHAR(request));
      break;
    case STRSXP:
      request_json = std::string(CHAR(STRING_ELT(request, 0)));
  }

  Request* request_message = new Request;
  ::google::protobuf::util::Status status =
      ::google::protobuf::util::JsonStringToMessage(request_json,
                                                    request_message);
  if (!status.ok()) {
    REprintf("Error in initial request conversion from json: %s\n",
             status.ToString().c_str());
    return nullptr;
  }

  return request_message;
}

// Cleans up any allocated memory for the call.
SEXP FinalizeCall(SEXP request, ::google::protobuf::Message* request_message,
                  ::google::protobuf::Message* response_message);

// For non-paginated RPCs.
template <typename Request, typename Response,
          typename std::enable_if<!has_page_token<Request>::value, int>::type = 0>
SEXP RPC(
    std::function<Status(ClientContext*, const Request&, Response*)> stubMethod,
    SEXP request, SEXP credentialsList) {
  Request* request_message = GetMessageObjectFromRequest<Request>(request);
  if (request_message == nullptr) {
    return R_NilValue;
  }

  Response* response_message = new Response;
  ClientContext context;
  InitContext(credentialsList, &context);
  Status status = stubMethod(&context, *request_message, response_message);
  if (!status.ok()) {
    ExplainError(status);
    return R_NilValue;
  }

  return FinalizeCall(request, request_message, response_message);
}

// For paginated RPCs.
template <typename Request, typename Response,
          typename std::enable_if<has_page_token<Request>::value, int>::type = 0>
SEXP RPC(
    std::function<Status(ClientContext*, const Request&, Response*)> stubMethod,
    SEXP request, SEXP credentialsList) {
  Request* request_message = GetMessageObjectFromRequest<Request>(request);
  if (request_message == nullptr) {
    return R_NilValue;
  }

  Response* response_message = new Response;
  do {
    Response response_chunk;
    ClientContext context;
    InitContext(credentialsList, &context);
    Status status = stubMethod(&context, *request_message, &response_chunk);
    if (!status.ok()) {
      ExplainError(status);
      return R_NilValue;
    }
    request_message->set_page_token(response_chunk.next_page_token());
    response_message->MergeFrom(response_chunk);
    R_CheckUserInterrupt();
  } while (!request_message->page_token().empty());
  response_message->clear_next_page_token();

  return FinalizeCall(request, request_message, response_message);
}

// For streamed RPCs.
template <typename Request, typename Response>
SEXP StreamedRPC(std::function<std::unique_ptr<grpc::ClientReader<Response>>(
                     ClientContext*, const Request&)>
                     stubMethod,
                 SEXP request, SEXP credentialsList) {
  Request* request_message = GetMessageObjectFromRequest<Request>(request);
  if (request_message == nullptr) {
    return R_NilValue;
  }

  ClientContext context;
  InitContext(credentialsList, &context);
  Response* response_message = new Response;
  Response response_chunk;
  std::unique_ptr<grpc::ClientReader<Response>> reader =
      stubMethod(&context, *request_message);
  while (reader->Read(&response_chunk)) {
    response_message->MergeFrom(response_chunk);
    R_CheckUserInterrupt();
  }

  Status status = reader->Finish();
  if (!status.ok()) {
    ExplainError(status);
    return R_NilValue;
  }

  return FinalizeCall(request, request_message, response_message);
}

// Convenience macros to avoid boiler plate.
#define METHOD(Service, MethodName, RequestType, ResponseType)            \
  SEXP MethodName(SEXP request, SEXP credentialsList) {                   \
    std::unique_ptr<Service::Stub> stub = Service::NewStub(getChannel()); \
    return RPC<RequestType, ResponseType>(                                \
        std::bind(&Service::Stub::MethodName, stub.get(), _1, _2, _3),    \
        request, credentialsList);                                        \
  }

#define STREAMED_METHOD(Service, MethodName, RequestType, ResponseType)     \
  SEXP MethodName(SEXP request, SEXP credentialsList) {                     \
    std::unique_ptr<Service::Stub> stub = Service::NewStub(getChannel());   \
    return StreamedRPC<RequestType, ResponseType>(                          \
        std::bind(&Service::Stub::MethodName, stub.get(), _1, _2), request, \
        credentialsList);                                                   \
  }

}  // namespace googlegenomics

#endif /* GOOGLE_GENOMICS_CLIENT_COMMON_H */
