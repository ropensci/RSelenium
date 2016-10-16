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
on.exit(remDr$close())
sysDetails <- remDr$getStatus()
remDr$setImplicitWaitTimeout(3000)
browser <- remDr$sessionInfo$browserName
appURL <- "http://127.0.0.1:6012"

test_that("sliderInput label correct", {
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
  webElem <- remDr$findElement("css selector", 
                               "#reqcontrols label[for = 'range']")
  expect_output(webElem$getElementText()[[1]], 
                "Select range of diamond prices:")
}
)

test_that("sliderInput selection invokes change", {
  # get the slider element using siblings
  webElem <- remDr$findElement("css selector", "#reqcontrols #range")
  appMin <- as.numeric(webElem$getElementAttribute("data-from"))
  appMax <- as.numeric(webElem$getElementAttribute("data-to"))
  appValue <- webElem$getElementAttribute("value")
  appValue <- as.numeric(unlist(strsplit(appValue[[1]], ";")))
  appStep <- as.numeric(webElem$getElementAttribute("data-step"))
  appRound <- as.logical(webElem$getElementAttribute("data-round"))
  outElem <- remDr$findElement("css selector", "#dttable")
  initOutput <- outElem$getElementText()[[1]]
  
  # get the slider dimensions
  webElem <- remDr$findElement("css selector", 
                               "#reqcontrols input#range + .jslider")
  sliderDim <- webElem$getElementSize()
  
  newValues <- seq(from = appMin, to = appMax, by = appStep)
  newValues <- sort(sample(newValues, 2))
  # use siblings to get the pointers
  cSelect <- "#reqcontrols input#range + .jslider .jslider-pointer"
  webElems <- remDr$findElements("css selector", cSelect)
  pxToMoveSldr <- trunc(sliderDim$width * 
                          (newValues - appValue)/(appMax - appMin))
  
  # move first slider
  moveOrder <- 1:2
  if(newValues[1] > appValue[2]){moveOrder <- rev(moveOrder)}
  for(x in moveOrder){
    remDr$mouseMoveToLocation(webElement = webElems[[x]])
    remDr$buttondown()
    remDr$mouseMoveToLocation(x = as.integer(pxToMoveSldr[x]), y = -1L)
    remDr$buttonup()
  }
  #webElem <- remDr$findElement("css selector", "#reqcontrols #range")
  #appValue <- webElem$getElementAttribute("value")
  
  # Shiny.onInputChange("range", [2000, 10000])
  # Shiny.shinyapp.sendInput({range: [6222, 9333]})
  Sys.sleep(1)
  outElem <- remDr$findElement("css selector", "#dttable")
  changeOutput <- outElem$getElementText()[[1]]
  
  expect_false(initOutput == changeOutput)
  
}
)
