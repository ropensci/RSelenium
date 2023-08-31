initFun <- function(silent = TRUE, ...) {
  browserName <- Sys.getenv("SELENIUM_BROWSER", "chrome")
  remDr <- remoteDriver(browserName = browserName, ...)

  remDr$open(silent)
  # set page load timeout to 20 secs
  remDr$setTimeout(milliseconds = 20000)
  # wait 5 secs for elements to load
  remDr$setTimeout(type = "implicit", milliseconds = 5000)

  htmlSrc <- Sys.getenv("TEST_SERVER", "http://localhost:3000")
  loadPage <- function(pgStr) {
    paste0(file.path(htmlSrc, paste0(pgStr, ".html")))
  }
  
  rdBrowser <- remDr$browserName

  list(remDr = remDr, rdBrowser = rdBrowser, loadPage = loadPage)
}
