# download with firefox
# see http://stackoverflow.com/questions/21944016/download-file-from-internet-via-r-despite-the-popup/21958555#21958555

require(RSelenium)
fprof <- getFirefoxProfile("~/.mozilla/firefox/downloadZip/")
remDr <- remoteDriver(extraCapabilities = fprof)
remDr$open(silent = TRUE)
remDr$navigate("https://www.chicagofed.org/applications/bhc_data/bhcdata_index.cfm")
# click year 2013
webElem <- remDr$findElement("name", "SelectedYear")
webElems <- webElem$findChildElements("css selector", "option")
webElems[[which(sapply(webElems, function(x){x$getElementText()}) == "2012" )]]$clickElement()

# click required quarter

webElem <- remDr$findElement("name", "SelectedQTR")
webElems <- webElem$findChildElements("css selector", "option")
webElems[[which(sapply(webElems, function(x){x$getElementText()}) == "4th Quarter" )]]$clickElement()

# click button

webElem <- remDr$findElement("name", "submitbutton")
webElem$clickElement()


