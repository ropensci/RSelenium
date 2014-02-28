context("alerts")
# add build details for sauceLabs
if(exists('rsel.opt', where = parent.env(environment()) , inherits = FALSE)){
  pv <- packageVersion("RSelenium")
  slFlags <- list(name = "RSelenium-test-suite"
                  , build = sum(unlist(pv)*10^(3-seq_along(unlist(pv)))) # 1.2.1 for example 121
                  , tags =  list("alerts")
                  , "custom-data" = list(release = do.call(paste, list(pv, collapse = ".")))
  )
  rsel.opt$extraCapabilities <- c(rsel.opt$extraCapabilities, slFlags)
}

source(file.path(find.package("RSelenium"), "tests", 'setup.r'), local = TRUE)
on.exit(remDr$close())

#1
test_that("testShouldBeAbleToOverrideTheWindowAlertMethod", {
  remDr$navigate(loadPage("alerts"))
  remDr$executeScript(
    "window.alert = function(msg) { document.getElementById('text').innerHTML = msg; }")
  remDr$findElement(using = "id", value="alert")$clickElement()
  expect_identical(remDr$findElement(using = "id", "text")$getElementText()[[1]], "cheese")
  
  # if fail we probably need to click an alert
  if(!identical(remDr$findElement(using = "id", "text")$getElementText()[[1]], "cheese")){
    remDr$dismissAlert()
  }
}
)

#2
test_that("testShouldAllowUsersToAcceptAnAlertManually", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="alert")$clickElement()
  remDr$acceptAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
  
}
)

#3
test_that("testShouldAllowUsersToAcceptAnAlertWithNoTextManually", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="empty-alert")$clickElement()
  remDr$acceptAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
  
}
)

#4
# test_that("testShouldGetTextOfAlertOpenedInSetTimeout", {
#   remDr$dismissAlert()
#   remDr$navigate(loadPage("alerts"))
#   remDr$findElement(using = "id", value="slow-alert")$clickElement()
#   # DO NOT WAIT OR SLEEP HERE
#   # This is a regression test for a bug where only the first switchTo call would throw,
#   # and only if it happens before the alert actually loads.
#   expect_identical("Slow", remDr$getAlertText()[[1]])
#   remDr$acceptAlert()
#   
# }
# )

#5
if(browser != "chrome"){
  test_that("testShouldAllowUsersToDismissAnAlertManually", {
    remDr$dismissAlert()
    remDr$navigate(loadPage("alerts"))
    remDr$findElement(using = "id", value="alert")$clickElement()
    remDr$dismissAlert()
    #  If we can perform any action, we're good to go
    expect_identical("Testing Alerts", remDr$getTitle()[[1]])
    
  }
  )
}
#6
test_that("testShouldAllowAUserToAcceptAPrompt", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="prompt")$clickElement()
  remDr$acceptAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
  
}
)

#7
test_that("testShouldAllowAUserToDismissAPrompt", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="prompt")$clickElement()
  remDr$dismissAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
  
}
)

#8
test_that("testShouldAllowAUserToSetTheValueOfAPrompt", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="prompt")$clickElement()
  remDr$sendKeysToAlert("cheese")
  remDr$acceptAlert()
  Sys.sleep(0.5)
  promptText <- remDr$findElement(using = 'id', value = "text")$getElementText()[[1]]
  expect_identical("cheese", promptText)
}
)

#9
test_that("testSettingTheValueOfAnAlertThrows", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="alert")$clickElement()
  remDr$sendKeysToAlert("cheese")
  # we expect an error here so status greater then 1
  expect_less_than(1, remDr$status)
  remDr$acceptAlert()
}
)

#10
test_that("testAlertShouldNotAllowAdditionalCommandsIfDimissed", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value="alert")$clickElement()
  remDr$dismissAlert()
  Sys.sleep(1)
  #  alertText <- remDr$getAlertText()
  remDr$getAlertText()
  # should fail and have status 27
  print(remDr$status)
  expect_equal(27, remDr$status)  
}
)

#11
test_that("testShouldAllowUsersToAcceptAnAlertInAFrame", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$switchToFrame("iframeWithAlert")
  remDr$findElement(using = "id", value= "alertInFrame")$clickElement()
  remDr$acceptAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
}
)

#12
test_that("testShouldAllowUsersToAcceptAnAlertInANestedFrame", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$switchToFrame("iframeWithIframe")
  remDr$switchToFrame("iframeWithAlert")
  remDr$findElement(using = "id", value= "alertInFrame")$clickElement()
  remDr$acceptAlert()
  #  If we can perform any action, we're good to go
  expect_identical("Testing Alerts", remDr$getTitle()[[1]])
  
}
)

test_that("testShouldThrowAnExceptionIfAnAlertHasNotBeenDealtWithAndDismissTheAlert", {
  
}
)

#13
test_that("testPromptShouldUseDefaultValueIfNoKeysSent", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value = "prompt-with-default")$clickElement()
  remDr$acceptAlert()
  promptText <- remDr$findElement(using = "id", value = "text")$getElementText()[[1]]
  expect_identical("This is a default value", promptText)
}
)

#14
test_that("testPromptShouldHaveNullValueIfDismissed", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value = "prompt-with-default")$clickElement()
  remDr$dismissAlert()
  promptText <- remDr$findElement(using = "id", value = "text")$getElementText()[[1]]
  expect_identical("null", promptText)
  
}
)

#15-16
test_that("testHandlesTwoAlertsFromOneInteraction", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value = "double-prompt")$clickElement()
  remDr$sendKeysToAlert("brie")
  remDr$acceptAlert()
  remDr$sendKeysToAlert("cheddar")
  remDr$acceptAlert()
  promptText1 <- remDr$findElement(using = "id", value = "text1")$getElementText()[[1]]
  promptText2 <- remDr$findElement(using = "id", value = "text2")$getElementText()[[1]]
  expect_identical("brie", promptText1)
  expect_identical("cheddar", promptText2)
}
)

#17
test_that("testShouldAllowTheUserToGetTheTextOfAnAlert", {
  remDr$dismissAlert()
  remDr$navigate(loadPage("alerts"))
  remDr$findElement(using = "id", value = "alert")$clickElement()
  Sys.sleep(1)
  #  alertText <- remDr$getAlertText()[[1]]
  print(remDr$getAlertText()[[1]])
  expect_identical("cheese", remDr$getAlertText()[[1]])
  remDr$acceptAlert()
}
)


