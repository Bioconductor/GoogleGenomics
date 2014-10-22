# Match variants data returned from Google Genomics with sample variants data in VariantAnnotation package
# This test is only run if there is an environment variable called API_KEY_SERVER containing the public API key.

library(GoogleGenomics)
library(testthat)

testVariants <- function() {
  authenticate(apiKey=apiKey)

  # Get raw variants from Variants API
  variants <- getVariants(datasetId="10473108253681171589", chromosome="22",
                          start=50300077, end=50301500, oneBasedCoord=TRUE)
  expect_equal(length(variants), 27)
  expect_equal(mode(variants), "list")
  expect_equal(class(variants)[1], "list")
  expect_equal(names(variants[[1]]), c("variantSetId", "id", "names", "created",
                                      "referenceName", "start", "end",
                                      "referenceBases", "alternateBases", "quality",
                                      "filter", "info", "calls"))

  # Get VRanges from the Variants API
  vranges <- getVariants(datasetId="10473108253681171589", chromosome="22",
              start=50300077, end=50301500, oneBasedCoord=TRUE, converter=variantsToVRanges)
  expect_equal(length(vranges), 27)
  expect_equal(mode(vranges), "S4")
  expect_equal(class(vranges)[1], "VRanges")

  # Get VCF from the variants API [not yet implemented]
  expect_error(getVariants(datasetId="10473108253681171589", chromosome="22",
                           start=50300077, end=50301500, oneBasedCoord=TRUE,
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

# Configure authentication
apiKey <- Sys.getenv("API_KEY_SERVER", unset=NA)
if (!is.na(apiKey) && nchar(apiKey)>0) {
  # Perform the test
  testVariants()
} else {
  # Skip the test
  message("Public key unavailable for authentication with Google Genomics. Skipping tests...")
}
