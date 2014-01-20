\name{checkForServer}
\alias{checkForServer}
\title{Check for Server binary}
\usage{
checkForServer(dir = NULL, update = FALSE)
}
\arguments{
  \item{dir}{A directory in which the binary is to be
  placed.}

  \item{update}{A boolean indicating whether to update the
  binary if it is present.}
}
\description{
\code{checkForServer} A utility function to check if the
Selenium Server stanalone binary is present.
}
\section{Detail}{
  The downloads for the Selenium project can be found at
  http://code.google.com/p/selenium/downloads/list. This
  convience function downloads the standalone server and
  places it in the RSelenium package directory bin folder
  by default.
}
\examples{
\dontrun{
checkForServer()
}
}

