#' CLASS remoteDriver
#'
#' remoteDriver Class uses the JsonWireProtocol to communicate with the Selenium Server. If an error occurs while executing the command then the server sends back an HTTP error code with a JSON encoded reponse that indicates the precise Response Error Code. The module will then croak with the error message associated with this code. If no error occurred, then the subroutine called will return the value sent back from the server (if a return value was sent). 
#' So a rule of thumb while invoking methods on the driver is if the method did not croak when called, then you can safely assume the command was successful even if nothing was returned by the method.
#'
#'@section Slots:      
#'  \describe{
#'    \item{\code{remoteServerAddr}:}{Object of class \code{"character"}, giving the ip of the remote server. Defaults to localhost}
#'    \item{\code{port}:}{Object of class \code{"numeric"}, the port of the remote server on which to connect.}
#'    \item{\code{browserName}:}{Object of class \code{"character"}. The name of the browser being used; should be one of {chrome|firefox|htmlunit|internet explorer|iphone}.}
#'    \item{\code{version}:}{Object of class \code{"character"}. The browser version, or the empty string if unknown.}
#'    \item{\code{platform}:}{Object of class \code{"character"}. A key specifying which platform the browser is running on. This value should be one of {WINDOWS|XP|VISTA|MAC|LINUX|UNIX}. When requesting a new session, the client may specify ANY to indicate any available platform may be used.}
#'    \item{\code{javascript}:}{Object of class \code{"character"}. Whether the session supports executing user supplied JavaScript in the context of the current page. }
#'    \item{\code{serverURL}:}{Object of class \code{"character"}. Url of the remote server which JSON requests are sent to. }
#'    \item{\code{sessionInfo}:}{Object of class \code{"list"}. A list containing information on sessions. }
#'  }
#'  
#'@section Methods:
#'  \describe{
#'      \item{\code{new()}:}{ Create a new \code{remoteDriver} object. }
#'  }
#' @export remoteDriver

remoteDriver <- setRefClass("remoteDriver",
  fields = list(
      remoteServerAddr = "character",
      port             = "numeric",
      browserName      = "character",
      version          = "character",
      platform         = "character",
      javascript       = "logical",
      autoClose        = "logical",
      serverURL        = "character",
      sessionInfo      = "list"  ),
  methods = list(
      initialize = function(remoteServerAddr = "localhost",
                                port             = 4444,
                                browserName      = "firefox",
                                version          = "",
                                platform         = "ANY",
                                javascript       = TRUE,
                                autoClose        = FALSE
                                ){
          remoteServerAddr <<- remoteServerAddr
          port <<- port
          browserName <<- browserName
          version <<- version
          platform <<- platform
          javascript <<- javascript
          autoClose <<- autoClose
          #eval(parse(text=paste0('.self$',ls(remoteDriver$def@refMethods))))

      },

      #finalize = function(){
      #    if(autoClose){
      #        serverDetails <- getSessions()
      #        sapply(seq_along(serverDetails$value),
      #               function(x){
      #                           queryRD(paste0(serverURL,'session/',serverDetails$value[[x]]$id),"DELETE")
      #               }
      #              )
      #    }
      #},

      open = function(){
          print("Connecting to remote server")
          serverURL <<- paste0("http://",remoteServerAddr,":",port,"/wd/hub/")
          serverOpts <- list(desiredCapabilities = list(
                           browserName = browserName,
                           version = version,
                           javascriptEnabled = javascript)
                      )
          queryRD(paste0(serverURL,'session'),"POST",data = toJSON(serverOpts))
          serverDetails <- getSessions()
          sessionInfo <<- tail(serverDetails$value,n = 1)[[1]]
          print(serverDetails)
      },    

      getSessions = function(){
          fromJSON(queryRD(paste0(serverURL,'sessions')))
      },

      status = function(){
          fromJSON(queryRD(paste0(serverURL,'status')))
      },

      getAlertText = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/alert_text')))
      },

      sendKeysToActiveElement = function(sendKeys){
          sendKeys<-toJSON(list(value = matchSelKeys(sendKeys)))
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/keys'),
                           "POST",data = sendKeys)
      },

      sendKeysToAlert = function(sendKeys){
          sendKeys<-toJSON(list(text = paste(matchSelKeys(sendKeys),collapse = "")))
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/alert_text'),
                           "POST",data = sendKeys)
      },

      acceptAlert = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/accept_alert'),
                           "POST")
      },

      dismissAlert = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/dismiss_alert'),
                           "POST")
      },

      mouseMoveToLocation = function(x,y,elementId = NULL){
          sendLoc<-toJSON(c(element = elementId,list(xoffset = x,yoffset = y)))
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/moveto'),
                           "POST",data = sendLoc)
      },

      setAsyncScriptTimeout = function(milliseconds = 10000){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/timeouts/async_script'),
                           "POST",data=toJSON(list(ms = milliseconds)))
      },

      setImplicitWaitTimeout = function(milliseconds = 10000){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/timeouts/implicit_wait'),
                           "POST",data=toJSON(list(ms = milliseconds)))
      },
      
      close = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window'),
                           "DELETE")
      },

      quit = function(){
          serverDetails<-getSessions()
          sapply(seq_along(serverDetails$value),
                 function(x){
                             queryRD(paste0(serverURL,'session/',serverDetails$value[[x]]$id),
                                              "DELETE")
                 }
                )
          autoClose <<- FALSE
      },

      getCurrentWindowHandle = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window_handle')))
      },

      getWindowHandles = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window_handles')))
      },

      getWindowSize = function(windowId = "current"){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window/',windowId,'/size')))
      },
     
      getWindowPosition = function(windowId = "current"){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window/',windowId,'/position')))
      },
     
      getCurrentUrl = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/url')))
      },
     
      navigate = function(url){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/url'),
                           "POST",data=toJSON(list(url = url)))
      },

      getTitle = function(url){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/title')))
      },

      goForward = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/forward'),
                           "POST")
      },
     
      goBack = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/back'),
                           "POST")
      },
     
      refresh = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/refresh'),
                           "POST")
      },

      executeAsyncScript = function(script,args = NA){
          if(.self$javascript){
              fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/execute_async'),
                               "POST",data = toJSON(list(script = script,args = list(args)))))
          }else{
              "Javascript is not enabled"
          }
      },
           
      executeScript = function(script,args = NA){
          if(.self$javascript){
              fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/execute'),
                               "POST",data = toJSON(list(script = script,args = list(args)))))
          }else{
              "Javascript is not enabled"
          }
      },

      screenshot = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/screenshot')))
      },
           
      #availableEngines = function(){
      #    fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/ime/available_engines')))
      #}

      switchToFrame = function(frameId){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/frame'),
                           "POST",data=toJSON(list(id = frameId)))
      },

      switchToWindow = function(windowId){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window'),
                           "POST",data = toJSON(list(name = windowId)))
      },

      setWindowPosition = function(x,y,winHand = 'current'){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window/',winHand,'/position'),
                           "POST",data=toJSON(list(x = x,y = y)))
      },
           
      setWindowSize = function(width,height,winHand='current'){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/window/',winHand,'/size'),
                           "POST",data = toJSON(list(width = width,height = height)))
      },
           
      getAllCookies = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/cookie')))
      },
           
      addCookie = function(name,value,path,domain,secure = FALSE){
          cookie<-list(name = name,value = value,path = path,domain = domain,secure = secure)
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/cookie'),
                           "POST",data=toJSON(cookie = list(cookie)))
      },

      deleteAllCookies = function(){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/cookie')
                                   ,"DELETE")
      },
           
      deleteCookieNamed = function(name){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/cookie/',name)
                                   ,"DELETE")
      },
           
      getPageSource = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/source')))
      },

      findElement = function(using = "xpath",value){
          elemDetails<-fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element'),
                           "POST",data = toJSON(list(using = using,value = value))))
          elemDetails$value
      },
      
      findElements = function(using = "xpath",value){
          elemDetails<-fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/elements'),
                           "POST",data = toJSON(list(using = using,value = value))))
          elemDetails$value
      },

      getActiveElement = function(){
          fromJSON(queryRD(paste0(serverURL,'session/',sessionInfo$id,'/element/active')))
      },

      click = function(buttonId = 0){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/click'),
                           "POST",data = toJSON(list(button = buttonId)))
      },
           
      doubleclick = function(buttonId = 0){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/doubleclick'),
                           "POST",data = toJSON(list(button = buttonId)))
      },
           
      buttondown = function(buttonId = 0){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/buttondown'),
                           "POST",data = toJSON(list(button = buttonId)))
      },
           
      buttonup = function(buttonId = 0){
          queryRD(paste0(serverURL,'session/',sessionInfo$id,'/buttonup'),
                           "POST",data = toJSON(list(button = buttonId)))
      }
           
  )

)


