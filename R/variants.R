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

#' Variants Store.
#'
#' Environment where the most recently read variants are stored.
#'   Variants can be accessed by \code{variantStore$variants}.
#'   Detailed variants data can be accessed by \code{variantStore$variantsData}.
#'
#' @format An R environment.

#' Get variants data from Google Genomics.
#'
#' By default, this function gets variant data from a small section of 1000 Genomes
#'
#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param endpoint The Google API endpoint. You should not be changing this.
#' @param pageToken The page token. This can be NULL (default) for the first page.
#' @export
getVariantsPage <- function(datasetId="10473108253681171589",
                            chromosome="22",
                            start=16051400,
                            end=16051500,
                            endpoint="https://www.googleapis.com/genomics/v1beta/",
                            oneBasedCoord=FALSE,
                            fields=NULL,
                            pageToken=NULL) {

  if(TRUE == oneBasedCoord) {
    # Pseudo-code to convert variants from 1-based coordinates to 0-based coordinates:
    # if (type=SNV){start=start-1; end=end;}
    # if (type=DEL){start=start-1; end=end;}
    # if (type=INS){start=start; end=end-1;}
    start <- start - 1
  }

  # Fetch data from the Genomics API
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

  message("Fetching variant data page")
  res <- httr::POST(paste(endpoint, "variants/search", sep=""),
    query=queryParams,
    body=rjson::toJSON(body),
    queryConfig,
    httr::add_headers("Content-Type"="application/json"))
  if("error" %in% names(httr::content(res))) {
    print(paste("ERROR:", httr::content(res)$error$message))
  }
  httr::stop_for_status(res)

  message("Parsing variant data page")
  res_content <- httr::content(res)
  list(variants=res_content$variants, nextPageToken=res_content$nextPageToken)
}

getVariants <- function(datasetId="10473108253681171589",
                        chromosome="22",
                        start=16051400,
                        end=16051500,
                        endpoint="https://www.googleapis.com/genomics/v1beta/",
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
                              endpoint=endpoint,
                              oneBasedCoord=oneBasedCoord,
                              pageToken=pageToken,
                              fields=fields)
    pageToken <- result$nextPageToken
    variants <- c(variants, converter(result$variants))
    if(is.null(pageToken)) {
      break
    }
    message(paste("Continuing variant query with the nextPageToken:", pageToken))
  }
  message("Variant data is now available")
  variants
}

variantsToVRanges <- function(variants) {
  if(missing(variants)) {
    return(VRanges())
  }

  vranges <- do.call("c", lapply(variants, function(v) {
    # Pseudo-code to convert variants from 0-based coordinates to 1-based coordinates:
    # if (type=SNV){start=start+1; end=end;}
    # if (type=DEL){start=start+1; end=end;}
    # if (type=INS){start=start; end=end+1;}
    # TODO don't do this if an insert
    position <- as.integer(v[["start"]])+ 1

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

variantsToVCF <- function(variants) {
  stop("method not yet implemented")
}
