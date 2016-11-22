#' Check for Server binary
#' 
#' \code{checkForServer}
#' A utility function to check if the Selenium Server stanalone binary is 
#'    present.
#' @param dir A directory in which the binary is to be placed.
#' @param update A boolean indicating whether to update the binary if it 
#'    is present.
#' @param rename A boolean indicating whether to rename to 
#'    "selenium-server-standalone.jar".
#' @param beta A boolean indicating whether to include beta releases.
#' @export
#' @importFrom XML xmlParse xpathSApply xmlValue
#' @importFrom utils download.file
#' @section Detail: The downloads for the Selenium project can be found at 
#'    http://selenium-release.storage.googleapis.com/index.html. This 
#'    convience function downloads the standalone server and places it in 
#'    the RSelenium package directory bin folder by default.
#' @examples
#' \dontrun{
#' checkForServer()
#' }

checkForServer <- function (dir = NULL, update = FALSE, rename = TRUE
                            , beta = FALSE) 
{
  .Deprecated(package = "RSelenium", msg = "checkForServer is deprecated.
Users in future can find the function in 
file.path(find.package(\"RSelenium\"), \"example/serverUtils\").
The sourcing/starting of a Selenium Server is a users responsiblity. 
Options include manually starting a server see 
vignette(\"RSelenium-basics\", package = \"RSelenium\")
and running a docker container see 
vignette(\"RSelenium-docker\", package = \"RSelenium\")")
  selURL <- "http://selenium-release.storage.googleapis.com"
  selXML <- xmlParse(paste0(selURL), "/?delimiter=")
  selJAR <- 
    xpathSApply(selXML, 
                "//s:Key[contains(text(),'selenium-server-standalone')]", 
                namespaces = 
                  c(s = "http://doc.s3.amazonaws.com/2006-03-01"), 
                xmlValue
    )
  
  # get the most up-to-date jar
  selJAR <- if(!beta){
    grep("^.*-([0-9\\.]*)\\.jar$", selJAR, value = TRUE)
  }else{
    selJAR
  }
  
  selJARdownload <- selJAR[order(gsub(".*-(.*).jar$", "\\1", selJAR), 
                                 decreasing = TRUE)][1]
  selDIR <- ifelse(is.null(dir), file.path(find.package("RSelenium"), 
                                           "bin"), dir)
  selFILE <- if(rename){
    file.path(selDIR, "selenium-server-standalone.jar")
  }else{
    file.path(selDIR, gsub(".*(selenium-server-standalone.*)", 
                           "\\1", selJARdownload)
    )
  }
  
  if (update || !file.exists(selFILE)) {
    dir.create(selDIR, showWarnings=FALSE)
    message("DOWNLOADING STANDALONE SELENIUM SERVER. THIS MAY TAKE SEVERAL 
            MINUTES")
    download.file(paste0( selURL, "/", selJARdownload), selFILE
                  , mode = "wb")
  }
}

#' Start the standalone server.
#' 
#' \code{startServer}
#' A utility function to start the standalone server. Return two functions 
#'    see values.
#' @param dir A directory in which the binary is to be placed.
#' @param args Additional arguments to be passed to Selenium Server.
#' @param javaargs arguments passed to JVM as opposed to the Selenium 
#'    Server jar.
#' @param log Logical value indicating whether to write a log file to the 
#'    directory containing the Selenium Server binary.
#' @param ... arguments passed \code{\link{system2}}. Unix defaults 
#'    wait = FALSE, stdout = FALSE, stderr = FALSE. Windows defaults 
#'    wait = FALSE, invisible = TRUE. 
#' @export
#' @importFrom XML readHTMLTable htmlParse
#' @section Detail: By default the binary is assumed to be in the 
#'    RSelenium package /bin directory. The log argument is for convience. 
#'    Setting it to FALSE and stipulating 
#'    args = c("-log /user/etc/somePath/somefile.log") allows a custom 
#'    location. Using log = TRUE sets the location to a file named 
#'    sellog.txt in the directory containing the Selenium Server binary.
#' @return Returns a list containing two functions. The 'getpid' function 
#'    returns the process id of the started Selenium binary. The 'stop' 
#'    function stops the started Selenium server using the process id. 
#' @examples
#' \dontrun{
#' selServ <- startServer()
#' # example of commandline passing
#' selServ <- startServer(args = c("-port 4455"), 
#'                        log = FALSE, invisible = FALSE)
#' remDr <- remoteDriver(browserName = "chrome", port = 4455)
#' remDr$open()
#' # get the process id of the selenium binary
#' selServ$getpid()
#' # stop the selenium binary
#' selServ$stop()
#' }

startServer <- function (dir = NULL, args = NULL, javaargs = NULL, 
                         log = TRUE,  ...) 
{
  .Deprecated(package = "RSelenium", msg = "startServer is deprecated.
Users in future can find the function in 
file.path(find.package(\"RSelenium\"), \"example/serverUtils\").
The sourcing/starting of a Selenium Server is a users responsiblity. 
Options include manually starting a server see 
vignette(\"RSelenium-basics\", package = \"RSelenium\")
and running a docker container see  
vignette(\"RSelenium-docker\", package = \"RSelenium\")")
  selDIR <-  ifelse(is.null(dir), file.path(find.package("RSelenium"), 
                                            "bin"), dir)
  selFILE <- file.path(selDIR, "selenium-server-standalone.jar")
  if (!file.exists(selFILE)) {
    possFiles <- list.files(selDIR, "selenium-server-standalone")
    if(length(possFiles) == 0){
      stop("No Selenium Server binary exists. Run checkForServer or start 
           server manually.")
    }
    # pick most recent driver
    selFILE <- possFiles[order(gsub(".*-(.*).jar$", "\\1", possFiles), 
                               decreasing = TRUE)][1]
    selFILE <- file.path(selDIR, selFILE)
  }
  logFILE <- file.path(selDIR, "sellog.txt")
  selArgs <- c(paste("-jar", shQuote(selFILE)))
  if(log){
    write("", logFILE)
    selArgs <- c(selArgs, paste("-log", shQuote(logFILE)))
  }
  selArgs <- c(javaargs, selArgs, args)
  userArgs <- list(...)
  if (.Platform$OS.type == "unix") {
    initArgs <- list(command = "java", args = selArgs, wait = FALSE, 
                     stdout = FALSE, stderr = FALSE)
  }
  else {
    initArgs <- list(command = "java",args = selArgs, wait = FALSE, 
                     invisible = TRUE)
  }
  initArgs[names(userArgs)] <- userArgs 
  do.call(system2, initArgs)
  if (.Platform$OS.type == "windows"){
    wmicOut <- tryCatch({
      system2("wmic",
              args = c("path win32_process get Caption,Processid,Commandline"
                       , "/format:htable")
              , stdout=TRUE, stderr=NULL)
    }, error = function(e)e)
    selPID <- if(inherits(wmicOut, "error")){
      wmicArgs <- paste0(c("path win32_process where \"commandline like '%",
                           selFILE, "%'\" get Processid"))
      wmicOut <- system2("wmic", 
                         args = wmicArgs
                         , stdout = TRUE)
      as.integer(gsub("\r", "", wmicOut[2]))
    }else{
      wmicOut <- readHTMLTable(htmlParse(wmicOut), header = TRUE, 
                               stringsAsFactors = FALSE)[[1]]
      wmicOut[["ProcessId"]] <- as.integer(wmicOut[["ProcessId"]])
      idx <- grepl(selFILE, wmicOut$CommandLine)
      if(!any(idx)) stop("Selenium binary error: Unable to start Selenium 
                         binary. Check if java is installed.")
      wmicOut[idx,"ProcessId"]
    }
  }else{
    if(Sys.info()["sysname"] == "Darwin"){
      sPids <- system('ps -Ao"pid"', intern = TRUE)
      sArgs <- system('ps -Ao"args"', intern = TRUE)
    }else{
      sPids <- system('ps -Ao"%p"', intern = TRUE)
      sArgs <- system('ps -Ao"%a"', intern = TRUE)
    }
    idx <- grepl(selFILE, sArgs)
    if(!any(idx)) stop("Selenium binary error: Unable to start Selenium 
                       binary. Check if java is installed.")
    selPID <- as.integer(sPids[idx])
  }
  
  list(
    stop = function(){
      tools::pskill(selPID)
    },
    getPID = function(){
      return(selPID)
    }
  )
}

#' Get Firefox profile.
#' 
#' \code{getFirefoxProfile}
#' A utility function to get a firefox profile. 
#' @param profDir The directory in which the firefox profile resides
#' @param useBase Logical indicating whether to attempt to use zip from 
#'    utils package. Maybe easier for Windows users.
#' @export
#' @importFrom utils head tail zip
#' @section Detail: A firefox profile directory is zipped and base64 
#'    encoded. It can then be passed to the selenium server as a required 
#'    capability with key firefox_profile 
#' @examples
#' \dontrun{
#' fprof <- getFirefoxProfile("~/.mozilla/firefox/9qlj1ofd.testprofile")
#' remDr <- remoteDriver(extraCapabilities = fprof)
#' remDr$open()
#' }

getFirefoxProfile <- function(profDir, useBase = FALSE){
  
  tmpfile <- tempfile(fileext = '.zip')
  reqFiles <- list.files(profDir, recursive = TRUE)
  if(!useBase){
    Rcompression::zip(tmpfile, paste(profDir, reqFiles, sep ="/"),  
                      altNames = reqFiles)
  }else{
    currWd <- getwd()
    setwd(profDir)
    on.exit(setwd(currWd))
    # break the zip into chunks as windows command line has limit of 8191 
    # characters
    # ignore .sqllite files
    reqFiles <- reqFiles[grep("^.*\\.sqlite$", reqFiles, perl = TRUE, 
                              invert = TRUE)]
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
#' @param dataDir Specifies the user data directory, which is where the 
#'    browser will look for all of its state.
#' @param profileDir Selects directory of profile to associate with the 
#'    first browser launched.
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
#' The profile directory is contained in the user directory and by default 
#' is named "Default" 
#' @examples
#' \dontrun{
#' # example from windows using a profile directory "Profile 1"
#' cprof <- getChromeProfile("C:\\Users\\john\\AppData\\Local\\Google\\Chrome\\User Data", "Profile 1")
#' remDr <- remoteDriver(browserName = "chrome", extraCapabilities = cprof)
#' }
getChromeProfile <- function(dataDir, profileDir){
  # see
  # http://peter.sh/experiments/chromium-command-line-switches/
  cprof <- list(chromeOptions = 
                  list(args = list(paste0('--user-data-dir=',dataDir), 
                                   paste0('--profile-directory=',profileDir))
                  )
  )
  cprof
}

#' Start a phantomjs binary in webdriver mode.
#' 
#' \code{phantom}
#' A utility function to control a phantomjs binary in webdriver mode. 
#' @param pjs_cmd The name, full or partial path of a phantomjs 
#'    executable. This is optional only state if the executable is not in 
#'    your path.
#' @param port An integer giving the port on which phantomjs will listen. 
#'    Defaults to 4444. format [[<IP>:]<PORT>]
#' @param extras An optional character vector: see 'Details'.
#' @param ... Arguments to pass to \code{\link{system2}}
#' @export
#' @importFrom tools pskill
#' @importFrom utils read.csv
#' @section Detail: phantom() is used to start a phantomjs binary in 
#'    webdriver mode. This can be used to drive a phantomjs binary on a 
#'    machine without selenium server. Argument extras can be used to 
#'    specify optional extra command line arguments see 
#'    \url{http://phantomjs.org/api/command-line.html}
#' @section Value: phantom() returns a list with two functions:
#' \describe{
#' \item{getPID}{returns the process id of the phantomjs binary running in 
#'    webdriver mode.}
#' \item{stop}{terminates the phantomjs binary running in webdriver mode 
#'    using \code{\link{pskill}}}
#' }
#' @examples
#' \dontrun{
#' pJS <- phantom()
#' # note we are running here without a selenium server phantomjs is 
#' # listening on port 4444
#' # in webdriver mode
#' remDr <- remoteDriver(browserName = "phantomjs")
#' remDr$open()
#' remDr$navigate("http://www.google.com/ncr")
#' remDr$screenshot(display = TRUE)
#' webElem <- remDr$findElement("name", "q")
#' webElem$sendKeysToElement(list("HELLO WORLD"))
#' remDr$screenshot(display = TRUE)
#' remDr$close()
#' # note remDr$closeServer() is not called here. We stop the phantomjs 
#' # binary using
#' pJS$stop()
#' }

phantom <- function (pjs_cmd = "", port = 4444L, extras = "", ...){
  if (!nzchar(pjs_cmd)) {
    pjsPath <- Sys.which("phantomjs")
  }else{
    pjsPath <- pjs_cmd
  }
  if(nchar(pjsPath) == 0){stop("PhantomJS binary not located.")}
  pjsargs <- c(paste0("--webdriver=", port), extras)
  if (.Platform$OS.type == "windows"){
    system2(pjsPath, pjsargs, invisible = TRUE, wait = FALSE, ...)
    pjsPID <- read.csv(text = system("tasklist /v /fo csv", intern = TRUE))
    # support for MS-DOS-compatible (short) file name
    pjsPID <- pjsPID$PID[grepl("phantomjs.exe|PHANTO~1.EXE", 
                               pjsPID$Image.Name)]
  }else{
    system2(pjsPath, pjsargs, wait = FALSE, ...)
    if(Sys.info()["sysname"] == "Darwin"){
      pids <- system('ps -Ao"pid"', intern = TRUE)
      args <- system('ps -Ao"args"', intern = TRUE)
    }else{
      pids <- system('ps -Ao"%p"', intern = TRUE)
      args <- system('ps -Ao"%a"', intern = TRUE)
    }
    idx <- grepl("phantomjs", args)
    if(!any(idx)) warning("Couldn't find the phantomjs process")
    pjsPID <- pids[idx]
  }
  
  list(
    stop = function(){
      tools::pskill(pjsPID)
    },
    getPID = function(){
      return(pjsPID)
    }
  )
}


matchSelKeys <- function(x){
  if(any(names(x) =='key')){
    x[names(x) =='key']<-selKeys[match(x[names(x) == 'key'],names(selKeys))]
  }
  unname(x)      
}

#' @export
#' @importFrom utils .DollarNames
#' 
.DollarNames.remoteDriver <- function(x, pattern = ""){
  grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

#' @export
#' 
.DollarNames.webElement <- function(x, pattern = ""){
  grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

#' @export
#' 
.DollarNames.errorHandler <- function(x, pattern = ""){
  grep(pattern, getRefClass(class(x))$methods(), value=TRUE)
}

makePrefjs <- function(opts) {
  op <- options(useFancyQuotes = FALSE)
  on.exit(options(op))
  
  optsQuoted <- lapply(opts, function(x) {
    if(is.character(x)) {
      dQuote(x)
    } else if(is.double(x)) {
      sprintf("%f", x)
    } else if(is.integer(x)) {
      sprintf("%d", x)
    } else if(is.logical(x)) {
      if(x) {
        "true"
      } else {
        "false"
      }
    }
  })
  
  sprintf("user_pref(\"%s\", %s);", names(opts), optsQuoted)
}

#' Make Firefox profile.
#' 
#' \code{makeFirefoxProfile}
#' A utility function to make a firefox profile. 
#' @param opts option list of firefox
#' @export
#' @section Detail: A firefox profile directory is zipped and base64 
#'    encoded. It can then be passed
#'    to the selenium server as a required capability with key 
#'    firefox_profile
#' @note Windows doesn't come with command-line zip capability. 
#'    Installing rtools
#' \url{https://CRAN.R-project.org/bin/windows/Rtools/index.html} is a 
#'    straightforward way to gain this capability.
#' @importFrom caTools base64encode
#' @examples
#' \dontrun{
#' fprof <- makeFirefoxProfile(list(browser.download.dir = "D:/temp"))
#' remDr <- remoteDriver(extraCapabilities = fprof)
#' remDr$open()
#' }

makeFirefoxProfile <- function(opts){
  # make profile
  profDir <- file.path(tempdir(), "firefoxprofile")
  dir.create(profDir, showWarnings = FALSE)
  prefs.js <- file.path(profDir, "prefs.js")
  writeLines(makePrefjs(opts), con = prefs.js)
  
  # zip
  tmpfile <- tempfile(fileext = '.zip')
  utils::zip(tmpfile, prefs.js, flags = "-r9Xjq")
  zz <- file(tmpfile, "rb")
  ar <- readBin(tmpfile, "raw", file.info(tmpfile)$size)
  
  # base64
  fireprof <- base64encode(ar)
  close(zz)
  
  # output
  list("firefox_profile" = fireprof)
}


testWebElement <- function(x, remDr){
  replaceWE <- function(x, remDr){
    if(identical(names(x), "ELEMENT")){
      webElement$new(as.character(x))$import(remDr)
    }else{
        x
    }
  }
  if(is.null(x)||identical(length(x), 0L)) return(x)
  listTest <- sum(vapply(x, inherits, logical(1), "list")) > 0
  if(listTest){
    lapply(x, testWebElement, remDr = remDr)
  }else{
    replaceWE(x, remDr = remDr)
  }
}