library(shiny)

shinyUI(fluidPage(
  titlePanel("Nearest EV charging outlets"),
  
  sidebarLayout(
  sidebarPanel(
  helpText("Enter your postcode. Please be patient while the map loads..."),
  textInput("pcode", "Postcode", "SE1 2LB"),
  helpText("If you don't know any UK postcodes and want to test this, try the following:"),
  helpText("Edinburgh Zoo: EH12 6TS"),
  helpText("Liverpool Airport: L24 1YD"),
  helpText("Cardiff Principality Stadium: CF10 1NS"),
  
  # Simple integer interval slider for zooming the map
  sliderInput("zoom", "Zoom:", min=3, max=21, value=15)
  ),
    
  mainPanel(plotOutput("map"),textOutput("details"),textOutput("charger1"),textOutput("charger2"),textOutput("charger3"))
    
  )
))

## Possible improvements
## Add filters: connector-type and rated output in kWs
## Find a different API that offers more charging locations (beyond the UK)
## UI improvements - would be good to get pop-up details if you hover over the location!
