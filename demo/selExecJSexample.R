# see http://stackoverflow.com/questions/22121006/how-to-scrape-this-squawka-page/22127054#22127054
# RSelenium::startServer() # if needed
require(RSelenium)
remDr <- remoteDriver()
remDr$open()
remDr$setImplicitWaitTimeout(3000)
remDr$navigate("http://epl.squawka.com/stoke-city-vs-arsenal/01-03-2014/english-barclays-premier-league/matches")
squawkData <- remDr$executeScript("return XMLSerializer().serializeToString(squawkaDp.xml);", list())
require(selectr)
example <- querySelectorAll(xmlParse(squawkData[[1]]), "crosses time_slice")
example[[1]]
# <time_slice name="0 - 5" id="1">
#   <event player_id="531" mins="4" secs="39" minsec="279" team="44" type="Failed">
#   <start>73.1,87.1</start>
#   <end>97.9,49.1</end>
#   </event>
#   </time_slice> 

# > xmlValue(querySelectorAll(xmlParse(squawkData[[1]]), "players #531 name")[[1]])
# [1] "Charlie Adam"
# 
# > xmlValue(querySelectorAll(xmlParse(squawkData[[1]]), "game team#44 long_name")[[1]])
# [1] "Stoke City"