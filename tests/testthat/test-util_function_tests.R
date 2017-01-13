context("util_function_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
selFILE <- ""
on.exit(remDr$close())

# test_that("canDownloadSeleniumServer", {
#   with_mock(
#     `utils::download.file` = function(url, destfile, ...){
#       tempFile <- file.path(tempdir(),"selenium-server-standalone.jar")
#       write("", file = tempFile)
#       list(sURL = url, sFile = destfile, tFile = tempFile)
#     },
#     {
#       expect_warning(out <- checkForServer(update = TRUE))
#       selFILE <<- out$tFile
#       expect_true(grepl("selenium-server-standalone", out$sFile))
#     }
#   )
# }
# )

# test_that("canStartSeleniumServer", {
#   if(.Platform$OS.type != "unix") return()
#   if(Sys.info()[["sysname"]] != "Linux") return()
#   with_mock(
#     `base::system2` = function(command, args, ...){
#       if(grepl("java", command)){
#         return(0L)
#       }
#     },
#     `base::system` = function(command, ...){
#       if(grepl('ps -Ao"%p"', command)){
#         return(100L)
#       }
#       if(grepl('ps -Ao"%a"', command)){
#         return(selFILE)
#       }
#     },
#     `tools::pskill` = function(pid, ...){
#       return(pid)
#     }
#     , {
#       expect_warning(out <- startServer(dir = dirname(selFILE)))
#       expect_identical(out$getPID(), 100L)
#       expect_identical(out$stop(), 100L)
#     }
#   )  
# }
# )

test_that("canGetFirefoxProfile", {
  if(Sys.info()[["sysname"]] != "Linux") return()
  out <- getFirefoxProfile(tempdir(), useBase = TRUE)
  expect_identical(names(out), "firefox_profile")
})

test_that("canGetChromeProfile", {
  cprof <- getChromeProfile("a", "b")
  expect_equal(length(cprof[["chromeOptions"]][["args"]]), 2L)
  expect_identical(cprof[["chromeOptions"]][["args"]][[1]], 
                   "--user-data-dir=a")
  expect_identical(cprof[["chromeOptions"]][["args"]][[2]], 
                   "--profile-directory=b")
}
)

test_that("canStartPhantom", {
  if(Sys.info()[["sysname"]] != "Linux") return()
  with_mock(
    `base::system2` = function(command, args, ...){
      if(grepl("myphantompath", command)){
        return(0L)
      }
    },
    `base::system` = function(command, ...){
      if(grepl('ps -Ao"%p"', command)){
        return(100L)
      }
      if(grepl('ps -Ao"%a"', command)){
        return("phantomjs")
      }
    },
    `tools::pskill` = function(pid, ...){
      return(pid)
    }, 
    {
      out <- phantom("myphantompath")
      expect_identical(out$getPID(), 100L)
      expect_identical(out$stop(), 100L)
    }
    
  )
})

test_that("canMakeFirefoxProfile", {
  if(Sys.info()[["sysname"]] != "Linux") return()
  fprof <- makeFirefoxProfile(list(browser.download.dir = "D:/temp"))
  expect_identical(names(fprof), "firefox_profile")
}
)


