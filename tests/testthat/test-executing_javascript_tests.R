context("executing_javascript_tests")
init <- initFun()
remDr <- init$remDr; rdBrowser <- init$rdBrowser; loadPage <- init$loadPage
on.exit(remDr$close())

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndReturnAString", {
  skip_on_cran()
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript("return document.title")
  expect_true(inherits(result[[1]], "character"))
  expect_equal("XHTML Test Page", result[[1]])
}
)

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndReturnAnInteger", {
  skip_on_cran()
  remDr$navigate(loadPage("nestedElements"))
  result <- remDr$
    executeScript("return document.getElementsByName('checky').length")
  expect_true(inherits(result[[1]], "integer"))
  expect_gt(result[[1]], 1L)
}
)

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndReturnAWebElement", {
  skip_on_cran()
  remDr$navigate(loadPage("xhtmlTest"))
  result <-  remDr$executeScript("return document.getElementById('id1')")
  expect_true(inherits(result[[1]], "webElement"))
  expect_equal(result[[1]]$getElementTagName()[[1]], "a")
}
)

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndReturnABoolean", {
  skip_on_cran()
  remDr$navigate(loadPage("xhtmlTest"))
  result <- remDr$executeScript("return true")
  expect_true(inherits(result[[1]], "logical"))
  expect_true(result[[1]])
}
)

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndAStringsArray", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  result <- remDr$executeScript("return ['zero', 'one', 'two']")
  expectedResult <- list('zero', 'one', 'two')
  expect_identical(result, expectedResult)
}
)

test_that("testShouldBeAbleToExecuteSimpleJavascriptAndReturnAnArray", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  result <- remDr$executeScript("return ['zero', [true, false]]")
  expectedResult <- list('zero', list(TRUE, FALSE))
  expect_identical(result, expectedResult)
}
)

test_that("testPassingAndReturningAnIntShouldReturnAWholeNumber", {
  skip_on_cran()
  expectedResult <- 1
  remDr$navigate(loadPage("javascriptPage"))
  result <- remDr$executeScript("return arguments[0]", 
                                list(expectedResult))
  expect_true(inherits(result[[1]], "integer"))
  expect_equal(result[[1]], expectedResult)
}
)

test_that("testPassingAndReturningADoubleShouldReturnADecimal", {
  skip_on_cran()
  expectedResult <- 1.2
  remDr$navigate(loadPage("javascriptPage"))
  result <- remDr$executeScript("return arguments[0]", 
                                list(expectedResult))
  expect_true(inherits(result[[1]], "numeric"))
  expect_identical(result[[1]], expectedResult)
}
)

test_that("testShouldThrowAnExceptionWhenTheJavascriptIsBad", {
  skip_on_cran()
  remDr$navigate(loadPage("xhtmlTest"))
  expect_error(
    remDr$executeScript("return squiggle()", retry = FALSE)
  )
}
)

test_that("testShouldBeAbleToCallFunctionsDefinedOnThePage", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  remDr$executeScript("displayMessage('I like cheese')")
  text <- remDr$findElement("id", "result")$
    getElementText()[[1]]
  expect_identical(text, 'I like cheese')
}
)

test_that("testShouldBeAbleToPassAStringAnAsArgument", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript(
    "return arguments[0] == 'fish' ? 'fish' : 'not fish'"
    , list("fish"))
  expect_identical(value[[1]], "fish")
}
)

test_that("testShouldBeAbleToPassABooleanAnAsArgument", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript("return arguments[0] == true"
                               , list(TRUE))
  expect_true(value[[1]])
}
)

test_that("testShouldBeAbleToPassANumberAnAsArgument", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript(
    "return arguments[0] == 1 ? true : false"
    , list(1L))
  expect_true(value[[1]])
}
)

test_that("testShouldBeAbleToPassAWebElementAsArgument", {
  skip_on_cran()
  jS <- "arguments[0]['flibble'] = arguments[0].getAttribute('id');
  return arguments[0]['flibble']"
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript(jS, 
                               list(remDr$findElement("id", "plainButton")))
  expect_identical(value[[1]], "plainButton")
}
)

test_that("testShouldBeAbleToPassAnArrayAsArgument", {
  skip_on_cran()
  array <- list("zerohero", 1, TRUE, 3.14159)
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript("return arguments[0].length"
                               , list(array))
  expect_equal(value[[1]], length(array))
}
)

test_that("testShouldBeAbleToPassInMoreThanOneArgument", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript("return arguments[0] + arguments[1]"
                               , list("one", "two"))
  expect_identical(value[[1]], "onetwo")
}
)

test_that("testJavascriptStringHandlingShouldWorkAsExpected", {
  skip_on_cran()
  remDr$navigate(loadPage("javascriptPage"))
  value <- remDr$executeScript("return ''")
  expect_identical(value[[1]], "")
  value <- remDr$executeScript("return ' '")
  expect_identical(value[[1]], " ")
}
)

test_that("testShouldBeAbleToCreateAPersistentValue", {
  skip_on_cran()
  remDr$navigate(loadPage("formPage"))
  remDr$executeScript("document.alerts = []")
  remDr$executeScript("document.alerts.push('hello world')")
  text <- remDr$executeScript("return document.alerts.shift()")
  expect_identical(text[[1]], "hello world")
}
)

test_that("testCanPassANone", {
  skip_on_cran()
  remDr$navigate(loadPage("simpleTest"))
  res <- remDr$executeScript("return arguments[0] === null", list(NA))
  expect_true(res[[1]])
}
)

test_that("testShouldBeAbleToReturnNestedWebElements", {
  skip_on_cran()
  remDr$navigate(loadPage("xhtmlTest"))
  result <- 
    remDr$executeScript("var1 = document.getElementById('id1');
                  return [var1, [var1, [var1, var1]]]")
  expect_true(inherits(result[[1]], "webElement"))
  expect_true(inherits(result[[2]][[1]], "webElement"))
  expect_true(inherits(result[[2]][[2]][[1]], "webElement"))
  expect_true(inherits(result[[2]][[2]][[2]], "webElement"))
  expect_equal(result[[1]]$getElementTagName()[[1]], "a")
}
)
