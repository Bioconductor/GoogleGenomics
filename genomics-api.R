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
  install.packages("rjson")
  install.packages("devtools")
  devtools::install_github("hadley/httr") # We need the dev version of httr for now
    
  # Bioconductor packages
  source("http://bioconductor.org/biocLite.R")
  biocLite("GenomicRanges")
  biocLite("ggbio")
  biocLite("Rsamtools")

  library(rjson)
  library(httr)
  library(ggbio)
  library(Rsamtools)

  app <- oauth_app("google", clientId, clientSecret)
  google_token <<- oauth2.0_token(oauth_endpoints("google"), app,
      scope = "https://www.googleapis.com/auth/genomics")
}

# By default, this function encompasses 2 chromosome positions which relate to ApoE
# (http://www.snpedia.com/index.php/Rs429358 and http://www.snpedia.com/index.php/Rs7412)
getReadData <- function(chromosome="chr19", start=45411941, end=45412079,
    readsetId="CJ_ppJ-WCxDxrtDr5fGIhBA=", endpoint="https://www.googleapis.com/genomics/v1beta/") {
    	
  # Fetch data from the Genomics API  	
  body <- list(readsetIds=list(readsetId), sequenceName=chromosome, sequenceStart=start, sequenceEnd=end)  	
    	
  res <- POST(paste(endpoint, "reads/search", sep=""),
    query=list(fields="reads(name,cigar,position,originalBases,flags)"),
    body=toJSON(body), config(token=google_token), add_headers("Content-Type"="application/json"))
  
  stop_for_status(res)
  reads <<- content(res)$reads

  # Transform the Genomics API data into a GAlignments object
  names = sapply(reads, '[[', 'name')
  cigars = sapply(reads, '[[', 'cigar')
  positions = as.integer(sapply(reads, '[[', 'position'))
  flags = sapply(reads, '[[', 'flags')
  
  isMinusStrand = bamFlagAsBitMatrix(as.integer(flags), bitnames="isMinusStrand")
  total_reads = length(positions)

  alignments <<- GAlignments(
      seqnames=Rle(c(chromosome), c(total_reads)), 
      strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))), 
      pos=positions, cigar=cigars, names=names, flag=flags)
 
  plotAlignments()    
}

plotAlignments <- function() {    
  # Display the basic alignments    
  p1 <- autoplot(alignments, color="gray40", fill="skyblue") 
  p1

  # You could also display the spot on the chromosome these alignments came from     
  # p2 <- plotIdeogram(genome="hg19", subchr=chromosome)  
  # p2 + xlim(as(alignments, 'GRanges'))
}    