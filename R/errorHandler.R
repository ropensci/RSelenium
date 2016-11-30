#' CLASS errorHandler
#'
#' class to handle errors
#'
#' This class is an internal class used by remoteDriver and webElement. It 
#'    describes how drivers may respond. With a wide range of browsers etc 
#'    the response can be variable.
#'  
#' @importFrom methods setRefClass new
#' @field statusCodes A list with status codes and their descriptions.
#' @field status A status code summarizing the result of the command. A 
#'    non-zero value indicates that the command failed. A value of one is 
#'    not a failure but may  indicate a problem.
#' @field statusclass Class associated with the java library underlying 
#'    the server. For Example: org.openqa.selenium.remote.Response
#' @field sessionid An opaque handle used by the server to determine where 
#'    to route session-specific commands. This ID should be included in 
#'    all future session-commands in place of the :sessionId path segment 
#'    variable.
#' @field hcode 
#' @field value A list containing detailed information regarding possible 
#'    errors:
#'    \describe{
#'      \item{\code{message}:}{A descriptive message for the command 
#'        failure.}
#'      \item{\code{screen}:}{string   (Optional) If included, a 
#'        screenshot of the current page as a base64 encoded string.}
#'      \item{\code{class}:}{string   (Optional) If included, specifies 
#'        the fully qualified class name for the exception that was thrown 
#'        when the command failed.}
#'      \item{\code{stackTrace}:}{array   (Optional) If included, 
#'        specifies an array of JSON objects describing the stack trace 
#'        for the exception that was thrown when the command failed. The 
#'        zeroeth element of the array represents the top of the stack.}
#'    }
#' @field responseheader There are two levels of error handling specified 
#'    by the wire protocol: invalid requests and failed commands.
#'    Invalid Requests will probably be indicted by a status of 1. 
#'
#'    All invalid requests should result in the server returning a 4xx HTTP 
#'    response. The response Content-Type should be set to text/plain and 
#'    the message body should be a descriptive error message. The 
#'    categories of invalid requests are as follows:
#'    \describe{
#'      \item{\code{Unknown Commands}:}{
#'        If the server receives a command request whose path is not mapped 
#'        to a resource in the REST service, it should respond with a 404 
#'        Not Found message.
#'      }
#'      \item{\code{Unimplemented Commands}:}{
#'        Every server implementing the WebDriver wire protocol must 
#'        respond to every defined command. If an individual command has 
#'        not been implemented on the server, the server should respond 
#'        with a 501 Not Implemented error message. Note this is the only 
#'        error in the Invalid Request category that does not return a 4xx 
#'        status code.
#'      }
#'      \item{\code{Variable Resource Not Found}:}{
#'        If a request path maps to a variable resource, but that resource 
#'        does not exist, then the server should respond with a 404 Not 
#'        Found. For example, if ID my-session is not a valid session ID 
#'        on the server, and a command is sent to GET /session/my-session 
#'        HTTP/1.1, then the server should gracefully return a 404.
#'      }
#'      \item{\code{Invalid Command Method}:}{
#'        If a request path maps to a valid resource, but that resource 
#'        does not respond to the request method, the server should 
#'        respond with a 405 Method Not Allowed. The response must include 
#'        an Allows header with a list of the allowed methods for the 
#'        requested resource.
#'      }
#'      \item{\code{Missing Command Parameters}:}{
#'        If a POST/PUT command maps to a resource that expects a set of 
#'        JSON parameters, and the response body does not include one of 
#'        those parameters, the server should respond with a 400 Bad 
#'        Request. The response body should list the missing parameters. 
#'      }
#'    }
#' @field debugheader Not currently implemented
#' @export errorHandler
#' @exportClass errorHandler
#' @aliases errorHandler
#' 
errorHandler <- 
  setRefClass(
    "errorHandler",
    fields   = list(
      statusCodes = "data.frame", 
      status = "numeric", 
      statusclass = "character", 
      sessionid = "character", 
      hcode = "numeric", 
      value = "list"),
    methods  = list(
      initialize = function(){
        # statCodes are status codes stored in sysdata.rda
        statusCodes <<- statCodes
        status <<- 0L # initial status success
        statusclass <<- NA_character_
        sessionid <<- NA_character_
        hcode <<- NA_integer_
        value <<- list()
        },
      
      queryRD = 
        function(ipAddr, method = "GET", qdata = NULL){
          "A method to communicate with the remote server implementing the 
          JSON wire protocol."
        getUC.params <- 
          list(url = ipAddr, verb = method, body = qdata, encode = "json")
        res <- tryCatch(
          {do.call(httr::VERB, getUC.params)}, 
          error = function(e){e}
        )
        if(inherits(res, "response")){
          resContent <- httr::content(res, simplifyVector = FALSE)
          checkStatus(resContent)
        }else{
          checkError(res)
        }
      },
      
      checkStatus = function(resContent){
        "An internal method to check the status returned by the server. If 
        status indicates an error an appropriate error message is thrown."
        if(!is.null(resContent[["status"]])){
          status <<- resContent[["status"]]
          statusclass <<- if(!is.null(resContent[["class"]])){
            resContent[["class"]]
          }else{
            NA_character_
          }
          if(!is.null(resContent[["sessionId"]])){
            sessionid <<- resContent[["sessionId"]]
          }
          hcode <<- if(!is.null(resContent[["hCode"]])){
            as.integer(resContent[["hCode"]])
          }else{
            NA_integer_
          }
          value <<- if(!is.null(resContent[["value"]])){
            if(is.list(resContent[["value"]])){
              resContent[["value"]]
            }else{
              list(resContent[["value"]])
            }
          }else{
            list()
          }
          errId <- which(
            statusCodes[["Code"]] == as.integer(status)
          )
          if(length(errId) > 0 && status > 1L){
            errMessage <- statusCodes[errId, c("Summary", "Detail")]
            errMessage[["class"]] <- value[["class"]]
            errMessage <- paste("\t", paste(names(errMessage), 
                                            errMessage, sep = ": "))
            errMessage[-1] <- paste("\n", errMessage[-1])
            errMessage <- 
              c(errMessage,
                "\n\t Further Details: run errorDetails method")
            if(!is.null(value[["message"]])){
              message("\nSelenium message:", value[["message"]], "\n")
            }
            stop(errMessage, call. = FALSE)
          }
        }else{
          
        }
      },
      
      checkError = function(res){
        status <<- 13L
        statusclass <<- NA_character_
        hcode <<- NA_integer_
        value <<- list()
        eMessage <- list(
          "Invalid call to server. Please check you have opened a browser.",
          paste0("Couldnt connect to host on ", serverURL, 
                 ".\n  Please ensure a Selenium server is running."),
          function(x){
            paste0("Undefined error in httr call. httr output: ", x)
          }
        )
        err <- switch(
          res[["message"]], 
          "Couldn't connect to server" = eMessage[[2]],
          eMessage[[3]](res[["message"]])
        )
        stop(err)
      },
      
      errorDetails = function(type = "value"){
        "Return error details. Type can one of c(\"value\", \"class\", 
        \"status\")"
        switch(type,
               value = value,
               class = statusclass,
               status = status
        )
      }
    )
  )
