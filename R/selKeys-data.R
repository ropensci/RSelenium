#' @name selKeys
#' @title Selenium key mappings
#' @description This data set contains a list of selenium key mappings. 
#'    The key mappings are outlined at \cr
#'    http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value.
#'    selKeys is used when a sendKeys variable is needed. sendKeys is defined 
#'    as a list. If an entry is needed from selKeys it is denoted by key.
#' @docType data
#' @usage selKeys
#' @export selKeys
#' @format A named list. The names are the descriptions of the keys. The 
#'    values are the "UTF-8" character representations.
#' @source http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value
#' @author John Harrison, 2012-10-05

selKeys <- structure(
  list(null = "\uE000", cancel = "\uE001", help = "\uE002", 
       backspace = "\uE003", tab = "\uE004", clear = "\uE005", 
       return = "\uE006", enter = "\uE007", shift = "\uE008", 
       control = "\uE009", alt = "\uE00A", pause = "\uE00B",
       escape = "\uE00C", space = "\uE00D", page_up = "\uE00E", 
       page_down = "\uE00F", end = "\uE010", home = "\uE011", 
       left_arrow = "\uE012", up_arrow = "\uE013", right_arrow = "\uE014", 
       down_arrow = "\uE015", insert = "\uE016", delete = "\uE017", 
       semicolon = "\uE018", equals = "\uE019", numpad_0 = "\uE01A",
       numpad_1 = "\uE01B", numpad_2 = "\uE01C", numpad_3 = "\uE01D", 
       numpad_4 = "\uE01E", numpad_5 = "\uE01F", numpad_6 = "\uE020", 
       numpad_7 = "\uE021", numpad_8 = "\uE022", numpad_9 = "\uE023", 
       multiply = "\uE024", add = "\uE025", separator = "\uE026",
       subtract = "\uE027", decimal = "\uE028", divide = "\uE029", 
       f1 = "\uE031", f2 = "\uE032", f3 = "\uE033", f4 = "\uE034", 
       f5 = "\uE035", f6 = "\uE036", f7 = "\uE037", f8 = "\uE038", 
       f9 = "\uE039", f10 = "\uE03A", f11 = "\uE03B", f12 = "\uE03C", 
       command_meta = "\uE03D"), 
  .Names = c("null", "cancel", "help", "backspace", "tab", "clear", 
             "return", "enter", "shift",  "control", "alt", "pause", 
             "escape", "space", "page_up", "page_down", "end", "home", 
             "left_arrow", "up_arrow", "right_arrow", "down_arrow", 
             "insert", "delete", "semicolon", "equals", "numpad_0", 
             "numpad_1", "numpad_2", "numpad_3", "numpad_4", "numpad_5", 
             "numpad_6", "numpad_7", "numpad_8", "numpad_9", "multiply", 
             "add", "separator", "subtract", "decimal", "divide", "f1", 
             "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", 
             "f12", "command_meta")
)