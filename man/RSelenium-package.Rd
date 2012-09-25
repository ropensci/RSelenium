\name{RSelenium-package}
\alias{RSelenium-package}
\alias{RSelenium}
\docType{package}
\title{
RSelnium: An R client for Selenium Remote Webdriver
}
\description{
More about what it does (maybe more than one line)
~~ A concise (1-5 lines) description of the package ~~
}
\details{
\tabular{ll}{
Package: \tab RSelenium\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-09-20\cr
License: \tab What license is it under?\cr
Depends: \tab methods\cr
}
~~ An overview of how to use the package, including the most important ~~
~~ functions ~~
}
\author{
John Harrison <johndharrion0@gmail.com
}
\references{
http://seleniumhq.org/projects/webdriver/
}
~~ Optionally other standard keywords, one per line, from file KEYWORDS in ~~
~~ the R documentation directory ~~
\keyword{ package }
\seealso{
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
remDr <- remoteDriver$new()
remDr$open()
remDr$navigate("http://www.google.com")
remDr$navigate("http://www.bbc.co.uk")
remDr$goBack()
remDr$goForward()
remDr$quit()
}
