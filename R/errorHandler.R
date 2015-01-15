#' CLASS errorHandler
#'
#' class to handle errors
#'
#' This class is an internal class used by remoteDriver and webElement. It describes how drivers may respond. With a wide range of browsers etc the response can be variable.
#'  
#' @import RCurl
#' @import methods
#' @import RJSONIO
#' @field statusCodes A list with status codes and their descriptions.
#' @field status A status code summarizing the result of the command. A non-zero value indicates that the command failed. A value of one is not a failure but may  indicate a problem.
#' @field statusclass Class associated with the java library underlying the server. For Example: org.openqa.selenium.remote.Response
#' @field sessionid An opaque handle used by the server to determine where to route session-specific commands. This ID should be included in all future session-commands in place of the :sessionId path segment variable.
#' @field hcode 
#' @field value A list containing detailed information regarding possible errors:
#'        \describe{
#'        \item{\code{message}:}{A descriptive message for the command failure.}
#'        \item{\code{screen}:}{string   (Optional) If included, a screenshot of the current page as a base64 encoded string.}
#'        \item{\code{class}:}{string   (Optional) If included, specifies the fully qualified class name for the exception that was thrown when the command failed.}
#'        \item{\code{stackTrace}:}{array   (Optional) If included, specifies an array of JSON objects describing the stack trace for the exception that was thrown when the command failed. The zeroeth element of the array represents the top of the stack.}
#'        }
#' @field responseheader There are two levels of error handling specified by the wire protocol: invalid requests and failed commands.
#' Invalid Requests will probably be indicted by a status of 1. 
#'
#' All invalid requests should result in the server returning a 4xx HTTP response. The response Content-Type should be set to text/plain and the message body should be a descriptive error message. The categories of invalid requests are as follows:
#'      \describe{
#'      \item{\code{Unknown Commands}:}{
#'      If the server receives a command request whose path is not mapped to a resource in the REST service, it should respond with a 404 Not Found message.
#'      }
#'      \item{\code{Unimplemented Commands}:}{
#'      Every server implementing the WebDriver wire protocol must respond to every defined command. If an individual command has not been implemented on the server, the server should respond with a 501 Not Implemented error message. Note this is the only error in the Invalid Request category that does not return a 4xx status code.
#'      }
#'      \item{\code{Variable Resource Not Found}:}{
#'      If a request path maps to a variable resource, but that resource does not exist, then the server should respond with a 404 Not Found. For example, if ID my-session is not a valid session ID on the server, and a command is sent to GET /session/my-session HTTP/1.1, then the server should gracefully return a 404.
#'      }
#'      \item{\code{Invalid Command Method}:}{
#'      If a request path maps to a valid resource, but that resource does not respond to the request method, the server should respond with a 405 Method Not Allowed. The response must include an Allows header with a list of the allowed methods for the requested resource.
#'      }
#'      \item{\code{Missing Command Parameters}:}{
#'      If a POST/PUT command maps to a resource that expects a set of JSON parameters, and the response body does not include one of those parameters, the server should respond with a 400 Bad Request. The response body should list the missing parameters. }
#'      }
#' @field debugheader Not currently implemented
#' @export errorHandler
#' @exportClass errorHandler
#' @aliases errorHandler
#' 
errorHandler <- setRefClass("errorHandler",
                            fields   = list(statusCodes = "data.frame"
                                            , status = "numeric"
                                            , encoding = "character"
                                            , statusclass = "character"
                                            , sessionid = "character"
                                            , hcode = "numeric"
                                            , value = "list"
                                            , responseheader = "list"
                                            , debugheader = "list"),
                            methods  = list(
                              initialize = function(){
                                # update statusCodes if needed
                                # jwireTables <- htmlParse("http://code.google.com/p/selenium/wiki/JsonWireProtocol")
                                # dput(readHTMLTable(getNodeSet(jwireTables, "/*//table//*[text()[contains(.,'Success')]]/../../..")[[1]], stringsAsFactors = FALSE, colClasses = c("integer", "character", "character")))
                                statusCodes <<- structure(list(Code = c(0L, 6L, 7L, 8L, 9L, 10L, 11L, 12L, 13L, 
                                                                        15L, 17L, 19L, 21L, 23L, 24L, 25L, 26L, 27L, 28L, 29L, 30L, 31L, 
                                                                        32L, 33L, 34L)
                                                               , Summary = c("Success", 
                                                                             "NoSuchDriver", "NoSuchElement", "NoSuchFrame", "UnknownCommand", 
                                                                             "StaleElementReference", "ElementNotVisible", "InvalidElementState", 
                                                                             "UnknownError", "ElementIsNotSelectable", "JavaScriptError", 
                                                                             "XPathLookupError", "Timeout", "NoSuchWindow", "InvalidCookieDomain", 
                                                                             "UnableToSetCookie", "UnexpectedAlertOpen", "NoAlertOpenError", 
                                                                             "ScriptTimeout", "InvalidElementCoordinates", "IMENotAvailable", 
                                                                             "IMEEngineActivationFailed", "InvalidSelector", "SessionNotCreatedException", 
                                                                             "MoveTargetOutOfBounds")
                                                               , Detail = c("The command executed successfully.", 
                                                                            "A session is either terminated or not started", "An element could not be located on the page using the given search parameters.", 
                                                                            "A request to switch to a frame could not be satisfied because the frame could not be found.", 
                                                                            "The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource.", 
                                                                            "An element command failed because the referenced element is no longer attached to the DOM.", 
                                                                            "An element command could not be completed because the element is not visible on the page.", 
                                                                            "An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element).", 
                                                                            "An unknown server-side error occurred while processing the command.", 
                                                                            "An attempt was made to select an element that cannot be selected.", 
                                                                            "An error occurred while executing user supplied JavaScript.", 
                                                                            "An error occurred while searching for an element by XPath.", 
                                                                            "An operation did not complete before its timeout expired.", 
                                                                            "A request to switch to a different window could not be satisfied because the window could not be found.", 
                                                                            "An illegal attempt was made to set a cookie under a different domain than the current page.", 
                                                                            "A request to set a cookie's value could not be satisfied.", 
                                                                            "A modal dialog was open, blocking this operation", "An attempt was made to operate on a modal dialog when one was not open.", 
                                                                            "A script did not complete before its timeout expired.", "The coordinates provided to an interactions operation are invalid.", 
                                                                            "IME was not available.", "An IME engine could not be started.", 
                                                                            "Argument was an invalid selector (e.g. XPath/CSS).", "A new session could not be created.", 
                                                                            "Target provided for a move action is out of bounds."))
                                                          , .Names = c("Code", "Summary", "Detail")
                                                          , row.names = c(NA, -25L)
                                                          , class = "data.frame")
                                status <<- 0 # initial status success
                                encoding <<- NA_character_
                                statusclass <<- NA_character_
                                sessionid <<- NA_character_
                                hcode <<- NA_integer_
                                value <<- list()
                                responseheader <<- list()
                                debugheader <<- list()
                              },
                              
                              queryRD = function(ipAddr,
                                                 method = "GET",
                                                 httpheader = c('Content-Type' = 'application/json;charset=UTF-8'),
                                                 qdata = NULL,
                                                 json = FALSE,
                                                 header = TRUE,
                                                 .mapUnicode = TRUE){
                                "A method to communicate with the remote server implementing the JSON wire protocol."
                                #browser(expr = BANDAID)
                                # optional logger here to log calls
                                # can log in an environment in the package namespace
                                # print(deparse(sys.calls()[[sys.nframe()-1]]))
                                h = basicHeaderGatherer()
                                w = basicTextGatherer(.mapUnicode = .mapUnicode)
                                d <- debugGatherer()
                                if(is.null(qdata)){
                                  getUC.params <- list(url = ipAddr, customrequest = method, httpheader = httpheader, isHTTP = FALSE)
                                }else{
                                  getUC.params <- list(url = ipAddr, customrequest = method, httpheader = httpheader, postfields = qdata, isHTTP = FALSE)
                                }
                                if(header){getUC.params <- c(getUC.params, list(headerfunction = h$update, writefunction = w$update))}
                                res <- tryCatch({do.call(getURLContent, getUC.params)}, error = function(e){
                                  err <- switch(e$message
                                         , "<url> malformed" = paste0("Invalid call to server. Please check you have opened a browser.")
                                         , "couldn't connect to host" = paste0("Couldnt connect to host on ", serverURL, ".\nPlease ensure a Selenium server is running."),
                                         "Undefined error in RCurl call."
                                  )
                                  cat(err)
                                  NA
                                }
                                )
                                if(is.na(res)){stop()}
                                
                                if(header){
                                  responseheader <<- as.list(h$value())
                                }
                                debugheader <<- as.list(d$value())
                                res <- w$value()
                                res <- ifelse(is.raw(res), rawToChar(res), res)
                                res1 <- try(fromJSON(res, simplifyWithNames = FALSE, encoding = encoding), TRUE)
                                if(identical(class(res1), "try-error") && grepl("\"value\":", res)){
                                  # try manually parse JSON RJSONIO wont handle
                                  testRes <- sub("(.*?\"value\":\")(.*)(\",\"state\":.*)", "\\1YYYYY\\3", res)
                                  testValue <- sub("(.*?\"value\":\")(.*)(\",\"state\":.*)", "\\2", res)
                                  res1 <- fromJSON(testRes, simplifyWithNames = FALSE, encoding = encoding)
                                  res1$value <- gsub("\\\"", "\"", testValue)
                                }
                                if( !identical(class(res1), "try-error")){
                                  if(!is.null(res1$status)){status <<- res1$status}
                                  if(!is.null(res1$class)){statusclass <<- res1$class}
                                  if(!is.null(res1$sessionId)){sessionid <<- res1$sessionId}
                                  if(!is.null(res1$hCode)){hcode <<- res1$hCode}
                                  if(!is.null(res1$value)){
                                    if(length(res1$value) > 0){
                                      if(is.list(res1$value)){
                                        value <<- res1$value
                                      }else{
                                        value <<- list(res1$value)                                      
                                      }
                                    }else{
                                      value <<- list()
                                    }
                                  }
                                }else{
                                  # try JSON
                                  status <<- 1L # user check for error
                                  statusclass <<- NA_character_
                                  sessionid <<- NA_character_
                                  hcode <<- NA_integer_
                                  value <<- list(res)
                                  
                                }
                                checkStatus()
                              }
                              , checkStatus = function(){
                                "An internal method to check the status returned by the server. If status indicates an error an appropriate error message is thrown."
                                if(status > 1){
                                  errId <- which(statusCodes$Code == as.integer(status))
                                  if(length(errId) > 0){
                                    errMessage <- statusCodes[errId, c("Summary", "Detail")]
                                    errMessage$class <- value$class
                                    errMessage <- paste("\t", paste(names(errMessage), errMessage, sep = ": "))
                                    errMessage[-1] <- paste("\n", errMessage[-1])
                                    stop(errMessage, call. = FALSE)
                                  }
                                }
                              }
                            )
)
