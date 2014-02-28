context("controls")

library(RSelenium)
library(testthat)

if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
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

test_that("numericInput label correct", {
  remDr$navigate(appURL)
  webElem <- remDr$findElement("css selector", "#ctrlSelect2")
  initState <- webElem$isElementSelected()[[1]]
  if(!initState){
    # select the checkbox
    if(browser == "internet explorer"){
      webElem$sendKeysToElement(list(key = "space"))
    }else{
      webElem$clickElement()
    }
  }
  webElem <- remDr$findElement("css selector", "#reqcontrols label[for = 'obs']")
#   if(is.na(webElem$elementId)){
#     Sys.sleep(1)
#     webElem <- remDr$findElement("css selector", "#reqcontrols label[for = 'obs']")
#   }
  expect_output(webElem$getElementText()[[1]], "Observations:")
}
)

test_that("numericInput selection invokes change", {
  webElem <- remDr$findElement("css selector", "#reqcontrols #obs")
  outElem <- remDr$findElement("css selector", "#distPlot img")
  initOutput <- outElem$getElementAttribute("src")[[1]]
  
  appMin <- as.integer(webElem$getElementAttribute("min")[[1]])
  appMax <- as.integer(webElem$getElementAttribute("max")[[1]])
  randInt <- sample(appMin:appMax, 1) # should really exclude current value here. Left as an exercise 
  webElem$clearElement()
  webElem$sendKeysToElement(list(as.character(randInt)))
  
  outElem <- suppressWarnings(remDr$findElement("css selector", "#distPlot img"))
#   if(is.na(outElem$elementId)){
#     Sys.sleep(1)
#     outElem <- remDr$findElement("css selector", "#distPlot img")
#   }
  changeOutput <- outElem$getElementAttribute("src")[[1]]
  
  expect_false(initOutput == changeOutput)
}
)

test_that("numericInput input character error", {
  webElem <- remDr$findElement("css selector", "#reqcontrols #obs")
  webElem$clearElement()
  webElem$sendKeysToElement(list('test'))
  outElem <- suppressWarnings(remDr$findElement("css selector", "#distPlot"))
#   if(is.na(outElem$elementId)){
#     Sys.sleep(1)
#     outElem <- remDr$findElement("css selector", "#distPlot img")
#   }
  changeOutput <- outElem$getElementText()[[1]]
  expect_output(changeOutput, "invalid arguments")
})

remDr$close()

  