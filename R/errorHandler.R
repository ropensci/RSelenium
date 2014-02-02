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
#' @include remoteDriver.R 
#' @export errorHandler
#' @exportClass errorHandler
#' @examples
#' \dontrun{
#' }
#' 
errorHandler <- setRefClass("errorHandler",
                            contains = "remoteDriver",
                            fields   = list(),
                            methods  = list(
                              initialize = function(...){
                                callSuper(...)
                              }
                              )
)
