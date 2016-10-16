context("controls")

library(RSelenium)
library(testthat)

if(exists('rsel.opt', where = parent.env(environment()) , 
          inherits = FALSE)){
  # print(rsel.opt)
  remDr <- do.call(remoteDriver, rsel.opt)
}else{
  remDr <- remoteDriver()
}
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
  webElem <- remDr$findElement("css selector", 
                               "#reqcontrols label[for = 'daterange']")
  expect_output(webElem$getElementText()[[1]], "Date range:")
}
)

test_that("dateRangeInput selection invokes change", {
  webElems <- remDr$findElements("css selector", 
                                 "#reqcontrols #daterange .input-small")
  appMinDate <- webElems[[1]]$getElementAttribute("data-min-date")[[1]]
  appMaxDate <- webElems[[1]]$getElementAttribute("data-max-date")[[1]]
  newDates <- sort(sample(seq(as.Date(appMinDate), 
                              as.Date(appMaxDate), 1), 2))
  newDates <- as.character(format(newDates, "%m/%d/%Y"))
  outElem <- remDr$findElement("css selector", "#ggPlot img")
  initOutput <- outElem$getElementAttribute("src")[[1]]
  
  webElems[[1]]$clearElement()
  webElems[[1]]$sendKeysToElement(list(newDates[1]))
  webElems[[2]]$clearElement()
  webElems[[2]]$sendKeysToElement(list(newDates[2]))
  if(browser == "phantomjs"){
    Sys.sleep(1)
  }
  outElem <- suppressWarnings(remDr$findElement("css selector", 
                                                "#ggPlot img"))
  changeOutput <- outElem$getElementAttribute("src")[[1]]
  
  expect_false(initOutput == changeOutput)
  
}
)

remDr$close()