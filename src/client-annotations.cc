#include <memory>
#include <string>

#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/support/status.h>
#include <grpc++/support/sync_stream.h>
#include <grpc/grpc.h>
#include <google/genomics/v1/annotations.grpc.pb.h>
#include <google/genomics/v1/annotations.pb.h>

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
METHOD(AnnotationServiceV1, CreateAnnotationSet, CreateAnnotationSetRequest,
       AnnotationSet)

METHOD(AnnotationServiceV1, GetAnnotationSet, GetAnnotationSetRequest,
       AnnotationSet)

METHOD(AnnotationServiceV1, UpdateAnnotationSet, UpdateAnnotationSetRequest,
       AnnotationSet)

METHOD(AnnotationServiceV1, DeleteAnnotationSet, DeleteAnnotationSetRequest,
       google::protobuf::Empty)

METHOD(AnnotationServiceV1, SearchAnnotationSets, SearchAnnotationSetsRequest,
       SearchAnnotationSetsResponse)

METHOD(AnnotationServiceV1, CreateAnnotation, CreateAnnotationRequest,
       Annotation)

METHOD(AnnotationServiceV1, BatchCreateAnnotations,
       BatchCreateAnnotationsRequest, BatchCreateAnnotationsResponse)

METHOD(AnnotationServiceV1, GetAnnotation, GetAnnotationRequest, Annotation)

METHOD(AnnotationServiceV1, UpdateAnnotation, UpdateAnnotationRequest,
       Annotation)

METHOD(AnnotationServiceV1, DeleteAnnotation, DeleteAnnotationRequest,
       google::protobuf::Empty)

METHOD(AnnotationServiceV1, SearchAnnotations, SearchAnnotationsRequest,
       SearchAnnotationsResponse)
}  // extern C
