startServer <- function (dir = NULL, args = NULL, javaargs = NULL, log = TRUE,  ...) 
{
  .Deprecated(package = "RSelenium", msg = "startServer is deprecated.
              Users in future can find the function in file.path(find.package(\"RSelenium\"), \"example/serverUtils\").
              The sourcing/starting of a Selenium Server is a users responsiblity. 
              Options include manually starting a server see vignette(\"RSelenium-basics\", package = \"RSelenium\")
              and running a docker container see  vignette(\"RSelenium-docker\", package = \"RSelenium\")")
  selDIR <-  ifelse(is.null(dir), file.path(find.package("RSelenium"), 
                                            "bin"), dir)
  selFILE <- file.path(selDIR, "selenium-server-standalone.jar")
  if (!file.exists(selFILE)) {
    possFiles <- list.files(selDIR, "selenium-server-standalone")
    if(length(possFiles) == 0){
      stop("No Selenium Server binary exists. Run checkForServer or start server manually.")
    }
    # pick most recent driver
    selFILE <- possFiles[order(gsub(".*-(.*).jar$", "\\1", possFiles), decreasing = TRUE)][1]
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
    initArgs <- list(command = "java", args = selArgs, wait = FALSE, stdout = FALSE, stderr = FALSE)
  }
  else {
    initArgs <- list(command = "java",args = selArgs, wait = FALSE, invisible = TRUE)
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
      wmicOut <- readHTMLTable(htmlParse(wmicOut), header = TRUE, stringsAsFactors = FALSE)[[1]]
      wmicOut[["ProcessId"]] <- as.integer(wmicOut[["ProcessId"]])
      idx <- grepl(selFILE, wmicOut$CommandLine)
      if(!any(idx)) stop("Selenium binary error: Unable to start Selenium binary. Check if java is installed.")
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
    if(!any(idx)) stop("Selenium binary error: Unable to start Selenium binary. Check if java is installed.")
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
