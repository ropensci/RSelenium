context("cookie_tests")
init <- initFun()
remDr <- init$remDr
rdBrowser <- init$rdBrowser
loadPage <- init$loadPage
on.exit(remDr$close())


test_that("testAddCookie", {
  remDr$navigate(loadPage("simpleTest"))
  remDr$executeScript("return document.cookie;")
  remDr$addCookie(
    name = "foo",
    value = "bar"
  )
  cookie_returned <- remDr$executeScript("return document.cookie;")
  expect_true(grepl("foo=bar", cookie_returned[[1]]))
  remDr$deleteAllCookies()
})

test_that("testAddingACookieThatExpiredInThePast", {
  remDr$navigate(loadPage("simpleTest"))
  remDr$addCookie(
    name = "foo",
    value = "bar",
    expiry = as.integer(Sys.time() - 100)
  )
  cookies <- remDr$getAllCookies()
  expect_equal(length(cookies), 0L)
  remDr$deleteAllCookies()
})

test_that("testDeleteAllCookie", {
  remDr$navigate(loadPage("simpleTest"))
  remDr$addCookie(
    name = "foo",
    value = "bar"
  )
  remDr$deleteAllCookies()
  expect_equal(0L, length(remDr$getAllCookies()))
  remDr$deleteAllCookies()
})

test_that("testDeleteCookie", {
  remDr$navigate(loadPage("simpleTest"))
  remDr$addCookie(
    name = "foo",
    value = "bar"
  )
  remDr$deleteCookieNamed(name = "foo")
  expect_equal(0L, length(remDr$getAllCookies()))
  remDr$deleteAllCookies()
})

test_that("testShouldGetCookieByName", {
  key <- sprintf("key_%d", as.integer(runif(1) * 10000000))
  remDr$navigate(loadPage("simpleTest"))
  remDr$executeScript("document.cookie = arguments[0] + '=set';", list(key))
  cookie <- remDr$getAllCookies()
  expect_equal(
    cookie[vapply(cookie, "[[", character(1), "name") == key][[1]][["value"]],
    "set"
  )
  remDr$deleteAllCookies()
})

test_that("testGetAllCookies", {
  key1 <- sprintf("key_%d", as.integer(runif(1) * 10000000))
  key2 <- sprintf("key_%d", as.integer(runif(1) * 10000000))
  remDr$navigate(loadPage("simpleTest"))
  cookies <- remDr$getAllCookies()
  count <- length(cookies)
  remDr$addCookie(name = key1, value = "value")
  remDr$addCookie(name = key2, value = "value")
  cookies <- remDr$getAllCookies()
  expect_equal(count + 2, length(cookies))
  remDr$deleteAllCookies()
})

test_that("testShouldNotDeleteCookiesWithASimilarName", {
  cookieOneName <- "fish"
  remDr$navigate(loadPage("simpleTest"))
  remDr$addCookie(name = cookieOneName, value = "cod")
  remDr$addCookie(name = paste0(cookieOneName, "x"), value = "earth")
  remDr$deleteCookieNamed(cookieOneName)
  cookies <- remDr$getAllCookies()
  expect_false(identical(cookies[[1]][["name"]], cookieOneName))
  expect_equal(cookies[[1]][["name"]], paste0(cookieOneName, "x"))
  remDr$deleteAllCookies()
})
