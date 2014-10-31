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

#' Get one page of reads from Google Genomics.
#'
#' In general, use the getReads method instead.  It calls this method,
#' returning reads from all of the pages that comprise the requested
#' genomic range.
#'
#' By default, this function gets reads for a small genomic region for one
#' sample in 1,000 Genomes.
#'
#' Note that the Global Alliance for Genomics and Health API uses a 0-based
#' coordinate system.  For more detail, please see GA4GH discussions such
#' as the following:
#' \itemize{
#'    \item\url{https://github.com/ga4gh/schemas/issues/168}
#'    \item\url{https://github.com/ga4gh/schemas/issues/121}
#'}
#'
#' @param readsetId The readset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'      return all fields.
#' @param pageToken The page token. This can be NULL (default) for the first page.
#' @return A two-element list is returned by the function.
#'
#'     reads: A list of R objects corresponding to the JSON objects returned
#'               by the Google Genomics Variants API.
#'
#'     nextPageToken: The token to be used to retrieve the next page of
#'                    results, if applicable.
#' @export
getReadsPage <- function(readsetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                         chromosome="22",
                         start=16051400,
                         end=16051500,
                         fields=NULL,
                         pageToken=NULL) {

  body <- list(readsetIds=list(readsetId), sequenceName=chromosome,
               sequenceStart=start, sequenceEnd=end, pageToken=pageToken)

  results <- getSearchPage("reads", body, fields, pageToken)

  list(reads=results$reads, nextPageToken=results$nextPageToken)
}

#' Get reads from Google Genomics.
#'
#' This function will return all of the reads that comprise the requested
#' genomic range, iterating over paginated results as necessary.
#'
#' By default, this function gets reads for a small genomic region for one
#' sample in 1,000 Genomes.
#'
#' Optionally pass a converter as appropriate for your use case.  By passing it
#' to this method, only the converted objects will be accumulated in memory. The
#' converter function should return an empty container of the desired type
#' if called without any arguments.
#'
#' @param readsetId The readset ID.
#' @param chromosome The chromosome.
#' @param start Start position on the chromosome.
#' @param end End position on the chromosome.
#' @param fields A subset of fields to retrieve.  The default (NULL) will
#'               return all fields.
#' @param converter A function that takes a list of read R objects and returns
#'                  them converted to the desired type.
#' @return By default, the return value is a list of R objects
#' corresponding to the JSON objects returned by the Google Genomics
#' Reads API.  If a converter is passed, object(s) of the type
#' returned by the converter will be returned by this function.
#' @export
getReads <- function(readsetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                     chromosome="22",
                     start=16051400,
                     end=16051500,
                     fields=NULL,
                     converter=c) {
  pageToken <- NULL
  reads <- converter()
  repeat {
    result <- getReadsPage(readsetId=readsetId,
                           chromosome=chromosome,
                           start=start,
                           end=end,
                           fields=fields,
                           pageToken=pageToken)
    pageToken <- result$nextPageToken
    # TODO improve performance https://github.com/googlegenomics/api-client-r/issues/17
    reads <- c(reads, converter(result$reads))
    if(is.null(pageToken)) {
      break
    }
    message(paste("Continuing read query with the nextPageToken:", pageToken))
  }

  message("Reads are now available")
  reads
}


#' Convert reads to GAlignments.
#'
#' @param reads A list of R objects corresponding to the JSON objects
#'  returned by the Google Genomics Variants API.
#' @param slStyle The style for seqnames (chrN or N or...).  Default is UCSC.
#' @return \link[GenomicAlignments]{GAlignments}
#' @export
readsToGAlignments <- function(reads, slStyle='UCSC') {

  if(missing(reads)) {
    return(GAlignments())
  }

  # Transform the Genomics API data into a GAlignments object
  names = sapply(reads, '[[', 'name')
  cigars = sapply(reads, '[[', 'cigar')
  positions = as.integer(sapply(reads, '[[', 'position'))
  flags = sapply(reads, '[[', 'flags')
  chromosomes = sapply(reads, '[[', 'referenceSequenceName')

  isMinusStrand = bamFlagAsBitMatrix(as.integer(flags), bitnames="isMinusStrand")
  total_reads = length(positions)

  alignments <- GAlignments(
    seqnames=Rle(chromosomes),
    strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))),
    pos=positions, cigar=cigars, names=names, flag=flags)

  seqlevelsStyle(alignments) <- slStyle
  alignments
}
