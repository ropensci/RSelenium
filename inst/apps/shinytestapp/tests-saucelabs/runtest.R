user <- "rselenium0"
pass <- "49953c74-5c46-4ff9-b584-cf31a4c71809" # insert appropriate key here
port <- 80
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
#browser <- "safari"
#browser <- "firefox"
#browser <- "chrome"
#browser <- "internet explorer"
#browser <- "android"
browser <- "safari"
version <- "7"
#platform <- "Windows 8.1"
# platform <- "linux"
platform <- "OS X 10.9"

testsel <- test_env()
with(testsel, {rsel.opt <- list(remoteServerAddr = ip, port = port, browserName = browser
                               , version = version, platform = platform
                               , extraCapabilities = list(username = user, accessKey = pass))
               sauceTest <- TRUE
               })
testRes <- test_dir("./inst/tests", reporter = "Tap", filter = "api-example", env = testsel)

if(!any(testRes$failed) && testsel[['sauceTest']]){
  # test passed rsel.opt should contain the jobid
  pv <- packageVersion("RSelenium")
  
  ip <- paste0(user, ':', pass, "@saucelabs.com/rest/v1/", user, "/jobs/", testsel[['rsel.opt']]$id)
  qdata <- toJSON(list(passed = TRUE, "custom-data" = list(release = do.call(paste, list(pv, collapse = ".")), testresult = testRes)))
  res <- getURLContent(ip, customrequest = "PUT", httpheader = "Content-Type:text/json", postfields = qdata, isHTTP = FALSE)
  
}
  

  