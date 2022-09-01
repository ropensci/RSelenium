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
getFirefoxProfile <- function(profDir, useBase = TRUE) {
  if (!missing("useBase")) {
    warning("`useBase` argument deprecated. Now using base as default.")
    useBase <- TRUE
}
  tmpfile <- tempfile(fileext = ".zip")
  reqFiles <- list.files(profDir, recursive = TRUE)
  if (isTRUE(useBase)) {
    currWd <- getwd()
    setwd(profDir)
    on.exit(setwd(currWd))
    # break the zip into chunks as windows command line has limit of 8191
    # characters
    # ignore .sqllite files
    reqFiles <- reqFiles[
      grep("^.*\\.sqlite$", reqFiles, perl = TRUE, invert = TRUE)
    ]
    chunks <- sum(nchar(reqFiles)) %/% 8000 + 2
    chunks <- as.integer(seq(1, length(reqFiles), length.out = chunks))
    chunks <- mapply(`:`, head(chunks, -1),
      tail(chunks, -1) - c(rep(1, length(chunks) - 2), 0),
      SIMPLIFY = FALSE
    )
    out <- lapply(chunks, function(x) {
      zip(tmpfile, reqFiles[x])
    })
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
#' cprof <- getChromeProfile(
#'   "C:\\Users\\john\\AppData\\Local\\Google\\Chrome\\User Data",
#'   "Profile 1"
#' )
#' remDr <- remoteDriver(browserName = "chrome", extraCapabilities = cprof)
#' }
getChromeProfile <- function(dataDir, profileDir) {
  # see http://peter.sh/experiments/chromium-command-line-switches/
  cprof <- list(
    chromeOptions =
      list(
        args = list(
          paste0("--user-data-dir=", dataDir),
          paste0("--profile-directory=", profileDir)
        )
      )
  )
  cprof
}

matchSelKeys <- function(x) {
  if (any(names(x) == "key")) {
    x[names(x) == "key"] <- selKeys[match(x[names(x) == "key"], names(selKeys))]
  }
  unname(x)
}

#' @export
#' @importFrom utils .DollarNames
.DollarNames.remoteDriver <- function(x, pattern = "") {
  grep(pattern, getRefClass(class(x))$methods(), value = TRUE)
}

#' @export
.DollarNames.webElement <- function(x, pattern = "") {
  grep(pattern, getRefClass(class(x))$methods(), value = TRUE)
}

#' @export
.DollarNames.errorHandler <- function(x, pattern = "") {
  grep(pattern, getRefClass(class(x))$methods(), value = TRUE)
}

makePrefjs <- function(opts) {
  op <- options(useFancyQuotes = FALSE)
  on.exit(options(op))

  optsQuoted <- lapply(opts, function(x) {
    if (is.character(x)) {
      dQuote(x)
    } else if (is.double(x)) {
      sprintf("%f", x)
    } else if (is.integer(x)) {
      sprintf("%d", x)
    } else if (is.logical(x)) {
      if (x) {
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
makeFirefoxProfile <- function(opts) {
  # make profile
  profDir <- file.path(tempdir(), "firefoxprofile")
  dir.create(profDir, showWarnings = FALSE)
  prefs.js <- file.path(profDir, "prefs.js")
  writeLines(makePrefjs(opts), con = prefs.js)

  # zip
  tmpfile <- tempfile(fileext = ".zip")
  utils::zip(tmpfile, prefs.js, flags = "-r9Xjq")
  zz <- file(tmpfile, "rb")
  ar <- readBin(tmpfile, "raw", file.info(tmpfile)$size)

  # base64
  fireprof <- base64encode(ar)
  close(zz)

  # output
  list("firefox_profile" = fireprof)
}


testWebElement <- function(x, remDr) {
  if (inherits(remDr, "webElement")) {
    remDr <- remDr$export("remoteDriver")
  }
  replaceWE <- function(x, remDr) {
    if (identical(names(x), "ELEMENT")) {
      webElement$
        new(as.character(x))$
        import(remDr)
    } else {
      x
    }
  }
  if (is.null(x) || identical(length(x), 0L)) {
    return(x)
  }
  listTest <- sum(vapply(x, inherits, logical(1), "list")) > 0
  if (listTest) {
    lapply(x, testWebElement, remDr = remDr)
  } else {
    replaceWE(x, remDr = remDr)
  }
}

#' @export
print.rsClientServer <- function(x, ...) {
  cat("$client\n")
  if (length(x[["client"]]$sessionInfo) == 0L) {
    print("No sessionInfo. Client browser is mostly likely not opened.")
  } else {
    print(
      as.data.frame(x[["client"]]$sessionInfo)[c("browserName", "id")],
      ...
    )
  }
  cat("\n$server\n")
  print(x[["server"]][["process"]], ...)
}
