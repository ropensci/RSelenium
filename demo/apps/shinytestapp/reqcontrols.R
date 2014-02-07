# render the required controls based on user selection
output$reqcontrols <- renderUI({
  ctrlSelect <- 1:4 %in% as.numeric(input$ctrlSelect)
  ctrlList <- list(selectInput("dataset", "Choose a dataset:", 
                               choices = c("rock", "pressure", "cars"))
                   , numericInput("obs", "Observations:", 10,
                                  min = 1, max = 100)
                   , dateInput("dateinput", "date label", value = NULL, min = NULL,
                               max = NULL, format = "yyyy-mm-dd", startview = "month",
                               weekstart = 0, language = "en")
                   , sliderInput("range", "Select range of diamond prices:",
                                 min = 326, max = 18823, value = c(1600,7900))
  )
  ctrlList[ctrlSelect]
})

