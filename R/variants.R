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
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param oneBasedCoord Interpret start and end as 1-based coordinates.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'      return all fields.
#' @param pageToken The page token. This can be NULL (default) for the first page.
#' @return A two-element list is returned by the function.
#'
#'     variants: A list of R objects corresponding to the JSON objects returned
#'               by the Google Genomics Variants API.
#'
#'     nextPageToken: The token to be used to retrieve the next page of
#'                    results, if applicable.
#' @export
getVariantsPage <- function(datasetId="10473108253681171589",
                            chromosome="22",
                            start=16051400,
                            end=16051500,
                            oneBasedCoord=FALSE,
                            fields=NULL,
                            pageToken=NULL) {

  if(TRUE == oneBasedCoord) {
    start <- start - 1
  }

  # Fetch variants from the Genomics API
  body <- list(variantSetIds=list(datasetId), referenceName=chromosome,
               start=start, end=end, pageToken=pageToken)
  queryConfig <- httr::config()
  queryParams <- list()

  if(is.null(fields)) {
    fields <- "nextPageToken,variants"
  } else {
    if(!grepl("nextPageToken", fields)) {
      fields <- paste(fields, "nextPageToken", sep=",")
    }
  }
  queryParams <- c(queryParams, fields=fields)

  if (GoogleGenomics:::.authStore$use_api_key) {
    queryParams <- c(queryParams, key=.authStore$api_key)
  } else {
    queryConfig <- httr::config(token=GoogleGenomics:::.authStore$google_token)
  }

  message("Fetching variant page")
  res <- httr::POST(paste(getOption("google_genomics_endpoint"),
                          "variants/search", sep=""),
    query=queryParams,
    body=rjson::toJSON(body),
    queryConfig,
    httr::add_headers("Content-Type"="application/json"))
  if("error" %in% names(httr::content(res))) {
    print(paste("ERROR:", httr::content(res)$error$message))
  }
  httr::stop_for_status(res)

  message("Parsing variant page")
  res_content <- httr::content(res)
  list(variants=res_content$variants, nextPageToken=res_content$nextPageToken)
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
#'
#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param oneBasedCoord Interpret start and end as 1-based coordinates.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'               return all fields.
#' @param converter A function that takes a list of variant R objects and returns
#'                  them converted to the desired type.
#' @return By default, the return value is a list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.  If a converter is passed,
#'  object(s) of the type returned by the converter will be returned by this function.
#' @export
getVariants <- function(datasetId="10473108253681171589",
                        chromosome="22",
                        start=16051400,
                        end=16051500,
                        oneBasedCoord=FALSE,
                        fields=NULL,
                        converter=c) {
  pageToken <- NULL
  variants <- converter()
  repeat {
    result <- getVariantsPage(datasetId=datasetId,
                              chromosome=chromosome,
                              start=start,
                              end=end,
                              oneBasedCoord=oneBasedCoord,
                              fields=fields,
                              pageToken=pageToken)
    pageToken <- result$nextPageToken
    variants <- c(variants, converter(result$variants))
    if(is.null(pageToken)) {
      break
    }
    message(paste("Continuing variant query with the nextPageToken:", pageToken))
  }
  message("Variants are now available")
  variants
}

#' Convert variants to VRanges.
#'
#' Note that genomic coordinates are converted from 0-based to 1-based.
#'
#' @param variants A list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.
#' @return VRanges
#' @references VRanges
variantsToVRanges <- function(variants) {
  if(missing(variants)) {
    return(VRanges())
  }

  vranges <- do.call("c", lapply(variants, function(v) {
    # Convert variants from 0-based coordinates to 1-based coordinates for
    # use with BioConductor.
    position <- as.integer(v[["start"]]) + 1

    ranges <- VRanges(
      seqnames=Rle(as.character(v[["referenceName"]]), 1),
      ranges=IRanges(start=position,
                     end=as.integer(v[["end"]])),
      ref=as.character(v[["referenceBases"]]),
      alt=as.character(v[["alternateBases"]][1]), # TODO flatten per alt
      qual=as.numeric(v[["quality"]]),
      filter=as.character(v[["filter"]]))

    names(ranges) <- as.character(v[["names"]][1])

    ranges
  }))
  vranges
}

#' Convert variants to GRanges.
#'
#' Note that genomic coordinates are converted from 0-based to 1-based.
#'
#' @param variants A list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.
#' @return GRanges
#' @references GRanges
variantsToGRanges <- function(variants) {
  if(missing(variants)) {
    return(GRanges())
  }

  granges <- do.call("c", lapply(variants, function(v) {
    # Convert variants from 0-based coordinates to 1-based coordinates for
    # use with BioConductor.
    position <- as.integer(v[["start"]]) + 1

    ranges <- GRanges(
      seqnames=Rle(as.character(v[["referenceName"]]), 1),
      ranges=IRanges(start=position,
                     end=as.integer(v[["end"]])),
      REF=DNAStringSet(v[["referenceBases"]]),
      ALT=DNAStringSetList(v[["alternateBases"]]),
      QUAL=as.numeric(v[["quality"]]),
      FILTER=as.character(v[["filter"]]))

    names(ranges) <- as.character(v[["names"]][1])

    ranges
  }))
  granges
}

#' Convert variants to VCF.
#'
#' @param variants A list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.
#' @return VCF
#' @references VCF
variantsToVCF <- function(variants) {
  stop("method not yet implemented")
}
