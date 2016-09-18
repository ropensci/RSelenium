require(testthat)
user <- "rselenium0"
pass <- "49953c74-5c46-4ff9-b584-cf31a4c71809"
port <- 80
selVersion <- "2.42.0"
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
testDir <- system.file("tests", package = "RSelenium")
osBrowser <- list(
  "OS X 10.9" = list(list(browser = "safari", version = '7')
                     , list(browser = "firefox", version = '28')
                     , list(browser = "chrome", version = '34')
  ),
  "Windows 8" = list(list(browser = "chrome", version = '34')
                     , list(browser = "firefox", version = '29')
                     , list(browser = "internet explorer", version = '10')
  ),
  "Windows 7" = list(list(browser = "chrome", version = '34')
                     , list(browser = "firefox", version = '29')
                     , list(browser = "internet explorer", version = '10')
  ),
  "Linux" = list(list(browser = "chrome", version = '34')
                 , list(browser = "firefox", version = '28')
                 , list(browser = "opera", version = '12')
  )
)

out <- lapply(names(osBrowser), function(x){
  platform <- x
  lapply(osBrowser[[x]], platform = platform, FUN = function(y, platform){
    rdBrowser <- y$browser
    version <- y$version
    testsel <- test_env()
    testsel[['sauceTest']] <- TRUE
    testsel[['rsel.opt']] <- list(remoteServerAddr = ip, port = port, browserName = rdBrowser
                                  , version = version, platform = platform
                                  , extraCapabilities = list(username = user, accessKey = pass, "selenium-version" = selVersion))
    testRes <- test_dir(testDir, reporter = "Tap", filter = "api-example", env = testsel)
    list(testsel[['rsel.opt']]$id, testRes)
  })
}) 

lapply(out, function(x){
  lapply(x, function(y){
    testId <- y[[1]]
    testRes <- y[[2]]
    if(!any(testRes$failed)){
      # test passed rsel.opt should contain the jobid
      pv <- packageVersion("RSelenium")
      
      ip <- paste0(user, ':', pass, "@saucelabs.com/rest/v1/", user, "/jobs/", testId)
      qdata <- toJSON(list(passed = TRUE, "custom-data" = list(release = do.call(paste, list(pv, collapse = ".")), testresult = testRes)))
      res <- getURLContent(ip, customrequest = "PUT", httpheader = "Content-Type:text/json", postfields = qdata, isHTTP = FALSE)
      
    }
  })
})

