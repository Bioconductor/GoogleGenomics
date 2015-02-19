context("Reads")

test_that("Raw reads are fetched correctly", {
  # Get raw reads from Reads API
  reads <- getReads(readGroupSetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                    chromosome="22",
                    start=16051000,
                    end=16055000)

  expect_equal(length(reads), 418)
  expect_equal(mode(reads), "list")
  expect_equal(class(reads), "list")
  expect_equal(0, length(setdiff(c("id", "fragmentName", "readGroupSetId"),
                                 names(reads[[1]]))))
})

test_that("Reads are converted to GAlignments correctly", {
  # Get GAlignments from the Reads API
  galignments <- getReads(readGroupSetId="CMvnhpKTFhDnk4_9zcKO3_YB",
                          chromosome="22",
                          start=16051000,
                          end=16055000,
                          converter=readsToGAlignments)
  expect_equal(length(galignments), 418)
  expect_equal(mode(galignments), "S4")
  expect_equal(class(galignments)[1], "GAlignments")
})
