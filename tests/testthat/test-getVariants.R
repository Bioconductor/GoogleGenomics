context("Variants")

fetchVariants <- function(...) {
  getVariants(datasetId="10473108253681171589", chromosome="22",
              start=50300077, end=50301500, ...)
}

test_that("Raw variants are fetched correctly", {
  # Get raw variants from Variants API
  variants <- fetchVariants()
  expect_equal(length(variants), 27)
  expect_equal(mode(variants), "list")
  expect_equal(class(variants)[1], "list")
  expect_equal(0, length(setdiff(names(variants[[1]]),
                                 c("variantSetId", "id", "names", "created",
                                   "referenceName", "start", "end",
                                   "referenceBases", "alternateBases",
                                   "quality", "filter", "info", "calls"))))
})

test_that("Variants are converted to GRanges correctly", {
  # Get GRanges from the Variants API
  granges <- fetchVariants(converter=variantsToGRanges)
  expect_equal(length(granges), 27)
  expect_equal(mode(granges), "S4")
  expect_equal(class(granges)[1], "GRanges")
})

test_that("Variants are converted to VRanges correctly", {
  # Get VRanges from the Variants API
  vranges <- fetchVariants(converter=variantsToVRanges)
  expect_equal(length(vranges), 27)
  expect_equal(mode(vranges), "S4")
  expect_equal(class(vranges)[1], "VRanges")
})

test_that("Variants data matches VariantAnnotation package", {
  # Get variants data from VariantAnnotation package
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")
  vranges <- fetchVariants(converter=variantsToVRanges)
  variantsReference <- as(vcf, "VRanges")[1:length(vranges)]

  # Check start positions.
  expect_equal(start(vranges), start(variantsReference))

  # Check reference alleles.
  expect_equal(ref(vranges), ref(variantsReference))

  # Check alternative allele after coercion from RLE.
  expect_equal(as.character(alt(vranges)), as.character(alt(variantsReference)))
})
