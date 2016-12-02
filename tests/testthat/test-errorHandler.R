context("test-errorHandler")

test_that("canGetHttrError", {
  # hopefully no sel server running on 9999L
  dumRD <- remoteDriver(port = 9999L)
  expect_error(
    dumRD$open(silent = TRUE), 
    ".*Couldnt connect to host on.*"
  )
})

test_that("canCheckErrorDetails", {
  # hopefully no sel server running on 9999L
  dumRD <- remoteDriver(port = 9999L)
  expect_identical(dumRD$errorDetails(), list())
  expect_identical(dumRD$errorDetails("class"), NA_character_)
  expect_identical(dumRD$errorDetails("status"), 0L)
})
