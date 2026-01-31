context("test-errorHandler")

test_that("canGetHttrError", {
  # hopefully no sel server running on 9999L
  dumRD <- remoteDriver(port = 9999L)
  expect_error(
    dumRD$open(silent = TRUE),
    "Undefined error in httr call. httr output: Could not connect to server [localhost]:\nFailed to connect to localhost port 9999 after 0 ms: Could not connect to server",
    fixed = TRUE
  )
})

test_that("canCheckErrorDetails", {
  # hopefully no sel server running on 9999L
  dumRD <- remoteDriver(port = 9999L)
  expect_identical(dumRD$errorDetails(), list())
  expect_identical(dumRD$errorDetails("class"), NA_character_)
  expect_identical(dumRD$errorDetails("status"), 0L)
})
