init <- initFun()
remDr <- init$remDr
rdBrowser <- init$rdBrowser
loadPage <- init$loadPage
on.exit(remDr$closeall())

test_that("canShowRemoteDriver", {
  expect_identical(remDr$show()$browserName, rdBrowser)
})

test_that("canShowErrorClass", {
  status <- remDr$showErrorClass()$status
  expect_equal(status, 0L)
})

test_that("canGetSessions", {
  sessions <- remDr$getSessions()
  expect_equal(length(sessions), 1L)
  expect_identical(sessions[[1]][["id"]], remDr$sessionid)
})

test_that("canGetStatus", {
  status <- remDr$getStatus()
  expect_contains(names(status), c("build", "os", "java"))
})

test_that("canSetAsyncScriptTimeout", {
  skip_if(init$selenium_ver$major > 2, "Changes in selenium version 3")
  expect_silent(remDr$setAsyncScriptTimeout())
})

test_that("canSetImplicitWaitTimeout", {
  skip_if(init$selenium_ver$major > 2, "Changes in selenium version 3")
  expect_silent(remDr$setImplicitWaitTimeout())
})

test_that("canGetLogTypes", {
  skip_if(init$selenium_ver$major > 2, "Changes in selenium version 3")
  expect_gt(length(remDr$getLogTypes()), 0L)
})

test_that("canGetLog", {
  skip_if(init$selenium_ver$major > 2, "Changes in selenium version 3")
  logs <- remDr$getLogTypes()[[1]]
  expect_true(inherits(remDr$log(logs[1]), "list"))
})

test_that("canGetPageSource", {
  remDr$navigate(loadPage("simpleTest"))
  source <- remDr$getPageSource()
  expect_true(grepl("html", source[[1]]))
})

test_that("canSetExtraCaps", {
  skip_if(init$selenium_ver$major > 2, "Changes in selenium version 3")
  prefs <- list("profile.managed_default_content_settings.images" = 2L)
  cprof <- list(chromeOptions = list(prefs = prefs))
  expect_output(
    init2 <- initFun(silent = FALSE, extraCapabilities = cprof)
  )
  on.exit(init2$remDr$close())
  expect_identical(init2$remDr$extraCapabilities, cprof)
})
