checkForServer <- function (dir = NULL, update = FALSE, rename = TRUE, 
                            beta = FALSE) 
{
  selURL <- "http://selenium-release.storage.googleapis.com"
  selXML <- xmlParse(paste0(selURL), "/?delimiter=")
  selJAR <- 
    xpathSApply(selXML,
                "//s:Key[contains(text(),'selenium-server-standalone')]", 
                namespaces = c(s = "http://doc.s3.amazonaws.com/2006-03-01"), 
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
    file.path(selDIR, gsub(".*(selenium-server-standalone.*)", "\\1", 
                           selJARdownload))
  }
  
  if (update || !file.exists(selFILE)) {
    dir.create(selDIR, showWarnings=FALSE)
    message("DOWNLOADING STANDALONE SELENIUM SERVER. THIS MAY TAKE 
            SEVERAL MINUTES")
    download.file(paste0( selURL, "/", selJARdownload), selFILE, 
                  mode = "wb")
  }
}
