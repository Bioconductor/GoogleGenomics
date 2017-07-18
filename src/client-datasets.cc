#include <memory>
#include <string>

#include <grpc++/channel.h>
#include <grpc++/client_context.h>
#include <grpc++/support/status.h>
#include <grpc++/support/sync_stream.h>
#include <grpc/grpc.h>
#include <google/genomics/v1/datasets.grpc.pb.h>
#include <google/genomics/v1/datasets.pb.h>

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
METHOD(DatasetServiceV1, ListDatasets, ListDatasetsRequest,
       ListDatasetsResponse)

METHOD(DatasetServiceV1, CreateDataset, CreateDatasetRequest, Dataset)

METHOD(DatasetServiceV1, GetDataset, GetDatasetRequest, Dataset)

METHOD(DatasetServiceV1, UpdateDataset, UpdateDatasetRequest, Dataset)

METHOD(DatasetServiceV1, DeleteDataset, DeleteDatasetRequest,
       google::protobuf::Empty)

METHOD(DatasetServiceV1, UndeleteDataset, UndeleteDatasetRequest, Dataset)

METHOD(DatasetServiceV1, SetIamPolicy, google::iam::v1::SetIamPolicyRequest,
       google::iam::v1::Policy)

METHOD(DatasetServiceV1, GetIamPolicy, google::iam::v1::GetIamPolicyRequest,
       google::iam::v1::Policy)

METHOD(DatasetServiceV1, TestIamPermissions,
       google::iam::v1::TestIamPermissionsRequest,
       google::iam::v1::TestIamPermissionsResponse)
}  // extern C
