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
                              initialize = function(...){
                                callSuper(...)
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
