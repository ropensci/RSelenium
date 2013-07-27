#' @export webElement
webElement <- setRefClass("webElement",
  fields   = list(elementId        = "character"),
  contains = "remoteDriver",
  methods  = list(
      initialize = function(elementId = "",...){
          elementId <<- elementId
          #eval(parse(text=paste0('.self$',ls(webElement$def@refMethods))))
          callSuper(...)
      },

      findChildElement = function(using = "xpath",value){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/element')
          elemDetails <- fromJSON(queryRD(qpath,
                           "POST",data = toJSON(list(using = using,value = value))))
          elemDetails$value
      },

      findChildElements = function(using = "xpath",value){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/elements')
          elemDetails <- fromJSON(queryRD(qpath,
                           "POST",data = toJSON(list(using = using,value = value))))
          elemDetails$value
      },

      compareElements = function(otherElem){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/equals/',otherElem)
          elemDetails <- fromJSON(queryRD(qpath))
          elemDetails
      },

      clickElement = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/click'),
                           "POST")
      },

      submitElement = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/submit'),
                           "POST")
      },

      sendKeysToElement = function(sendKeys){
          sendKeys<-toJSON(list(value = matchSelKeys(sendKeys)))
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/value'),
                           "POST",data = sendKeys)
      },

      isElementSelected = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/selected')))
      },

      isElementEnabled = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/enabled')))
      },

      getElementLocation = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/location')))
      },

      getElementLocationInView = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/location_in_view')))
      },

      getElementTagName = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/name')))
      },

      clearElement = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/clear'),
                                    "POST")
      },

      getElementAttribute = function(attrName){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/attribute/',attrName)))
      },

      isElementDisplayed = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/displayed')))
      },

      getElementSize = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/size')))
      },

      getElementText = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/text')))
      },

      getElementValueOfCssProperty = function(propName){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/css/',propName)))
      },

      describeElement = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId)))
      }


  )
)


