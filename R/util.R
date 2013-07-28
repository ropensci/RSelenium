checkForServer <- function(dir = NULL, update = FALSE){
  selURL <- 'http://code.google.com/p/selenium/downloads/'
  selXML <- htmlParse(paste0(selURL, "list"))
  selJAR <- xpathSApply(selXML, "//a[contains(@href,'selenium-server-standalone')]/@href")[[1]]
  
  if(is.null(dir)){
    selDIR <- paste0(find.package('RSelenium'), '/bin/')
  }else{
    selDIR <- dir    
  }
  
  if(update){
    download.file(selJAR, paste0('http:', selDIR,'selenium-server-standalone.jar'), mode = "wb")   
  }else{
    if(!file.exists(paste0(selDIR,'selenium-server-standalone.jar'))){
      download.file(paste0('http:',selJAR), paste0(selDIR,'selenium-server-standalone.jar'), mode = "wb")
    }
  }
}


system(paste0("java -jar ", shQuote(paste0(selDIR, 'selenium-server-standalone.jar'))), wait = FALSE, invisible = FALSE)

#' @export .DollarNames.remoteDriver
#' @export .DollarNames.webElement
#' 
queryRD <- function(ipAddr,
                  method = "GET",
                  httpheader = c('Content-Type' = 'application/json;charset=UTF-8'),
                  data = NULL){
  if(is.null(data)){
      res <- rawToChar(getURLContent(ipAddr,
                                   customrequest = method,
                                   httpheader = httpheader,
                                   binary = TRUE))
  }else{
      res <- rawToChar(getURLContent(ipAddr,
                                   customrequest = method,
                                   httpheader = httpheader,
                                   postfields = data,
                                   binary = TRUE))
  }
  res
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

