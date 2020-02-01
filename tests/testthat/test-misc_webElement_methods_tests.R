context("misc_webElement_methods_tests")
init <- initFun()
remDr <- init$remDr
rdBrowser <- init$rdBrowser
loadPage <- init$loadPage
on.exit(remDr$closeall())

test_that("canSetElementAttribute", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement("id", "test_id")
  elem$setElementAttribute("name", "jimmy")
  expect_identical(elem$getElementAttribute("name")[[1]], "jimmy")
})

test_that("canHighlightElement", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement("id", "test_id")
  expect_silent(elem$highlightElement())
})

test_that("canSelectTagOptions", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement("id", "1")
  expect_identical(elem$getElementTagName()[[1]], "select")
  options <- elem$selectTag()
  expect_identical(options[["value"]], NULL)
  expect_identical(options[["selected"]], c(TRUE, FALSE, FALSE, FALSE))
  exT <- c("One", "Two", "Four", "Still learning how to count, apparently")
  expect_identical(options[["text"]], exT)
})

test_that("errorWhenSelectTagNonSelectElement", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement("id", "test_id")
  expect_error(elem$selectTag())
})

test_that("canPrintWebElement", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement("id", "test_id")
  expect_output(print(elem), "webElement fields")
})
