# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Get one page of variants from Google Genomics.
#'
#' In general, use the getVariants method instead.  It calls this method,
#' returning variants from all of the pages that comprise the requested
#' genomic range.
#'
#' By default, this function gets variants from a small section of 1000
#' Genomes phase 1 variants.
#'
#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome in 0-based coordinates.
#' @param end End position on the chromosome in 0-based coordinates.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'   return all fields.
#' @param pageToken The page token. This can be NULL (default) for the first
#'   page.
#' @return A two-element list is returned by the function.
#'
#'     variants: A list of R objects corresponding to the JSON objects returned
#'               by the Google Genomics Variants API.
#'
#'     nextPageToken: The token to be used to retrieve the next page of
#'                    results, if applicable.
#' @family page fetch functions
#' @examples
#' # Authenticated on package load from the env variable GOOGLE_API_KEY.
#' variantsPage <- getVariantsPage()
#' summary(variantsPage)
#' summary(variantsPage$variants[[1]])
#' @export
getVariantsPage <- function(datasetId="10473108253681171589",
                            chromosome="22",
                            start=16051400,
                            end=16051500,
                            fields=NULL,
                            pageToken=NULL) {

  body <- list(variantSetIds=list(datasetId), referenceName=chromosome,
               start=start, end=end, pageToken=pageToken)

  results <- getSearchPage("variants", body, fields, pageToken)

  list(variants=results$variants, nextPageToken=results$nextPageToken)
}

#' Get variants from Google Genomics.
#'
#' This function will return all of the variants that comprise the requested
#' genomic range, iterating over paginated results as necessary.
#'
#' By default, this function gets variants from a small section of 1000
#' Genomes phase 1 variants.
#'
#' Optionally pass a converter as appropriate for your use case.  By passing it
#' to this method, only the converted objects will be accumulated in memory.
#' The converter function should return an empty container of the desired type
#' if called without any arguments.
#'
#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome in 0-based coordinates.
#' @param end End position on the chromosome in 0-based coordinates.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'               return all fields.
#' @param converter A function that takes a list of variant R objects and
#'                  returns them converted to the desired type.
#' @return By default, the return value is a list of R objects
#'   corresponding to the JSON objects returned by the Google Genomics
#'   Variants API.  If a converter is passed, object(s) of the type
#'   returned by the converter will be returned by this function.
#' @seealso \code{\link{getReads}} for equivalent function for reads, and
#'   \code{\link{variantsToVRanges}} for a converter function.
#' @examples
#' # Authenticated on package load from the env variable GOOGLE_API_KEY.
#' variants <- getVariants()
#' summary(variants)
#' summary(variants[[1]])
#' @export
getVariants <- function(datasetId="10473108253681171589",
                        chromosome="22",
                        start=16051400,
                        end=16051500,
                        fields=NULL,
                        converter=c) {
  pageToken <- NULL
  variants <- converter()
  repeat {
    result <- getVariantsPage(datasetId=datasetId,
                              chromosome=chromosome,
                              start=start,
                              end=end,
                              fields=fields,
                              pageToken=pageToken)
    pageToken <- result$nextPageToken
    # TODO improve performance,
    # see https://github.com/Bioconductor/GoogleGenomics/issues/17
    variants <- c(variants, converter(result$variants))
    if (is.null(pageToken) || pageToken == "") {
      break
    }
    message(paste("Continuing variant query with the nextPageToken:",
                  pageToken))
  }

  message("Variants are now available.")
  variants
}

#' Convert variants to VRanges.
#'
#' Note that the Global Alliance for Genomics and Health API uses a 0-based
#' coordinate system.  For more detail, please see GA4GH discussions such
#' as the following:
#' \itemize{
#'    \item\url{https://github.com/ga4gh/schemas/issues/168}
#'    \item\url{https://github.com/ga4gh/schemas/issues/121}
#'}
#'
#' @param variants A list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.
#' @param oneBasedCoord Convert genomic positions to 1-based coordinates.
#' @param slStyle The style for seqnames (chrN or N or...).  Default is UCSC.
#' @return \link[VariantAnnotation]{VRanges}
#' @family variants converter functions
#' @examples
#' # Authenticated on package load from the env variable GOOGLE_API_KEY.
#' variants1 <- getVariants(converter=variantsToVRanges)
#' summary(variants1)
#' variants2 <- variantsToVRanges(getVariants())
#' print(identical(variants1, variants2))
#' @export
variantsToVRanges <- function(variants, oneBasedCoord=TRUE, slStyle="UCSC") {
  if (missing(variants)) {
    return(VRanges())
  }

  variantsToVRangesHelper <- function(v) {
    if (TRUE == oneBasedCoord) {
      position <- as.integer(v$start) + 1
    } else {
      position <- as.integer(v$start)
    }

    ranges <- VRanges(
        seqnames=Rle(as.character(v$referenceName), 1),
        ranges=IRanges(start=position,
                       end=as.integer(v$end)),
        ref=as.character(v$referenceBases),
        alt=as.character(v$alternateBases[1]),  # TODO flatten per alt
        QUAL=as.numeric(v$quality),
        FILTER=as.character(v$filter))

    names(ranges) <- as.character(v$names[1])
    ranges
  }
  vranges <- do.call("c", lapply(variants, variantsToVRangesHelper))

  seqlevelsStyle(vranges) <- slStyle
  vranges
}

#' Convert variants to GRanges.
#'
#' Note that the Global Alliance for Genomics and Health API uses a 0-based
#' coordinate system.  For more detail, please see GA4GH discussions such
#' as the following:
#' \itemize{
#'    \item\url{https://github.com/ga4gh/schemas/issues/168}
#'    \item\url{https://github.com/ga4gh/schemas/issues/121}
#'}
#'
#' @param variants A list of R objects corresponding to the JSON objects
#'   returned by the Google Genomics Variants API.
#' @param oneBasedCoord Convert genomic positions to 1-based coordinates.
#' @param slStyle The style for seqnames (chrN or N or...).  Default is UCSC.
#' @return \link[GenomicRanges]{GRanges}
#' @family variants converter functions
#' @examples
#' # Authenticated on package load from the env variable GOOGLE_API_KEY.
#' variants1 <- getVariants(converter=variantsToGRanges)
#' summary(variants1)
#' variants2 <- variantsToGRanges(getVariants())
#' print(identical(variants1, variants2))
#' @export
variantsToGRanges <- function(variants, oneBasedCoord=TRUE, slStyle="UCSC") {
  if (missing(variants)) {
    return(GRanges())
  }

  variantsToGRangesHelper <- function(v) {
    if (TRUE == oneBasedCoord) {
      position <- as.integer(v$start) + 1
    } else {
      position <- as.integer(v$start)
    }

    ranges <- GRanges(
        seqnames=Rle(as.character(v$referenceName), 1),
        ranges=IRanges(start=position,
                       end=as.integer(v$end)),
        REF=DNAStringSet(v$referenceBases),
        ALT=DNAStringSetList(v$alternateBases),
        QUAL=as.numeric(v$quality),
        FILTER=as.character(v$filter))

    names(ranges) <- as.character(v$names[1])
    ranges
  }
  granges <- do.call("c", lapply(variants, variantsToGRangesHelper))

  seqlevelsStyle(granges) <- slStyle
  granges
}

#' Elaborate the result of getVariants as a VRanges with all
#' calls for all samples

#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome in 0-based coordinates.
#' @param end End position on the chromosome in 0-based coordinates.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'               return all fields.
#' @param converter A function that takes a list of variant R objects and
#'                  returns them converted to the desired type.
#' @param oneBasedCoord Convert returned addresses to 1-based address system
#' @param nullaction either \code{"stop"} or \code{"warn"} telling how to deal with event in which request yields no variants; for \code{"warn"} we return NULL
#' @examples
#' # default to generate VRanges
#' getVariantCalls()
#' @export
#'

getVariantCalls = function(datasetId = "10473108253681171589", 
    chromosome = "22", 
    start = 16051400, end = 16051500, fields = NULL, converter = c,
    oneBasedCoord = TRUE, nullaction="stop")  {
#
# this function is an elementary approach to obtaining
# all calls in a GoogleGenomics 'getVariants' call
#
# fields in a getVariants list element
# [1] "variantSetId"   "id"             "names"          "created"       
# [5] "referenceName"  "start"          "end"            "referenceBases"
# [9] "alternateBases" "quality"        "filter"         "info"          
#[13] "calls"         
#
# subfields in the call field
#[1] "callSetId"          "callSetName"        "genotype"          
#[4] "phaseset"           "genotypeLikelihood" "info"              
#
# call getVariants
ggv = getVariants(datasetId = datasetId, chromosome=chromosome,
    start = start, end = end, fields = fields, converter = converter )
#
#
# obtain start, end, chr, and base for each variant in requested range
#
sts = as.numeric(sapply(ggv, function(x) x$start))
if (length(sts)==0) {
  if (nullaction=="warn") {
      warning("no variants in this interval")
      return(NULL)
      }
  else stop("no variants in this interval")
  }
ens = as.numeric(sapply(ggv, function(x) x$end))
chrs = sapply(ggv, function(x) x$referenceName)
refs = sapply(ggv, function(x) x$referenceBases)
alts = sapply(ggv, function(x) x$alternateBases)
#
# variant names could be one per alt
#
vnames = sapply(ggv, "[[", "names")
if (is.matrix(vnames))
  allnames = apply(vnames,2,function(x) paste(unique(x), collapse=";"))
else if (is.list(vnames))
  allnames = sapply(vnames, function(x)
    if (is.character(unlist(x))) paste(unique(x), collapse=";") else NA)
#
# determine counts and values of variant calls in range (all samples)
#
clens = sapply(ggv, function(x) length(x$calls))
calls = lapply(ggv, function(x) x$calls)
#
#
# retrieve all sample identifiers for each variant
# and confirm that they are consistently ordered for all variants
# fail if they are not
#
sids = lapply(calls, sapply, function(x)x$callSetName) # sample names
if (length(sids)>1)
  for (j in 2:length(sids)) stopifnot(all.equal(sids[[1]], sids[[j]]))
#
# begin a GRanges with structural and base information
#
if (oneBasedCoord) sts=sts+1
gr = GRanges(chrs, IRanges(sts,ens), ref=refs, 
       alt=sapply(alts, paste, collapse="")) # any multinucleotide alts collapsed
#
# obtain all genotype calls, current assumption is "unphased" -- need more info
# from VCF content, might be in the JSON -- FIXME
#
gs = unlist(lapply(calls, sapply, function(x)paste(unlist(x$genotype), 
    collapse="/")))
#
# obtain initial VRanges
#
gr = as(rep(gr, each=clens[1]), "VRanges")
#
# bind sample names
#
sampleNames(gr) = unlist(sids)
#
# add genotype field FIXME -- may not reflect actual content of GT field in VCF
#
gr$GT = gs
#
# bind on variant names
#
names(gr) = rep(allnames, each=clens[1])
gr
}
