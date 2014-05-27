context("api-example")
# add build details for sauceLabs
if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
  pv <- packageVersion("RSelenium")
  slFlags <- list(name = "RSelenium-test-suite"
                  , build = sum(unlist(pv)*10^(3-seq_along(unlist(pv)))) # 1.2.1 for example 121
                  , tags =  list("api-example")
                  , "custom-data" = list(release = do.call(paste, list(pv, collapse = ".")))
  )
  rsel.opt$extraCapabilities <- c(rsel.opt$extraCapabilities, slFlags)
}

source(file.path(find.package("RSelenium"), "tests", 'setup.r'), local = TRUE)
on.exit(remDr$close())

#1
test_that("GetTitle", {
  remDr$navigate(loadPage("simpleTest"))
  title <- remDr$getTitle()
  expect_equal("Hello WebDriver", title[[1]])
}
)

#2
test_that("GetCurrentUrl", {
  remDr$navigate(loadPage("simpleTest"))
  url <- remDr$getCurrentUrl()
  expect_equal(loadPage("simpleTest"), url[[1]])
}
)

#3
test_that("FindElementsByXPath", {
  remDr$navigate(loadPage("simpleTest"))
  elem <- remDr$findElement(using = "xpath", "//h1")
  expect_equal("Heading", elem$getElementText()[[1]])
}
)

#4
test_that("FindElementByXpathThrowNoSuchElementException", {
  remDr$navigate(loadPage("simpleTest"))
  expect_error(remDr$findElement(using = "xpath", "//h4"))
  expect_equal(7, remDr$status)
  
}
)

#5-6
test_that("FindElementsByXpath", {
  remDr$navigate(loadPage("nestedElements"))
  elems <- remDr$findElements(using = "xpath", "//option")
  expect_equal(48, length(elems))
  expect_equal("One", elems[[1]]$getElementAttribute("value")[[1]])
}
)

#7
test_that("FindElementsByName", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "name", "windowOne")
  expect_equal("Open new window", elem$getElementText()[[1]])
}
)

#8
test_that("FindElementsByNameInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  subElem <- elem$findChildElement(using = "name", "selectomatic")
  expect_equal("2", subElem$getElementAttribute("id")[[1]])
}
)

#9
test_that("FindElementsByLinkTextInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "div1")
  subElem <- elem$findChildElement(using = "link text", "hello world")
  expect_equal("link1", subElem$getElementAttribute("name")[[1]])
}
)

#10
test_that("FindElementByIdInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  subElem <- elem$findChildElement(using = "id", "2")
  expect_equal("selectomatic", subElem$getElementAttribute("name")[[1]])
}
)

#11
test_that("FindElementByXpathInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  subElem <- elem$findChildElement(using = "xpath", "select")
  expect_equal("2", subElem$getElementAttribute("id")[[1]])
}
)

#12
test_that("FindElementByXpathInElementContextNotFound", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  expect_error(elem$findChildElement(using = "xpath", "div"))
  expect_equal(7, elem$status)
}
)

#13
test_that("ShouldBeAbleToEnterDataIntoFormFields", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "xpath", "//form[@name='someForm']/input[@id='username']")
  elem$clearElement()
  elem$sendKeysToElement(list("some text"))
  elem <- remDr$findElement(using = "xpath", "//form[@name='someForm']/input[@id='username']")
  expect_equal("some text", elem$getElementAttribute("value")[[1]])
}
)

#14-15
test_that("FindElementByTagName", {
  remDr$navigate(loadPage("simpleTest"))
  elems <- remDr$findElements(using = "tag name", "div")
  num_by_xpath = length(remDr$findElements(using = "xpath", "//div"))
  expect_equal(num_by_xpath, length(elems))
  elems <- remDr$findElements(using = "tag name", "iframe")
  expect_equal(0, length(elems))
}
)

#16
test_that("FindElementByTagNameWithinElement", {
  remDr$navigate(loadPage("simpleTest"))
  div <- remDr$findElement(using = "id", "multiline")
  elems = div$findChildElements(using = "tag name", "p")
  expect_true(length(elems) == 1)
}
)

#17-18
test_that("SwitchToWindow", {
  #if(rdBrowser == 'safari'){
    # see https://code.google.com/p/selenium/issues/detail?id=3693
    return()
  #} 
  title_1 = "XHTML Test Page"
  title_2 = "We Arrive Here"
  #         switch_to_window_timeout = 5
  #         wait = WebDriverWait(self.driver, switch_to_window_timeout, ignored_exceptions=[NoSuchWindowException])
  remDr$navigate(loadPage("xhtmlTest"))
  remDr$findElement(using = "link text", "Open new window")$clickElement()
  expect_equal(title_1, remDr$getTitle()[[1]])
  Sys.sleep(5)
  remDr$switchToWindow("result")
  #         wait.until(lambda dr: dr.switch_to_window("result") is None)
  expect_equal(title_2, remDr$getTitle()[[1]])
}
)

####
test_that("SwitchFrameByName", {
  remDr$navigate(loadPage("frameset"))
  remDr$switchToFrame("third")
  checkbox <- remDr$findElement(using = "id", "checky")
  checkbox$clickElement()
  checkbox$submitElement()
}
)

#19-20
test_that("IsEnabled", {
  remDr$navigate(loadPage("formPage"))
  elem <- remDr$findElement(using = "xpath", "//input[@id='working']")
  expect_true(elem$isElementEnabled()[[1]])
  elem <- remDr$findElement(using = "xpath", "//input[@id='notWorking']")
  expect_false(elem$isElementEnabled()[[1]])
}
)

#21-24
test_that("IsSelectedAndToggle", {
  if(rdBrowser == 'chrome' && as.integer(sub("(.*?)\\..*", "\\1", remDr$sessionInfo$version)) < 16){
    return("deselecting preselected values only works on chrome >= 16")
  }
  return()
  remDr$navigate(loadPage("formPage"))
  elem <- remDr$findElement(using = "id", "multi")
  option_elems = elem$findChildElements(using = "xpath", "option")
  expect_true(option_elems[[1]]$isElementSelected()[[1]])
  option_elems[[1]]$clickElement()
  expect_false(option_elems[[1]]$isElementSelected()[[1]])
  option_elems[[1]]$clickElement()
  expect_true(option_elems[[1]]$isElementSelected()[[1]])
  expect_true(option_elems[[3]]$isElementSelected()[[1]])
}
)

#25-27
test_that("Navigate", {
 # if(rdBrowser == 'safari'){
    # see http://code.google.com/p/selenium/issues/detail?id=3771&can=1&q=browser%3DSafari%20component%3DWebDriver%20status%3ANew%2CAccepted%2CWorkingAsIntended%2CWontFix%2CNotFeasible&colspec=ID%20Stars%20Type%20Status%20Priority%20Owner%20Summary%20Browser%20Component
    return()
 # } 
  
  remDr$navigate(loadPage("formPage"))
  remDr$findElement(using = "id", "imageButton")$submitElement()
  expect_equal("We Arrive Here", remDr$getTitle()[[1]])
  remDr$goBack()
  expect_equal("We Leave From Here", remDr$getTitle()[[1]])
  remDr$goForward()
  expect_equal("We Arrive Here", remDr$getTitle()[[1]])
}
)

#28
test_that("GetAttribute", {
  page = "xhtmlTest"
  remDr$navigate(loadPage(page))
  elem <- remDr$findElement(using = "id", "id1")
  attr <- elem$getElementAttribute("href")[[1]]
  expect_equal(paste0(loadPage(page), "#"), attr)
}
)

#29-33
test_that("GetImplicitAttribute", {
  remDr$navigate(loadPage("nestedElements"))
  elems <- remDr$findElements(using = "xpath", "//option")
  expect_true(length(elems) >= 3)
  for(x in seq(4)){
    expect_equal(x-1, as.integer(elems[[x]]$getElementAttribute("index")[[1]]))          
  }
}
)

#34
test_that("ExecuteSimpleScript", {
  remDr$navigate(loadPage("xhtmlTest"))
  title <- remDr$executeScript("return document.title;")[[1]]
  expect_equal("XHTML Test Page", title)
}
)

#35
test_that("ExecuteScriptAndReturnElement", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem = remDr$executeScript("return document.getElementById('id1');")
  expect_true("webElement" == class(elem[[1]]))
}
)

#36
test_that("ExecuteScriptWithArgs", {
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript("return arguments[0] == 'fish' ? 'fish' : 'not fish';", list("fish"))
  expect_equal("fish", result[[1]])
}
)

#37
test_that("ExecuteScriptWithMultipleArgs", {
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript(
    "return arguments[0] + arguments[1]", list(1, 2))
  expect_equal(3, result[[1]])
}
)

#38
test_that("ExecuteScriptWithElementArgs", {
  remDr$navigate(loadPage("javascriptPage"))
  button <- remDr$findElement(using = "id", "plainButton")
  result <- remDr$executeScript("arguments[0]['flibble'] = arguments[0].getAttribute('id'); return arguments[0]['flibble'];", list(button))
  expect_equal("plainButton", result[[1]])
}
)

#39
test_that("FindElementsByPartialLinkText", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "partial link text", "new window")
  expect_equal("Open new window", elem$getElementText()[[1]])
}
)

#40-41
test_that("IsElementDisplayed", {
  remDr$navigate(loadPage("javascriptPage"))
  visible <- remDr$findElement(using = "id", "displayed")$isElementDisplayed()
  not_visible <- remDr$findElement(using = "id", "hidden")$isElementDisplayed()
  expect_true(visible[[1]], "Should be visible")
  expect_false(not_visible[[1]], "Should not be visible")
}
)

#42-43
test_that("MoveWindowPosition", {
  if(rdBrowser == 'android' || rdBrowser == "safari"){
    print("Not applicable")
    return()
  }
  return()
  remDr$navigate(loadPage("blank"))
  loc <- remDr$getWindowPosition()
  # note can't test 0,0 since some OS's dont allow that location
  # because of system toolbars
  new_x = 50
  new_y = 50
  if(loc[['x']] == new_x){
    new_x <- new_x + 10
  }
  if(loc['y'] == new_y){
    new_y <- new_y + 10
  }
  remDr$setWindowPosition(new_x, new_y)
  loc = remDr$getWindowPosition()
  # change test to be within 10 pixels
  expect_less_than(abs(loc[['x']] - new_x), 10)
  expect_less_than(abs(loc[['y']] - new_y), 10)
}
)

#44-45
test_that("ChangeWindowSize", {
  if(rdBrowser == 'android'){
    print("Not applicable")
    return()
  }
  return()
  remDr$navigate(loadPage("blank"))
  size <- remDr$getWindowSize()
  newSize <- rep(600, 2)
  if( size[['width']] == 600){
    newSize[1] <- 500
  }
  if( size[['height']] == 600){
    newSize[2] <- 500
  }
  remDr$setWindowSize(newSize[1], newSize[2])
  size <- remDr$getWindowSize()
  # change test to be within 10 pixels
  expect_less_than(abs(size[['width']] - newSize[1]), 10)
  expect_less_than(abs(size[['height']] - newSize[2]), 10)
}
)
