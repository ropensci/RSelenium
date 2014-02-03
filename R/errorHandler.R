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
                            fields   = list(statusCodes = "data.frame"),
                            methods  = list(
                              initialize = function(){
                                # update statusCodes if needed
                                # jwireTables <- htmlParse("http://code.google.com/p/selenium/wiki/JsonWireProtocol")
                                # dput(readHTMLTable(getNodeSet(jwireTables, "/*//table//*[text()[contains(.,'Success')]]/../../..")[[1]], stringsAsFactors = FALSE))
                                statusCodes <<- structure(list(Code = c("0", "6", "7", "8", "9", "10", "11", 
                                                                        "12", "13", "15", "17", "19", "21", "23", "24", "25", "26", "27", 
                                                                        "28", "29", "30", "31", "32", "33", "34")
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
                              },
                              
                              queryRD = function(ipAddr,
                                                 method = "GET",
                                                 httpheader = c('Content-Type' = 'application/json;charset=UTF-8'),
                                                 qdata = NULL,
                                                 json = FALSE){
                                
                                if(is.null(qdata)){
                                  res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader, isHTTP = FALSE)
                                }else{
                                  res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader, postfields = qdata, isHTTP = FALSE)
                                }
                                
                                res1 <- ifelse(is.raw(res), rawToChar(res), res)
                                if(method == 'GET' || json){
                                  if( isValidJSON(res1, asText = TRUE)){
                                    res1 <- fromJSON(res1) 
                                  }
                                }
                                # insert error checking code here based on res1$status
                                if(is.atomic(res1)){
                                  return(res1)
                                }else{
                                  res1$value
                                }
                              }
                            )
)
