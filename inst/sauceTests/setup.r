# setup some base functions etc that all tests use
library(RSelenium)
library(testthat)

if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
  remDr <- do.call(remoteDriver, rsel.opt)
}else{
  remDr <- remoteDriver()
}
remDr$open(silent = TRUE)
sysDetails <- remDr$getStatus()
remDr$setImplicitWaitTimeout(3000)
rdBrowser <- remDr$sessionInfo$browserName

htmlSrc <- Sys.getenv("SEL_TEST_DIR")
loadPage <- function(pgStr){
  paste0("file://", file.path(htmlSrc, paste0(pgStr, ".html")))
}

if(exists('sauceTest', where = parent.env(environment()) , inherits = FALSE)){
  if(sauceTest){
    # assume running /selenium/common/src/web$ python -m SimpleHTTPServer 3000 
    # this will serve the files from the selenium project on port 3000
    # myname.local maps to 127.0.0.1 in hosts hopefully to allow windows to
    # work on sauceConnect
    if(rdBrowser %in% c("iPhone", "iPad", "safari")){
      htmlSrc <- "localhost:3000"      
    }else{
      htmlSrc <- "myname.local:3000"      
    }
    loadPage <- function(pgStr){
      paste0("http://", file.path(htmlSrc, paste0(pgStr, ".html")))
    }
    rsel.opt$id <<- remDr$sessionInfo$id
  }
}


