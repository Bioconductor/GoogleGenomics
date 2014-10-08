# Match variants data returned from Google Genomics with sample variants data in VariantAnnotation package
# This test is only run if there is an environment variable called API_KEY_SERVER containing the public API key.

library(GoogleGenomics)

testVariants <- function() {
  authenticate(apiKey=apiKey)
  
  # Get variants data from API
  getVariantData(datasetId="10473108253681171589", chromosome="22", start=50300077, end=50300187)
  variantData <- variantStore$variantdata
  hg96Rows <- which(sampleNames(variantData) == "HG00096")
  variantData <- renameSeqlevels(variantData[hg96Rows], c("22"="chr22"))
  
  # Get variants data from VariantAnnotation package
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg96")
  variantDataReference <- as(vcf, "VRanges")[1:length(variantData)]
  
  # Check start positions.
  # variantData has 0-based indices and variantDataReference has 1-based indices.
  testthat::expect_equal(start(variantData) + 1, start(variantDataReference))
  
  # Check reference alleles.
  testthat::expect_equal(ref(variantData), ref(variantDataReference))
  
  # Check alternative allele after coercion from RLE.
  testthat::expect_equal(as.character(alt(variantData)), as.character(alt(variantDataReference)))
  
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
