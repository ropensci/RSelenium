ontext("controls")

library(RSelenium)
library(testthat)
if(exists(rsel.opt)){
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
  webElem <- remDr$findElement("css selector", "#ctrlSelect4")
  initState <- webElem$isElementSelected()[[1]]
  if(!initState){
    # select the checkbox
    if(browser == "internet explorer"){
      webElem$sendKeysToElement(list(key = "space"))
    }else{
      webElem$clickElement()
    }
  }
  webElem <- remDr$findElement("css selector", "#reqcontrols label[for = 'range']")
  expect_output(webElem$getElementText()[[1]], "Select range of diamond prices:")
}
)

