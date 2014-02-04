R Bindings for Selenium 2.0 Remote WebDriver
==========================

This is a set of R Bindings for Selenium 2.0 Remote WebDriver, which you
should download from http://code.google.com/p/selenium; look for
selenium-server-standalone.jar.  This binding will not work with the
1.0 version of Selenium.

This library was influenced by the perl implemetation detailed here 
https://metacpan.org/release/Selenium-Remote-Driver.

### Install 

To install, install the `devtools` package if necessary (`install.packages("devtools")`) and run:

```
devtools::install_github("RSelenium", "johndharrison")
```

To get started using `RSelenium` you can look at the introduction vignette located 
in `/doc/RSelenium-basics.html` once `RSelenium` is installed or run

```

vignette('RSelenium-basics')

```

### Use sauceLabs
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

### License

The RSelenium package is licensed under the <a href="http://www.tldrlegal.com/l/AGPL3" target="_blank">AGPLv3</a>. The help files are licensed under the creative commons attribution, non-commercial, share-alike license <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">CC-NC-SA</a>.

As a summary, the AGPLv3 license requires, attribution, include copyright and license in copies of the software, state changes if you modify the code, and disclose all source code. Details are in the COPYING file.