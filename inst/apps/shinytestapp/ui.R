shinyUI(
  navbarPage(
    "Shiny Test App", 
    tabPanel("Plots",  sidebarLayout(
      
      # Sidebar with a slider input
      sidebarPanel(
        checkboxGroupInput("ctrlSelect", "Select controls required:",
                           setNames(1:4, c("selectInput", 
                                           "numericInput", 
                                           "dateRangeInput", 
                                           "sliderInput")))
        , uiOutput("reqcontrols")
        , width = 3
      )
      , mainPanel(
        uiOutput("reqplots")
        , width = 9
      )
    )
    ), 
    tabPanel("About", 
             "A simple shiny app to illustrate testing as part of the 
             RSelenium package.") 
  )
  
)
