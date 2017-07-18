#include <memory>
#include <string>

#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/support/status.h>
#include <grpc++/support/sync_stream.h>
#include <grpc/grpc.h>
#include <google/genomics/v1/references.grpc.pb.h>
#include <google/genomics/v1/references.pb.h>

#include <client-common.h>

using ::std::placeholders::_1;
using ::std::placeholders::_2;
using ::std::placeholders::_3;

using ::grpc::ClientContext;
using ::grpc::ClientReader;
using ::grpc::Status;

using namespace ::google::genomics::v1;
using namespace ::googlegenomics;

extern "C" {
METHOD(ReferenceServiceV1, SearchReferenceSets, SearchReferenceSetsRequest,
       SearchReferenceSetsResponse)

METHOD(ReferenceServiceV1, GetReferenceSet, GetReferenceSetRequest,
       ReferenceSet)

METHOD(ReferenceServiceV1, SearchReferences, SearchReferencesRequest,
       SearchReferencesResponse)

METHOD(ReferenceServiceV1, GetReference, GetReferenceRequest, Reference)

METHOD(ReferenceServiceV1, ListBases, ListBasesRequest, ListBasesResponse)
}  // extern C
