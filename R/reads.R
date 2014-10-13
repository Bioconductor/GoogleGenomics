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

#' Read Store.
#' 
#' Environment where the most recently read alignments and reads are stored.
#'   Reads can be accessed by \code{readStore$reads}.
#'   Alignments can be accessed by \code{readStore$alignments}.
#'   
#' @format An R environment.
readStore <- new.env()

#' Get reads data from Google Genomics.
#' 
#' By default, this function encompasses 2 chromosome positions which relate to ApoE
#' (http://www.snpedia.com/index.php/Rs429358 and http://www.snpedia.com/index.php/Rs7412)
#' 
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param readsetId The readset ID.
#' @param endpoint The Google API endpoint. You should not be changing this.
#' @param pageToken The page token. This can be NULL (default) for the first page.
#' @export
getReadData <- function(chromosome="chr19", start=45411941, end=45412079,
  readsetId="CJ_ppJ-WCxDxrtDr5fGIhBA=", endpoint="https://www.googleapis.com/genomics/v1beta/",
  pageToken=NULL) {
  
  # Fetch data from the Genomics API
  body <- list(readsetIds=list(readsetId), sequenceName=chromosome, sequenceStart=start,
    sequenceEnd=end, pageToken=pageToken)
  
  message("Fetching read data page")
  
  queryParams <- list(fields="nextPageToken,reads(name,cigar,position,originalBases,flags)")
  queryConfig <- config()
  if (.authStore$use_api_key) {
    queryParams <- c(queryParams, key=.authStore$api_key)
  } else {
    queryConfig <- config(token=.authStore$google_token)
  }
  res <- POST(paste(endpoint, "reads/search", sep=""),
    query=queryParams,
    body=rjson::toJSON(body), queryConfig,
    add_headers("Content-Type"="application/json"))
  if("error" %in% names(httr::content(res))) {
    print(paste("ERROR:", httr::content(res)$error$message))
  }
  stop_for_status(res)
  
  message("Parsing read data page")
  res_content <- httr::content(res)
  readStore$reads <- res_content$reads
  
  # Transform the Genomics API data into a GAlignments object
  names = sapply(readStore$reads, '[[', 'name')
  cigars = sapply(readStore$reads, '[[', 'cigar')
  positions = as.integer(sapply(readStore$reads, '[[', 'position'))
  flags = sapply(readStore$reads, '[[', 'flags')
  
  isMinusStrand = bamFlagAsBitMatrix(as.integer(flags), bitnames="isMinusStrand")
  total_reads = length(positions)
  
  if (is.null(pageToken)) {
    # If this is the first getReadData request, clear out any existing alignments
    # Otherwise we will append our data to what we've retrieved before
    readStore$alignments <- NULL
  }
  
  readStore$alignments <- c(GAlignments(
    seqnames=Rle(c(chromosome), c(total_reads)),
    strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))),
    pos=positions, cigar=cigars, names=names, flag=flags), readStore$alignments)
  
  if (!is.null(res_content$nextPageToken)) {
    message(paste("Continuing read query with the nextPageToken:", res_content$nextPageToken))
    getReadData(chromosome=chromosome, start=start, end=end, readsetId=readsetId,
      endpoint=endpoint, pageToken=res_content$nextPageToken)
  } else {
    message("Read data is now available")
  }
}
