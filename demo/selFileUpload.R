# http://stackoverflow.com/questions/23949637/openfiledialog-in-r-selenium
require(RSelenium)
RSelenium::startServer()
remDr <- remoteDriver()
remDr$open()
remDr$navigate("https://gallery.shinyapps.io/uploadfile")
webElem <- remDr$findElement("id", "file1")
# create a dummy csv 
testCsv <- tempfile(fileext = ".csv")
x <- data.frame(a = 1:4, b = 5:8, c = letters[1:4])
write.csv(x, testCsv, row.names = FALSE)

# post the file to the app
webElem$sendKeysToElement(list(testCsv))
remDr$close()
remDr$closeServer()
