context("api_example_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
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
  getCurrentUrl <- remDr$getCurrentUrl()
  expect_equal(loadPage("simpleTest"), getCurrentUrl[[1]])
}
)

#3
test_that("FindElementsByXPath", {
  remDr$navigate(loadPage("simpleTest"))
  findElementText <- remDr$findElement(using = "xpath", "//h1")$getElementText()
  
  expect_equal("Heading", findElementText[[1]])
}
)

#4-5
test_that("FindElementByXpathThrowNoSuchElementException", {
  expect_error({
    remDr$navigate(loadPage("simpleTest"))
    findElementText <- remDr$findElement(using = "xpath", "//h4")$getElementText()
  }
  )
  expect_equal(7, remDr$status)
}
)

#6-7
test_that("FindElementsByXpath", {
  remDr$navigate(loadPage("nestedElements"))
  elems <- remDr$findElements(using = "xpath", "//option")
  expect_equal(48, length(elems))
  expect_equal("One", elems[[1]]$getElementAttribute("value")[[1]])
}
)

#8
test_that("FindElementsByName", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "name", "windowOne")
  expect_equal("Open new window", elem$getElementText()[[1]])
}
)

#9
test_that("FindElementsByNameInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  childElem <- elem$findChildElement(using = "name", "selectomatic")
  expect_equal("2", childElem$getElementAttribute("id")[[1]])
}
)

#10
test_that("FindElementsByLinkTextInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "div1")
  childElem <- elem$findChildElement(using = "link text", "hello world")
  expect_equal("link1", childElem$getElementAttribute("name")[[1]])
}
)

#11
test_that("FindElementByIdInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  childElem <- elem$findChildElement(using = "id", "2")
  expect_equal("selectomatic", childElem$getElementAttribute("name")[[1]])
}
)

#12
test_that("FindElementByXpathInElementContext", {
  remDr$navigate(loadPage("nestedElements"))
  elem <- remDr$findElement(using = "name", "form2")
  childElem <- elem$findChildElement(using = "xpath", "select")
  expect_equal("2", childElem$getElementAttribute("id")[[1]])
}
)

#13-14
test_that("FindElementByXpathInElementContextNotFound", {
  expect_error({
    remDr$navigate(loadPage("nestedElements"))
    elem <- remDr$findElement(using = "name", "form2")
    childElem <- elem$findChildElement(using = "xpath", "div") })
  expect_equal(7, elem$status)
}
)

#15
test_that("ShouldBeAbleToEnterDataIntoFormFields", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "xpath", "//form[@name='someForm']/input[@id='username']")
  elem$clearElement()
  elem$sendKeysToElement(list("some text"))
  elem <- remDr$findElement(using = "xpath", "//form[@name='someForm']/input[@id='username']")
  expect_equal("some text", elem$getElementAttribute("value")[[1]])
}
)

#16-17
test_that("FindElementByTagName", {
  remDr$navigate(loadPage("simpleTest"))
  elems <- remDr$findElements(using = "tag name", "div")
  num_by_xpath <- length(remDr$findElements(using = "xpath", "//div"))
  expect_equal(num_by_xpath, length(elems))
  elems <- remDr$findElements(using = "tag name", "iframe")
  expect_equal(0, length(elems))
}
)

#18
test_that("FindElementByTagNameWithinElement", {
  remDr$navigate(loadPage("simpleTest"))
  elems <- remDr$findElement(using = "id", "multiline")$findChildElements(using = "tag name", "p")
  expect_true(length(elems) == 1)
}
)

#19-21
test_that("SwitchToWindow", {
  #if(rdBrowser == 'safari'){
  # see https://code.google.com/p/selenium/issues/detail?id=3693
  #return()
  #}
  title_1 = "XHTML Test Page"
  title_2 = "We Arrive Here"
  
  remDr$navigate (loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "link text", "Open new window")
  elem$clickElement()
  expect_equal(title_1, remDr$getTitle()[[1]])
  remDr$switchToWindow("result")
  #         wait.until(lambda dr: dr.switch_to_window("result") is None)
  expect_equal(title_2, remDr$getTitle()[[1]])
  # close window and switch back to first one
  windows <- unlist(remDr$getWindowHandles())
  currentWindow <- remDr$getCurrentWindowHandle()[[1]]
  remDr$closeWindow()
  remDr$switchToWindow(windows[!windows %in% currentWindow])
  expect_equal(title_1, remDr$getTitle()[[1]])
}
)

####
test_that("SwitchFrameByName", {
  remDr$navigate(loadPage("frameset"))
  remDr$switchToFrame("third")
  remDr$findElement(using = "id", "checky")$clickElement()
}
)

#22-23
test_that("IsEnabled", {
  remDr$navigate(loadPage("formPage"))
  elem <- remDr$findElement(using = "xpath", "//input[@id='working']")
  expect_true(elem$isElementEnabled()[[1]])
  elem <- remDr$findElement(using = "xpath", "//input[@id='notWorking']")
  expect_false(elem$isElementEnabled()[[1]])
}
)

#24-27
test_that("IsSelectedAndToggle", {
  if(rdBrowser == 'chrome' && package_version(remDr$sessionInfo$version)$major < 16){
    return("deselecting preselected values only works on chrome >= 16")
  }
  remDr$navigate(loadPage("formPage"))
  elem <- remDr$findElement(using = "id", "multi")
  option_elems <-  elem$findChildElements(using = "xpath", "option")
  expect_true(option_elems[[1]]$isElementSelected()[[1]])
  option_elems[[1]]$clickElement()
  expect_false(option_elems[[1]]$isElementSelected()[[1]])
  option_elems[[1]]$clickElement()
  expect_true(option_elems[[1]]$isElementSelected()[[1]])
  expect_true(option_elems[[3]]$isElementSelected()[[1]])
}
)

#28-30
test_that("Navigate", {
  # if(rdBrowser == 'safari'){
  # see http://code.google.com/p/selenium/issues/detail?id=3771&can=1&q=browser%3DSafari%20component%3DWebDriver%20status%3ANew%2CAccepted%2CWorkingAsIntended%2CWontFix%2CNotFeasible&colspec=ID%20Stars%20Type%20Status%20Priority%20Owner%20Summary%20Browser%20Component
  # return()
  # }
  
  remDr$navigate(loadPage("formPage"))
  remDr$findElement(using = "id", "imageButton")$clickElement()
  expect_equal("We Arrive Here", remDr$getTitle()[[1]])
  remDr$goBack()
  expect_equal("We Leave From Here", remDr$getTitle()[[1]])
  remDr$goForward()
  expect_equal("We Arrive Here",remDr$getTitle()[[1]])
}
)

#31
test_that("GetAttribute", {
  remDr$navigate(loadPage("xhtmlTest"))
  attr <- remDr$findElement(using = "id", "id1")$getElementAttribute("href")
  expect_equal(paste0(loadPage("xhtmlTest"), "#"), attr[[1]])
}
)

#32-36
test_that("GetImplicitAttribute", {
  remDr$navigate(loadPage("nestedElements"))
  elems <- remDr$findElements(using = "xpath", "//option")
  expect_true(length(elems) >= 3)
  for(x in seq(4)){
    expect_equal(x-1, as.integer(elems[[x]]$getElementAttribute("index")[[1]]))
  }
}
)

#37
test_that("ExecuteSimpleScript", {
  remDr$navigate(loadPage("xhtmlTest"))
  title <- remDr$executeScript("return document.title;")
  expect_equal("XHTML Test Page", title[[1]])
}
)

#38
test_that("ExecuteScriptAndReturnElement", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$executeScript("return document.getElementById('id1');")
  expect_true(inherits(elem[[1]], "webElement"))
}
)

#39
test_that("ExecuteScriptWithArgs", {
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript("return arguments[0] == 'fish' ? 'fish' : 'not fish';", list("fish"))
  expect_equal("fish", result[[1]])
}
)

#40
test_that("ExecuteScriptWithMultipleArgs", {
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript("return arguments[0] + arguments[1]", list(1, 2))
  expect_equal(3, result[[1]])
}
)

#41
test_that("ExecuteScriptWithElementArgs", {
  remDr$navigate(loadPage("javascriptPage"))
  button <- remDr$findElement(using = "id", "plainButton")
  appScript <- "arguments[0]['flibble'] = arguments[0].getAttribute('id'); return arguments[0]['flibble'];"
  result <- remDr$executeScript(appScript, list(button))
  expect_equal("plainButton", result[[1]])
}
)

#42
test_that("FindElementsByPartialLinkText", {
  remDr$navigate(loadPage("xhtmlTest"))
  elem <- remDr$findElement(using = "partial link text", "new window")
  expect_equal("Open new window", elem$getElementText()[[1]])
}
)

#43-44
test_that("IsElementDisplayed", {
  remDr$navigate(loadPage("javascriptPage"))
  visible <- remDr$findElement(using = "id", "displayed")$isElementDisplayed()
  not_visible <- remDr$findElement(using = "id", "hidden")$isElementDisplayed()
  expect_true(visible[[1]])
  expect_false(not_visible[[1]])
}
)

#45-46
test_that("MoveWindowPosition", {
  if(rdBrowser == 'android' || rdBrowser == "safari"){
    print("Not applicable")
    return()
  }
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
  loc <- remDr$getWindowPosition()
  expect_lt(abs(loc[['x']] - new_x), 10)
  expect_lt(abs(loc[['y']] - new_y), 10)
}
)

#47-48
test_that("ChangeWindowSize", {
  if(rdBrowser == 'android'){
    print("Not applicable")
    return()
  }
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
  expect_lt(abs(size[['width']] - newSize[1]), 10)
  expect_lt(abs(size[['height']] - newSize[2]), 10)
}
)

# On headless docker container the below doesnt make sense
# test_that("testShouldMaximizeTheWindow", {
#   size <- remDr$navigate(loadPage("blank")) %>%
#     setWindowSize(200,200) %>%
#     getWindowSize
#   new_size <- remDr %>% maximizeWindow %>%
#     getWindowSize
#   expect_gt(new_size[['width']], size[['width']])
#   expect_gt(new_size[['height']], size[['height']])
# }
# )
