RSelenium
================

[![Build Status](https://travis-ci.org/ropensci/RSelenium.svg?branch=master)](https://travis-ci.org/ropensci/RSelenium)
[![codecov](https://codecov.io/gh/ropensci/RSelenium/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/RSelenium)
[![](http://www.r-pkg.org/badges/version/RSelenium)](https://CRAN.R-project.org/package=RSelenium)
![](http://cranlogs.r-pkg.org/badges/RSelenium?color=yellow)
![](http://cranlogs.r-pkg.org/badges/grand-total/RSelenium?color=yellowgreen)


This is a set of R Bindings for Selenium 2.0 Remote WebDriver, which you can download from http://selenium-release.storage.googleapis.com/index.html. This binding will not work with the 1.0 version of Selenium.


## Install 

To install `RSelenium` from CRAN, run:

```R
install.packages("RSelenium")
```

To install the development version from GitHub, run:

```R
# install.packages("devtools")
devtools::install_github("ropensci/RSelenium")
```

To get started using `RSelenium` you can look at the introduction vignette located in `/doc/basics.html` once `RSelenium` is installed or run

```R
vignette("basics", package = "RSelenium")
```

or the basic vignette can be viewed [here](http://ropensci.github.io/RSelenium/articles/basics.html).

There is a second vignette dealing with running RSelenium on different browsers/OS locally and remotely which can be viewed at [Driving OS/Browsers Local and Remote](http://ropensci.github.io/RSelenium/articles/saucelabs.html). Finally, you can read all about running a headless browser or running a normal browser on a headless server at [Headless Browsing](http://ropensci.github.io/RSelenium/articles/headless.html).

### Summary of Vignettes

1. [Basics](http://ropensci.github.io/RSelenium/articles/basics.html)
1. [Driving OS/Browsers Local and Remote](http://ropensci.github.io/RSelenium/articles/saucelabs.html)
1. [Testing Shiny Apps](http://ropensci.github.io/RSelenium/articles/shinytesting.html)
1. [Headless Browsing](http://ropensci.github.io/RSelenium/articles/headless.html)
1. [Docker](http://ropensci.github.io/RSelenium/articles/docker.html)
1. [Internet Explorer](http://ropensci.github.io/RSelenium/articles/internetexplorer.html)
1. [Orange County R Users Group Webinar](http://ropensci.github.io/RSelenium/articles/webinar.html)


## Test Shiny Apps

Use `RSelenium` to test your Shiny Apps. Read the introductory tutorial [here](http://ropensci.github.io/RSelenium/articles/shinytesting.html).


## Use [Sauce Labs](https://saucelabs.com/) and [BrowserStack](https://www.browserstack.com/)

### Sauce Labs

```R
user <- "rselenium0"
pass <- "*******************************"
port <- 80
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
browser <- "firefox"
version <- "25"
platform <- "OS X 10.9"
extraCapabilities <- list(
  name = "Test RSelenium",
  username = user,
  accessKey = pass
)

remDr <- remoteDriver$new(
  remoteServerAddr = ip,
  port = port,
  browserName = browser,
  version = version,
  platform = platform,
  extraCapabilities = extraCapabilities
)
```

### BrowserStack

```R
user <- "johnharrison" 
pass <- "*******************"
port <- 80
ip <- paste0(user, ':', pass, "@hub.browserstack.com")
extraCapabilities <- list(
  "browser" = "IE",
  "browser_version" = "7.0",
  "os" = "Windows",
  "os_version" = "XP",
  "browserstack.debug" = "true"
)

remDr <- remoteDriver$new(
  remoteServerAddr = ip,
  port = port,
  extraCapabilities = extraCapabilities
)
```


## Related Work

* [seleniumPipes](https://github.com/johndharrison/seleniumPipes): A lightweight implementation of the w3c webdriver specification. It has been built utilising `xml2`, `httr` and `magrittr` so provides an alternative for users who are familiar with piping.
* [webdriver](https://github.com/rstudio/webdriver): A client for the 'WebDriver API'. It allows driving a (probably headless) web browser, and can be used to test web applications, including `Shiny` apps. In theory it works with any 'WebDriver' implementation, but it was only tested with 'PhantomJS'.
* [rwebdriver](https://github.com/crubba/Rwebdriver): R bindings to the Webdriver API
* [rdom](https://github.com/cpsievert/rdom): Render and parse the DOM from R via phantomjs.


## License

The RSelenium package is licensed under the [AGPLv3](https://www.r-project.org/Licenses/AGPL-3). The help files are licensed under the creative commons attribution, non-commercial, share-alike license [CC-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/).

As a summary, the AGPLv3 license requires, attribution, include copyright and license in copies of the software, state changes if you modify the code, and disclose all source code. Details are in the COPYING file.

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
