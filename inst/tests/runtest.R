user <- "rselenium0"
pass <- "49953c74-5c46-4ff9-b584-cf31a4c71809"
port <- 80
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
browser <- "internet explorer"
version <- "10"
platform <- "Win 8"

testsel <- test_env()
with(testsel, {rsel.opt <- list(remoteServerAddr = ip, port = port, browserName = browser
                               , version = version, platform = platform
                               , extraCapabilities = list(username = user, accessKey = pass))
               sauceTest <- TRUE
               })
test_dir("./inst/tests", reporter = "Tap", filter = "api-example", env = testsel)