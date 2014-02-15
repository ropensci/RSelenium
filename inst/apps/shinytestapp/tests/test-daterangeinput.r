context("controls")

library(RSelenium)
library(testthat)

remDr <- remoteDriver()
remDr$open(silent = TRUE)
sysDetails <- remDr$getStatus()
remDr$setImplicitWaitTimeout(3000)
browser <- remDr$sessionInfo$browserName
appURL <- "http://127.0.0.1:6012"

test_that("dateRangeInput label correct", {
  remDr$navigate(appURL)
  webElem <- remDr$findElement("css selector", "#ctrlSelect3")
  initState <- webElem$isElementSelected()[[1]]
  if(!initState){
    # select the checkbox
    if(browser == "internet explorer"){
      webElem$sendKeysToElement(list(key = "space"))
    }else{
      webElem$clickElement()
    }
  }
  webElem <- remDr$findElement("css selector", "#reqcontrols label[for = 'daterange']")
  expect_output(webElem$getElementText()[[1]], "Date range:")
}
)

test_that("dateRangeInput selection invokes change", {
  

remdr$close()