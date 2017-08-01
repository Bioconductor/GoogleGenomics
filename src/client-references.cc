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
