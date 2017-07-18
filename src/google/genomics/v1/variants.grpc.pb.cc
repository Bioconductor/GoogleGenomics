// Generated by the gRPC C++ plugin.
// If you make any local change, they will be lost.
// source: google/genomics/v1/variants.proto

#include "google/genomics/v1/variants.pb.h"
#include "google/genomics/v1/variants.grpc.pb.h"

#include <grpc++/impl/codegen/async_stream.h>
#include <grpc++/impl/codegen/async_unary_call.h>
#include <grpc++/impl/codegen/channel_interface.h>
#include <grpc++/impl/codegen/client_unary_call.h>
#include <grpc++/impl/codegen/method_handler_impl.h>
#include <grpc++/impl/codegen/rpc_service_method.h>
#include <grpc++/impl/codegen/service_type.h>
#include <grpc++/impl/codegen/sync_stream.h>
namespace google {
namespace genomics {
namespace v1 {

static const char* StreamingVariantService_method_names[] = {
  "/google.genomics.v1.StreamingVariantService/StreamVariants",
};

std::unique_ptr< StreamingVariantService::Stub> StreamingVariantService::NewStub(const std::shared_ptr< ::grpc::ChannelInterface>& channel, const ::grpc::StubOptions& options) {
  std::unique_ptr< StreamingVariantService::Stub> stub(new StreamingVariantService::Stub(channel));
  return stub;
}

StreamingVariantService::Stub::Stub(const std::shared_ptr< ::grpc::ChannelInterface>& channel)
  : channel_(channel), rpcmethod_StreamVariants_(StreamingVariantService_method_names[0], ::grpc::RpcMethod::SERVER_STREAMING, channel)
  {}

::grpc::ClientReader< ::google::genomics::v1::StreamVariantsResponse>* StreamingVariantService::Stub::StreamVariantsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::StreamVariantsRequest& request) {
  return new ::grpc::ClientReader< ::google::genomics::v1::StreamVariantsResponse>(channel_.get(), rpcmethod_StreamVariants_, context, request);
}

::grpc::ClientAsyncReader< ::google::genomics::v1::StreamVariantsResponse>* StreamingVariantService::Stub::AsyncStreamVariantsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::StreamVariantsRequest& request, ::grpc::CompletionQueue* cq, void* tag) {
  return ::grpc::ClientAsyncReader< ::google::genomics::v1::StreamVariantsResponse>::Create(channel_.get(), cq, rpcmethod_StreamVariants_, context, request, tag);
}

StreamingVariantService::Service::Service() {
  AddMethod(new ::grpc::RpcServiceMethod(
      StreamingVariantService_method_names[0],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< StreamingVariantService::Service, ::google::genomics::v1::StreamVariantsRequest, ::google::genomics::v1::StreamVariantsResponse>(
          std::mem_fn(&StreamingVariantService::Service::StreamVariants), this)));
}

StreamingVariantService::Service::~Service() {
}

::grpc::Status StreamingVariantService::Service::StreamVariants(::grpc::ServerContext* context, const ::google::genomics::v1::StreamVariantsRequest* request, ::grpc::ServerWriter< ::google::genomics::v1::StreamVariantsResponse>* writer) {
  (void) context;
  (void) request;
  (void) writer;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}


static const char* VariantServiceV1_method_names[] = {
  "/google.genomics.v1.VariantServiceV1/ImportVariants",
  "/google.genomics.v1.VariantServiceV1/CreateVariantSet",
  "/google.genomics.v1.VariantServiceV1/ExportVariantSet",
  "/google.genomics.v1.VariantServiceV1/GetVariantSet",
  "/google.genomics.v1.VariantServiceV1/SearchVariantSets",
  "/google.genomics.v1.VariantServiceV1/DeleteVariantSet",
  "/google.genomics.v1.VariantServiceV1/UpdateVariantSet",
  "/google.genomics.v1.VariantServiceV1/SearchVariants",
  "/google.genomics.v1.VariantServiceV1/CreateVariant",
  "/google.genomics.v1.VariantServiceV1/UpdateVariant",
  "/google.genomics.v1.VariantServiceV1/DeleteVariant",
  "/google.genomics.v1.VariantServiceV1/GetVariant",
  "/google.genomics.v1.VariantServiceV1/MergeVariants",
  "/google.genomics.v1.VariantServiceV1/SearchCallSets",
  "/google.genomics.v1.VariantServiceV1/CreateCallSet",
  "/google.genomics.v1.VariantServiceV1/UpdateCallSet",
  "/google.genomics.v1.VariantServiceV1/DeleteCallSet",
  "/google.genomics.v1.VariantServiceV1/GetCallSet",
};

std::unique_ptr< VariantServiceV1::Stub> VariantServiceV1::NewStub(const std::shared_ptr< ::grpc::ChannelInterface>& channel, const ::grpc::StubOptions& options) {
  std::unique_ptr< VariantServiceV1::Stub> stub(new VariantServiceV1::Stub(channel));
  return stub;
}

VariantServiceV1::Stub::Stub(const std::shared_ptr< ::grpc::ChannelInterface>& channel)
  : channel_(channel), rpcmethod_ImportVariants_(VariantServiceV1_method_names[0], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_CreateVariantSet_(VariantServiceV1_method_names[1], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_ExportVariantSet_(VariantServiceV1_method_names[2], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_GetVariantSet_(VariantServiceV1_method_names[3], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_SearchVariantSets_(VariantServiceV1_method_names[4], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_DeleteVariantSet_(VariantServiceV1_method_names[5], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_UpdateVariantSet_(VariantServiceV1_method_names[6], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_SearchVariants_(VariantServiceV1_method_names[7], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_CreateVariant_(VariantServiceV1_method_names[8], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_UpdateVariant_(VariantServiceV1_method_names[9], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_DeleteVariant_(VariantServiceV1_method_names[10], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_GetVariant_(VariantServiceV1_method_names[11], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_MergeVariants_(VariantServiceV1_method_names[12], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_SearchCallSets_(VariantServiceV1_method_names[13], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_CreateCallSet_(VariantServiceV1_method_names[14], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_UpdateCallSet_(VariantServiceV1_method_names[15], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_DeleteCallSet_(VariantServiceV1_method_names[16], ::grpc::RpcMethod::NORMAL_RPC, channel)
  , rpcmethod_GetCallSet_(VariantServiceV1_method_names[17], ::grpc::RpcMethod::NORMAL_RPC, channel)
  {}

::grpc::Status VariantServiceV1::Stub::ImportVariants(::grpc::ClientContext* context, const ::google::genomics::v1::ImportVariantsRequest& request, ::google::longrunning::Operation* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_ImportVariants_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::longrunning::Operation>* VariantServiceV1::Stub::AsyncImportVariantsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::ImportVariantsRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::longrunning::Operation>::Create(channel_.get(), cq, rpcmethod_ImportVariants_, context, request);
}

::grpc::Status VariantServiceV1::Stub::CreateVariantSet(::grpc::ClientContext* context, const ::google::genomics::v1::CreateVariantSetRequest& request, ::google::genomics::v1::VariantSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_CreateVariantSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>* VariantServiceV1::Stub::AsyncCreateVariantSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::CreateVariantSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>::Create(channel_.get(), cq, rpcmethod_CreateVariantSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::ExportVariantSet(::grpc::ClientContext* context, const ::google::genomics::v1::ExportVariantSetRequest& request, ::google::longrunning::Operation* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_ExportVariantSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::longrunning::Operation>* VariantServiceV1::Stub::AsyncExportVariantSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::ExportVariantSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::longrunning::Operation>::Create(channel_.get(), cq, rpcmethod_ExportVariantSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::GetVariantSet(::grpc::ClientContext* context, const ::google::genomics::v1::GetVariantSetRequest& request, ::google::genomics::v1::VariantSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_GetVariantSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>* VariantServiceV1::Stub::AsyncGetVariantSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::GetVariantSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>::Create(channel_.get(), cq, rpcmethod_GetVariantSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::SearchVariantSets(::grpc::ClientContext* context, const ::google::genomics::v1::SearchVariantSetsRequest& request, ::google::genomics::v1::SearchVariantSetsResponse* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_SearchVariantSets_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchVariantSetsResponse>* VariantServiceV1::Stub::AsyncSearchVariantSetsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::SearchVariantSetsRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchVariantSetsResponse>::Create(channel_.get(), cq, rpcmethod_SearchVariantSets_, context, request);
}

::grpc::Status VariantServiceV1::Stub::DeleteVariantSet(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteVariantSetRequest& request, ::google::protobuf::Empty* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_DeleteVariantSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>* VariantServiceV1::Stub::AsyncDeleteVariantSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteVariantSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>::Create(channel_.get(), cq, rpcmethod_DeleteVariantSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::UpdateVariantSet(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateVariantSetRequest& request, ::google::genomics::v1::VariantSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_UpdateVariantSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>* VariantServiceV1::Stub::AsyncUpdateVariantSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateVariantSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::VariantSet>::Create(channel_.get(), cq, rpcmethod_UpdateVariantSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::SearchVariants(::grpc::ClientContext* context, const ::google::genomics::v1::SearchVariantsRequest& request, ::google::genomics::v1::SearchVariantsResponse* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_SearchVariants_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchVariantsResponse>* VariantServiceV1::Stub::AsyncSearchVariantsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::SearchVariantsRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchVariantsResponse>::Create(channel_.get(), cq, rpcmethod_SearchVariants_, context, request);
}

::grpc::Status VariantServiceV1::Stub::CreateVariant(::grpc::ClientContext* context, const ::google::genomics::v1::CreateVariantRequest& request, ::google::genomics::v1::Variant* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_CreateVariant_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>* VariantServiceV1::Stub::AsyncCreateVariantRaw(::grpc::ClientContext* context, const ::google::genomics::v1::CreateVariantRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>::Create(channel_.get(), cq, rpcmethod_CreateVariant_, context, request);
}

::grpc::Status VariantServiceV1::Stub::UpdateVariant(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateVariantRequest& request, ::google::genomics::v1::Variant* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_UpdateVariant_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>* VariantServiceV1::Stub::AsyncUpdateVariantRaw(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateVariantRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>::Create(channel_.get(), cq, rpcmethod_UpdateVariant_, context, request);
}

::grpc::Status VariantServiceV1::Stub::DeleteVariant(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteVariantRequest& request, ::google::protobuf::Empty* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_DeleteVariant_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>* VariantServiceV1::Stub::AsyncDeleteVariantRaw(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteVariantRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>::Create(channel_.get(), cq, rpcmethod_DeleteVariant_, context, request);
}

::grpc::Status VariantServiceV1::Stub::GetVariant(::grpc::ClientContext* context, const ::google::genomics::v1::GetVariantRequest& request, ::google::genomics::v1::Variant* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_GetVariant_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>* VariantServiceV1::Stub::AsyncGetVariantRaw(::grpc::ClientContext* context, const ::google::genomics::v1::GetVariantRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::Variant>::Create(channel_.get(), cq, rpcmethod_GetVariant_, context, request);
}

::grpc::Status VariantServiceV1::Stub::MergeVariants(::grpc::ClientContext* context, const ::google::genomics::v1::MergeVariantsRequest& request, ::google::protobuf::Empty* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_MergeVariants_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>* VariantServiceV1::Stub::AsyncMergeVariantsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::MergeVariantsRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>::Create(channel_.get(), cq, rpcmethod_MergeVariants_, context, request);
}

::grpc::Status VariantServiceV1::Stub::SearchCallSets(::grpc::ClientContext* context, const ::google::genomics::v1::SearchCallSetsRequest& request, ::google::genomics::v1::SearchCallSetsResponse* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_SearchCallSets_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchCallSetsResponse>* VariantServiceV1::Stub::AsyncSearchCallSetsRaw(::grpc::ClientContext* context, const ::google::genomics::v1::SearchCallSetsRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::SearchCallSetsResponse>::Create(channel_.get(), cq, rpcmethod_SearchCallSets_, context, request);
}

::grpc::Status VariantServiceV1::Stub::CreateCallSet(::grpc::ClientContext* context, const ::google::genomics::v1::CreateCallSetRequest& request, ::google::genomics::v1::CallSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_CreateCallSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>* VariantServiceV1::Stub::AsyncCreateCallSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::CreateCallSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>::Create(channel_.get(), cq, rpcmethod_CreateCallSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::UpdateCallSet(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateCallSetRequest& request, ::google::genomics::v1::CallSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_UpdateCallSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>* VariantServiceV1::Stub::AsyncUpdateCallSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::UpdateCallSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>::Create(channel_.get(), cq, rpcmethod_UpdateCallSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::DeleteCallSet(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteCallSetRequest& request, ::google::protobuf::Empty* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_DeleteCallSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>* VariantServiceV1::Stub::AsyncDeleteCallSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::DeleteCallSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::protobuf::Empty>::Create(channel_.get(), cq, rpcmethod_DeleteCallSet_, context, request);
}

::grpc::Status VariantServiceV1::Stub::GetCallSet(::grpc::ClientContext* context, const ::google::genomics::v1::GetCallSetRequest& request, ::google::genomics::v1::CallSet* response) {
  return ::grpc::BlockingUnaryCall(channel_.get(), rpcmethod_GetCallSet_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>* VariantServiceV1::Stub::AsyncGetCallSetRaw(::grpc::ClientContext* context, const ::google::genomics::v1::GetCallSetRequest& request, ::grpc::CompletionQueue* cq) {
  return ::grpc::ClientAsyncResponseReader< ::google::genomics::v1::CallSet>::Create(channel_.get(), cq, rpcmethod_GetCallSet_, context, request);
}

VariantServiceV1::Service::Service() {
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[0],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::ImportVariantsRequest, ::google::longrunning::Operation>(
          std::mem_fn(&VariantServiceV1::Service::ImportVariants), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[1],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::CreateVariantSetRequest, ::google::genomics::v1::VariantSet>(
          std::mem_fn(&VariantServiceV1::Service::CreateVariantSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[2],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::ExportVariantSetRequest, ::google::longrunning::Operation>(
          std::mem_fn(&VariantServiceV1::Service::ExportVariantSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[3],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::GetVariantSetRequest, ::google::genomics::v1::VariantSet>(
          std::mem_fn(&VariantServiceV1::Service::GetVariantSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[4],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::SearchVariantSetsRequest, ::google::genomics::v1::SearchVariantSetsResponse>(
          std::mem_fn(&VariantServiceV1::Service::SearchVariantSets), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[5],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::DeleteVariantSetRequest, ::google::protobuf::Empty>(
          std::mem_fn(&VariantServiceV1::Service::DeleteVariantSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[6],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::UpdateVariantSetRequest, ::google::genomics::v1::VariantSet>(
          std::mem_fn(&VariantServiceV1::Service::UpdateVariantSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[7],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::SearchVariantsRequest, ::google::genomics::v1::SearchVariantsResponse>(
          std::mem_fn(&VariantServiceV1::Service::SearchVariants), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[8],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::CreateVariantRequest, ::google::genomics::v1::Variant>(
          std::mem_fn(&VariantServiceV1::Service::CreateVariant), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[9],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::UpdateVariantRequest, ::google::genomics::v1::Variant>(
          std::mem_fn(&VariantServiceV1::Service::UpdateVariant), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[10],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::DeleteVariantRequest, ::google::protobuf::Empty>(
          std::mem_fn(&VariantServiceV1::Service::DeleteVariant), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[11],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::GetVariantRequest, ::google::genomics::v1::Variant>(
          std::mem_fn(&VariantServiceV1::Service::GetVariant), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[12],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::MergeVariantsRequest, ::google::protobuf::Empty>(
          std::mem_fn(&VariantServiceV1::Service::MergeVariants), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[13],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::SearchCallSetsRequest, ::google::genomics::v1::SearchCallSetsResponse>(
          std::mem_fn(&VariantServiceV1::Service::SearchCallSets), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[14],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::CreateCallSetRequest, ::google::genomics::v1::CallSet>(
          std::mem_fn(&VariantServiceV1::Service::CreateCallSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[15],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::UpdateCallSetRequest, ::google::genomics::v1::CallSet>(
          std::mem_fn(&VariantServiceV1::Service::UpdateCallSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[16],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::DeleteCallSetRequest, ::google::protobuf::Empty>(
          std::mem_fn(&VariantServiceV1::Service::DeleteCallSet), this)));
  AddMethod(new ::grpc::RpcServiceMethod(
      VariantServiceV1_method_names[17],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< VariantServiceV1::Service, ::google::genomics::v1::GetCallSetRequest, ::google::genomics::v1::CallSet>(
          std::mem_fn(&VariantServiceV1::Service::GetCallSet), this)));
}

VariantServiceV1::Service::~Service() {
}

::grpc::Status VariantServiceV1::Service::ImportVariants(::grpc::ServerContext* context, const ::google::genomics::v1::ImportVariantsRequest* request, ::google::longrunning::Operation* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::CreateVariantSet(::grpc::ServerContext* context, const ::google::genomics::v1::CreateVariantSetRequest* request, ::google::genomics::v1::VariantSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::ExportVariantSet(::grpc::ServerContext* context, const ::google::genomics::v1::ExportVariantSetRequest* request, ::google::longrunning::Operation* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::GetVariantSet(::grpc::ServerContext* context, const ::google::genomics::v1::GetVariantSetRequest* request, ::google::genomics::v1::VariantSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::SearchVariantSets(::grpc::ServerContext* context, const ::google::genomics::v1::SearchVariantSetsRequest* request, ::google::genomics::v1::SearchVariantSetsResponse* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::DeleteVariantSet(::grpc::ServerContext* context, const ::google::genomics::v1::DeleteVariantSetRequest* request, ::google::protobuf::Empty* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::UpdateVariantSet(::grpc::ServerContext* context, const ::google::genomics::v1::UpdateVariantSetRequest* request, ::google::genomics::v1::VariantSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::SearchVariants(::grpc::ServerContext* context, const ::google::genomics::v1::SearchVariantsRequest* request, ::google::genomics::v1::SearchVariantsResponse* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::CreateVariant(::grpc::ServerContext* context, const ::google::genomics::v1::CreateVariantRequest* request, ::google::genomics::v1::Variant* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::UpdateVariant(::grpc::ServerContext* context, const ::google::genomics::v1::UpdateVariantRequest* request, ::google::genomics::v1::Variant* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::DeleteVariant(::grpc::ServerContext* context, const ::google::genomics::v1::DeleteVariantRequest* request, ::google::protobuf::Empty* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::GetVariant(::grpc::ServerContext* context, const ::google::genomics::v1::GetVariantRequest* request, ::google::genomics::v1::Variant* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::MergeVariants(::grpc::ServerContext* context, const ::google::genomics::v1::MergeVariantsRequest* request, ::google::protobuf::Empty* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::SearchCallSets(::grpc::ServerContext* context, const ::google::genomics::v1::SearchCallSetsRequest* request, ::google::genomics::v1::SearchCallSetsResponse* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::CreateCallSet(::grpc::ServerContext* context, const ::google::genomics::v1::CreateCallSetRequest* request, ::google::genomics::v1::CallSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::UpdateCallSet(::grpc::ServerContext* context, const ::google::genomics::v1::UpdateCallSetRequest* request, ::google::genomics::v1::CallSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::DeleteCallSet(::grpc::ServerContext* context, const ::google::genomics::v1::DeleteCallSetRequest* request, ::google::protobuf::Empty* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}

::grpc::Status VariantServiceV1::Service::GetCallSet(::grpc::ServerContext* context, const ::google::genomics::v1::GetCallSetRequest* request, ::google::genomics::v1::CallSet* response) {
  (void) context;
  (void) request;
  (void) response;
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED, "");
}


}  // namespace google
}  // namespace genomics
}  // namespace v1

