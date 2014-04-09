# Stackoverflow
# http://stackoverflow.com/questions/22899951/scraping-issue-need-advice/22900084#22900084
# simple example of returning a javascript object
require(RSelenium)
RSelenium::startServer()
appURL <- "http://www.newlook.com/shop/womens/jackets-and-coats/navy-aztec-faux-shearling-collar-parka_286764649?tmcampid=UK_AFF_AffiliateWindow"
remDr <- remoteDriver()
remDr$open()
remDr$navigate(appURL)
inventory <- remDr$executeScript("return list;")
do.call(rbind.data.frame, inventory)
# > do.call(rbind.data.frame, inventory)
# color listPrice popupImage   skuID
# 2                0            2867684
# 21               0            2867685
# swatchImage largeImage salePrice
# 2                                 0
# 21                                0
# detailImage stockLevel size
# 2                      75   12
# 21                    133   14

remDr$close()
remDr$closeServer()