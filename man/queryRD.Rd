\name{queryRD}
\alias{queryRD}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Prepare a query to send to the remote server.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
queryRD(ipAddr, method = "GET", httpheader = c(`Content-Type` = "application/json;charset=UTF-8"), data = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ipAddr}{
%%     ~~Describe \code{ipAddr} here~~
}
  \item{method}{
%%     ~~Describe \code{method} here~~
}
  \item{httpheader}{
%%     ~~Describe \code{httpheader} here~~
}
  \item{data}{
%%     ~~Describe \code{data} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (ipAddr, method = "GET", httpheader = c(`Content-Type` = "application/json;charset=UTF-8"), 
    data = NULL) 
{
    if (is.null(data)) {
        res <- rawToChar(getURLContent(ipAddr, customrequest = method, 
            httpheader = httpheader, binary = TRUE))
    }
    else {
        res <- rawToChar(getURLContent(ipAddr, customrequest = method, 
            httpheader = httpheader, postfields = data, binary = TRUE))
    }
    res
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
