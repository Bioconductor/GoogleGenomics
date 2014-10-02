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
