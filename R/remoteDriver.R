
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


