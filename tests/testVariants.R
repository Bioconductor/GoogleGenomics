# Match variants data returned from Google Genomics with sample variants data in VariantAnnotation package
# This test is only run if there is an environment variable called API_KEY_SERVER containing the public API key.

library(GoogleGenomics)
library(testthat)

testVariants <- function() {
  # Get raw variants from Variants API
  variants <- getVariants(datasetId="10473108253681171589", chromosome="22",
                          start=50300077, end=50301500)
  expect_equal(length(variants), 27)
  expect_equal(mode(variants), "list")
  expect_equal(class(variants)[1], "list")
  expect_equal(names(variants[[1]]), c("variantSetId", "id", "names", "created",
                                      "referenceName", "start", "end",
                                      "referenceBases", "alternateBases", "quality",
                                      "filter", "info", "calls"))

  # Get GRanges from the Variants API
  granges <- getVariants(datasetId="10473108253681171589", chromosome="22",
                         start=50300077, end=50301500,
                         converter=variantsToGRanges)
  expect_equal(length(granges), 27)
  expect_equal(mode(granges), "S4")
  expect_equal(class(granges)[1], "GRanges")

  # Get VRanges from the Variants API
  vranges <- getVariants(datasetId="10473108253681171589", chromosome="22",
              start=50300077, end=50301500, converter=variantsToVRanges)
  expect_equal(length(vranges), 27)
  expect_equal(mode(vranges), "S4")
  expect_equal(class(vranges)[1], "VRanges")

  # Get VCF from the variants API [not yet implemented]
  expect_error(getVariants(datasetId="10473108253681171589", chromosome="22",
                           start=50300077, end=50301500,
                           converter=variantsToVCF))

  # Get variants data from VariantAnnotation package
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")
  variantsReference <- as(vcf, "VRanges")[1:length(variants)]

  # Check start positions.
  expect_equal(start(vranges), start(variantsReference))

  # Check reference alleles.
  expect_equal(ref(vranges), ref(variantsReference))

  # Check alternative allele after coercion from RLE.
  expect_equal(as.character(alt(vranges)), as.character(alt(variantsReference)))

  message("Variants tests pass.")
}

testReads <- function() {
  # Get raw reads from Reads API
  reads <- getReads(readGroupSetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                    chromosome="22",
                    start=16051000,
                    end=16055000)

  expect_equal(length(reads), 419)
  expect_equal(mode(reads), "list")
  expect_equal(class(reads)[1], "list")
  expect_equal(0, length(setdiff(c("id", "fragmentName", "readGroupSetId"),
      names(reads[[1]]))))

  # Get GAlignments from the Reads API
  galignments <- getReads(readGroupSetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                          chromosome="22",
                          start=16051000,
                          end=16055000,
                          converter=readsToGAlignments)
  expect_equal(length(galignments), 419)
  expect_equal(mode(galignments), "S4")
  expect_equal(class(galignments)[1], "GAlignments")

  message("Reads tests pass.")
}

# Configure authentication
apiKey <- Sys.getenv("API_KEY_SERVER", unset=NA)
if (!is.na(apiKey) && nchar(apiKey)>0) {
  authenticate(apiKey=apiKey)
  # Perform the tests
  testVariants()
  testReads()
} else {
  # Skip the test
  message("Public key unavailable for authentication with Google Genomics. Skipping tests...")
}
