#' Start a Selenium Server and WebDriver remote-controlling a web browser
#'
#' @param port Port number to run Selenium on. An integer scalar.
#' @param browser Which web browser to start. One of
#'   - `"chrome"`
#'   - `"firefox"`
#'   - `"phantomjs"` (deprecated)
#'   - `"internet explorer"`
#' @param version What version of Selenium Server to run. Defaults to `"latest"`
#'   which runs the most recent version. To see other versions currently
#'   sourced, run `binman::list_versions("seleniumserver")`.
#' @param chromever What version of [ChromeDriver](https://chromedriver.chromium.org/)
#'   to run. Defaults to `"latest"` which runs the most recent version. To see
#'   other versions currently sourced, run `binman::list_versions("chromedriver")`.
#'   A value of `NULL` excludes adding the Google Chrome browser to Selenium Server.
#' @param geckover What version of [geckodriver](https://firefox-source-docs.mozilla.org/testing/geckodriver/)
#'   to run. Defaults to `"latest"` which runs the most recent version. To see
#'   other versions currently sourced, run `binman::list_versions("geckodriver")`.
#'   A value of `NULL` excludes adding the Firefox browser to Selenium Server.
#' @param phantomver What version of [PhantomJS](https://phantomjs.org/) to run.
#'   Defaults to `"2.1.1"` which runs the most recent stable version. To see
#'   other versions currently sourced, run `binman::list_versions("phantomjs")`.
#'   A value of `NULL` excludes adding the PhantomJS headless browser to
#'   Selenium Server.
#' @param iedrver What version of [InternetExplorerDriver (`IEDriverServer.exe`)](https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver)
#'   to run. Defaults to `"latest"` which runs the most recent version. To see
#'   other version currently sourced, run `binman::list_versions("iedriverserver")`.
#'   A value of `NULL` excludes adding the Internet Explorer browser to
#'   Selenium Server. **Note** that this functionality is restricted to
#'   Windows only.
#' @param verbose If `TRUE`, include status messages (if any).
#' @param check If `TRUE`, check the versions of Selenium available and the
#'   versions of associated drivers (`chromever`, `geckover`, `phantomver`,
#'   `iedrver`). If new versions are available, they will be downloaded.
#' @param ... Additional arguments passed to \code{\link{remoteDriver}}.
#'
#' @return A list containing a server and a client. The server is the object
#' returned by \code{\link[wdman]{selenium}} and the client is an object of class
#' \code{\link{remoteDriver}}
#' @details This function is a wrapper around \code{\link[wdman]{selenium}}.
#'   It provides a "shim" for the current issue running Firefox on
#'   Windows. For a more detailed set of functions for running binaries
#'   relating to the Selenium/webdriver project, see the
#'   \code{\link[wdman]{wdman}} package. Both the client and server
#'   are closed using a registered finalizer.
#' @examples
#' \dontrun{
#' # start a chrome browser
#' rD <- rsDriver()
#' remDr <- rD[["client"]]
#' remDr$navigate("http://www.google.com/ncr")
#' remDr$navigate("http://www.bbc.com")
#' remDr$close()
#' # stop the selenium server
#' rD[["server"]]$stop()
#'
#' # if user forgets to stop server it will be garbage collected.
#' rD <- rsDriver()
#' rm(rD)
#' gc(rD)
#' }
#' @export
#' @importFrom wdman selenium
rsDriver <- function(port = 4567L,
                     browser = c("chrome", "firefox", "phantomjs", "internet explorer"),
                     version = "latest",
                     chromever = "latest",
                     geckover = "latest",
                     iedrver = NULL,
                     phantomver = "2.1.1",
                     verbose = TRUE,
                     check = TRUE, ...) {
  browser <- match.arg(browser)
  if (identical(browser, "internet explorer") &&
    !identical(.Platform[["OS.type"]], "windows")) {
    stop("Internet Explorer is only available on Windows.")
  }
  selServ <- wdman::selenium(
    port = port,
    verbose = verbose,
    version = version,
    chromever = chromever,
    geckover = geckover,
    iedrver = iedrver,
    phantomver = phantomver,
    check = check
  )
  remDr <- remoteDriver(browserName = browser, port = port, ...)

  # check server status
  count <- 0L
  while (
    inherits(res <- tryCatch(remDr$getStatus(), error = function(e) e), "error")
  ) {
    Sys.sleep(1)
    count <- count + 1L
    if (count > 5L) {
      warning("Could not determine server status.")
      break
    }
  }

  res <- tryCatch(remDr$open(silent = !verbose), error = function(e) e)
  if (inherits(res, "error")) {
    message("Could not open ", browser, " browser.")
    message("Client error message:\n", res$message)
    message("Check server log for further details.")
  }

  csEnv <- new.env()
  csEnv[["server"]] <- selServ
  csEnv[["client"]] <- remDr
  clean <- function(e) {
    chk <- suppressMessages(
      tryCatch(e[["client"]]$close(), error = function(e) e)
    )
    e[["server"]]$stop()
  }
  reg.finalizer(csEnv, clean)
  class(csEnv) <- c("rsClientServer", class(csEnv))

  return(csEnv)
}
