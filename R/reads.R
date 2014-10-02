#' Read Store.
#' 
#' Environment where the most recently read alignments and reads are stored.
#'   Reads can be accessed by \code{readStore$reads}.
#'   Alignments can be accessed by \code{readStore$alignments}.
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
  
  res <- POST(paste(endpoint, "reads/search", sep=""),
    query=list(fields="nextPageToken,reads(name,cigar,position,originalBases,flags)"),
    body=rjson::toJSON(body), config(token=.authStore$google_token),
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
