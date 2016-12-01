context("alerts_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
on.exit(remDr$closeall())

#1
test_that("testShouldBeAbleToOverrideTheWindowAlertMethod", {
  
  script <- "window.alert = function(msg) {
  document.getElementById('text').innerHTML = msg;}"
  remDr$navigate(loadPage("alerts"))
  remDr$executeScript(script)
  remDr$findElement("id", "alert")$
    clickElement()
  appText <- remDr$findElement("id", "text")$
    getElementText()
  expect_equal("cheese", appText[[1]])
}
)

test_that("testShouldAllowUsersToAcceptAnAlertManually", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testShouldAllowUsersToAcceptAnAlertWithNoTextManually", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "empty-alert")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testShouldGetTextOfAlertOpenedInSetTimeout", {
  if(identical(rdBrowser, "chrome")) skip("Not chrome")
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "slow-alert")$
    clickElement()
  alertTxt <- remDr$getAlertText()[[1]]
  expect_equal("Slow", alertTxt)
  remDr$acceptAlert()
}
)

test_that("testShouldAllowUsersToDismissAnAlertManually", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testShouldAllowAUserToAcceptAPrompt", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "prompt")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)


test_that("testShouldAllowAUserToDismissAPrompt", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "prompt")$
    clickElement()
  remDr$dismissAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testShouldAllowAUserToSetTheValueOfAPrompt", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "prompt")$
    clickElement()
  remDr$sendKeysToAlert(list("cheese"))
  remDr$acceptAlert()
  alertTxt <- remDr$findElement("id", "text")$
    getElementText()[[1]]
  expect_equal("cheese", alertTxt)
}
)

test_that("testSettingTheValueOfAnAlertThrows", {
  if(identical("chrome", rdBrowser)) skip("Not chrome")
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  expect_error(remDr$sendKeysToAlert(list("cheadder")))
  remDr$dismissAlert()
}
)

test_that("testAlertShouldNotAllowAdditionalCommandsIfDimissed", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  remDr$dismissAlert()
  expect_error(remDr$sendKeysToAlert())
}
)

test_that("testShouldAllowUsersToAcceptAnAlertInAFrame", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$switchToFrame(remDr$findElement("name", "iframeWithAlert"))
  remDr$findElement("id", "alertInFrame")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testShouldAllowUsersToAcceptAnAlertInANestedFrame", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$switchToFrame(remDr$findElement("name", "iframeWithIframe"))
  remDr$switchToFrame(remDr$findElement("name", "iframeWithAlert"))
  remDr$findElement("id", "alertInFrame")$
    clickElement()
  remDr$acceptAlert()
  expect_equal("Testing Alerts", remDr$getTitle()[[1]])
}
)

test_that("testPromptShouldUseDefaultValueIfNoKeysSent", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "prompt-with-default")$
    clickElement()
  remDr$acceptAlert()
  alertTxt <- remDr$findElement("id", "text")$
    getElementText()[[1]]
  expect_equal("This is a default value", alertTxt)
}
)

test_that("testPromptShouldHaveNullValueIfDismissed", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "prompt-with-default")$
    clickElement()
  remDr$dismissAlert()
  alertTxt <- remDr$findElement("id", "text")$
    getElementText()[[1]]
  expect_equal("null", alertTxt)
}
)

test_that("testHandlesTwoAlertsFromOneInteraction", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "double-prompt")$
    clickElement()
  remDr$sendKeysToAlert(list("brie"))
  remDr$acceptAlert()
  remDr$sendKeysToAlert(list("cheddar"))
  remDr$acceptAlert()
  alertTxt1 <- remDr$findElement("id", "text1")$
    getElementText()[[1]]
  alertTxt2 <- remDr$findElement("id", "text2")$
    getElementText()[[1]]
  expect_equal("brie", alertTxt1)
  expect_equal("cheddar", alertTxt2)
}
)

test_that("testShouldHandleAlertOnPageLoad", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "open-page-with-onload-alert")$
    clickElement()
  alertTxt <- remDr$getAlertText()[[1]]
  remDr$acceptAlert()
  expect_equal("onload", alertTxt)
}
)

test_that("testShouldAllowTheUserToGetTheTextOfAnAlert", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  alertTxt <- remDr$getAlertText()[[1]]
  remDr$acceptAlert()
  expect_equal("cheese", alertTxt)
}
)

test_that("testUnexpectedAlertPresentExceptionContainsAlertText", {
  
  remDr$navigate(loadPage("alerts"))
  remDr$findElement("id", "alert")$
    clickElement()
  expect_error(remDr$navigate(loadPage("simpleTest")))
  expect_equal(remDr$status, 26L)
  tryCatch({remDr$acceptAlert()}, error = function(e){})
}
)
