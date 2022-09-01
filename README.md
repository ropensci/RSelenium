# RSelenium

[![R-CMD-check](https://github.com/ropensci/RSelenium/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/RSelenium/actions)
[![codecov](https://codecov.io/gh/ropensci/RSelenium/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/RSelenium)
[![CRAN status](https://www.r-pkg.org/badges/version/RSelenium)](https://CRAN.R-project.org/package=RSelenium)
![CRAN monthly](http://cranlogs.r-pkg.org/badges/RSelenium?color=yellow)
![CRAN total](http://cranlogs.r-pkg.org/badges/grand-total/RSelenium?color=yellowgreen)


This is a set of R Bindings for Selenium **2.0** Remote WebDriver, which you can download from http://selenium-release.storage.googleapis.com/index.html. This binding will not work with the 1.0 version of Selenium.


## Install 

To install `RSelenium` from CRAN, run:

```R
install.packages("RSelenium")
```

To install the development version from GitHub, run:

```R
# install.packages("remotes")
remotes::install_github("ropensci/RSelenium")
```

To get started using `RSelenium` you can look at the introduction vignette located in `/doc/basics.html` once `RSelenium` is installed or run

```R
vignette("basics", package = "RSelenium")
```

or the basic vignette can be viewed [here](https://docs.ropensci.org/RSelenium/articles/basics.html).

There is a second vignette dealing with running RSelenium on different browsers/OS locally and remotely which can be viewed at [Driving OS/Browsers Local and Remote](https://docs.ropensci.org/RSelenium/articles/saucelabs.html).

### Summary of Vignettes

1. [Basics](https://docs.ropensci.org/RSelenium/articles/basics.html)
1. [Driving OS/Browsers Local and Remote](https://docs.ropensci.org/RSelenium/articles/saucelabs.html)
1. ~~Testing Shiny Apps~~
    * Consider using RStudio's [shinytest](https://rstudio.github.io/shinytest/) package for testing Shiny apps.
1. ~~Headless Browsing~~
    * PhantomJS development is [suspended](https://github.com/ariya/phantomjs/issues/15344) until further notice.
    * Consider using RStudio's [webdriver](https://rstudio.github.io/webdriver/) package.
1. [Docker](https://docs.ropensci.org/RSelenium/articles/docker.html)
1. [Internet Explorer](https://docs.ropensci.org/RSelenium/articles/internetexplorer.html)
    * Internet Explorer 11 has retired as of June 15, 2022.


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

* [chromote](https://rstudio.github.io/chromote/): An R implementation of the Chrome DevTools Protocol. It works with Chrome, Chromium, Opera, Vivaldi, and other browsers based on Chromium.
* [shinytest](https://rstudio.github.io/shinytest/): For automated testing of Shiny applications, using a headless browser, driven through `webdriver`.
* [webdriver](https://rstudio.github.io/webdriver/): A client for the 'WebDriver API'. It allows driving a (probably headless) web browser, and can be used to test web applications, including `Shiny` apps. In theory it works with any 'WebDriver' implementation, but it was only tested with 'PhantomJS'.
* [seleniumPipes](https://github.com/johndharrison/seleniumPipes): A lightweight implementation of the w3c webdriver specification. It has been built utilising `xml2`, `httr` and `magrittr` so provides an alternative for users who are familiar with piping.
* [rwebdriver](https://github.com/crubba/Rwebdriver): R bindings to the Webdriver API
* [rdom](https://github.com/cpsievert/rdom): Render and parse the DOM from R via phantomjs.


## License

The RSelenium package is licensed under the [AGPLv3](https://www.r-project.org/Licenses/AGPL-3). The help files are licensed under the creative commons attribution, non-commercial, share-alike license [CC-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/).

As a summary, the AGPLv3 license requires, attribution, include copyright and license in copies of the software, state changes if you modify the code, and disclose all source code. Details are in the COPYING file.

---

[![](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
