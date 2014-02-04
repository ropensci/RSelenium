<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{RSelenium basics}
-->




# RSelenium basics

## Introduction

The goal of RSelenium is to make it easy to connect to a Selenium Server/ Remote Selenium Server from within R. RSelenium provides R bindings for the Selenium Webdriver API. [Selenium](http://docs.seleniumhq.org/) is a project focused on automating web browsers. RSelenium allows you to carry out unit testing and regression testing on your webapps and webpages across a range of browser/OS combinations. This allows us to integrate from within R testing and manipulation of popular projects such as [shiny](http://www.rstudio.com/shiny/), [sauceLabs](https://saucelabs.com/).

This vignette is divided into five main sections:

* [Connecting to a Selenium Server.](#id1)
* [Navigating using RSelenium.](#id2)
* [Accessing elements in the DOM.](#id3)
* [Sending events to elements.](#id4)
* [Injecting JavaScript.](#id5)

Each section will be an introduction to a major idea in Selenium, and point to more detailed explanation in other vignettes.


## <a id="id1">Connecting to a Selenium Server.</a>

### What is a Selenium Server?
Selenium Server is  a standalone java program which allows you to run HTML test suites in a range of different browsers, plus extra options like reporting.
You may, or may not, need to run a Selenium Server, depending on how you intend to use Selenium-WebDriver (RSelenium). 

### Do I need to run a Selenium Server?
If you intend to drive a browser on the same machine that RSelenium is running on then you will need to have Selenium Server running on that machine. 

### How do I get the Selenium Server stand-alone binary?
RSelenium has a built-in function that will download the stand-alone java binary and place it in the RSelenium package location in the `/bin/` directory. If you would like to install elsewhere the function takes a `dir` argument and can also update an existing binary. 
```
RSelenium::checkForServer()
```
If you would like to download the binary manually it is currently found [here](http://code.google.com/p/selenium/downloads/list). Look for `selenium-server-standalone-x.xx.x.jar`.

### How do I run the Selenium Server?

There is a utility function included in `RSelenium` to run an existing stand-alone Selenium Server binary. 
```
RSelenium::startServer()
```
By default it looks in the `RSelenium` package `/bin/` directory. It has an optional `dir` argument if your binary is elsewhere. Alternatively you can run the binary manually. Open a console in your OS and navigate to where the binary is located and run:
```
java -jar selenium-server-standalone-x.xx.x.jar
```
By default the `Selenium Server` listens for connections on port 4444.

### How do I connect to a running server?
`RSelenium` has a main reference class named `remoteDriver`. To connect to a server you need to instantiate a new `remoteDriver` with appropriate options.
```
# RSelenium::startServer() if required
require(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
                      )
```
It would have been sufficient to call `remDr <- remoteDriver()` but the options where explicitly listed to show how one may connect to an arbitrary ip/port/browser etc. More detail maybe found on the `sauceLabs` vignette. To connect to the server use the `open` method.

```
remDr$open()
```
RSelenium should now have a connection to the Selenium Server. You can query the status of the remote Server using the `status` method.
```
> remDr$getStatus()
$os
              arch               name            version 
           "amd64"            "Linux" "3.8.0-35-generic" 

$java
   version 
"1.6.0_27" 

$build
             revision                  time               version 
            "ff23eac" "2013-12-16 16:11:15"              "2.39.0" 

```

# <a id="id2">Navigating using RSelenium.</a>
### Basic Navigation
To start with we navigate to a url.
```
remDr$navigate("http://www.google.com")
```
Then we navigate to a second page.
```
remDr$navigate("http://www.bbc.co.uk")

> remDr$getCurrentUrl()
[[1]]
[1] "http://www.bbc.co.uk/"

```
We can go backwards and forwards using the methods `goBack` and `goForward`.

```
remDr$goBack()

> remDr$getCurrentUrl()
[[1]]
[1] "https://www.google.com/"

remDr$goForward()

> remDr$getCurrentUrl()
[[1]]
[1] "http://www.bbc.co.uk/"

```

To refresh the current page you can use the `refresh method.

```
remDr$refresh()

```

## <a id="id3">Accessing elements in the DOM.</a>
The DOM stands for the Document Object Model. It is a cross-platform and language-independent convention for representing and interacting with objects in HTML, XHTML and XML documents. Interacting with the DOM will be very important for us with Selenium and the webDriver provides a number of methods in which to do this.
A basic html page is 

```
<!DOCTYPE html>
<html>
<body>

<h1>My First Heading</h1>

<p>My first paragraph.</p>

</body>
</html>

```

The query box on the front page of `http://www.google.com` has html code `input id="gbqfq" class="gbqfif"` associated with it. The full html associated with the input tag is:

```
<input type="text" value="" autocomplete="off" name="q" class="gbqfif" id="gbqfq" style="border: medium none; padding: 0px; margin: 0px; height: auto; width: 100%; background: url(&quot;data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw%3D%3D&quot;) repeat scroll 0% 0% transparent; position: absolute; z-index: 6; left: 0px; outline: medium none;" dir="ltr" spellcheck="false">

```
### Search by id.

To find this element in the DOM a number of methods can be used. We can search by the id.

```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = 'id', value = "gbqfq")

> webElem$getElementAttribute("id")
[[1]]
[1] "gbqfq"

> webElem$getElementAttribute("class")
[[1]]
[1] "gbqfif"

```
### Search by class.
We can also search by class name.

```
webElem <- remDr$findElement(using = 'class name', "gbqfif")

> webElem$getElementAttribute("class")
[[1]]
[1] "gbqfif"

> webElem$getElementAttribute("type")
[[1]]
[1] "text"

```
### Search using css-selectors
The class is denoted by `.` when using css selectors. To search on class using css selectors we would use

```
webElem <- remDr$findElement(using = 'css selector', "input.gbqfif")

```

and to search on id using css-selectors

```
webElem <- remDr$findElement(using = 'css selector', "input#gbqfq")

```

A good example of searching using css-selectors is given [here](http://saucelabs.com/resources/selenium/css-selectors).

### Search by name
To search using the `name` if given of the element. Note that ids are unique in a given html page. Names are not necessarily unique. 

```
webElem <- remDr$findElement(using = 'name', "q")
 
> webElem$getElementAttribute("name")
[[1]]
[1] "q"

> webElem$getElementAttribute("id")
[[1]]
[1] "gbqfq"

```

### Search using xpath
The final option is to search using xpath. Normally one would use xpath by default when searching. 

Xpath using id.

```
webElem <- remDr$findElement(using = 'xpath', "//*/input[@id = 'gbqfq']")
```

Xpath using class.

```
webElem <- remDr$findElement(using = 'xpath', "//*/input[@class = 'gbqfif']")
```

## <a id="id4">Sending events to elements.</a>

To illustrate how to interact with elements we will again use the `http://www.google.com/ncr` as an example.


### Sending text to elements

Suppose we would like to search for `R cran` on google. We would need to find the element for the query box and send the appropriate text to it. We can do this using the `sendKeysToElement` method for the `webElement` class.

```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", "//*/input[@id = 'gbqfq']")
webElem$sendKeysToElement(list("R Cran"))

```

### Sending key presses to elements

We should see that the text `R Cran` has now been entered into the query box.
How do we press enter. We can simply send the enter key to query box. The enter key would be denoted as `"\uE007"`. So we could use:

```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", "//*/input[@id = 'gbqfq']")
webElem$sendKeysToElement(list("R Cran", "\uE007"))

```
It is not very easy to remember utf8 codes for appropriate keys so a mapping has been provided in `RSelenium`. `?selkeys' will bring up a help page explaining the mapping. The utf codes given [here](http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value) have been mapped to easy to remember names. 

To use `selkeys` we would send the following


```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", "//*/input[@id = 'gbqfq']")
webElem$sendKeysToElement(list("R Cran", key = "enter"))

```

Typing `selKeys` into the console will bring up the list of mappings.

### Sending mouse events to elements

For this example we will go back to the google frontpage and search for
`R Cran` then we will click the link for the `The Comprehensive R Archive Network`.

```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", "//*/input[@id = 'gbqfq']")
webElem$sendKeysToElement(list("R Cran", key = "enter"))

```

`<li class="g">` contains the search results we can find all the search entries on the first page using the `findElements` method. The header for each link is contained further in with a `<h3 class = "r">` tag. We will access the `h3` headers first. It will be succinct to find these elements using `css selectors`.

```
webElems <- remDr$findElements(using = 'css selector', "li.g h3.r")
resHeaders <- unlist(lapply(webElems, function(x){x$getElementText()}))
> resHeaders
 [1] "The Comprehensive R Archive Network"                        
 [2] "Comprehensive R Archive"                                    
 [3] "Mirrors"                                                    
 [4] "Contributed Packages"                                       
 [5] "R for Mac OS X"                                             
 [6] "Download R 3.0.2"                                           
 [7] "CRAN Repository Policy"                                     
 [8] "The R Project for Statistical Computing"                    
 [9] "Cran - Wikipedia, the free encyclopedia"                    
[10] "Comprehensive R Archive Network (CRAN) - StatLib - Carnegie"
[11] "CRAN - Package R.methodsS3"                                 
[12] "CRAN - Package R.cache"                                     
[13] "Ubuntu – Details of package r-cran-sp in lucid"

```
We can see that the first link is the one we want but in case googles search results change we refer to it as 

```
webElem <- webElems[[which(resHeaders == "The Comprehensive R Archive Network")]]

```

How do we click the link. We can use the `clickElement` method:

```
webElem$clickElement()

> remDr$getCurrentUrl()
[[1]]
[1] "http://cran.r-project.org/"

> remDr$getTitle()
[[1]]
[1] "The Comprehensive R Archive Network"
```
## <a id="id5">Injecting JavaScript</a>

Sometimes it is necessary to interact with the current url using JavaScript. This maybe necessary to call bespoke methods or to have more control over the page for example by adding the `JQuery` library to the page if it is missing. `Selenium` has two methods we can use to execute JavaScript namely
`executeScript` and `executeAsyncScript` from the `remoteDriver` class. We return to the google front page to investigate these methods.


### Injecting JavaScript synchronously

Returning to the google homepage we can find the element for the `google` image. The image has `id = "hplogo"` and
we can use this in an xpath or search by id etc to select the element. In this case we use `css selectors`:

```
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement("css selector", "img#hplogo")

```

Is the image visible? Clearly it is but we can check using javascript. 

```
> remDr$executeScript("return document.getElementById('hplogo').hidden;", args = list())
[[1]]
[1] FALSE

```

Great so the image is not hidden indicated by the `FALSE`. We can hide it executing some simple JavaScript.

```
remDr$executeScript("document.getElementById('hplogo').hidden = true;", args = list())

> remDr$executeScript("return document.getElementById('hplogo').hidden;", args = list())
[[1]]
[1] TRUE

```
So now the image is hidden. We used an element here given by `id = "hplogo"`. We had to use the JavaScript function
`getElementById` to access it. It would be nicer if we could have used `webElem` which we had specified earlier. 
If we pass a webElement object as an argument to either `executeScript` or `executeAsyncScript` `RSelenium` will pass it in an appropriate fashion.

```
> remDr$executeScript(script = "return arguments[0].hidden = false;", args = list(webElem))
[[1]]
[1] FALSE

```
Notive how we passed the web element to the method `executeScript`. The script argument defines the script to execute in the form of a function body. The value returned by that function will be returned to the client. The function will be invoked with the provided args. If the function returns an element then this will be returned as an object of class webElement:

```
test <- remDr$executeScript("return document.getElementById('gbqfq');", args = list())

> test[[1]]
[1] "remoteDriver fields"
$remoteServerAddr
[1] "localhost"

$port
[1] 4444

$browserName
[1] "firefox"

$version
[1] ""

$platform
[1] "ANY"

$javascript
[1] TRUE

$autoClose
[1] FALSE

$nativeEvents
[1] TRUE

$extraCapabilities
list()

[1] "webElement fields"
$elementId
[1] 1

> class(test[[1]])
[1] "webElement"
attr(,"package")
[1] "RSelenium"

```

### Injecting JavaScript asynchronously

I will briefly touch on asynch versus sync calls here. With the current firefox and selenium server combination (firefox 26.0 sel server 2.39.0) I had issues with async javascript calls when `nativeEvents = TRUE` (the default) was used. 

For the example below I switched to `nativeEvents = FALSE`

```

remDr <- remoteDriver(nativeEvents = FALSE)
remDr$open()
remDr$navigate("http://www.google.com/ncr")
remDr$setAsyncScriptTimeout(10000)

```

Observe:

```
remDr$executeAsyncScript("setTimeout(function(){ alert('Hello'); arguments[arguments.length -1]('DONE');},5000); ", args = list())


```

versus

```
remDr$executeScript("setTimeout(function(){ alert('Hello');},5000); return 'DONE';", args = list())

```

The async version waits until the callback (defined as the last argument) is called.
