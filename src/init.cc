#include <R_ext/Rdynload.h>
#include <Rinternals.h>

#ifdef HAVE_GRPC
#include <google/protobuf/descriptor.h>
#include <grpc/grpc.h>
#endif  /* HAVE_GRPC */

extern "C" {

SEXP builtWithGRPC() {
#ifdef HAVE_GRPC
  return Rf_ScalarLogical(true);
#else
  return Rf_ScalarLogical(false);
#endif
}

#ifdef HAVE_GRPC
extern SEXP GetRProtoBufMessage(SEXP);
extern SEXP CreateAnnotationSet(SEXP, SEXP);
extern SEXP GetAnnotationSet(SEXP, SEXP);
extern SEXP UpdateAnnotationSet(SEXP, SEXP);
extern SEXP DeleteAnnotationSet(SEXP, SEXP);
extern SEXP SearchAnnotationSets(SEXP, SEXP);
extern SEXP CreateAnnotation(SEXP, SEXP);
extern SEXP BatchCreateAnnotations(SEXP, SEXP);
extern SEXP GetAnnotation(SEXP, SEXP);
extern SEXP UpdateAnnotation(SEXP, SEXP);
extern SEXP DeleteAnnotation(SEXP, SEXP);
extern SEXP SearchAnnotations(SEXP, SEXP);
extern SEXP ListDatasets(SEXP, SEXP);
extern SEXP CreateDataset(SEXP, SEXP);
extern SEXP GetDataset(SEXP, SEXP);
extern SEXP UpdateDataset(SEXP, SEXP);
extern SEXP DeleteDataset(SEXP, SEXP);
extern SEXP UndeleteDataset(SEXP, SEXP);
extern SEXP SetIamPolicy(SEXP, SEXP);
extern SEXP GetIamPolicy(SEXP, SEXP);
extern SEXP TestIamPermissions(SEXP, SEXP);
extern SEXP StreamReads(SEXP, SEXP);
extern SEXP ImportReadGroupSets(SEXP, SEXP);
extern SEXP ExportReadGroupSet(SEXP, SEXP);
extern SEXP SearchReadGroupSets(SEXP, SEXP);
extern SEXP UpdateReadGroupSet(SEXP, SEXP);
extern SEXP DeleteReadGroupSet(SEXP, SEXP);
extern SEXP GetReadGroupSet(SEXP, SEXP);
extern SEXP ListCoverageBuckets(SEXP, SEXP);
extern SEXP SearchReads(SEXP, SEXP);
extern SEXP SearchReferenceSets(SEXP, SEXP);
extern SEXP GetReferenceSet(SEXP, SEXP);
extern SEXP SearchReferences(SEXP, SEXP);
extern SEXP GetReference(SEXP, SEXP);
extern SEXP ListBases(SEXP, SEXP);
extern SEXP StreamVariants(SEXP, SEXP);
extern SEXP ImportVariants(SEXP, SEXP);
extern SEXP CreateVariantSet(SEXP, SEXP);
extern SEXP ExportVariantSet(SEXP, SEXP);
extern SEXP GetVariantSet(SEXP, SEXP);
extern SEXP SearchVariantSets(SEXP, SEXP);
extern SEXP DeleteVariantSet(SEXP, SEXP);
extern SEXP UpdateVariantSet(SEXP, SEXP);
extern SEXP SearchVariants(SEXP, SEXP);
extern SEXP CreateVariant(SEXP, SEXP);
extern SEXP UpdateVariant(SEXP, SEXP);
extern SEXP DeleteVariant(SEXP, SEXP);
extern SEXP GetVariant(SEXP, SEXP);
extern SEXP MergeVariants(SEXP, SEXP);
extern SEXP SearchCallSets(SEXP, SEXP);
extern SEXP CreateCallSet(SEXP, SEXP);
extern SEXP UpdateCallSet(SEXP, SEXP);
extern SEXP DeleteCallSet(SEXP, SEXP);
extern SEXP GetCallSet(SEXP, SEXP);
#endif  /* HAVE_GRPC */

static const R_CallMethodDef callMethods[] = {
    {"builtWithGRPC", (DL_FUNC)&builtWithGRPC, 0},
#ifdef HAVE_GRPC
    {"GetRProtoBufMessage", (DL_FUNC)&GetRProtoBufMessage, 1},
    {"CreateAnnotationSet", (DL_FUNC)&CreateAnnotationSet, 2},
    {"GetAnnotationSet", (DL_FUNC)&GetAnnotationSet, 2},
    {"UpdateAnnotationSet", (DL_FUNC)&UpdateAnnotationSet, 2},
    {"DeleteAnnotationSet", (DL_FUNC)&DeleteAnnotationSet, 2},
    {"SearchAnnotationSets", (DL_FUNC)&SearchAnnotationSets, 2},
    {"CreateAnnotation", (DL_FUNC)&CreateAnnotation, 2},
    {"BatchCreateAnnotations", (DL_FUNC)&BatchCreateAnnotations, 2},
    {"GetAnnotation", (DL_FUNC)&GetAnnotation, 2},
    {"UpdateAnnotation", (DL_FUNC)&UpdateAnnotation, 2},
    {"DeleteAnnotation", (DL_FUNC)&DeleteAnnotation, 2},
    {"SearchAnnotations", (DL_FUNC)&SearchAnnotations, 2},
    {"ListDatasets", (DL_FUNC)&ListDatasets, 2},
    {"CreateDataset", (DL_FUNC)&CreateDataset, 2},
    {"GetDataset", (DL_FUNC)&GetDataset, 2},
    {"UpdateDataset", (DL_FUNC)&UpdateDataset, 2},
    {"DeleteDataset", (DL_FUNC)&DeleteDataset, 2},
    {"UndeleteDataset", (DL_FUNC)&UndeleteDataset, 2},
    {"SetIamPolicy", (DL_FUNC)&SetIamPolicy, 2},
    {"GetIamPolicy", (DL_FUNC)&GetIamPolicy, 2},
    {"TestIamPermissions", (DL_FUNC)&TestIamPermissions, 2},
    {"StreamReads", (DL_FUNC)&StreamReads, 2},
    {"ImportReadGroupSets", (DL_FUNC)&ImportReadGroupSets, 2},
    {"ExportReadGroupSet", (DL_FUNC)&ExportReadGroupSet, 2},
    {"SearchReadGroupSets", (DL_FUNC)&SearchReadGroupSets, 2},
    {"UpdateReadGroupSet", (DL_FUNC)&UpdateReadGroupSet, 2},
    {"DeleteReadGroupSet", (DL_FUNC)&DeleteReadGroupSet, 2},
    {"GetReadGroupSet", (DL_FUNC)&GetReadGroupSet, 2},
    {"ListCoverageBuckets", (DL_FUNC)&ListCoverageBuckets, 2},
    {"SearchReads", (DL_FUNC)&SearchReads, 2},
    {"SearchReferenceSets", (DL_FUNC)&SearchReferenceSets, 2},
    {"GetReferenceSet", (DL_FUNC)&GetReferenceSet, 2},
    {"SearchReferences", (DL_FUNC)&SearchReferences, 2},
    {"GetReference", (DL_FUNC)&GetReference, 2},
    {"ListBases", (DL_FUNC)&ListBases, 2},
    {"StreamVariants", (DL_FUNC)&StreamVariants, 2},
    {"ImportVariants", (DL_FUNC)&ImportVariants, 2},
    {"CreateVariantSet", (DL_FUNC)&CreateVariantSet, 2},
    {"ExportVariantSet", (DL_FUNC)&ExportVariantSet, 2},
    {"GetVariantSet", (DL_FUNC)&GetVariantSet, 2},
    {"SearchVariantSets", (DL_FUNC)&SearchVariantSets, 2},
    {"DeleteVariantSet", (DL_FUNC)&DeleteVariantSet, 2},
    {"UpdateVariantSet", (DL_FUNC)&UpdateVariantSet, 2},
    {"SearchVariants", (DL_FUNC)&SearchVariants, 2},
    {"CreateVariant", (DL_FUNC)&CreateVariant, 2},
    {"UpdateVariant", (DL_FUNC)&UpdateVariant, 2},
    {"DeleteVariant", (DL_FUNC)&DeleteVariant, 2},
    {"GetVariant", (DL_FUNC)&GetVariant, 2},
    {"MergeVariants", (DL_FUNC)&MergeVariants, 2},
    {"SearchCallSets", (DL_FUNC)&SearchCallSets, 2},
    {"CreateCallSet", (DL_FUNC)&CreateCallSet, 2},
    {"UpdateCallSet", (DL_FUNC)&UpdateCallSet, 2},
    {"DeleteCallSet", (DL_FUNC)&DeleteCallSet, 2},
    {"GetCallSet", (DL_FUNC)&GetCallSet, 2},
#endif  /* HAVE_GRPC */
    {NULL, NULL, 0}};

/*
 * Initialize the shared library in the package.
 * The name of this function should always match the package name.
 */
void R_init_GoogleGenomics(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);

#ifdef HAVE_GRPC
  GOOGLE_PROTOBUF_VERIFY_VERSION;
  grpc_init();
#endif
}

/*
 * Prepare to unload the shared library in the package.
 * The name of this function should always match the package name.
 */
void R_unload_GoogleGenomics(DllInfo *dll) {
#ifdef HAVE_GRPC
  // Shutdown gRPC.
  grpc_shutdown();
#endif  /* HAVE_GRPC */
}

}  // extern C
