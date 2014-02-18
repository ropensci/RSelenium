context("controls")

library(RSelenium)
library(testthat)
if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
  print(rsel.opt)
  remDr <- do.call(remoteDriver, rsel.opt)
}else{
  remDr <- remoteDriver()
}
remDr$open(silent = TRUE)
on.exit(remDr$close())
sysDetails <- remDr$getStatus()
remDr$setImplicitWaitTimeout(3000)
browser <- remDr$sessionInfo$browserName
appURL <- "http://127.0.0.1:6012"

test_that("output object alignment correct", {
  remDr$navigate(appURL)
  webElems <- remDr$findElements("css selector", "#ctrlSelect input")
  lapply(webElems, function(x){
    if(!x$isElementSelected()[[1]]){
      if(browser != "internet explorer"){
        x$clickElement()
      }else{
        x$sendKeysToElement(list(key='space'))
      }
    }
  })
  remDr$maxWindowSize()
  # dttable is last element selected try to find it so remDr$setImplicitWaitTimeout(3000)
  # will be initiated if it is not loadedd yet.
  webElem <- remDr$findElement("css selector", "#reqplots #dttable")
  webElems <- remDr$findElements("css selector", "#reqplots .span5")
  out <- sapply(webElems, function(x){x$getElementLocation()})
  out <- out[c('x', 'y'),]
  print(out)
  expect_equal(as.integer(out['y', 1]) - as.integer(out['y', 2]), 0) # 1st row
  expect_equal(as.integer(out['y', 3]) - as.integer(out['y', 4]), 0) # 2nd row
  expect_equal(as.integer(out['x', 1]) - as.integer(out['x', 3]), 0) # 1st col
  expect_equal(as.integer(out['x', 2]) - as.integer(out['x', 4]), 0) # 2nd col
}
)

