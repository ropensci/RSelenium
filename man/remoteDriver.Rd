\name{remoteDriver}
\alias{remoteDriver}
\title{CLASS remoteDriver}
\description{
  remoteDriver Class uses the JsonWireProtocol to
  communicate with the Selenium Server. If an error occurs
  while executing the command then the server sends back an
  HTTP error code with a JSON encoded reponse that
  indicates the precise Response Error Code. The module
  will then croak with the error message associated with
  this code. If no error occurred, then the subroutine
  called will return the value sent back from the server
  (if a return value was sent). So a rule of thumb while
  invoking methods on the driver is if the method did not
  croak when called, then you can safely assume the command
  was successful even if nothing was returned by the
  method.
}
\section{Slots}{
  \describe{ \item{\code{remoteServerAddr}:}{Object of
  class \code{"character"}, giving the ip of the remote
  server. Defaults to localhost} \item{\code{port}:}{Object
  of class \code{"numeric"}, the port of the remote server
  on which to connect.} \item{\code{browserName}:}{Object
  of class \code{"character"}. The name of the browser
  being used; should be one of
  {chrome|firefox|htmlunit|internet explorer|iphone}.}
  \item{\code{version}:}{Object of class
  \code{"character"}. The browser version, or the empty
  string if unknown.} \item{\code{platform}:}{Object of
  class \code{"character"}. A key specifying which platform
  the browser is running on. This value should be one of
  {WINDOWS|XP|VISTA|MAC|LINUX|UNIX}. When requesting a new
  session, the client may specify ANY to indicate any
  available platform may be used.}
  \item{\code{javascript}:}{Object of class
  \code{"character"}. Whether the session supports
  executing user supplied JavaScript in the context of the
  current page. } \item{\code{serverURL}:}{Object of class
  \code{"character"}. Url of the remote server which JSON
  requests are sent to. } \item{\code{sessionInfo}:}{Object
  of class \code{"list"}. A list containing information on
  sessions. } }
}

\section{Methods}{
  \describe{ \item{\code{new()}:}{ Create a new
  \code{remoteDriver} object. } }
}

