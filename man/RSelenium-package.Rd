\name{RSelenium-package}
\alias{RSelenium-package}
\alias{RSelenium}
\docType{package}
\title{
RSelnium: An R client for Selenium Remote Webdriver
}
\description{
These are R bindings for the WebDriver API in Selenium 2. They use
    the JsonWireProtocol defined at
    http://code.google.com/p/selenium/wiki/JsonWireProtocol to communicate with
    a Selenium RemoteWebDriver Server.
}
\details{
\tabular{ll}{
Package: \tab RSelenium\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-09-20\cr
License: \tab MIT\cr
Depends: \tab R (>= 2.15.0),methods,RCurl,rjson\cr
}
}
\author{
John Harrison <johndharrion0@gmail.com
}
\references{
http://seleniumhq.org/projects/webdriver/
}
\keyword{ package }
\examples{
\dontrun{
# run checkForServer() if you need the stand-alone Java binary
startServer()
remDr <- remoteDriver$new()
remDr$open()
remDr$navigate("http://www.google.com")
remDr$navigate("http://www.bbc.co.uk")
remDr$goBack()
remDr$goForward()
remDr$quit()
}
}
