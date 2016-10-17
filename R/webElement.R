#' CLASS webElement
#'
#' Selenium Webdriver represents all the HTML elements as WebElements. 
#'    This class provides a mechanism to represent them as objects & 
#'    perform various actions on the related elements. Typically, the 
#'    findElement method in \code{\link{remoteDriver}} returns an object 
#'    of class webElement.
#'
#' webElement is a generator object. To define a new webElement class 
#'    method `new` is called.  When a webElement class is created an 
#'    elementId should be given. Each webElement inherits from a 
#'    remoteDriver. webElement is not usually called by the end-user.   
#'
#' @field elementId Object of class \code{"character"}, giving a character 
#'    representation of the element id.
#' @include remoteDriver.R
#' @export webElement
#' @exportClass webElement
#' @aliases webElement
webElement <- 
  setRefClass(
    "webElement",
    fields   = 
      list(
        elementId        = "character"
      ),
    contains = "remoteDriver",
    methods  = list(
      initialize = function(elementId = "",...){
        elementId <<- elementId
        callSuper(...)
      },
      
      show = function(){
        print("remoteDriver fields")
        callSuper()
        print("webElement fields")
        print(list(elementId = elementId))
      },
      
      findChildElement = function(using = c("xpath", "css selector", "id", 
                                            "name", "tag name", 
                                            "class name", "link text", 
                                            "partial link text"),
                                  value){
        "Search for an element on the page, starting from the node defined 
        by the parent webElement. The located element will be returned as 
        an object of webElement class.
        The inputs are:
        \\describe{
          \\item{\\code{using}:}{Locator scheme to use to search the 
            element, available schemes: {\"class name\", \"css selector\", 
            \"id\", \"name\", \"link text\", \"partial link text\", 
            \"tag name\", \"xpath\" }. Defaults to 'xpath'. Partial string 
            matching is accepted.}
          \\item{\\code{value}:}{The search target. See examples.}
        }"
        using <- match.arg(using)
        qpath <- paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                        elementId,'/element')
        queryRD(qpath, "POST", 
                qdata = toJSON(list(using = using,value = value)), 
                json = TRUE)
        elemDetails <- .self$value[[1]]
        webElement$new(as.character(elemDetails))$
          import(.self$export("remoteDriver"))
      },
      
      findChildElements = function(using = c("xpath", "css selector", 
                                             "id", "name", "tag name", 
                                             "class name", "link text", 
                                             "partial link text"),
                                   value){
        "Search for multiple elements on the page, starting from the node 
        defined by the parent webElement. The located elements will be 
        returned as an list of objects of class WebElement. 
        The inputs are:
        \\describe{
          \\item{\\code{using}:}{Locator scheme to use to search the 
            element, available schemes: {\"class name\", \"css selector\", 
            \"id\", \"name\", \"link text\", \"partial link text\", 
            \"tag name\", \"xpath\" }. Defaults to 'xpath'. 
            Partial string matching is accepted.}
          \\item{\\code{value}:}{The search target. See examples.}
        }"
        using <- match.arg(using)
        qpath <- paste0(serverURL,'/session/',sessionInfo$id,
                        '/element/',elementId,'/elements')
        queryRD(qpath, "POST", 
                qdata = toJSON(list(using = using,value = value)), 
                json = TRUE)
        elemDetails <- .self$value
        lapply(elemDetails, 
               function(x){
                 webElement$new(as.character(x))$
                   import(.self$export("remoteDriver"))
               }
        )
      },
      
      compareElements = function(otherElem){
        "Test if the current webElement and an other web element refer to 
        the same DOM element."
        qpath <- paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                        elementId,'/equals/',otherElem$elementId)
        queryRD(qpath)
        .self$value
      },
      
      clickElement = function(){
        "Click the element."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/click'), "POST")
      },
      
      submitElement = function(){
        "Submit a FORM element. The submit command may also be applied to 
        any element that is a descendant of a FORM element."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/submit'), "POST")
      },
      
      sendKeysToElement = function(sendKeys){
        "Send a sequence of key strokes to an element. The key strokes are 
        sent as a list. Plain text is enter as an unnamed element of the 
        list. Keyboard entries are defined in `selKeys` and should be 
        listed with name `key`. See the examples."
        sendKeys<-toJSON(list(value = matchSelKeys(sendKeys)))
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,
                       '/element/',elementId,'/value'),
                "POST",qdata = sendKeys)
      },
      
      isElementSelected = function(){
        "Determine if an OPTION element, or an INPUT element of type 
        checkbox or radiobutton is currently selected."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/selected'))
        .self$value
      },
      
      isElementEnabled = function(){
        "Determine if an element is currently enabled. Obviously to enable 
        an element just preform a click on it."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/enabled'))
        .self$value
      },
      
      getElementLocation = function(){
        "Determine an element's location on the page. The point (0, 0) 
        refers to the upper-left corner of the page."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/location'))
        .self$value
      },
      
      getElementLocationInView = function(){
        "Determine an element's location on the screen once it has been 
        scrolled into view.
        Note: This is considered an internal command and should only be 
        used to determine an element's location for correctly generating 
        native events."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/location_in_view'))
        .self$value
      },
      
      getElementTagName = function(){
        "Query for an element's tag name."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/name'))
        .self$value
      },
      
      clearElement = function(){
        "Clear a TEXTAREA or text INPUT element's value."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/clear'),
                "POST")
      },
      
      getElementAttribute = function(attrName){
        "Get the value of an element's attribute. See examples."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/attribute/',attrName))
        .self$value
      },
      
      isElementDisplayed = function(){
        "Determine if an element is currently displayed."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/displayed'))
        .self$value
      },
      
      getElementSize = function(){
        "Determine an element's size in pixels. The size will be returned 
        with width and height properties."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/size'))
        .self$value
      },
      
      getElementText = function(){
        "Get the innerText of the element."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/text'))
        .self$value
      },
      
      getElementValueOfCssProperty = function(propName){
        "Query the value of an element's computed CSS property. The CSS 
        property to query should be specified using the CSS property name, 
        not the JavaScript property name (e.g. background-color instead of 
        backgroundColor)."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId,'/css/',propName))
        .self$value
      },
      
      describeElement = function(){
        "Describe the identified element."
        queryRD(paste0(serverURL,'/session/',sessionInfo$id,'/element/',
                       elementId))
        .self$value
      },
      
      setElementAttribute = function(attributeName, value){
        "Utility function to set an elements atrributes."
        if(.self$javascript){
          jS <- "arguments[0].setAttribute(arguments[1], arguments[2]);"
          executeScript(jS, list(.self, attributeName, value))
        }else{
          "Javascript is not enabled"
        }
      },
      
      highlightElement = function(wait = 75/1000){
        "Utility function to highlight current Element. Wait denotes the 
        time in seconds between style changes on element."
        if(.self$javascript){
          style1 <- "color: yellow; border: 5px solid yellow; 
          background-color: black;"
          style2 <- "color: black; border: 5px solid black; 
          background-color: yellow;"
          originalStyle <- getElementAttribute("style")[[1]]
          for(x in rep(c(style1, style2), 2)){
            setElementAttribute("style", x)
            Sys.sleep(wait)
          }
          setElementAttribute("style", originalStyle)
        }else{
          "Javascript is not enabled"
        }
        
      }
      
    )
  )


