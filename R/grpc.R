#' Returns if this package was built with gRPC support.
#'
#' @return TRUE iff the package was built with gRPC support.
isGRPCAvailable <- function() {
  # Value will be substituted when running the configure script.
  isTRUE(.Call(C_builtWithGRPC))
}

#' Returns a protocol buffer Message object from
#' \code{\link[RProtoBuf]{RProtoBuf}}.
#'
#' Needs gRPC support at package build time and the RProtoBuf package.
#' See package README for instructions on installing gRPC.
#'
#' @param fullyQualifiedName Type of the message object to return.
#'
#' @return Default instance of the Message.
#' @examples
#' if (isGRPCAvailable()) {
#'   getRProtoBufDefaultObject("google.genomics.v1.SearchReadsRequest")
#' }
getRProtoBufDefaultObject <- function(fullyQualifiedName) {
  stopifnot(isGRPCAvailable())
  stopifnot(requireNamespace("RProtoBuf"))

  # We lookup the object dynamically because it is available only with gRPC.
  .Call(get0("C_GetRProtoBufMessage"), fullyQualifiedName)
}

#' Issues a gRPC call to the Google Genomics service and returns the
#' response.
#'
#' Needs gRPC support at package build time and the RProtoBuf package.
#' See package README for instructions on installing gRPC.
#'
#' In general, use higher level methods such as getReads and getVariants
#' instead.
#'
#' @param methodName The RPC method name.
#' @param request The request object for the RPC, either as a JSON object
#'        generated from \code{\link[rjson]{rjson}}, or as a
#'        \code{\link[RProtoBuf]{RProtoBuf}} object modified from the
#'        default instance obtained from
#'        \code{\link{getRProtoBufDefaultObject}}.
#'
#' @return The raw response converted from JSON to an R object, or the
#'         RProtoBuf object if the request was an RProtoBuf object.
#' @family page fetch functions
#' @examples
#' # Authenticated on package load from the env variable GOOGLE_API_KEY.
#' if (isGRPCAvailable()) {
#'   request <- list(readGroupSetIds=list("CMvnhpKTFhDnk4_9zcKO3_YB"),
#'                   referenceName="22",
#'                   start=16051400, end=16051500, pageToken=NULL)
#'   reads <- callGRPCMethod("SearchReads", request)
#'   summary(reads)
#' } else {
#'   message("gRPC support is disabled; package was not compiled with GRPC")
#' }
callGRPCMethod <- function(methodName, request) {
  stopifnot(isGRPCAvailable())

  if (!is.character(request) && !is(request, "Message")) {
    warning("Invalid request type")
    return(NULL)
  }

  method <- get0(paste0("C_", methodName))
  if (is.null(method)) {
    warning("Invalid method name for Google Genomics API: ", methodName)
    return(NULL)
  }

  .Call(method, request, getGRPCCreds())
}
