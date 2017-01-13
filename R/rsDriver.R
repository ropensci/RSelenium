#' Title
#'
#' @param port 
#' @param verbose 
#' @param browser 
#' @param ... 
#'
#' @return
#' @export
#' @importFrom wdman selenium
#'
#' @examples

rsDriver <- function(port = 4567L, verbose = TRUE, 
                     browser = c("chrome", "firefox", "phantomjs", 
                                 "internet explorer"), ...){
  selServ <- wdman::selenium(port = port, verbose = verbose, ...)
  browser <- match.arg(browser)
  # shim for blocking pipe windows issues
  if(identical(binman:::get_os(), "windows")){
    remDr <- httr::with_config(
      httr::timeout(3000), 
      {remoteDriver(browserName = browser, port = 4567L)}
    )
  }else{
    remDr <- remoteDriver(browserName = browser, port = 4567L)
  }
}