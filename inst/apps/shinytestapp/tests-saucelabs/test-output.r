context("outputs")

library(RSelenium)
library(testthat)
if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
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
  #print(out)
  expect_equal(as.integer(out['y', 1]) - as.integer(out['y', 2]), 0) # 1st row
  expect_equal(as.integer(out['y', 3]) - as.integer(out['y', 4]), 0) # 2nd row
  expect_equal(as.integer(out['x', 1]) - as.integer(out['x', 3]), 0) # 1st col
  expect_equal(as.integer(out['x', 2]) - as.integer(out['x', 4]), 0) # 2nd col
}
)

test_that("output labels are correct", {
  
  webElems <- remDr$findElements("css selector", "#reqplots h6")
  appLabels <- unlist(sapply(webElems, function(x){x$getElementText()}))
  checkLabels <- appLabels %in% c("selectInput Output", "numericInput Output", "dateRangeInput Output", 
                   "sliderInput Output")
  expect_true(all(checkLabels))
  
}
)

test_that("output check images", {
  
  webElems <- remDr$findElements("css selector", "#distPlot img, #ggPlot img")
  appImages <- sapply(webElems, function(x){x$getElementAttribute("src")})
  expect_true(all(grepl("image/png;base64",appImages)))
}
)

test_that("output check data-table", {
  
  webElems <- remDr$findElements("css selector", "#dttable .sorting")
  appHeaders <- sapply(webElems, function(x){x$getElementText()})
  # check a random sorting
  appSort <- sample(seq_along(appHeaders)[c(1,4)], 1)
  webElems[[appSort]]$clickElement()
  # check ordering of column after 1st click
  appSource <- remDr$getPageSource()[[1]]
  appSource <- htmlParse(appSource)
  dttable <- readHTMLTable(appSource, stringsAsFactors = FALSE)
  appCol <- dttable$DataTables_Table_0[[appHeaders[[appSort]]]]
  ordering1 <- is.unsorted(appCol)

  webElems[[appSort]]$clickElement()
  # check ordering of column after 2nd click
  appSource <- remDr$getPageSource()[[1]]
  appSource <- htmlParse(appSource)
  dttable <- readHTMLTable(appSource, stringsAsFactors = FALSE)
  appCol <- dttable$DataTables_Table_0[[appHeaders[[appSort]]]]
  ordering2 <- is.unsorted(appCol)
  
  expect_false(ordering1 == ordering2)
}
)
