shinyUI(
  navbarPage("Shiny Test App"
             , tabPanel("Plots",  sidebarLayout(
               
               # Sidebar with a slider input
               sidebarPanel(
                 sliderInput("obs"
                             , "Number of observations:"
                             , min = 0
                             , max = 1000
                             , value = 500)
                 , width = 3
               )
               , mainPanel(
                 plotOutput("distPlot")
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
