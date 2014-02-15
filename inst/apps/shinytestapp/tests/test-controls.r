context("controls")

library(RSelenium)
library(testthat)

remDr <- remoteDriver()
remDr$open(silent = TRUE)
sysDetails <- remDr$getStatus()
appURL <- "http://127.0.0.1:6012"

test_that("can select/deselect input 1", {  
  remDr$navigate(appURL)
  webElem <- remDr$findElement("css selector", "#ctrlSelect1")
  initState <- webElem$isElementSelected()[[1]]
  # check if we can select/deselect
  if(sysDetails$os[['name']] == ""){
    webElem$sendKeysToElement(list(key = "space"))
  }else{
    webElem$clickElement()
  }
  changeState <- webElem$isElementSelected()[[1]]
  expect_is(initState, "logical")  
  expect_is(changeState, "logical")  
  expect_false(initState == changeState)  
})

test_that("can select/deselect input 2", {  
  webElem <- remDr$findElement("css selector", "#ctrlSelect2")
  initState <- webElem$isElementSelected()[[1]]
  # check if we can select/deselect
  if(sysDetails$os[['name']] == ""){
    webElem$sendKeysToElement(list(key = "space"))
  }else{
    webElem$clickElement()
  }
  changeState <- webElem$isElementSelected()[[1]]
  expect_is(initState, "logical")  
  expect_is(changeState, "logical")  
  expect_false(initState == changeState)  
})

test_that("can select/deselect input 3", {  
  webElem <- remDr$findElement("css selector", "#ctrlSelect3")
  initState <- webElem$isElementSelected()[[1]]
  # check if we can select/deselect
  if(sysDetails$os[['name']] == ""){
    webElem$sendKeysToElement(list(key = "space"))
  }else{
    webElem$clickElement()
  }
  changeState <- webElem$isElementSelected()[[1]]
  expect_is(initState, "logical")  
  expect_is(changeState, "logical")  
  expect_false(initState == changeState)  
})

test_that("can select/deselect input 4", {  
  webElem <- remDr$findElement("css selector", "#ctrlSelect4")
  initState <- webElem$isElementSelected()[[1]]
  # check if we can select/deselect
  if(sysDetails$os[['name']] == ""){
    webElem$sendKeysToElement(list(key = "space"))
  }else{
    webElem$clickElement()
  }
  changeState <- webElem$isElementSelected()[[1]]
  expect_is(initState, "logical")  
  expect_is(changeState, "logical")  
  expect_false(initState == changeState)  
})

remDr$close()
