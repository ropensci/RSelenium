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
    Class = "webElement",
    fields = list(elementId = "character"),
    contains = "remoteDriver",
    methods = list(
      initialize = function(elementId = "", ...) {
        elementId <<- elementId
        callSuper(...)
      },

      show = function() {
        print("remoteDriver fields")
        callSuper()
        print("webElement fields")
        print(list(elementId = elementId))
      },

      findChildElement = function(
                                  using = c(
                                    "xpath", "css selector", "id", "name", "tag name", "class name",
                                    "link text", "partial link text"
                                  ),
                                  value) {
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
        qpath <- sprintf(
          "%s/session/%s/element/%s/element",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST", qdata = list(using = using, value = value))
        elemDetails <- .self$value[[1]]
        webElement$
          new(as.character(elemDetails))$
          import(.self$export("remoteDriver"))
      },

      findChildElements = function(
                                   using = c(
                                     "xpath", "css selector", "id", "name", "tag name", "class name",
                                     "link text", "partial link text"
                                   ),
                                   value) {
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
        qpath <- sprintf(
          "%s/session/%s/element/%s/elements",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST", qdata = list(using = using, value = value))
        elemDetails <- .self$value
        lapply(
          elemDetails,
          function(x) {
            webElement$
              new(as.character(x))$
              import(.self$export("remoteDriver"))
          }
        )
      },

      compareElements = function(otherElem) {
        "Test if the current webElement and an other web element refer to
        the same DOM element."
        qpath <- sprintf(
          "%s/session/%s/element/%s/equals/%s",
          serverURL, sessionInfo[["id"]],
          elementId, otherElem[["elementId"]]
        )
        queryRD(qpath)
        .self$value
      },

      clickElement = function() {
        "Click the element."
        qpath <- sprintf(
          "%s/session/%s/element/%s/click",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST")
      },

      submitElement = function() {
        "Submit a FORM element. The submit command may also be applied to
        any element that is a descendant of a FORM element."
        qpath <- sprintf(
          "%s/session/%s/element/%s/submit",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST")
      },

      sendKeysToElement = function(sendKeys) {
        "Send a sequence of key strokes to an element. The key strokes are
        sent as a list. Plain text is enter as an unnamed element of the
        list. Keyboard entries are defined in `selKeys` and should be
        listed with name `key`. See the examples."
        sendKeys <- list(value = matchSelKeys(sendKeys))
        qpath <- sprintf(
          "%s/session/%s/element/%s/value",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST", qdata = sendKeys)
      },

      isElementSelected = function() {
        "Determine if an OPTION element, or an INPUT element of type
        checkbox or radiobutton is currently selected."
        qpath <- sprintf(
          "%s/session/%s/element/%s/selected",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      isElementEnabled = function() {
        "Determine if an element is currently enabled. Obviously to enable
        an element just preform a click on it."
        qpath <- sprintf(
          "%s/session/%s/element/%s/enabled",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementLocation = function() {
        "Determine an element's location on the page. The point (0, 0)
        refers to the upper-left corner of the page."
        qpath <- sprintf(
          "%s/session/%s/element/%s/location",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementLocationInView = function() {
        "Determine an element's location on the screen once it has been
        scrolled into view.
        Note: This is considered an internal command and should only be
        used to determine an element's location for correctly generating
        native events."
        qpath <- sprintf(
          "%s/session/%s/element/%s/location_in_view",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementTagName = function() {
        "Query for an element's tag name."
        qpath <- sprintf(
          "%s/session/%s/element/%s/name",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      clearElement = function() {
        "Clear a TEXTAREA or text INPUT element's value."
        qpath <- sprintf(
          "%s/session/%s/element/%s/clear",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath, "POST")
      },

      getElementAttribute = function(attrName) {
        "Get the value of an element's attribute. See examples."
        qpath <- sprintf(
          "%s/session/%s/element/%s/attribute/%s",
          serverURL, sessionInfo[["id"]], elementId, attrName
        )
        queryRD(qpath)
        .self$value
      },

      isElementDisplayed = function() {
        "Determine if an element is currently displayed."
        qpath <- sprintf(
          "%s/session/%s/element/%s/displayed",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementSize = function() {
        "Determine an element's size in pixels. The size will be returned
        with width and height properties."
        qpath <- sprintf(
          "%s/session/%s/element/%s/size",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementText = function() {
        "Get the innerText of the element."
        qpath <- sprintf(
          "%s/session/%s/element/%s/text",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      getElementValueOfCssProperty = function(propName) {
        "Query the value of an element's computed CSS property. The CSS
        property to query should be specified using the CSS property name,
        not the JavaScript property name (e.g. background-color instead of
        backgroundColor)."
        qpath <- sprintf(
          "%s/session/%s/element/%s/css/%s",
          serverURL, sessionInfo[["id"]], elementId, propName
        )
        queryRD(qpath)
        .self$value
      },

      describeElement = function() {
        "Describe the identified element."
        qpath <- sprintf(
          "%s/session/%s/element/%s",
          serverURL, sessionInfo[["id"]], elementId
        )
        queryRD(qpath)
        .self$value
      },

      setElementAttribute = function(attributeName, value) {
        "Utility function to set an elements attributes."
        if (.self$javascript) {
          jS <- "arguments[0].setAttribute(arguments[1], arguments[2]);"
          invisible(executeScript(jS, list(.self, attributeName, value)))
        } else {
          "Javascript is not enabled"
        }
      },

      highlightElement = function(wait = 75 / 1000) {
        "Utility function to highlight current Element. Wait denotes the
        time in seconds between style changes on element."
        if (.self$javascript) {
          style1 <- "color: yellow; border: 5px solid yellow;
          background-color: black;"
          style2 <- "color: black; border: 5px solid black;
          background-color: yellow;"
          originalStyle <- getElementAttribute("style")[[1]]
          for (x in rep(c(style1, style2), 2)) {
            setElementAttribute("style", x)
            Sys.sleep(wait)
          }
          setElementAttribute("style", originalStyle)
        } else {
          "Javascript is not enabled"
        }
      },

      selectTag = function() {
        "Utility function to return options from a select DOM node. The
        option nodes are returned as webElements. The option text and the
        value of the option attribute 'value' and whether the option is
        selected are returned also. If this
        method is called on a webElement that is not a select DOM node an
        error will result."
        if (!identical(getElementTagName()[[1]], "select")) {
          stop(
            "webElement does not appear to point to a select element in DOM."
          )
        }
        script <-
          "function getSelect(select) {
            var resEl = [];
            var resVal = []; var resTxt = []; var resSel = [];
            var options = select && select.options;
            for (var i=0, iLen=options.length; i<iLen; i++) {
             resEl.push(options[i]);
             resVal.push(options[i].getAttribute('value'));
             resTxt.push(options[i].text);
             resSel.push(options[i].selected);
            }
            return {elements:resEl, text:resTxt, value:resVal,
                    selected:resSel};
           }; var sEl = arguments[0]; return getSelect(sEl);"
        res <- executeScript(script, list(.self))
        res[c("text", "value", "selected")] <-
          lapply(res[c("text", "value", "selected")], unlist)
        res
      }
    )
  )
