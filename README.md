R Bindings for Selenium 2.0 Remote WebDriver
==========================
| CRAN version       | Travis build status    | SauceTests  | Coverage |
| :-------------: |:-------------:|:-------------:|:-------------:|
| [![](http://www.r-pkg.org/badges/version/RSelenium)](https://CRAN.R-project.org/package=RSelenium) | [![Build Status](https://travis-ci.org/ropensci/RSelenium.svg?branch=master)](https://travis-ci.org/ropensci/RSelenium) | [![Selenium Test Status](https://saucelabs.com/buildstatus/rselenium0)](https://saucelabs.com/u/rselenium0) | [![codecov](https://codecov.io/gh/ropensci/RSelenium/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/RSelenium)|


#### Selenium test status

[![Selenium Test Status](https://saucelabs.com/browser-matrix/rselenium0.svg)](https://saucelabs.com/u/rselenium0)

This is a set of R Bindings for Selenium 2.0 Remote WebDriver, which you
can download from http://selenium-release.storage.googleapis.com/index.html .This binding will not work with the
1.0 version of Selenium.

### Install 

To install RSelenium from CRAN run install.packages('RSelenium'). If you require the development version you will need the devtools package. If necessary (install.packages("devtools")) and run:

```
devtools::install_github("ropensci/RSelenium")
```

To get started using `RSelenium` you can look at the introduction vignette located 
in `/doc/RSelenium-basics.html` once `RSelenium` is installed or run

```

vignette('RSelenium-basics')

```

or the basic vignette can be viewed on [Rpubs](http://rpubs.com/johndharrison/12843).

There is a second vignette dealing with running RSelenium on different browsers/OS locally and remotely which can be viewed at [RSelenium: Driving OS/Browsers local and remote](http://rpubs.com/johndharrison/13885). Finally you can read all about running a headless browser or running a normal browser on a headless server [RSelenium: Headless browsing.](http://rpubs.com/johndharrison/RSelenium-headless).

#### Summary of vignettes
1.  [RSelenium: basics](http://rpubs.com/johndharrison/12843)
2.  [RSelenium: Driving OS/Browsers local and remote](http://rpubs.com/johndharrison/13885)
3.  [RSelenium: Testing Shiny Apps](http://rpubs.com/johndharrison/13408)
4.  [Orange County R Users Group (OC-RUG): RSelenium Webinar](http://johndharrison.blogspot.com/2014/05/orange-county-r-users-group-oc-rug.html)
5.  [RSelenium: Headless browsing.](http://rpubs.com/johndharrison/RSelenium-headless)
6.  [RSelenium: Docker Containers](http://rpubs.com/johndharrison/RSelenium-Docker)

### Test Shiny Apps

Use RSelenium to test your Shiny Apps.

Read the introductory tutorial on [Rpubs](http://rpubs.com/johndharrison/13408).


### Use Sauce Labs and BrowserStack

#### Sauce Labs

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
#### BrowserStack

```
require(RSelenium)
user <- "johnharrison" 
pass <- "*******************"
port <- 80
ip <- paste0(user, ':', pass, "@hub.browserstack.com")
extraCapabilities <- list("browser" = "IE",
                          "browser_version" = "7.0",
                          "os" = "Windows",
                          "os_version" = "XP",
                          "browserstack.debug" = "true")
remDr <- remoteDriver$new(remoteServerAddr = ip, port = port
                          , extraCapabilities = extraCapabilities)
```

### RELATED WORK

* [seleniumPipes](https://github.com/johndharrison/seleniumPipes) seleniumPipes is a lightweight implementation of the w3c webdriver specification. It has been built utilising xml2, httr and magrittr so provides an alternative for users who are familiar with piping.

* [webdriver](https://github.com/MangoTheCat/webdriver) A client for the 'WebDriver' 'API'. It allows driving a (probably headless) web browser, and can be used to test web applications, including 'Shiny' apps. In theory it works with any 'WebDriver' implementation, but it was only tested with 'PhantomJS'.

* [rwebdriver](https://github.com/crubba/Rwebdriver) R bindings to the Webdriver API

* [rdom](https://github.com/cpsievert/rdom) Render and parse the DOM from R via phantomjs.

### License

The RSelenium package is licensed under the <a href="https://www.r-project.org/Licenses/AGPL-3" target="_blank">AGPLv3</a>. The help files are licensed under the creative commons attribution, non-commercial, share-alike license <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">CC-NC-SA</a>.

As a summary, the AGPLv3 license requires, attribution, include copyright and license in copies of the software, state changes if you modify the code, and disclose all source code. Details are in the COPYING file.

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)