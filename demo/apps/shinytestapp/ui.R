shinyUI(
  navbarPage("Shiny Test App"
             , tabPanel("Plots",  sidebarLayout(
               
               # Sidebar with a slider input
               sidebarPanel(
                 checkboxGroupInput("ctrlSelect", "Select controls required:",
                                    setNames(1:4, c("selectInput", "numericInput", "dateInput", "sliderInput")))
                 , uiOutput("reqcontrols")           
                 , width = 3
               )
               , mainPanel(
                 uiOutput("reqplots")
                 , width = 9
               )
             )
             )
             , navbarMenu("GoogleVis",
                          tabPanel("Summary"),
                          tabPanel("Table")
             )
  )
)
