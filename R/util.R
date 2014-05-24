#' Check for Server binary
#' 
#' \code{checkForServer}
#' A utility function to check if the Selenium Server stanalone binary is present.
#' @param dir A directory in which the binary is to be placed.
#' @param update A boolean indicating whether to update the binary if it is present.
#' @export
#' @import XML
#' @section Detail: The downloads for the Selenium project can be found at http://selenium-release.storage.googleapis.com/index.html. This convience function downloads the standalone server and places it in the RSelenium package directory bin folder by default.
#' @examples
#' \dontrun{
#' checkForServer()
#' }

checkForServer <- function (dir = NULL, update = FALSE) 
{
  selURL <- "http://selenium-release.storage.googleapis.com"
  selXML <- xmlParse(paste0(selURL), "/?delimiter=")
  selJAR <- xpathSApply(selXML, "//s:Key[contains(text(),'selenium-server-standalone')]", namespaces = c(s = "http://doc.s3.amazonaws.com/2006-03-01"), xmlValue)
# get the most up-to-date jar
  selJAR <- selJAR[order(as.numeric(gsub("(.*)/.*", "\\1",selJAR)), decreasing = TRUE)][1]
  selDIR <- ifelse(is.null(dir), paste0(find.package("RSelenium"), 
                                        "/bin/"), dir)
  selFILE <- paste0(selDIR, "selenium-server-standalone.jar")
  if (update || !file.exists(selFILE)) {
    dir.create(selDIR, showWarnings=FALSE)
    print("DOWNLOADING STANDALONE SELENIUM SERVER. THIS MAY TAKE SEVERAL MINUTES")
    download.file(paste0( selURL, "/", selJAR), selFILE, mode = "wb")
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
  logFILE <- paste0(selDIR, "sellog.txt")
  write("", logFILE)
  if (!file.exists(selFILE)) {
    stop("No Selenium Server binary exists. Run checkForServer or start server manually.")
  }
  else {
    if (.Platform$OS.type == "unix") {
      system(paste0("java -jar ", shQuote(selFILE), " -log ", shQuote(logFILE)), wait = FALSE, 
             ignore.stdout = TRUE, ignore.stderr = TRUE)
    }
    else {
      system(paste0("java -jar ", shQuote(selFILE), " -log ", shQuote(logFILE)), wait = FALSE, 
             invisible = FALSE)
    }
  }
}
#' Get Firefox profile.
#' 
#' \code{getFirefoxProfile}
#' A utility function to get a firefox profile. 
#' @param profDir The directory in which the firefox profile resides
#' @param useBase Logical indicating whether to attempt to use zip from utils package. Maybe easier for Windows users.
#' @export
#' @section Detail: A firefox profile directory is zipped and base64 encoded. It can then be passed
#' to the selenium server as a required capability with key firefox_profile 
#' @examples
#' \dontrun{
#' fprof <- getFirefoxProfile("~/.mozilla/firefox/9qlj1ofd.testprofile")
#' remDr <- remoteDriver(extraCapabilities = fprof)
#' remDr$open()
#' }

getFirefoxProfile <- function(profDir, useBase = FALSE){
  
  if(!useBase){
    require(Rcompression)
  }
  tmpfile <- tempfile(fileext = '.zip')
  reqFiles <- list.files(profDir, recursive = TRUE)
  if(!useBase){
    Rcompression::zip(tmpfile, paste(profDir, reqFiles, sep ="/"),  altNames = reqFiles)
  }else{
    currWd <- getwd()
    on.exit(setwd(currWd))
    setwd(profDir)
    # break the zip into chunks as windows command line has limit of 8191 characters
    # ignore .sqllite files
    reqFiles <- reqFiles[grep("^.*\\.sqlite$", reqFiles, perl = TRUE, invert = TRUE)]
    chunks <- sum(nchar(reqFiles))%/%8000 + 2
    chunks <- as.integer(seq(1, length(reqFiles), length.out= chunks))
    chunks <- mapply(`:`, head(chunks, -1)
           , tail(chunks, -1) - c(rep(1, length(chunks) - 2), 0)
           , SIMPLIFY = FALSE)
    out <- lapply(chunks, function(x){zip(tmpfile, reqFiles[x])})
  }
  zz <- file(tmpfile, "rb")
  ar <- readBin(tmpfile, "raw", file.info(tmpfile)$size)
  fireprof <- base64encode(ar)
  close(zz)
  list("firefox_profile" = fireprof)
}

#' Get Chrome profile.
#' 
#' \code{getChromeProfile}
#' A utility function to get a Chrome profile. 
#' @param dataDir Specifies the user data directory, which is where the browser will look for all of its state.
#' @param profileDir Selects directory of profile to associate with the first browser launched.
#' @export
#' @section Detail: A chrome profile directory is passed as an extraCapability.
#' The data dir has a number of default locations
#' \describe{
#' \item{Windows XP}{
#' Google Chrome: C:/Documents and Settings/\%USERNAME\%/Local Settings/Application Data/Google/Chrome/User Data
#' }
#' \item{Windows 8 or 7 or Vista}{
#' Google Chrome: C:/Users/\%USERNAME\%/AppData/Local/Google/Chrome/User Data
#' }
#' \item{Mac OS X}{
#' Google Chrome: ~/Library/Application Support/Google/Chrome
#' }
#' \item{Linux}{
#' Google Chrome: ~/.config/google-chrome
#' }
#' }
#' The profile directory is contained in the user directory and by default is named "Default" 
#' @examples
#' \dontrun{
#' # example from windows using a profile directory "Profile 1"
#' cprof <- getChromeProfile("C:\\Users\\john\\AppData\\Local\\Google\\Chrome\\User Data", "Profile 1")
#' remDr <- remoteDriver(browserName = "chrome", extraCapabilities = cprof)
#' }
getChromeProfile <- function(dataDir, profileDir){
  # see
  # http://peter.sh/experiments/chromium-command-line-switches/#user-data-dir
  # http://peter.sh/experiments/chromium-command-line-switches/#profile-directory
  cprof <- list(chromeOptions = list(args = list(paste0('--user-data-dir=',dataDir)
                                                 , paste0('--profile-directory=',profileDir))))
  cprof
}


#' @export .DollarNames.remoteDriver
#' @export .DollarNames.webElement
#' @export .DollarNames.errorHandler
#' @import methods
#' 

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

.DollarNames.errorHandler <- function(x, pattern){
  grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

