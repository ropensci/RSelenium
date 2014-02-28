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

test_that("selectInput dataSet correct", {  
  remDr$navigate(appURL)
  webElem <- remDr$findElement("css selector", "#ctrlSelect1")
  initState <- webElem$isElementSelected()[[1]]
  if(!initState){
    # select the checkbox
    if(browser == "internet explorer"){
      webElem$sendKeysToElement(list(key = "space"))
    }else{
      webElem$clickElement()
    }
  }
  
  webElem <- remDr$findElement("css selector", "#reqcontrols #dataset")
  # check the available datasets
  childElems <- webElem$findChildElements("css selector", "[value]")
  appDataSets <- sapply(childElems, function(x){x$getElementAttribute("value")})
  expect_true(all(c("rock", "pressure", "cars") %in% appDataSets))
})

test_that("selectInput label correct", {
  webElem <- remDr$findElement("css selector", "#reqcontrols label[for = 'dataset']")
  expect_output(webElem$getElementText()[[1]], "Choose a dataset:")
}
)

test_that("selectInput selection invokes change", {
  webElem <- remDr$findElement("css selector", "#reqcontrols #dataset")
  childElems <- webElem$findChildElements("css selector", "[value]")
  ceState <- sapply(childElems, function(x){x$isElementSelected()})
  newState <- sample(seq_along(ceState)[!unlist(ceState)], 1)
  
  outElem <- remDr$findElement("css selector", "#summary")
  initOutput <- outElem$getElementText()[[1]]
  
  # change dataset 
  childElems[[newState]]$clickElement()
  outElem <- remDr$findElement("css selector", "#summary")  
  changeOutput <- outElem$getElementText()[[1]]
  
  expect_false(initOutput == changeOutput)
}
)

remDr$close()
