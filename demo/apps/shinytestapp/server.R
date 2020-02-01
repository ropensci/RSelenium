shinyServer(function(input, output, session) {
  # plots tab source code
  source("reqcontrols.R", local = TRUE)
  source("reqplots.R", local = TRUE)
})
