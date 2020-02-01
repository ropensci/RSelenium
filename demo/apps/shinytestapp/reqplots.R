# render the required plots based on user selection

output$reqplots <- renderUI({
  ctrlSelect <- 1:4 %in% as.numeric(input$ctrlSelect)
  plotList <- list(
    verbatimTextOutput("summary"),
    plotOutput("distPlot"),
    plotOutput("ggPlot"),
    dataTableOutput("dttable")
  )
  # add styles
  titles <- paste(c("selectInput", "numericInput", "dateRangeInput", "sliderInput"), "Output")
  style <- "float:left; margin:25px;"
  plotList <- lapply(seq_along(plotList), function(x) {
    tags$div(h6(titles[x]), plotList[[x]], style = style, class = "span5")
  })

  plotList[ctrlSelect]
})

# Return the requested dataset for ctrl 1
datasetInput <- reactive({
  switch(input$dataset,
    "rock" = rock,
    "pressure" = pressure,
    "cars" = cars
  )
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

# render ggplot2 for ctrl3
# adapted from http://stackoverflow.com/questions/11687739/two-legends-based-on-different-datasets-with-ggplot2
output$ggPlot <- renderPlot({

  #   if(is.null(input$daterange)){
  #     datastart <- presidential$start[1]
  #     dataend <- presidential$end[10]
  #   }else{
  datastart <- as.numeric(cut(as.Date(input$daterange), breaks = presidential$end))[1]
  datastart <- presidential$start[datastart]
  dataend <- as.numeric(cut(as.Date(input$daterange), breaks = c(presidential$start, Inf)))[2]
  dataend <- presidential$end[dataend]
  #   }
  economics <- economics[with(economics, date >= datastart & date <= dataend), ]
  presidential <- presidential[with(presidential, start >= datastart & end <= dataend), ]
  yrng <- range(economics$unemploy)
  #  xrng <- range(economics$date)
  xrng <- range(economics$date)
  economics <- cbind.data.frame(economics, col = gl(2, nrow(economics) / 2))
  g <- ggplot() + geom_line(aes(x = date, y = unemploy, color = col), data = economics)
  g <- g + geom_rect(aes(xmin = start, xmax = end, fill = party),
    ymin = yrng[1], ymax = yrng[2], data = presidential
  )
  g <- g + scale_fill_manual(values = alpha(c("blue", "red"), 0.2))
  g <- g + xlab("") + ylab("No. unemployed (1000s)")
  print(g)
})

# render table for ctrl 4
output$dttable <- renderDataTable(
  {
    diamonds[with(diamonds, price > input$range[1] & price < input$range[2]),
      c("carat", "cut", "color", "price"),
      drop = FALSE
    ]
  },
  options = list(
    aLengthMenu = c(5, 30, 50), iDisplayLength = 5
    #                 , aoColumns = "[{ sWidth: '50px'},{ sWidth: '50px'},{ sWidth: '50px'},{ sWidth: '50px'}]"
  )
)
