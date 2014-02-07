# render the required plots based on user selection

output$reqplots <- renderUI({
  ctrlSelect <- 1:4 %in% as.numeric(input$ctrlSelect)
  plotList <- list(verbatimTextOutput("summary")
                   , plotOutput("distPlot")
                   , ""
                   , dataTableOutput("dttable")
  )
  # add styles
  titles <- paste(c("selectInput", "numericInput", "dateInput", "sliderInput") , "Output")
  style <- "float:left; margin:5px;"
  plotList <- lapply(seq_along(plotList), function(x){
    tags$div(h6(titles[x]), plotList[[x]], style = style, width = 6)
  }
  )
  
  plotList[ctrlSelect]
})

# Return the requested dataset for ctrl 1
datasetInput <- reactive({
  switch(input$dataset,
         "rock" = rock,
         "pressure" = pressure,
         "cars" = cars)
})

# Generate a summary of the dataset for ctrl 1
output$summary <- renderPrint({
  dataset <- datasetInput()
  summary(dataset)
})

# render plot for ctrl 2
output$distPlot <- renderPlot(width = 300, {
  
  # generate an rnorm distribution and plot it
  dist <- rnorm(input$obs)
  hist(dist)
})

# render table for ctrl 4
output$dttable = renderDataTable({
  diamonds[with(diamonds, price > input$range[1] & price < input$range[2])
           , c("carat", "cut", "color", "price"), drop = FALSE]
}
, options = list(aLengthMenu = c(5, 30, 50), iDisplayLength = 5))
