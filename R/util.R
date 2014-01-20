#' Check for Server binary
#' 
#' \code{checkForServer}
#' A utility function to check if the Selenium Server stanalone binary is present.
#' @param dir A directory in which the binary is to be placed.
#' @param update A boolean indicating whether to update the binary if it is present.
#' @export
#' @section Detail: The downloads for the Selenium project can be found at http://code.google.com/p/selenium/downloads/list. This convience function downloads the standalone server and places it in the RSelenium package directory bin folder by default.
#' @examples
#' \dontrun{
#' checkForServer()
#' }

checkForServer <- function (dir = NULL, update = FALSE) 
{
  selURL <- "http://code.google.com/p/selenium/downloads/"
  selXML <- htmlParse(paste0(selURL, "list"))
  selJAR <- xpathSApply(selXML, "//a[contains(@href,'selenium-server-standalone')]/@href")[[1]]
  selDIR <- ifelse(is.null(dir), paste0(find.package("RSelenium"), 
                                        "/bin/"), dir)
  selFILE <- paste0(selDIR, "selenium-server-standalone.jar")
  if (update || !file.exists(selFILE)) {
    dir.create(selDIR, showWarnings=FALSE)
    print("DOWNLOADING STANDALONE SELENIUM SERVER. THIS MAY TAKE SEVERAL MINUTES")
    download.file(paste0("http:", selJAR), selFILE, mode = "wb")
  }
}

#' Start the standalone server.
#' 
#' \code{startServer}
#' A utility function to start the standalone server. 
#' @param dir A directory in which the binary is to be placed.
#' @export
#' @section Detail: By default the binary is assumed to be in
#' the RSelenium package /bin directory. 
#' @examples
#' \dontrun{
#' startServer()
#' }

startServer <- function (dir = NULL) 
{
  selDIR <- ifelse(is.null(dir), paste0(find.package("RSelenium"), 
                                        "/bin/"), dir)
  selFILE <- paste0(selDIR, "selenium-server-standalone.jar")
  if (!file.exists(selFILE)) {
    stop("No Selenium Server binary exists. Run checkForServer or start server manually.")
  }
  else {
    if (.Platform$OS.type == "unix") {
      system(paste0("java -jar ", shQuote(selFILE)), wait = FALSE, 
             ignore.stdout = TRUE, ignore.stderr = TRUE)
    }
    else {
      system(paste0("java -jar ", shQuote(selFILE)), wait = FALSE, 
             invisible = FALSE)
    }
  }
}

#' @export .DollarNames.remoteDriver
#' @export .DollarNames.webElement
#' 
queryRD <- function(ipAddr,
                  method = "GET",
                  httpheader = c('Content-Type' = 'application/json;charset=UTF-8'),
                  qdata = NULL,
                  json = FALSE){
  
 if(is.null(qdata)){
   res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader)
 }else{
   res <- getURLContent(ipAddr, customrequest = method, httpheader = httpheader, postfields = qdata)
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

matchSelKeys <- function(x){
  if(any(names(x) =='key')){
      x[names(x) =='key']<-selKeys[match(x[names(x) == 'key'],names(selKeys))]
  }
  unname(x)      
}

.DollarNames.remoteDriver <- function(x, pattern){
    grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

.DollarNames.webElement <- function(x, pattern){
    grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

