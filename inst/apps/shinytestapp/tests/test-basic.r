context("basic")

library(RSelenium)
library(testthat)

if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
  # print(rsel.opt)
  remDr <- do.call(remoteDriver, rsel.opt)
}else{
  remDr <- remoteDriver()
}
remDr$open(silent = TRUE)
appURL <- "http://127.0.0.1:6012"

test_that("can connect to app", {  
  remDr$navigate(appURL)
  appTitle <- remDr$getTitle()[[1]]
  expect_equal(appTitle, "Shiny Test App")  
})

test_that("controls are present", {  
  webElems <- remDr$findElements("css selector", "#ctrlSelect label")
  appCtrlLabels <- sapply(webElems, function(x){x$getElementText()})
  expect_equal(appCtrlLabels[[1]], "Select controls required:")  
  expect_equal(appCtrlLabels[[2]], "selectInput")  
  expect_equal(appCtrlLabels[[3]], "numericInput")  
  expect_equal(appCtrlLabels[[4]], "dateRangeInput")  
  expect_equal(appCtrlLabels[[5]], "sliderInput")  
})

test_that("tabs are present", {  
  webElems <- remDr$findElements("css selector", ".nav a")
  appTabLabels <- sapply(webElems, function(x){x$getElementText()})
  expect_equal(appTabLabels[[1]], "Plots")  
  expect_equal(appTabLabels[[2]], "About")  
})

remDr$close()
