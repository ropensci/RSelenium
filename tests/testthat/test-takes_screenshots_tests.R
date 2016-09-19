context("takes_screenshots_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
on.exit(remDr$close())

test_that("testShouldWriteScreenshotToFile", {
  tmpF <- tempfile()
  result <- remDr$navigate(loadPage("simpleTest"))
  remDr$screenshot(file = tmpF)
  expect_true(file.exists(tmpF))
}
)

test_that("test_get_screenshot_as_png", {
  if (!.Platform$OS.type == "unix") {
    skip("unix file command used to determine file type")
  }
  tmpF <- tempfile()
  result <- remDr$navigate(loadPage("simpleTest"))
  remDr$screenshot(file = tmpF)
  fileInfo <- system(paste("file --mime-type", tmpF), intern = TRUE)
  expect_true(grepl("image/png", fileInfo))
}
)
