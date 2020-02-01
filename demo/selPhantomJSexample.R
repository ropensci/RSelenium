# see http://stackoverflow.com/questions/22314380/collecting-table-data-from-a-asp-webpage-over-with-a-for-loop-using-rselenium/22330362#22330362
remDr <- remoteDriver$new(browserName = "phantomjs")
remDr$open()
remDr$setImplicitWaitTimeout(3000)
remDr$navigate("http://www.censusindia.gov.in/Census_Data_2001/Village_Directory/View_data/Village_Profile.aspx")

# STATES
stateElem <- remDr$findElement(using = "name", "ctl00$Body_Content$drpState")
states <- stateElem$getElementAttribute("outerHTML")[[1]]
stateCodes <- sapply(querySelectorAll(xmlParse(states), "option"), xmlGetAttr, "value")[-1]
states <- sapply(querySelectorAll(xmlParse(states), "option"), xmlValue)[-1]

changeFun <- function(value, elementName, targetName, vs = FALSE) {
  changeElem <- remDr$findElement(using = "name", elementName)
  script <- paste0("arguments[0].value = '", value, "'; arguments[0].onchange();")
  remDr$executeScript(script, list(changeElem))
  targetCodes <- c()
  while (length(targetCodes) == 0) {
    targetElem <- remDr$findElement(using = "name", targetName)
    target <- xmlParse(targetElem$getElementAttribute("outerHTML")[[1]])
    targetCodes <- sapply(querySelectorAll(target, "option"), xmlGetAttr, "value")[-1]
    target <- sapply(querySelectorAll(target, "option"), xmlValue)[-1]
    if (length(targetCodes) == 0) {
      Sys.sleep(0.5)
    } else {
      if (vs) {
        viewSTATE <- remDr$executeScript("return __VIEWSTATE.value;")[[1]]
        out <- list(target, targetCodes, viewSTATE)
      } else {
        out <- list(target, targetCodes)
      }
    }
  }
  return(out)
}

state <- list()
x <- 1
# for(x in seq_along(stateCodes)){
Sys.time()
district <- changeFun(stateCodes[[x]], "ctl00$Body_Content$drpState", "ctl00$Body_Content$drpDistrict")
subdistrict <- lapply(district[[2]], function(y) {
  subdistrict <- changeFun(y, "ctl00$Body_Content$drpDistrict", "ctl00$Body_Content$drpSubDistrict")
  village <- lapply(subdistrict[[2]], function(z) {
    village <- changeFun(z, "ctl00$Body_Content$drpSubDistrict", "ctl00$Body_Content$drpVillage", vs = TRUE)
    village
  })
  list(subdistrict, village)
})
state[[x]] <- list(district, subdistrict)
Sys.time()

# }
