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

Reproducing Variant Annotation Results
---------------------------------------

Below we compare the results of annotating variants via the [VariantAnnotation](http://www.bioconductor.org/packages/release/bioc/html/VariantAnnotation.html)  [BioConductor](http://www.bioconductor.org/) package.  We compare using data from 1,000 Genomes Phase 1 Variants:
* as parsed from a VCF file
* retrieved from the Google Genomics API

### VCF Data

First we read in the data from the VCF file:

```r
require(VariantAnnotation)
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
vcf <- readVcf(fl, "hg19")
vcf <- renameSeqlevels(vcf, c("22"="chr22"))
vcf
```

```
## class: CollapsedVCF 
## dim: 10376 5 
## rowData(vcf):
##   GRanges with 5 metadata columns: paramRangeID, REF, ALT, QUAL, FILTER
## info(vcf):
##   DataFrame with 22 columns: LDAF, AVGPOST, RSQ, ERATE, THETA, CIEND, C...
## info(header(vcf)):
##              Number Type    Description                                   
##    LDAF      1      Float   MLE Allele Frequency Accounting for LD        
##    AVGPOST   1      Float   Average posterior probability from MaCH/Thu...
##    RSQ       1      Float   Genotype imputation quality from MaCH/Thunder 
##    ERATE     1      Float   Per-marker Mutation rate from MaCH/Thunder    
##    THETA     1      Float   Per-marker Transition rate from MaCH/Thunder  
##    CIEND     2      Integer Confidence interval around END for imprecis...
##    CIPOS     2      Integer Confidence interval around POS for imprecis...
##    END       1      Integer End position of the variant described in th...
##    HOMLEN    .      Integer Length of base pair identical micro-homolog...
##    HOMSEQ    .      String  Sequence of base pair identical micro-homol...
##    SVLEN     1      Integer Difference in length between REF and ALT al...
##    SVTYPE    1      String  Type of structural variant                    
##    AC        .      Integer Alternate Allele Count                        
##    AN        1      Integer Total Allele Count                            
##    AA        1      String  Ancestral Allele, ftp://ftp.1000genomes.ebi...
##    AF        1      Float   Global Allele Frequency based on AC/AN        
##    AMR_AF    1      Float   Allele Frequency for samples from AMR based...
##    ASN_AF    1      Float   Allele Frequency for samples from ASN based...
##    AFR_AF    1      Float   Allele Frequency for samples from AFR based...
##    EUR_AF    1      Float   Allele Frequency for samples from EUR based...
##    VT        1      String  indicates what type of variant the line rep...
##    SNPSOURCE .      String  indicates if a snp was called when analysin...
## geno(vcf):
##   SimpleList of length 3: GT, DS, GL
## geno(header(vcf)):
##       Number Type   Description                      
##    GT 1      String Genotype                         
##    DS 1      Float  Genotype dosage from MaCH/Thunder
##    GL .      Float  Genotype Likelihoods
```

The file `chr22.vcf.gz` within package VariantAnnotation holds data for 5 of the 1,092 individuals in 1,000 Genomes, starting at position 50300078 and ending at position 50999964.

`HG00096 HG00097 HG00099 HG00100 HG00101`

### Google Genomics Data

Important data differences to note:
* VCF data uses 1-based coordinates but data from the GA4GH APIs is 0-based.
* There are two variants in the Google Genomics copy of 1,000 Genomes phase 1 variants that are not in `chr22.vcf.gz`.  They are the only two variants within the genomic range with `ALT == <DEL>`.


```r
require(GoogleGenomics)

# TODO Right now we're just getting a few variants.  Later update this to retrieve them all.
system.time({
granges <- getVariants(datasetId="10473108253681171589",
                       chromosome="22",
                       start=50300077,
                       end=50303000,         # TODO end=50999964
                       converter=variantsToGRanges)
})
```

```
## Fetching variants page
## Continuing variant query with the nextPageToken: CPmR_hcQl5DAzMmGoeht
## Fetching variants page
## Continuing variant query with the nextPageToken: CKuZ_hcQ9pHXwa742bKgAQ
## Fetching variants page
## Continuing variant query with the nextPageToken: CJqf_hcQ26CqjLiVvan2AQ
## Fetching variants page
## Variants are now available
```

```
##    user  system elapsed 
##   8.190   0.257  13.572
```

### Compare the Loaded Data
Ensure that the data retrieved by each matches:

```r
vcf <- vcf[1:length(granges)] # Truncate the VCF data

require(testthat)
```

```
## Loading required package: testthat
```

```r
expect_equal(start(granges), start(vcf))
expect_equal(end(granges), end(vcf))
expect_equal(as.character(granges$REF), as.character(ref(vcf)))
expect_equal(as.character(unlist(granges$ALT)), as.character(unlist(alt(vcf))))
expect_equal(granges$QUAL, qual(vcf))
expect_equal(granges$FILTER, filt(vcf))
```

### Compare the Annotations


```r
# To install annotation database packages (only need to do this once)
source("http://bioconductor.org/biocLite.R")
biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")
biocLite("BSgenome.Hsapiens.UCSC.hg19")
biocLite("org.Hs.eg.db")
```

Now locate the protein coding variants in each:

```r
require(TxDb.Hsapiens.UCSC.hg19.knownGene)
```

```
## Loading required package: TxDb.Hsapiens.UCSC.hg19.knownGene
## Loading required package: GenomicFeatures
## Loading required package: AnnotationDbi
## Loading required package: Biobase
## Welcome to Bioconductor
## 
##     Vignettes contain introductory material; view with
##     'browseVignettes()'. To cite Bioconductor, see
##     'citation("Biobase")', and for packages 'citation("pkgname")'.
## 
## 
## Attaching package: 'AnnotationDbi'
## 
## The following object is masked from 'package:GenomeInfoDb':
## 
##     species
```

```r
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene


rd <- rowData(vcf)
vcf_locations <- locateVariants(rd, txdb, CodingVariants())
vcf_locations
```

```
## GRanges object with 7 ranges and 9 metadata columns:
##       seqnames               ranges strand | LOCATION  LOCSTART    LOCEND
##          <Rle>            <IRanges>  <Rle> | <factor> <integer> <integer>
##   [1]    chr22 [50301422, 50301422]      - |   coding       939       939
##   [2]    chr22 [50301476, 50301476]      - |   coding       885       885
##   [3]    chr22 [50301488, 50301488]      - |   coding       873       873
##   [4]    chr22 [50301494, 50301494]      - |   coding       867       867
##   [5]    chr22 [50301584, 50301584]      - |   coding       777       777
##   [6]    chr22 [50302962, 50302962]      - |   coding       698       698
##   [7]    chr22 [50302995, 50302995]      - |   coding       665       665
##         QUERYID      TXID     CDSID      GENEID       PRECEDEID
##       <integer> <integer> <integer> <character> <CharacterList>
##   [1]        24     75253    218562       79087                
##   [2]        25     75253    218562       79087                
##   [3]        26     75253    218562       79087                
##   [4]        27     75253    218562       79087                
##   [5]        28     75253    218562       79087                
##   [6]        57     75253    218563       79087                
##   [7]        58     75253    218563       79087                
##              FOLLOWID
##       <CharacterList>
##   [1]                
##   [2]                
##   [3]                
##   [4]                
##   [5]                
##   [6]                
##   [7]                
##   -------
##   seqinfo: 1 sequence from an unspecified genome; no seqlengths
```

```r
granges_locations <- locateVariants(granges, txdb, CodingVariants())
granges_locations
```

```
## GRanges object with 7 ranges and 9 metadata columns:
##       seqnames               ranges strand | LOCATION  LOCSTART    LOCEND
##          <Rle>            <IRanges>  <Rle> | <factor> <integer> <integer>
##   [1]    chr22 [50301422, 50301422]      - |   coding       939       939
##   [2]    chr22 [50301476, 50301476]      - |   coding       885       885
##   [3]    chr22 [50301488, 50301488]      - |   coding       873       873
##   [4]    chr22 [50301494, 50301494]      - |   coding       867       867
##   [5]    chr22 [50301584, 50301584]      - |   coding       777       777
##   [6]    chr22 [50302962, 50302962]      - |   coding       698       698
##   [7]    chr22 [50302995, 50302995]      - |   coding       665       665
##         QUERYID      TXID     CDSID      GENEID       PRECEDEID
##       <integer> <integer> <integer> <character> <CharacterList>
##   [1]        24     75253    218562       79087                
##   [2]        25     75253    218562       79087                
##   [3]        26     75253    218562       79087                
##   [4]        27     75253    218562       79087                
##   [5]        28     75253    218562       79087                
##   [6]        57     75253    218563       79087                
##   [7]        58     75253    218563       79087                
##              FOLLOWID
##       <CharacterList>
##   [1]                
##   [2]                
##   [3]                
##   [4]                
##   [5]                
##   [6]                
##   [7]                
##   -------
##   seqinfo: 1 sequence from an unspecified genome; no seqlengths
```

```r
expect_equal(granges_locations, vcf_locations)
```

And predict the effect of the protein coding variants:

```r
require(BSgenome.Hsapiens.UCSC.hg19)
```

```
## Loading required package: BSgenome.Hsapiens.UCSC.hg19
## Loading required package: BSgenome
## Loading required package: rtracklayer
```

```r
vcf_coding <- predictCoding(vcf, txdb, seqSource=Hsapiens)
vcf_coding
```

```
## GRanges object with 7 ranges and 17 metadata columns:
##                   seqnames               ranges strand | paramRangeID
##                      <Rle>            <IRanges>  <Rle> |     <factor>
##       rs114335781    chr22 [50301422, 50301422]      - |         <NA>
##         rs8135963    chr22 [50301476, 50301476]      - |         <NA>
##   22:50301488_C/T    chr22 [50301488, 50301488]      - |         <NA>
##   22:50301494_G/A    chr22 [50301494, 50301494]      - |         <NA>
##   22:50301584_C/T    chr22 [50301584, 50301584]      - |         <NA>
##       rs114264124    chr22 [50302962, 50302962]      - |         <NA>
##       rs149209714    chr22 [50302995, 50302995]      - |         <NA>
##                              REF                ALT      QUAL      FILTER
##                   <DNAStringSet> <DNAStringSetList> <numeric> <character>
##       rs114335781              G                  A       100        PASS
##         rs8135963              T                  C       100        PASS
##   22:50301488_C/T              C                  T       100        PASS
##   22:50301494_G/A              G                  A       100        PASS
##   22:50301584_C/T              C                  T       100        PASS
##       rs114264124              C                  T       100        PASS
##       rs149209714              C                  G       100        PASS
##                        varAllele     CDSLOC    PROTEINLOC   QUERYID
##                   <DNAStringSet>  <IRanges> <IntegerList> <integer>
##       rs114335781              T [939, 939]           313        24
##         rs8135963              G [885, 885]           295        25
##   22:50301488_C/T              A [873, 873]           291        26
##   22:50301494_G/A              T [867, 867]           289        27
##   22:50301584_C/T              A [777, 777]           259        28
##       rs114264124              A [698, 698]           233        57
##       rs149209714              C [665, 665]           222        58
##                          TXID     CDSID      GENEID   CONSEQUENCE
##                   <character> <integer> <character>      <factor>
##       rs114335781       75253    218562       79087    synonymous
##         rs8135963       75253    218562       79087    synonymous
##   22:50301488_C/T       75253    218562       79087    synonymous
##   22:50301494_G/A       75253    218562       79087    synonymous
##   22:50301584_C/T       75253    218562       79087    synonymous
##       rs114264124       75253    218563       79087 nonsynonymous
##       rs149209714       75253    218563       79087 nonsynonymous
##                         REFCODON       VARCODON         REFAA
##                   <DNAStringSet> <DNAStringSet> <AAStringSet>
##       rs114335781            ATC            ATT             I
##         rs8135963            GCA            GCG             A
##   22:50301488_C/T            CCG            CCA             P
##   22:50301494_G/A            CAC            CAT             H
##   22:50301584_C/T            CCG            CCA             P
##       rs114264124            CGG            CAG             R
##       rs149209714            GGA            GCA             G
##                           VARAA
##                   <AAStringSet>
##       rs114335781             I
##         rs8135963             A
##   22:50301488_C/T             P
##   22:50301494_G/A             H
##   22:50301584_C/T             P
##       rs114264124             Q
##       rs149209714             A
##   -------
##   seqinfo: 1 sequence from hg19 genome; no seqlengths
```

```r
granges_coding <- predictCoding(rep(granges, elementLengths(granges$ALT)),
                                txdb,
                                seqSource=Hsapiens,
                                varAllele=unlist(granges$ALT, use.names=FALSE))

granges_coding
```

```
## GRanges object with 7 ranges and 16 metadata columns:
##               seqnames               ranges strand |            REF
##                  <Rle>            <IRanges>  <Rle> | <DNAStringSet>
##   rs114335781    chr22 [50301422, 50301422]      - |              G
##     rs8135963    chr22 [50301476, 50301476]      - |              T
##   rs200080075    chr22 [50301488, 50301488]      - |              C
##   rs147801200    chr22 [50301494, 50301494]      - |              G
##   rs138060012    chr22 [50301584, 50301584]      - |              C
##   rs114264124    chr22 [50302962, 50302962]      - |              C
##   rs149209714    chr22 [50302995, 50302995]      - |              C
##                              ALT      QUAL      FILTER      varAllele
##               <DNAStringSetList> <numeric> <character> <DNAStringSet>
##   rs114335781                  A       100        PASS              T
##     rs8135963                  C       100        PASS              G
##   rs200080075                  T       100        PASS              A
##   rs147801200                  A       100        PASS              T
##   rs138060012                  T       100        PASS              A
##   rs114264124                  T       100        PASS              A
##   rs149209714                  G       100        PASS              C
##                   CDSLOC    PROTEINLOC   QUERYID        TXID     CDSID
##                <IRanges> <IntegerList> <integer> <character> <integer>
##   rs114335781 [939, 939]           313        24       75253    218562
##     rs8135963 [885, 885]           295        25       75253    218562
##   rs200080075 [873, 873]           291        26       75253    218562
##   rs147801200 [867, 867]           289        27       75253    218562
##   rs138060012 [777, 777]           259        28       75253    218562
##   rs114264124 [698, 698]           233        57       75253    218563
##   rs149209714 [665, 665]           222        58       75253    218563
##                    GENEID   CONSEQUENCE       REFCODON       VARCODON
##               <character>      <factor> <DNAStringSet> <DNAStringSet>
##   rs114335781       79087    synonymous            ATC            ATT
##     rs8135963       79087    synonymous            GCA            GCG
##   rs200080075       79087    synonymous            CCG            CCA
##   rs147801200       79087    synonymous            CAC            CAT
##   rs138060012       79087    synonymous            CCG            CCA
##   rs114264124       79087 nonsynonymous            CGG            CAG
##   rs149209714       79087 nonsynonymous            GGA            GCA
##                       REFAA         VARAA
##               <AAStringSet> <AAStringSet>
##   rs114335781             I             I
##     rs8135963             A             A
##   rs200080075             P             P
##   rs147801200             H             H
##   rs138060012             P             P
##   rs114264124             R             Q
##   rs149209714             G             A
##   -------
##   seqinfo: 1 sequence from an unspecified genome; no seqlengths
```

```r
expect_equal(as.matrix(granges_coding$REFCODON), as.matrix(vcf_coding$REFCODON))
expect_equal(as.matrix(granges_coding$VARCODON), as.matrix(vcf_coding$VARCODON))
expect_equal(granges_coding$GENEID, vcf_coding$GENEID)
expect_equal(granges_coding$CONSEQUENCE, vcf_coding$CONSEQUENCE)
```

Add gene information:

```r
require(org.Hs.eg.db)
```

```
## Loading required package: org.Hs.eg.db
## Loading required package: DBI
```

```r
annots <- select(org.Hs.eg.db,
                 keys=granges_coding$GENEID,
                 keytype="ENTREZID",
                 columns=c("SYMBOL", "GENENAME","ENSEMBL"))
cbind(elementMetadata(granges_coding), annots)
```

```
##   REF ALT QUAL FILTER varAllele CDSLOC.start CDSLOC.end CDSLOC.width
## 1   G   A  100   PASS         T          939        939            1
## 2   T   C  100   PASS         G          885        885            1
## 3   C   T  100   PASS         A          873        873            1
## 4   G   A  100   PASS         T          867        867            1
## 5   C   T  100   PASS         A          777        777            1
## 6   C   T  100   PASS         A          698        698            1
## 7   C   G  100   PASS         C          665        665            1
##   CDSLOC.names PROTEINLOC QUERYID  TXID  CDSID GENEID   CONSEQUENCE
## 1  rs114335781        313      24 75253 218562  79087    synonymous
## 2    rs8135963        295      25 75253 218562  79087    synonymous
## 3  rs200080075        291      26 75253 218562  79087    synonymous
## 4  rs147801200        289      27 75253 218562  79087    synonymous
## 5  rs138060012        259      28 75253 218562  79087    synonymous
## 6  rs114264124        233      57 75253 218563  79087 nonsynonymous
## 7  rs149209714        222      58 75253 218563  79087 nonsynonymous
##   REFCODON VARCODON REFAA VARAA ENTREZID SYMBOL
## 1      ATC      ATT     I     I    79087  ALG12
## 2      GCA      GCG     A     A    79087  ALG12
## 3      CCG      CCA     P     P    79087  ALG12
## 4      CAC      CAT     H     H    79087  ALG12
## 5      CCG      CCA     P     P    79087  ALG12
## 6      CGG      CAG     R     Q    79087  ALG12
## 7      GGA      GCA     G     A    79087  ALG12
##                               GENENAME         ENSEMBL
## 1 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 2 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 3 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 4 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 5 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 6 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
## 7 ALG12, alpha-1,6-mannosyltransferase ENSG00000182858
```

### Provenance
Package versions used:

```r
sessionInfo()
```

```
## R version 3.1.1 (2014-07-10)
## Platform: x86_64-apple-darwin13.1.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats4    parallel  stats     graphics  grDevices utils     datasets 
## [8] methods   base     
## 
## other attached packages:
##  [1] org.Hs.eg.db_3.0.0                     
##  [2] RSQLite_0.11.4                         
##  [3] DBI_0.3.1                              
##  [4] BSgenome.Hsapiens.UCSC.hg19_1.3.99     
##  [5] BSgenome_1.34.0                        
##  [6] rtracklayer_1.26.1                     
##  [7] TxDb.Hsapiens.UCSC.hg19.knownGene_3.0.0
##  [8] GenomicFeatures_1.18.1                 
##  [9] AnnotationDbi_1.28.0                   
## [10] Biobase_2.26.0                         
## [11] testthat_0.9.1                         
## [12] ggbio_1.14.0                           
## [13] ggplot2_1.0.0                          
## [14] GoogleGenomics_0.1.1                   
## [15] VariantAnnotation_1.12.1               
## [16] GenomicAlignments_1.2.0                
## [17] Rsamtools_1.18.0                       
## [18] Biostrings_2.34.0                      
## [19] XVector_0.6.0                          
## [20] GenomicRanges_1.18.1                   
## [21] GenomeInfoDb_1.2.0                     
## [22] IRanges_2.0.0                          
## [23] S4Vectors_0.4.0                        
## [24] BiocGenerics_0.12.0                    
## [25] knitr_1.7                              
## [26] BiocInstaller_1.16.0                   
## 
## loaded via a namespace (and not attached):
##  [1] acepack_1.3-3.3     base64enc_0.1-2     BatchJobs_1.4      
##  [4] BBmisc_1.7          BiocParallel_1.0.0  biomaRt_2.22.0     
##  [7] biovizBase_1.14.0   bitops_1.0-6        brew_1.0-6         
## [10] checkmate_1.5.0     cluster_1.15.3      codetools_0.2-9    
## [13] colorspace_1.2-4    dichromat_2.0-0     digest_0.6.4       
## [16] evaluate_0.5.5      fail_1.2            foreach_1.4.2      
## [19] foreign_0.8-61      formatR_1.0         Formula_1.1-2      
## [22] GGally_0.4.8        graph_1.44.0        grid_3.1.1         
## [25] gridExtra_0.9.1     gtable_0.1.2        Hmisc_3.14-5       
## [28] htmltools_0.2.6     httr_0.5            iterators_1.0.7    
## [31] jsonlite_0.9.13     labeling_0.3        lattice_0.20-29    
## [34] latticeExtra_0.6-26 MASS_7.3-35         munsell_0.4.2      
## [37] nnet_7.3-8          OrganismDbi_1.8.0   plyr_1.8.1         
## [40] proto_0.3-10        RBGL_1.42.0         RColorBrewer_1.0-5 
## [43] Rcpp_0.11.3         RCurl_1.95-4.3      reshape_0.8.5      
## [46] reshape2_1.4        rjson_0.2.14        rmarkdown_0.3.3    
## [49] rpart_4.1-8         scales_0.2.4        sendmailR_1.2-1    
## [52] splines_3.1.1       stringr_0.6.2       survival_2.37-7    
## [55] tools_3.1.1         XML_3.98-1.1        zlibbioc_1.12.0
```

