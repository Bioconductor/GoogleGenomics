context("VariantCalls")

fetchVariantCalls <- function(...) {
  getVariantCalls(variantSetId = "10473108253681171589", chromosome = "22",
                  start = 50300077, end = 50301500, fields = NULL, converter = c,
                  oneBasedCoord = TRUE)
}

test_that("Raw variant calls are fetched correctly", {
  # Get raw variant calls from Variants API
  variant_calls <- fetchVariantCalls()
  expect_equal(length(variant_calls), 29484)
  expect_equal(mode(variant_calls), "S4")
  expect_equal(class(variant_calls)[1], "VRanges")
  expect_equal(names(variant_calls[1]), "rs7410291")
  expect_equal(as.character(sampleNames(variant_calls[1])), "HG00261")
  expect_equal(variant_calls[1]$GT, "1/0")
})
