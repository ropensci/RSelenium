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

