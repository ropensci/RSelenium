# render the required controls based on user selection
output$reqcontrols <- renderUI({
  ctrlSelect <- 1:4 %in% as.numeric(input$ctrlSelect)
  ctrlList <- list(
    selectInput("dataset", "Choose a dataset:",
      choices = c("rock", "pressure", "cars")
    ),
    numericInput("obs", "Observations:", 10,
      min = 1, max = 100
    ),
    dateRangeInput("daterange", "Date range:",
      start = as.character(min(economics$date)),
      end = as.character(max(economics$date)),
      min = as.character(min(economics$date)),
      max = as.character(max(economics$date)),
      format = "mm/dd/yyyy",
      separator = " - "
    ),
    sliderInput("range", "Select range of diamond prices:",
      min = 326, max = 18823, value = c(1600, 7900)
    )
  )
  ctrlList[ctrlSelect]
})
