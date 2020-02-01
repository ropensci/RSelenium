appURL <- "http://www.skyscanner.it/trasporti/voli/rome/it/voli-piu-economici-da-roma-per-italia.html?rtn=1&oym=1405&iym=1405"
library(RSelenium)
addCap <- list(phantomjs.page.settings.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20120101 Firefox/29.0")
remDr <- remoteDriver(
  browserName = "phantomjs",
  extraCapabilities = addCap
)
remDr$open()
remDr$navigate(appURL)
tableElem <- remDr$findElement("id", "browse-data-table")
xData <- tableElem$getElementAttribute("outerHTML")[[1]]
xData <- htmlParse(xData, encoding = "UTF-8")
readHTMLTable(xData)
