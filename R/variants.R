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
variantStore <- new.env()

#' Get variants data from Google Genomics.
#' 
#' By default, this function gets variant data from a small section of 1000 genomes
#' 
#' @param datasetId The dataset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param endpoint The Google API endpoint. You should not be changing this.
#' @param pageToken The page token. This can be NULL (default) for the first page.
#' @export
getVariantData <- function(datasetId="10473108253681171589", chromosome="22", start=16051400, end=16051500,
  endpoint="https://www.googleapis.com/genomics/v1beta/", pageToken=NULL) {
  
  # Fetch data from the Genomics API
  body <- list(variantSetIds=list(datasetId), referenceName=chromosome, start=start,
    end=end, pageToken=pageToken)
  
  message("Fetching variant data page")
  
  res <- POST(paste(endpoint, "variants/search", sep=""),
    query=list(fields="nextPageToken,variants(names,referenceBases,alternateBases,start,info,calls(callSetName))"),
    body=toJSON(body), config(token=.authStore$google_token),
    add_headers("Content-Type"="application/json"))
  if("error" %in% names(content(res))) {
    print(paste("ERROR:", content(res)$error$message))
  }
  stop_for_status(res)
  
  message("Parsing variant data page")
  res_content <- content(res)
  variantStore$variants <- res_content$variants
  
  # Transform the Genomics API data into a VRanges object
  
  if (is.null(pageToken)) {
    # If this is the first getVariantData request, clear out any existing ranges
    # Otherwise we will append our data to what we've retrieved before
    variantStore$variantdata <- NULL
  }
  
  # Each variant gets a VRanges object
  for (v in variantStore$variants) {
    name = v[["names"]] # TODO: Use this field
    refs = v[["referenceBases"]]
    alts = v[["alternateBases"]]
    position = as.integer(v[["start"]])
    
    calls = v[["calls"]]
    samples = factor(sapply(calls, "[[", "callSetName"))
    # TODO: Can we put genotype in here somewhere?
    reflength = length(refs)
    
    info = data.frame(variantStore$variants[["info"]]) # TODO: Add the info tags to the ranges
    
    ranges = VRanges(
      seqnames=Rle(chromosome, 1),
      ranges=IRanges(position, width=reflength),
      ref=refs, alt=alts[[1]], sampleNames=samples)
    
    if (is.null(variantStore$variantdata)) {
      variantStore$variantdata <- ranges
    } else {
      variantStore$variantdata <- c(variantStore$variantdata, ranges)
    }
  }
  
  if (!is.null(res_content$nextPageToken)) {
    message(paste("Continuing variant query with the nextPageToken:", res_content$nextPageToken))
    getVariantData(datasetId=datasetId, chromosome=chromosome, start=start, end=end,
      endpoint=endpoint, pageToken=res_content$nextPageToken)
  } else {
    message("Variant data is now available")
  }
}
