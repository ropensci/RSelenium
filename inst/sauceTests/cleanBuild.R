# quick script to get non passing ids
require(RSelenium)
require(selectr)
remDr <- remoteDriver()
remDr$open()
remDr$navigate("https://saucelabs.com/u/rselenium0")
slSource <- htmlParse(remDr$getPageSource()[[1]])
slIds <- vapply(querySelectorAll(slSource, "#jobGrid .slick-row .r0 input")
                , xmlGetAttr, character(1), name = "data-id")
slBuild <- vapply(querySelectorAll(slSource, "#jobGrid .slick-row .r4")
                  , xmlValue, character(1))
slPass <- vapply(querySelectorAll(slSource, "#jobGrid .slick-row .r5")
                 , xmlValue, character(1))

removeIds <- slIds[slBuild == "132" & slPass != "Pass"]
user <- "rselenium0"
pass <- "49953c74-5c46-4ff9-b584-cf31a4c71809"

for(x in removeIds){
  ip <- paste0(user, ':', pass, "@saucelabs.com/rest/v1/", user, "/jobs/", x)
  qdata <- toJSON(list(build = 0))
  res <- getURLContent(ip, customrequest = "PUT", 
                       httpheader = "Content-Type:text/json", 
                       postfields = qdata, isHTTP = FALSE)
}
remDr$close()
