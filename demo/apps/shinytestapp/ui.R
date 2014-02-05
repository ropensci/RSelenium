shinyUI(navbarPage("Shiny Test App"
                   , tabPanel("Plots",  sidebarLayout(
                     
                     # Sidebar with a slider input
                     sidebarPanel(
                       sliderInput("obs"
                                   , "Number of observations:"
                                   , min = 0
                                   , max = 1000
                                   , value = 500)
                     )
                     , mainPanel(
                       plotOutput("distPlot")
                     )
                   )
                   )
                   , navbarMenu("GoogleVis",
                              tabPanel("Summary"),
                              tabPanel("Table")
                   )
))
