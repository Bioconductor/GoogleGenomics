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
library(shiny)
library(httr)
library(jsonlite)
library(httpuv)
library(ggbio)
library(GenomicRanges)
library(Rsamtools)

shinyServer(function(input, output) {

  alignments <- reactive({
    validate(
      need(input$readsetId != "", label = "Readset ID"),
      need(input$chr != "", label = "Sequence name"),
      need(input$position > 1000, "Position must be greater than 1000")
    )
    getAlignments(readsetId=input$readsetId, chr=input$chr,
        start=input$position - 1000, end=input$position + 1000)
  })
    
  output$plot <- renderPlot({
    data = alignments()

    reads <- autoplot(data, aes(color=strand, fill=strand))
    coverage <- ggplot(as(data, 'GRanges')) + stat_coverage(
        color="gray40", fill="skyblue")
    tracks(reads, coverage, xlab="Position")
  }, height=500)


  # Get alignment data from the Google Genomics API
  getAlignments <- function(readsetId, chr, start, end, pageToken="") {
    body <- list(readsetIds=list(readsetId), sequenceName=chr,
      sequenceStart=start, sequenceEnd=end, pageToken=pageToken,
      maxResults=1024)

    res <- POST(
        "https://www.googleapis.com/genomics/v1beta/reads/search",
        query=list(key="AIzaSyBCyldseSGXfdQVdT4gTPepOWunJzhJtd4",
            fields="nextPageToken,reads(name,cigar,position,flags)"),
        body=toJSON(body, auto_unbox=TRUE),
        add_headers("Content-Type"="application/json"))
    stop_for_status(res)

    res_content <- content(res)
    reads <- res_content$reads

    validate(need(length(reads) > 0, "No read data found for this position"))
    alignments <- readsToAlignments(reads, chr)

    if (!is.null(res_content$nextPageToken)) {
      return(c(alignments, getAlignments(readsetId=readsetId, chr=chr,
          start=start, end=end, pageToken=res_content$nextPageToken)))
    } else {
      return(alignments)
    }
  }

  # Transform the Google Genomics API read data into a GAlignments object
  readsToAlignments <- function(reads, chr) {
    names = sapply(reads, '[[', 'name')
    cigars = sapply(reads, '[[', 'cigar')
    positions = as.integer(sapply(reads, '[[', 'position'))
    flags = sapply(reads, '[[', 'flags')

    isMinusStrand = bamFlagAsBitMatrix(as.integer(flags),
        bitnames="isMinusStrand")
    total = length(positions)

    GAlignments(
        seqnames=Rle(c(chr), c(total)),
        strand=strand(as.vector(ifelse(isMinusStrand, '-', '+'))),
        pos=positions, cigar=cigars, names=names, flag=flags)
  }
})