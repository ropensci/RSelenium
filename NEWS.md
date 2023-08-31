# RSelenium 1.7.9
* Remove images in vignettes (addressing #260)
* Remove dependency on `Rcompression` (addressing #251 #256)
* Remove the defunct functions: `phantom`, `checkForServer`, and `startServer`
* Use `caTools::base64decode` instead of `openssl::base64_decode` to decode the base64 encoded PNG screenshot

# RSelenium 1.7.7
* Moved testing to GitHub Actions

# RSelenium 1.7.6
* No functional changes in this version (need to re-submit to CRAN for being archived)
* Fixed typos in vignettes and documentation
* Styled the package with `styler` package following the tidyverse formatting rules

# RSelenium 1.7.5
* Fix switchToWindow issue in fiefox (#143)
* Add a tutorial to allow running RSelenium Tests in Internet Explorer (thanks @zappingseb #193)
* Updated vignettes and documentation

# RSelenium 1.7.4
* `executeScript` now passes a dummy argument
* Defunct `phantom()` function
* Updated unit tests and test environment
* Updated vignettes and documentation

# RSelenium 1.7.3
* Address issue with user/pass credentials being exposed using SauceLabs (thanks @jstockwin #131)
* Cache packages on TRAVIS to reduce runtime (thanks @jstockwin #132)

# RSelenium 1.7.2
* Fixed issue where rsDriver client when failing to open didn't catch error
* Correctly pass the check argument in rsDriver to wdman (thanks @bourdieu #123)

# RSelenium 1.7.1
* Fixed issue where rsDriver was not passing additional arguments via ...
* Fixed issue with rsDriver and Win/Firefox
* serverURL field in remoteDriver class is now set in initialize method

# RSelenium 1.7.0
* Basic vignette update with appendix on using rsDriver
* Print method added for environment returned by rsDriver
* Default PhantomJS version switched to 2.1.1 (2.5.0-beta has old
  version of ghostdriver)

# RSelenium 1.6.6
* phantom is marked as deprecated. To drive PhantomJS via selenium use the
  rsDriver function. To drive directly use wdman::phantomjs

# RSelenium 1.6.5
* checkForServer and startServer are now defunct. rsDriver is marked as a
  dual replacement. Docker is recommended to run a selenium server/browser.

# RSelenium 1.6.4
* Add a rsDriver function to return a Selenium/webdriver server and a 
  browser client.

# RSelenium 1.6.3
* Return a selected value with the selectTag method.

# RSelenium 1.6.1
* Added a selectTag method to the webElement class see #108.
* RSelenium Basics vignette was updated/revised.

# RSelenium 1.6.0
* Moved http package from RCurl to httr see #106.
* Removed dependence on rjson. httr incorporates jsonlite.
* Import base64_decode from openssl.
* Fixed issue with attributes.Selenium not firing error see #109

# RSelenium 1.5.1
* Added a path argument to the remoteDriver class.

# RSelenium 1.4.9
* Fix .DollarNames to correct issues running under recent RStudio version.

# RSelenium 1.4.8
* Added tests for executeScript
* Fixed issue in executeScript/executeAsyncScript with returning nested
    web elements

# RSelenium 1.4.7
* Code tidied up
* statCodes added as an internal data.frame
* tidy up imports. importFrom instead of import

# RSelenium 1.4.6
* Replace calls to cat with message when error

# RSelenium 1.4.5
* Use canonical form for referring to r-project

# RSelenium 1.4.4
* Deprecate startServer and checkForServer (look at processx to manage process)
* Use message rather than print (thanks Dean Attali #88) in checkForServer. Fix typo in startServer (thanks Charles Thompson #85)
* Copy startServer and checkForServer to examples/serverUtils 

# RSelenium 1.4.3
* Moved testing to TRAVIS
* Switch to rjson from RJSONIO as issue with RJSONIO and TRAVIS/covr
* Ported api tests to TRAVIS

# RSelenium 1.4.2
* Add vignette on RSelenium and Docker containers.

# RSelenium 1.4.1
* Add option to pass arguments to JVM in startServer.
* In startServer look for multiple copies of selenium binary in selDIR 
* Make renaming selenium binary optional in checkForServer
* Add option to download beta releases in checkForServer

# RSelenium 1.4.0
* startServer utility function now returns a list of function; getpid returns the process id of the
  started server, the stop function stops the started server using the process id. Thanks to  
  Dan Tenenbaum #67 and Toby Dylan Hocking #72

# RSelenium 1.3.7
* Add fix for multiple/Beta JARS in checkForServer (Thanks Dean Attali #79)
* Update reference for Selenium download (Thanks @mnel)

# RSelenium 1.3.6
* Allow passing of system2 arguments in startServer utility function

# RSelenium 1.3.4
* Fix custom path not being passed correctly to phantom utility function.
* Allowing passing of commandline arguments via utility function startServer.

# RSelenium 1.3.3
* Add utility function makeFirefoxProfile (Thanks Shan Huang #24)
* Fix phantom utility function for OSX (Thanks Carson Sievert #25)

# RSelenium 1.3.2
* Methods now fail with errors if the server returns an error related status code. Summary and Detail of the error are outputted as well as the associated java class.
* Add a phantom utility function to enable driving of phantomjs in webdriver mode independent of Selenium Server.
* Fixed file paths in startServer for windows (Thanks @mnel #22)

# RSelenium 1.3.0
* Add the content from OC-RUG webinar as a vignette.
* Update the Driving OS/Browsers local and remote vignette.

# RSelenium 1.2.5
* Update reference classes to use `@field` and inline docstrings for methods
* Allow partial string matching on the `using` argument of the findElement and findElements method from the remoteDriver class.
* Allow partial string matching on the `using` argument of the findChildElement and findChildElements method from the webElement class.

# RSelenium 1.2.4
* Add getLogtypes() and log(type) methods to remoteDriver class
* Fix getFirefoxProfile so useBase = TRUE works under windows.
* Add additional support for encoding (thanks to Nicola Logrillo issue #16)
* Add file argument to screenshot method in remoteDriver class to allow writing screenshot to file
* Add a getChromeProfile utility function.

# RSelenium 1.2.3
* Add option to display screenshot in viewer panel if using RStudio
