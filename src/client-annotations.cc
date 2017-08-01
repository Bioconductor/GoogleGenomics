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
