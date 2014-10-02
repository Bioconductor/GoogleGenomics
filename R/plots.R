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

#' Plot the alignment coverage.
#' 
#' This function uses the reads stored in \code{readStore}.
#' 
#' @param xlab The X axis label.
#' @export
plotAlignments <- function(xlab="") {
  # Display the basic alignments
  p1 <- autoplot(readStore$alignments, aes(color=strand, fill=strand))
  
  # And coverage data
  p2 <- ggplot(as(readStore$alignments, 'GRanges')) + stat_coverage(color="gray40", fill="skyblue")
  tracks(p1, p2, xlab=xlab)
  
  # You could also display the spot on the chromosome these alignments came from
  #  p3 <- plotIdeogram(genome="hg19", subchr=chromosome)
  #  p3 + xlim(as(readStore$alignments, 'GRanges'))
}
