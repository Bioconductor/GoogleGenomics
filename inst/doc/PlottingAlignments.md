<!-- R Markdown Documentation, DO NOT EDIT THE PLAIN MARKDOWN VERSION OF THIS FILE -->

<!-- Copyright 2014 Google Inc. All rights reserved. -->

<!-- Licensed under the Apache License, Version 2.0 (the "License"); -->
<!-- you may not use this file except in compliance with the License. -->
<!-- You may obtain a copy of the License at -->

<!--     http://www.apache.org/licenses/LICENSE-2.0 -->

<!-- Unless required by applicable law or agreed to in writing, software -->
<!-- distributed under the License is distributed on an "AS IS" BASIS, -->
<!-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. -->
<!-- See the License for the specific language governing permissions and -->
<!-- limitations under the License. -->

Plotting Alignments
==============

Let's take a look at the reads that overlap rs9536314 for sample NA12893 within the [Illumina Platinum Genomes](https://cloud.google.com/genomics/data/platinum-genomes) dataset.

```r
require(GoogleGenomics)
reads <- getReads(readsetId="CMvnhpKTFhDyy__v0qfPpkw",
                  chromosome="chr13",
                  start=33053995,
                  end=33054010)
```

```
## Fetching reads page
## Reads are now available
```

```r
alignments <- readsToGAlignments(reads)
```

Display the basic alignments and coverage data:

```r
require(ggplot2)
require(ggbio)
alignmentPlot <- autoplot(alignments, aes(color=strand, fill=strand))
```

```
## Scale for 'colour' is already present. Adding another scale for 'colour', which will replace the existing scale.
## Scale for 'fill' is already present. Adding another scale for 'fill', which will replace the existing scale.
```

```r
coveragePlot <- ggplot(as(alignments, 'GRanges')) + stat_coverage(color="gray40", fill="skyblue")
tracks(alignmentPlot, coveragePlot, xlab="foo")
```

![plot of chunk coverage](figure/coverage-1.png) 

You could also display the spot on the chromosome these alignments came from:

```r
ideogramPlot <- plotIdeogram(genome="hg19", subchr="chr13")
ideogramPlot + xlim(as(alignments, 'GRanges'))
```

![plot of chunk ideogram](figure/ideogram-1.png) 
