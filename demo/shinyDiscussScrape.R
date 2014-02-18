
remDr <- remoteDriver()
remDr$open(silent = TRUE)
sysDetails <- remDr$getStatus()
remDr$setImplicitWaitTimeout(6000)
browser <- remDr$sessionInfo$browserName
appURL <- "https://groups.google.com/forum/?hl=en#!forum/shiny-discuss"

remDr$navigate(appURL)
webElem <- remDr$findElement("css selector", ".GNI5KIWDCL")

while(grepl( "of many topics", webElem$getElementText()[[1]])){
  webElems <- remDr$findElements("css selector", "table.GNI5KIWDJI .GNI5KIWDEL")
  webElems[[length(webElems)]]$getElementLocationInView()
  webElem <- remDr$findElement("css selector", ".GNI5KIWDCL")
  while(webElem$getElementText()[[1]] == "Loading more topics..."){
    Sys.sleep(2)
  }
}

# get the post links

webElems <- remDr$findElements("css selector", "table.GNI5KIWDJI .GNI5KIWDEL")
googHTML <- remDr$getPageSource()[[1]]
googHTML <- gsub("\\\\\"", "\"", googHTML)
googXML <- htmlParse(googHTML)
xpathSApply(googXML, "//*/a[@class='GNI5KIWDEL']", function(x){xmlGetAttr(x, "href")})

