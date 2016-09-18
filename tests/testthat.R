library(testthat)
library(RSelenium)

if(Sys.getenv("NOT_CRAN") == "true"){
  test_check("RSelenium")
}