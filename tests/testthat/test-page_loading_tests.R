context("page_loading_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
on.exit(remDr$close())

test_that("testShouldWaitForDocumentToBeLoaded", {
  remDr$navigate(loadPage("simpleTest"))
  result <- remDr$getTitle()
  expect_identical(result[[1]], "Hello WebDriver")
}
)

test_that("testShouldBeAbleToGetAFragmentOnTheCurrentPage", {
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$getCurrentUrl()
  remDr$navigate(paste0(result[[1]], "#text"))
  wElem <- remDr$findElement("id", "id1")
  expect_true(inherits(wElem, "webElement"))
}
)

test_that("testShouldReturnWhenGettingAUrlThatDoesNotResolve", {
  expect_silent(
    result <- remDr$navigate("http://www.thisurldoesnotexist.comx/")
  )
}
)

test_that("testShouldReturnWhenGettingAUrlThatDoesNotConnect", {
  expect_silent(
    result <- remDr$navigate("http://localhost:3001")
  )
}
)

test_that("testShouldBeAbleToNavigateBackInTheBrowserHistory", {
  remDr$navigate(loadPage("formPage"))
  remDr$findElement("id", "imageButton")$clickElement()
  result <- remDr$getTitle()
  expect_identical(result[[1]], "We Arrive Here")
  remDr$goBack()
  resBack <- remDr$getTitle()
  expect_identical(resBack[[1]], "We Leave From Here")
}
)

test_that("testShouldBeAbleToNavigateBackInTheBrowserHistoryInPresenceOfIframes", {
  remDr$navigate(loadPage("xhtmlTest"))
  remDr$findElement("name", "sameWindow")$clickElement()
  expect_identical(remDr$getTitle()[[1]], "This page has iframes")
  remDr$goBack()
  result <- remDr$getTitle()
  expect_identical(result[[1]], "XHTML Test Page")
}
)

test_that("testShouldBeAbleToNavigateForwardsInTheBrowserHistory", {
  remDr$navigate(loadPage("formPage"))
  remDr$findElement("id", "imageButton")$clickElement()
  expect_identical(remDr$getTitle()[[1]], "We Arrive Here")
  remDr$goBack()
  expect_identical(remDr$getTitle()[[1]], "We Leave From Here")
  remDr$goForward()
  expect_identical(remDr$getTitle()[[1]], "We Arrive Here")
}
)

test_that("testShouldNotHangifDocumentOpenCallIsNeverFollowedByDocumentCloseCall", {
  result <- remDr$navigate(loadPage("document_write_in_onload"))
  result <- remDr$findElement("xpath", "//body")
  expect_true(inherits(result, "webElement"))
}
)

test_that("testShouldBeAbleToRefreshAPage", {
  remDr$navigate(loadPage("xhtmlTest"))
  remDr$refresh()
  result <- remDr$getTitle()
  expect_identical(result[[1]], "XHTML Test Page")
}
)
