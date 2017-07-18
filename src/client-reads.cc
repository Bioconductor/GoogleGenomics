#include <memory>
#include <string>

#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/support/status.h>
#include <grpc++/support/sync_stream.h>
#include <grpc/grpc.h>
#include <google/genomics/v1/reads.grpc.pb.h>
#include <google/genomics/v1/reads.pb.h>

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
STREAMED_METHOD(StreamingReadService, StreamReads, StreamReadsRequest,
                StreamReadsResponse)

METHOD(ReadServiceV1, ImportReadGroupSets, ImportReadGroupSetsRequest,
       google::longrunning::Operation)

METHOD(ReadServiceV1, ExportReadGroupSet, ExportReadGroupSetRequest,
       google::longrunning::Operation)

METHOD(ReadServiceV1, SearchReadGroupSets, SearchReadGroupSetsRequest,
       SearchReadGroupSetsResponse)

METHOD(ReadServiceV1, UpdateReadGroupSet, UpdateReadGroupSetRequest,
       ReadGroupSet)

METHOD(ReadServiceV1, DeleteReadGroupSet, DeleteReadGroupSetRequest,
       google::protobuf::Empty)

METHOD(ReadServiceV1, GetReadGroupSet, GetReadGroupSetRequest, ReadGroupSet)

METHOD(ReadServiceV1, ListCoverageBuckets, ListCoverageBucketsRequest,
       ListCoverageBucketsResponse)

METHOD(ReadServiceV1, SearchReads, SearchReadsRequest, SearchReadsResponse)
}  // extern C
