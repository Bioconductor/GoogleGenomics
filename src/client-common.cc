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

#include <memory>
#include <string>

#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/create_channel.h>
#include <grpc++/security/credentials.h>
#include <grpc++/support/status.h>
#include <grpc++/support/status_code_enum.h>
#include <grpc/grpc.h>

#include <client-common.h>

namespace googlegenomics {
std::shared_ptr<Channel> getChannel() {
  // Authentication is handled outside of gRPC to support the non-GRPC methods.
  // static
  std::shared_ptr<Channel> channel =
      grpc::CreateChannel("genomics.googleapis.com:443",
                          grpc::SslCredentials(grpc::SslCredentialsOptions()));

  return channel;
}

Status ApiKeyCredentialsPlugin::GetMetadata(
    grpc::string_ref, grpc::string_ref, const grpc::AuthContext&,
    std::multimap<grpc::string, grpc::string>* metadata) {
  metadata->insert(std::make_pair("x-api-key", api_key_.c_str()));
  return Status::OK;
}

void InitContext(SEXP credentialsList, ClientContext* context) {
  std::string api_key;
  std::string json_refresh_token;
  std::string access_token;

  SEXP names = Rf_getAttrib(credentialsList, R_NamesSymbol);
  for (int i = 0; i < Rf_length(credentialsList); ++i) {
    SEXP element = VECTOR_ELT(credentialsList, i);
    if (element == R_NilValue) {
      continue;
    }

    const char* name = CHAR(STRING_ELT(names, i));
    std::string value = std::string(CHAR(STRING_ELT(element, 0)));
    if (strcmp(name, "api_key") == 0) {
      api_key = value;
    } else if (strcmp(name, "json_refresh_token") == 0) {
      json_refresh_token = value;
    } else if (strcmp(name, "access_token") == 0) {
      access_token = value;
    }
  }

  if (!api_key.empty()) {
    context->set_credentials(grpc::MetadataCredentialsFromPlugin(
        std::unique_ptr<ApiKeyCredentialsPlugin>(new ApiKeyCredentialsPlugin(api_key))));
  }

  if (!access_token.empty()) {
    context->set_credentials(grpc::AccessTokenCredentials(access_token));
  } else if (!json_refresh_token.empty()) {
    context->set_credentials(
        grpc::GoogleRefreshTokenCredentials(json_refresh_token));
  }

  context->set_wait_for_ready(true);
}

void ExplainError(const Status& status) {
  switch (status.error_code()) {
    case StatusCode::UNAUTHENTICATED:
    case StatusCode::PERMISSION_DENIED:
      REprintf(
          "Authentication error: %s\nPlease try authenticating again, or use "
          "a different method.\n",
          status.error_message().data());
      break;
    default:
      REprintf("RPC Failed: %s\n", status.error_message().data());
  }
}

// Checks the R request type and returns a protocol buffer request.
// Cleans up any allocated memory for the call.
SEXP FinalizeCall(SEXP request, ::google::protobuf::Message* request_message,
                  ::google::protobuf::Message* response_message) {
  if (!(TYPEOF(request) == STRSXP || TYPEOF(request) == CHARSXP)) {
    return MakeRProtoBufObject(
        dynamic_cast<::google::protobuf::Message*>(response_message));
  }

  std::string response_json;
  ::google::protobuf::util::Status status =
      ::google::protobuf::util::MessageToJsonString(*response_message,
                                                    &response_json);
  if (!status.ok()) {
    REprintf("Error in final response conversion to json: %s\n",
             status.ToString().c_str());
    return R_NilValue;
  }

  delete request_message;
  delete response_message;

  // R will make a copy of the string.
  SEXP response = PROTECT(Rf_mkString(response_json.c_str()));
  UNPROTECT(1);
  return response;
}

}  // namespace googlegenomics
