#' CLASS errorHandler
#'
#' class to handle errors
#'
#' brief desc here
#'  
#'@section Methods:
#'  \describe{
#'    \item{\code{new(...)}:}{ Create a new \code{errorHandler} object. ... is used to define the appropriate slots.}
#'    }
#'      
#' @export errorHandler
#' @exportClass errorHandler
#' @examples
#' \dontrun{
#' }
#' 
errorHandler <- setRefClass("errorHandler",
                            fields   = list(statusCodes = "data.frame"
                                            , status = "numeric"
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
                                                 header = TRUE){
                                #browser(expr = BANDAID)
                                # optional logger here to log calls
                                # can log in an environment in the package namespace
                                print(deparse(sys.calls()[[sys.nframe()-1]]))
                                h = basicHeaderGatherer()
                                d <- debugGatherer()
                                if(is.null(qdata)){
                                  getUC.params <- list(url = ipAddr, customrequest = method, httpheader = httpheader, isHTTP = FALSE)
                                  if(header){getUC.params <- c(getUC.params, list(headerfunction = h$update))}
                                  res <- do.call(getURLContent, getUC.params)
                                  #res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader, isHTTP = FALSE, headerfunction = h$update)
                                }else{
                                  getUC.params <- list(url = ipAddr, customrequest = method, httpheader = httpheader, postfields = qdata, isHTTP = FALSE)
                                  if(header){getUC.params <- c(getUC.params, list(headerfunction = h$update))}
                                  res <- do.call(getURLContent, getUC.params)
                                  #res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader, postfields = qdata, isHTTP = FALSE, headerfunction = h$update)#, .opts = list(verbose = TRUE), debugfunction = d$update)
                                }
                                if(header){
                                  responseheader <<- as.list(h$value())
                                }
                                debugheader <<- as.list(d$value())
                                res <- ifelse(is.raw(res), rawToChar(res), res)
                                res1 <- try(fromJSON(res, simplifyWithNames = FALSE), TRUE)
                                if(identical(class(res1), "try-error") && grepl("\"value\":", res)){
                                  # try manually parse JSON RJSONIO wont handle
                                  testRes <- sub("(.*?\"value\":\")(.*)(\",\"state\":.*)", "\\1YYYYY\\3", res1)
                                  testValue <- sub("(.*?\"value\":\")(.*)(\",\"state\":.*)", "\\2", res1)
                                  res1 <- fromJSON(testRes, simplifyWithNames = FALSE)
                                  res1$value <- gsub("\\\"", "\"", testValue)
                                }
#                                if( isValidJSON(res1, asText = TRUE)){ # not reliable
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
                                  status <<- 1 # user check for error
                                  statusclass <<- NA_character_
                                  sessionid <<- NA_character_
                                  hcode <<- NA_integer_
                                  value <<- list(res)
                                  
                                }
                                #                                }
                                # insert error checking code here based on res1$status
                                #                                  
                                #                                 if(is.atomic(res1)){
                                #                                   return(res1)
                                #                                 }else{
                                #                                   res1$value
                                #                                 }
                              }
                            )
)
