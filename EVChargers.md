Electric Vehicle Charger Locations
========================================================
author: Jo Stichbury
date: May 2016
autosize: true


If you own an electric vehicle, one of the things you worry about is where you can charge it. 
I've created a shiny app (https://stichbury.shinyapps.io/evchargers) that helps you find the nearest charging stations.
- Type in the postcode (where you are, or where you are going)
- The app finds 3 locations of chargers that are within 20 miles of that postcode
- It plots them in red on a map, which can be zoomed in and out. Your location is shown in blue.
- Finally, it lists the names and post codes of each charging station.

Data Source
========================================================

The charging station data are provided in CSV format
- Accessed through a web API.
- The API is provided by the UK National Charge Point Registry (NCR)
- More information https://data.gov.uk/dataset/national-charge-point-registry

Of course, this means that the data is for drivers in the UK only
- The project could be enhanced by finding worldwide datasets or
- The UI could be updated to allow the user to select a country of interest, and different datasets used as necessary.

Code: ui.R
========================================================

The UI code is relatively straightforward


```r
library(shiny)
shinyUI(fluidPage(
  titlePanel("Nearest EV charging outlets"),
  
  sidebarLayout(
  sidebarPanel(
  helpText("Enter your postcode. Please be patient while the map loads..."),
  textInput("pcode", "Postcode", "SE1 2LB"),
  
  # Simple integer interval slider for zooming the map
  sliderInput("zoom", "Zoom:", min=3, max=21, value=15)
  ),
  mainPanel(plotOutput("map"),textOutput("details"),textOutput("charger1"),
            textOutput("charger2"),textOutput("charger3"))
  )
))
```
 
Code: server.R
========================================================

The server code 


```r
shinyServer(function(input, output) {
  des<-reactive({ gsub(input$pcode, pattern=" ",replacement="+") }) ## Munge postcode to replace space with +
  location<- reactive({ paste("http://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/", des(), "/limit/3/dist/20/format/csv/", sep="") })
  chargers <- reactive({ read.csv(location())})
  output$map <- renderPlot({
  map <- switch(as.character(input$zoom), 
                   "3" = qmap(input$pcode, zoom=3),
                   "4" = qmap(input$pcode, zoom=4),
                  # ... 
                   "21" = qmap(input$pcode, zoom=21))  
  pcodeLatLon<-geocode(input$pcode, output="latlon", source="google")
  map + geom_point(data=pcodeLatLon, aes(x = lon, y=lat), color="blue", size=3, alpha=0.5) + geom_point(data = chargers(), aes(x = longitude, y = latitude), color="red", size=3, alpha=0.5)
  })
    output$details <- renderText({paste("Nearest chargers to", input$pcode, "are:")})
  output$charger1 <- renderText({paste("1:", chargers()$name[1], chargers()$postcode[1])})
  #...
})
```

Improvements
========================================================
A number of ideas to improve the usability of the app:
- Filters to allow the driver to search for chargers that are suitable for his/her car
- Better user experience 
   + the map is slow to load and cannot be moved around (centres on the postcode location)
   + the display is not very pretty (I'm not a designer!)
   + it would be better to return the charger location information to the UI for it to display
- Have an option to use the current location (where it's available) rather than require a postcode entry
- Setting to select a charger then show the route to reach it.
