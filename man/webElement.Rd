\name{webElement}
\alias{webElement}
\title{CLASS webElement}
\usage{
  webElement(...)
}
\description{
  Selenium Webdriver represents all the HTML elements as
  WebElements. This class provides a mechanism to represent
  them as objects & perform various actions on the related
  elements. Typically, the findElement method in
  \code{\link{remoteDriver}} returns an object of class
  webElement.
}
\details{
  webElement is a generator object. To define a new
  webElement class method `new` is called. When a
  webElement class is created an elementId should be given.
  Each webElement inherits from a remoteDriver. webElement
  is not usually called by the end-user.
}
\section{Slots}{
  \describe{ \item{\code{elementId}:}{Object of class
  \code{"character"}, giving a character representation of
  the element id.} }
}

\section{Methods}{
  \describe{ \item{\code{new(...)}:}{ Create a new
  \code{remoteDriver} object. ... is used to define the
  appropriate slots.} \item{\code{findChildElement(using
  ,value)}:}{ Search for an element on the page, starting
  from the identified element. The located element will be
  returned as a WebElement id. }
  \item{\code{findChildElements(using ,value)}:}{ Search
  for multiple element on the page, starting from the
  identified element. The located elements will be returned
  as a list of WebElement ids.}
  \item{\code{compareElements(otherElem)}:}{ Test if the
  current webElement and an other web element referred to
  by webElement id refer to the same DOM element.}
  \item{\code{clickElement()}:}{ Click the element.}
  \item{\code{submitElement()}:}{ Submit a FORM element.
  The submit command may also be applied to any element
  that is a descendant of a FORM element.}
  \item{\code{sendKeysToElement(sendKeys)}:}{ Send a
  sequence of key strokes to an element.  The key strokes
  are sent as a list. Plain text is enter as an unnamed
  element of the list. Keyboard entries are defined in
  `selKeys` and should be listed with name `key`. See the
  examples. } \item{\code{isElementSelected()}:}{ Determine
  if an OPTION element, or an INPUT element of type
  checkbox or radiobutton is currently selected.}
  \item{\code{isElementEnabled()}:}{ Determine if an
  element is currently enabled. Obviously to enable an
  element just preform a click on it.}
  \item{\code{getElementLocation()}:}{ Determine an
  element's location on the page. The point (0, 0) refers
  to the upper-left corner of the page.}
  \item{\code{getElementLocationInView()}:}{ Determine an
  element's location on the screen once it has been
  scrolled into view.

  Note: This is considered an internal command and should
  only be used to determine an element's location for
  correctly generating native events.}
  \item{\code{getElementTagName()}:}{ Query for an
  element's tag name.} \item{\code{clearElement()}:}{ Clear
  a TEXTAREA or text INPUT element's value.}
  \item{\code{getElementAttribute(attrName)}:}{ Get the
  value of an element's attribute. See examples.}
  \item{\code{isElementDisplayed()}:}{ Determine if an
  element is currently displayed.}
  \item{\code{getElementSize()}:}{ Determine an element's
  size in pixels. The size will be returned with width and
  height properties.} \item{\code{getElementText()}:}{ Get
  the innerText of the element.}
  \item{\code{getElementValueOfCssProperty(propName)}:}{
  Query the value of an element's computed CSS property.
  The CSS property to query should be specified using the
  CSS property name, not the JavaScript property name (e.g.
  background-color instead of backgroundColor).}
  \item{\code{describeElement()}:}{ Describe the identified
  element.} }
}

