# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a "client ID for native application" id and secret from the Google Developer's console
# (console.developers.google.com). Make sure you pass in your own values.
setup <- function(clientId="...googleusercontent.com", clientSecret) {
  # Package type as determined by the platform. Source for Linux, and preference to binary for others.
  pkgType <- getOption("pkgType")
  if (grepl(pkgType, "binary")) {
    pkgType <- "both"
  }

  # Cran packages
  update.packages()
  cranPkgs <- c("rjson", "httr")
  cranInstallPkgs <- c(cranPkgs, "jsonlite", "httpuv") # Runtime dependencies
  cranInstallPkgs <- cranInstallPkgs[!cranInstallPkgs %in% installed.packages()]
  if (length(cranInstallPkgs) > 0)
    install.packages(cranInstallPkgs, type=pkgType)
  sapply(cranPkgs, library, character.only=TRUE)

  # Bioconductor packages
  source("http://bioconductor.org/biocLite.R")
  biocLite() # Update all packages
  if (biocVersion() >= "2.14") {
    biocLitePkgs <- c("GenomicAlignments", "ggbio", "Rsamtools", "VariantAnnotation")
  } else {
    biocLitePkgs <- c("GenomicRanges", "ggbio", "Rsamtools", "VariantAnnotation")
  }

  biocLiteInstallPkgs <- biocLitePkgs[!biocLitePkgs %in% installed.packages()]
  if (length(biocLiteInstallPkgs) > 0)
    biocLite(biocLiteInstallPkgs, type=pkgType)
  sapply(biocLitePkgs, library, character.only=TRUE)

  app <- oauth_app("google", clientId, clientSecret)
  google_token <<- oauth2.0_token(oauth_endpoints("google"), app,
      scope = "https://www.googleapis.com/auth/genomics", use_oob=TRUE)
}

# By default, this function encompasses 2 chromosome positions which relate to ApoE
# (http://www.snpedia.com/index.php/Rs429358 and http://www.snpedia.com/index.php/Rs7412)
getReadData <- function(chromosome="chr19", start=45411941, end=45412079,
    readsetId="CJ_ppJ-WCxDxrtDr5fGIhBA=", endpoint="https://www.googleapis.com/genomics/v1beta/",
    pageToken=NULL) {

  # Fetch data from the Genomics API
  body <- list(readsetIds=list(readsetId), sequenceName=chromosome, sequenceStart=start,
      sequenceEnd=end, pageToken=pageToken)

  message("Fetching read data page")

  res <- POST(paste(endpoint, "reads/search", sep=""),
    query=list(fields="nextPageToken,reads(name,cigar,position,originalBases,flags)"),
    body=toJSON(body), config(token=google_token), add_headers("Content-Type"="application/json"))
  stop_for_status(res)

  message("Parsing read data page")
  res_content <- content(res)
  reads <<- res_content$reads

  # Transform the Genomics API data into a GAlignments object
  names = sapply(reads, '[[', 'name')
  cigars = sapply(reads, '[[', 'cigar')
  positions = as.integer(sapply(reads, '[[', 'position'))
  flags = sapply(reads, '[[', 'flags')

  isMinusStrand = bamFlagAsBitMatrix(as.integer(flags), bitnames="isMinusStrand")
  total_reads = length(positions)

  if (is.null(pageToken)) {
  	# If this is the first getReadData request, clear out any existing alignments
  	# Otherwise we will append our data to what we've retrieved before
  	alignments <<- NULL
  }

  alignments <<- c(GAlignments(
      seqnames=Rle(c(chromosome), c(total_reads)),
      strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))),
      pos=positions, cigar=cigars, names=names, flag=flags), alignments)

  if (!is.null(res_content$nextPageToken)) {
 	  message(paste("Continuing read query with the nextPageToken:", res_content$nextPageToken))
  	getReadData(chromosome=chromosome, start=start, end=end, readsetId=readsetId,
  	    endpoint=endpoint, pageToken=res_content$nextPageToken)
  } else {
    message("Read data is now available")
  }
}

plotAlignments <- function(xlab="") {
  # Display the basic alignments
  p1 <- autoplot(alignments, aes(color=strand, fill=strand))

  # And coverage data
  p2 <- ggplot(as(alignments, 'GRanges')) + stat_coverage(color="gray40", fill="skyblue")
  tracks(p1, p2, xlab=xlab)

  # You could also display the spot on the chromosome these alignments came from
  # p3 <- plotIdeogram(genome="hg19", subchr=chromosome)
  # p3 + xlim(as(alignments, 'GRanges'))
}

# By default, this function gets variant data from a small section of 1000 genomes
getVariantData <- function(datasetId="376902546192", chromosome="22", start=16051400, end=16051500,
    endpoint="https://www.googleapis.com/genomics/v1beta/", pageToken=NULL) {

  # Fetch data from the Genomics API
  body <- list(datasetId=datasetId, contig=chromosome, startPosition=start,
      endPosition=end, pageToken=pageToken)

  message("Fetching variant data page")

  res <- POST(paste(endpoint, "variants/search", sep=""),
    query=list(fields="nextPageToken,variants(names,referenceBases,alternateBases,position,info,calls(callsetName))"),
    body=toJSON(body), config(token=google_token), add_headers("Content-Type"="application/json"))
  stop_for_status(res)

  message("Parsing variant data page")
  res_content <- content(res)
  variants <<- res_content$variants

  # Transform the Genomics API data into a VRanges object

  if (is.null(pageToken)) {
  	# If this is the first getVariantData request, clear out any existing ranges
  	# Otherwise we will append our data to what we've retrieved before
  	variantdata <<- NULL
  }

  # Each variant gets a VRanges object
  for (v in variants) {
    name = v[["names"]] # TODO: Use this field
  	refs = v[["referenceBases"]]
  	alts = v[["alternateBases"]]
  	position = as.integer(v[["position"]])

    calls = v[["calls"]]
  	samples = factor(sapply(calls, "[[", "callsetName"))
  	# TODO: Can we put genotype in here somewhere?
  	reflength = length(refs)

    info = data.frame(variants[["info"]]) # TODO: Add the info tags to the ranges

  	ranges = VRanges(
        seqnames=Rle(chromosome, 1),
        ranges=IRanges(position, width=reflength),
        ref=refs, alt=alts[[1]], sampleNames=samples)

    if (is.null(variantdata)) {
      variantdata <<- ranges
    } else {
      variantdata <<- c(variantdata, ranges)
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
