#' CLASS webElement
#'
#' Selenium Webdriver represents all the HTML elements as WebElements. This class provides a mechanism to represent them as objects & perform various actions on the related elements. 
#' Typically, the findElement method in \code{\link{remoteDriver}} returns an object of class webElement.
#'
#' webElement is a generator object. To define a new webElement class method `new` is called. 
#' When a webElement class is created an elementId should be given.
#' Each webElement inherits from a remoteDriver. webElement is not usually called by the end-user.   
#'
#'@section Slots:      
#'  \describe{
#'    \item{\code{elementId}:}{Object of class \code{"character"}, giving a character representation of the element id.}
#'  }
#'  
#'@section Methods:
#'  \describe{
#'      \item{\code{new(...)}:}{ Create a new \code{remoteDriver} object. ... is used to define the appropriate slots.}
#'      \item{\code{findChildElement(using ,value)}:}{ Search for an element on the page, starting from the identified element. The located element will be returned as a WebElement id. }
#'      \item{\code{findChildElements(using ,value)}:}{ Search for multiple element on the page, starting from the identified element. The located elements will be returned as a list of WebElement ids.}
#'      \item{\code{compareElements(otherElem)}:}{ Test if the current webElement and an other web element referred to by webElement id refer to the same DOM element.}
#'      \item{\code{clickElement()}:}{ Click the element.}
#'      \item{\code{submitElement()}:}{ Submit a FORM element. The submit command may also be applied to any element that is a descendant of a FORM element.}
#'      \item{\code{sendKeysToElement(sendKeys)}:}{ Send a sequence of key strokes to an element. 
#'      The key strokes are sent as a list. Plain text is enter as an unnamed element of the list. Keyboard entries are defined in `selKeys` and should be listed with name `key`. See the examples. }
#'      \item{\code{isElementSelected()}:}{ Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.}
#'      \item{\code{isElementEnabled()}:}{ Determine if an element is currently enabled. Obviously to enable an element just preform a click on it.}
#'      \item{\code{getElementLocation()}:}{ Determine an element's location on the page. The point (0, 0) refers to the upper-left corner of the page.}
#'      \item{\code{getElementLocationInView()}:}{ Determine an element's location on the screen once it has been scrolled into view.
#'
#'      Note: This is considered an internal command and should only be used to
#'      determine an element's location for correctly generating native events.}
#'      \item{\code{getElementTagName()}:}{ Query for an element's tag name.}
#'      \item{\code{clearElement()}:}{ Clear a TEXTAREA or text INPUT element's value.}
#'      \item{\code{getElementAttribute(attrName)}:}{ Get the value of an element's attribute. See examples.}
#'      \item{\code{isElementDisplayed()}:}{ Determine if an element is currently displayed.}
#'      \item{\code{getElementSize()}:}{ Determine an element's size in pixels. The size will be returned with width and height properties.}
#'      \item{\code{getElementText()}:}{ Get the innerText of the element.}
#'      \item{\code{getElementValueOfCssProperty(propName)}:}{ Query the value of an element's computed CSS property. The CSS property to
#'      query should be specified using the CSS property name, not the JavaScript
#'      property name (e.g. background-color instead of backgroundColor).}
#'      \item{\code{describeElement()}:}{ Describe the identified element.}
#'  }
#' @export webElement
webElement <- setRefClass("webElement",
  fields   = list(elementId        = "numeric"),
  contains = "remoteDriver",
  methods  = list(
      initialize = function(elementId = "",...){
          elementId <<- elementId
          #eval(parse(text=paste0('.self$',ls(webElement$def@refMethods))))
          callSuper(...)
      },

      findChildElement = function(using = "xpath",value){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/element')
          elemDetails <- queryRD(qpath,
                           "POST",qdata = toJSON(list(using = using,value = value)))
          elemDetails$value
      },

      findChildElements = function(using = "xpath",value){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/elements')
          elemDetails <- queryRD(qpath,
                           "POST",qdata = toJSON(list(using = using,value = value)))
          elemDetails$value
      },

      compareElements = function(otherElem){
          qpath <- paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/equals/',otherElem$elementId)
          elemDetails <- queryRD(qpath)
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
                           "POST",qdata = sendKeys)
      },

      isElementSelected = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/selected'))
      },

      isElementEnabled = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/enabled'))
      },

      getElementLocation = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/location'))
      },

      getElementLocationInView = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/location_in_view'))
      },

      getElementTagName = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/name'))
      },

      clearElement = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/clear'),
                                    "POST")
      },

      getElementAttribute = function(attrName){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/attribute/',attrName))
      },

      isElementDisplayed = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/displayed'))
      },

      getElementSize = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/size'))
      },

      getElementText = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/text'))
      },

      getElementValueOfCssProperty = function(propName){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId,'/css/',propName))
      },

      describeElement = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/',elementId))
      }


  )
)


