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
library(shiny)
library(httr)
library(jsonlite)
library(httpuv)
library(ggbio)
library(GenomicRanges)
library(Rsamtools)

shinyServer(function(input, output) {

  endpoint = 'https://www.googleapis.com/genomics/v1beta2/'

  google_token <- reactive({
    shiny::validate(
      need(input$clientId != '', label = 'Client ID'),
      need(input$clientSecret != '', label = 'Client secret')
    )
    app <- oauth_app('google', input$clientId, input$clientSecret)
    oauth2.0_token(oauth_endpoints('google'), app,
        scope = 'https://www.googleapis.com/auth/genomics')
  })

  alignments <- reactive({
    shiny::validate(
      need(input$readGroupSetId != '', label = 'Read group set ID'),
      need(input$chr != '', label = 'Reference name'),
      need(input$position > 1000, 'Position must be greater than 1000')
    )
    getAlignments(readGroupSetId=input$readGroupSetId, chr=input$chr,
        start=input$position - 1000, end=input$position + 1000)
  })
    
  output$plot <- renderPlot({
    data = alignments()

    reads <- autoplot(data, aes(color=strand, fill=strand))
    coverage <- ggplot(as(data, 'GRanges')) + stat_coverage(
        color='gray40', fill='skyblue')
    tracks(reads, coverage, xlab='Position')
  }, height=500)


  # Get alignment data from the Google Genomics API
  getAlignments <- function(readGroupSetId, chr, start, end, pageToken='') {
    body <- list(readGroupSetIds=list(readGroupSetId), referenceName=chr,
      start=start, end=end, pageToken=pageToken,
      pageSize=1024)

    res <- POST(paste(endpoint, 'reads/search', sep=''),
        body=toJSON(body, auto_unbox=TRUE), config(token=google_token()),
        add_headers('Content-Type'='application/json'))
    stop_for_status(res)

    res_content <- content(res)
    reads <- res_content$alignments

    shiny::validate(need(length(reads) > 0,
        'No read data found for this position'))
    alignments <- readsToAlignments(reads, chr)

    if (!is.null(res_content$nextPageToken)) {
      return(c(alignments, getAlignments(readGroupSetId=readGroupSetId, chr=chr,
          start=start, end=end, pageToken=res_content$nextPageToken)))
    } else {
      return(alignments)
    }
  }

  # Transformation helpers
  cigar_enum_map = list(
      ALIGNMENT_MATCH="M",
      CLIP_HARD="H",
      CLIP_SOFT="S",
      DELETE="D",
      INSERT="I",
      PAD="P",
      SEQUENCE_MATCH="=",
      SEQUENCE_MISMATCH="X",
      SKIP="N")

  getCigar <- function(read) {
    paste(sapply(read$alignment$cigar, function(cigarPiece) {
      paste(cigarPiece$operationLength,
          cigar_enum_map[cigarPiece$operation], sep='')
    }), collapse='')
  }

  getPosition <- function(read) {
    as.integer(read$alignment$position$position)
  }

  getFlags <- function(read) {
    flags = 0

    if (read$numberReads == 2) {
      flags = flags + 1 #read_paired
    }
    if (isTRUE(read$properPlacement)) {
      flags = flags + 2 #read_proper_pair
    }
    if (is.null(getPosition(read))) {
      flags = flags + 4 #read_unmapped
    }
    if (is.null(read$nextMatePosition$position)) {
      flags = flags + 8 #mate_unmapped
    }
    if (isTRUE(read$alignment$position$reverseStrand)) {
      flags = flags + 16 #read_reverse_strand
    }
    if (isTRUE(read$nextMatePosition$reverseStrand)) {
      flags = flags + 32 #mate_reverse_strand
    }
    if (read$readNumber == 0) {
      flags = flags + 64 #first_in_pair
    }
    if (read$readNumber == 1) {
      flags = flags + 128 #second_in_pair
    }
    if (isTRUE(read$secondaryAlignment)) {
      flags = flags + 256 #secondary_alignment
    }
    if (isTRUE(read$failedVendorQualityChecks)) {
      flags = flags + 512 #failed_quality_check
    }
    if (isTRUE(read$duplicateFragment)) {
      flags = flags + 1024 #duplicate_read
    }
    if (isTRUE(read$supplementaryAlignment)) {
      flags = flags + 2048 #supplementary_alignment
    }
    flags
  }

  # Transform the Google Genomics API read data into a GAlignments object
  readsToAlignments <- function(reads, chr) {
    names = sapply(reads, '[[', 'fragmentName')
    cigars = sapply(reads, getCigar)
    positions = sapply(reads, getPosition)
    flags = sapply(reads, getFlags)

    isMinusStrand = bamFlagAsBitMatrix(as.integer(flags),
        bitnames='isMinusStrand')
    total = length(positions)

    GAlignments(
        seqnames=Rle(c(chr), c(total)),
        strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))),
        pos=positions, cigar=cigars, names=names, flag=flags)
  }
})