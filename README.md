client-r
==============

This R client fetches data from the
<a href="https://developers.google.com/genomics">Google Genomics API</a> and
turns it into a GAlignments object provided by the
<a href="http://master.bioconductor.org/packages/release/bioc/html/GenomicRanges.html">GenomicRanges package.</a>

This GAlignments object is then plotted using
<a href="http://master.bioconductor.org/packages/release/bioc/html/ggbio.html">ggbio</a> - but 
it can also be integrated with any of the other R packages that support GAlignments or GRanges.

###Getting started

* First you'll need to setup an <a href="http://www.r-project.org/">R environment</a>.

* Then you'll need a valid client ID and secret. Follow the
<a href="https://developers.google.com/genomics#authenticate">authentication instructions</a>,
but instead of downloading the json file, you'll pass the 'Client ID' and
'Client secret' values into the setup function.

* In an R interpreter:
```
source("/path/to/genomics-tools/client-r/genomics-api.R")
setup("<client ID>", "<client secret>")
getReadData()
```

`setup` only needs to be run once. After it has been called, `getReadData`
can then be run repeatedly. It fetches data from the API
and can be used to search over any set of reads. You can pull up a different
sequence position by specifying additional arguments:
```
getReadData(chromosome="chr3", start="121458049", end="121459049")
```

Or, you can use the readsetId argument to query a different readset entirely:
```
getReadData(readsetId="<myreadset>")
```

Both `reads` and `alignments` are exported as global variables so that you
can use other <a href="http://www.bioconductor.org/">Bioconductor</a> 
tools to modify the data as you wish.
