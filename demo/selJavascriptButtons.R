# see http://stackoverflow.com/questions/22107674/scraping-table-from-asp-net-webpage-with-javascript-buttons-using-r/22109906#22109906

require(RSelenium)
# RSelenium::startServer() # if needed
remDr <- remoteDriver()
remDr$open()
remDr$setImplicitWaitTimeout(3000)
remDr$navigate("http://www.spp.org/LIP.asp")
remDr$switchToFrame("content_frame")
dateElem <- remDr$findElement(using = "id", "txtLIPDate") # select the date
dateRequired <- "01/14/2014"
dateElem$clearElement()
dateElem$sendKeysToElement(list("01/14/2014", key = "enter")) # send a date to app
hourElem <- remDr$findElement(using = "css selector", '#ddlHour [value="5"]') # select the 5th hour
hourElem$clickElement() # select this hour
buttonElem <- remDr$findElement(using = "id", "cmdView")
buttonElem$clickElement() # click the view button

# Sys.sleep(5)
tableElem <- remDr$findElement(using = "id", "dgLIP")
readHTMLTable(htmlParse(tableElem$getElementAttribute("outerHTML")[[1]]))
# [1] "tableElem$getElementAttribute(\"outerHTML\")"
# $dgLIP
# V1           V2                   V3    V4                  V5                  V6
# 1  Publish Date   Price Date                PNode Price        Parent PNode Settlement Location
# 2  201401132252 201401132300                 AECI 19.14                AECI                AECI
# 3  201401132252 201401132300                 AMRN 18.87                AMRN                AMRN
# 4  201401132252 201401132300                 BLKW 20.28                BLKW                BLKW
# 5  201401132252 201401132300                 CLEC 18.99                CLEC                CLEC
# 6  201401132252 201401132300         CSWS_AECC_LA 19.77        CSWS_AECC_LA           AECC_CSWS
# 7  201401132252 201401132300  CSWS_GREEN_LIGHT_LA  18.5 CSWS_GREEN_LIGHT_LA        GSEC_GL_CSWS
# 8  201401132252 201401132300              CSWS_LA 19.01             CSWS_LA           AEPM_CSWS
# 9  201401132252 201401132300              CSWS_LA 19.01             CSWS_LA            AEP_LOSS
# 10 201401132252 201401132300         CSWS_OMPA_LA 18.66        CSWS_OMPA_LA           OMPA_CSWS
# 11 201401132252 201401132300      CSWS_TENASKA_LA 18.95     CSWS_TENASKA_LA        GATEWAY_LOAD
# 12 201401132252 201401132300      CSWS112_WGORLD1  18.7             CSWS_LA           AEPM_CSWS
# 13 201401132252 201401132300      CSWS112_WGORLD1  18.7             CSWS_LA            AEP_LOSS
# 14 201401132252 201401132300      CSWS116PEORILD1  18.9             CSWS_LA           AEPM_CSWS
# 15 201401132252 201401132300      CSWS116PEORILD1  18.9             CSWS_LA            AEP_LOSS
# 16 201401132252 201401132300    CSWS121EASTLDXFL1 18.92             CSWS_LA           AEPM_CSWS
# 17 201401132252 201401132300    CSWS121EASTLDXFL1 18.92             CSWS_LA            AEP_LOSS
# 18 201401132252 201401132300      CSWS121LYNN4LD1 18.91             CSWS_LA           AEPM_CSWS
# 19 201401132252 201401132300      CSWS121LYNN4LD1 18.91             CSWS_LA            AEP_LOSS
# 20 201401132252 201401132300   CSWS12TH_STLD69_12 18.92             CSWS_LA           AEPM_CSWS
# 21 201401132252 201401132300   CSWS12TH_STLD69_12 18.92             CSWS_LA            AEP_LOSS
# 22 201401132252 201401132300 CSWS12TH_STLD69_12_2 18.92             CSWS_LA           AEPM_CSWS
# 23 201401132252 201401132300 CSWS12TH_STLD69_12_2 18.92             CSWS_LA            AEP_LOSS
# 24 201401132252 201401132300      CSWS136_YALELD1  18.9             CSWS_LA           AEPM_CSWS
# 25 201401132252 201401132300      CSWS136_YALELD1  18.9             CSWS_LA            AEP_LOSS
# 26 201401132252 201401132300  CSWS141_PINELDXFMR1 19.09             CSWS_LA           AEPM_CSWS
# 27          < >         <NA>                 <NA>  <NA>                <NA>                <NA>
#
