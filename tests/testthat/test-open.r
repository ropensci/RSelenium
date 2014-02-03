# test if a connection can be made to Selenium Server
context("Basic")
test_that("can open and close connection", {
  remDr <- remoteDriver()
  remDr$open()
  remDr$close()
})