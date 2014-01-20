R Bindings for Selenium 2.0 Remote WebDriver
==========================

*** NOTE: Most of the JSON Wire Protocol http://code.google.com/p/selenium/wiki/JsonWireProtocol
***     has been implemented. This is still beta quality code.

This is a R Binding for Selenium 2.0 Remote WebDriver, which you
should download from http://code.google.com/p/selenium; look for
selenium-server-standalone.jar.  This binding will not work with the
1.0 version of Selenium.

This library borrowed heavily from the perl implemetation detailed here 
https://metacpan.org/release/Selenium-Remote-Driver.

To install, install the `devtools` package if necessary (`install.packages("devtools")`) and run:

```
devtools::install_github("RSelenium", "johndharrison")
```
Added support for sauceLabs:

```
user <- "rselenium0"
pass <- "*******************************"
port <- 80
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
browser <- "firefox"
version <- "25"
platform <- "OS X 10.9"
extraCapabilities <- list(name = "Test RSelenium", username = user, accessKey = pass)

remDr <- remoteDriver$new(remoteServerAddr = ip, port = port, browserName = browser
                          , version = version, platform = platform
                          , extraCapabilities = extraCapabilities)
```