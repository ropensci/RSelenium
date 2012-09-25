\name{remoteDriver-class}
\Rdversion{1.1}
\docType{class}
\alias{remoteDriver-class}

\title{Class \code{"remoteDriver"}}
\description{
%%  ~~ A concise (1-5 lines) description of what the class is. ~~
}
\section{Extends}{

All reference classes extend and inherit methods from \code{"\linkS4class{envRefClass}"}.

}
\references{
%%  ~~put references to the literature/web site here~~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%%  ~~objects to See Also as \code{\link{~~fun~~}}, ~~~
%%  ~~or \code{\linkS4class{CLASSNAME}} for links to other classes ~~~
}
\examples{
showClass("remoteDriver")
}
\keyword{classes}
\section{Fields}{
  \describe{
    \item{\code{remoteServerAddr}:}{Object of class \code{character} ~~ }
    \item{\code{port}:}{Object of class \code{numeric} ~~ }
    \item{\code{browserName}:}{Object of class \code{character} ~~ }
    \item{\code{version}:}{Object of class \code{character} ~~ }
    \item{\code{platform}:}{Object of class \code{character} ~~ }
    \item{\code{javascript}:}{Object of class \code{logical} ~~ }
    \item{\code{autoClose}:}{Object of class \code{logical} ~~ }
    \item{\code{serverURL}:}{Object of class \code{character} ~~ }
    \item{\code{sessionInfo}:}{Object of class \code{list} ~~ }
  }
}
\section{Methods}{
  \describe{
    \item{\code{findElements(using, value)}:}{ ~~ }
    \item{\code{click(buttonId)}:}{ ~~ }
    \item{\code{goBack()}:}{ ~~ }
    \item{\code{getAllCookies()}:}{ ~~ }
    \item{\code{executeScript(script, args)}:}{ ~~ }
    \item{\code{findElement(using, value)}:}{ ~~ }
    \item{\code{initialize(remoteServerAddr, port, browserName, version, platform, javascript, autoClose)}:}{ ~~ }
    \item{\code{getTitle(url)}:}{ ~~ }
    \item{\code{getPageSource()}:}{ ~~ }
    \item{\code{mouseMoveToLocation(x, y, elementId)}:}{ ~~ }
    \item{\code{switchToWindow(windowId)}:}{ ~~ }
    \item{\code{buttonup(buttonId)}:}{ ~~ }
    \item{\code{status()}:}{ ~~ }
    \item{\code{getActiveElement()}:}{ ~~ }
    \item{\code{deleteCookieNamed(name)}:}{ ~~ }
    \item{\code{getAlertText()}:}{ ~~ }
    \item{\code{acceptAlert()}:}{ ~~ }
    \item{\code{switchToFrame(frameId)}:}{ ~~ }
    \item{\code{open()}:}{ ~~ }
    \item{\code{setImplicitWaitTimeout(milliseconds)}:}{ ~~ }
    \item{\code{setAsyncScriptTimeout(milliseconds)}:}{ ~~ }
    \item{\code{sendKeysToActiveElement(sendKeys)}:}{ ~~ }
    \item{\code{goForward()}:}{ ~~ }
    \item{\code{setWindowSize(width, height, winHand)}:}{ ~~ }
    \item{\code{refresh()}:}{ ~~ }
    \item{\code{getWindowHandles()}:}{ ~~ }
    \item{\code{doubleclick(buttonId)}:}{ ~~ }
    \item{\code{sendKeysToAlert(sendKeys)}:}{ ~~ }
    \item{\code{screenshot()}:}{ ~~ }
    \item{\code{getCurrentUrl()}:}{ ~~ }
    \item{\code{executeAsyncScript(script, args)}:}{ ~~ }
    \item{\code{getWindowSize(windowId)}:}{ ~~ }
    \item{\code{addCookie(name, value, path, domain, secure)}:}{ ~~ }
    \item{\code{close()}:}{ ~~ }
    \item{\code{getCurrentWindowHandle()}:}{ ~~ }
    \item{\code{getSessions()}:}{ ~~ }
    \item{\code{deleteAllCookies()}:}{ ~~ }
    \item{\code{quit()}:}{ ~~ }
    \item{\code{dismissAlert()}:}{ ~~ }
    \item{\code{navigate(url)}:}{ ~~ }
    \item{\code{setWindowPosition(x, y, winHand)}:}{ ~~ }
    \item{\code{getWindowPosition(windowId)}:}{ ~~ }
    \item{\code{buttondown(buttonId)}:}{ ~~ }
  }
}
