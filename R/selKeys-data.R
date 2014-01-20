#' @name selKeys
#' @title Selenium key mappings
#' @description This data set contains a list of selenium key mappings. The key mappings are outlined
#' http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value.
#' @docType data
#' @usage selKeys is used when a `sendKeys` variable is needed. `sendKeys` is defined as a list. If an entry is needed from selKeys it is denoted by `key`.
#' @format A named list. The names are the descriptions of the keys. The values are the "UTF-8" character representations.
#' @source http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value
#' @author John Harrison, 2012-10-05
NULL