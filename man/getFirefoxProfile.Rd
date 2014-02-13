\name{getFirefoxProfile}
\alias{getFirefoxProfile}
\title{Get Firefox profile.}
\usage{
getFirefoxProfile(profDir)
}
\arguments{
  \item{profDir}{The directory in which the firefox profile
  resides}
}
\description{
\code{getFirefoxProfile} A utility function to get a
firefox profile.
}
\section{Detail}{
  A firefox profile directory is zipped and base64 encoded.
  It can then be passed to the selenium server as a
  required capability with key firefox_profile
}
\examples{
\dontrun{
fprof <- getFirefoxProfile("~/.mozilla/firefox/9qlj1ofd.testprofile")
remDr <- remoteDriver(extraCapabilities = fprof)
remDr$open()
}
}

