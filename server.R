# server.R

library(shiny)
library(ggmap)

shinyServer(function(input, output) {
  des<-reactive({ gsub(input$pcode, pattern=" ",replacement="+") }) ## Munge postcode to replace space with +
  ## Build API call based on postcode and limited to 3 charging locations, within 20 miles, returning data in CSV
  ## e.g. http://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/EC3A+7BR/limit/3/ for "EC3A 7BR"
  location<- reactive({ paste("http://chargepoints.dft.gov.uk/api/retrieve/registry/postcode/", des(), "/limit/3/dist/20/format/csv/", sep="") })
  
  ## Read CSV data
  chargers <- reactive({ read.csv(location())})
  
  output$map <- renderPlot({
  
  ## I've no idea why I can't just use input$zoom in the map() function. This is a workaround.  
  map <- switch(as.character(input$zoom), 
                   "3" = qmap(input$pcode, zoom=3),
                   "4" = qmap(input$pcode, zoom=4),
                   "5" = qmap(input$pcode, zoom=5),
                   "6" = qmap(input$pcode, zoom=6),
                   "7" = qmap(input$pcode, zoom=7),
                   "8" = qmap(input$pcode, zoom=8),
                   "9" = qmap(input$pcode, zoom=9),
                   "10" = qmap(input$pcode, zoom=10),
                   "11" = qmap(input$pcode, zoom=11),
                   "12" = qmap(input$pcode, zoom=12),
                   "13" = qmap(input$pcode, zoom=13),
                   "14" = qmap(input$pcode, zoom=14),
                   "15" = qmap(input$pcode, zoom=15),
                   "16" = qmap(input$pcode, zoom=16),
                   "17" = qmap(input$pcode, zoom=17),
                   "18" = qmap(input$pcode, zoom=18),
                   "19" = qmap(input$pcode, zoom=19),
                   "20" = qmap(input$pcode, zoom=20),
                   "21" = qmap(input$pcode, zoom=21)
                )  
    
   ## Work out lat/longitude of postcode and plot it on the map in blue, plot charger locations in red
  pcodeLatLon<-geocode(input$pcode, output="latlon", source="google")
  map + geom_point(data=pcodeLatLon, aes(x = lon, y=lat), color="blue", size=3, alpha=0.5) + geom_point(data = chargers(), aes(x = longitude, y = latitude), color="red", size=3, alpha=0.5)
  })
  
  # Put some basic details in text below the map - name and postcode of charger
  output$details <- renderText({paste("Nearest chargers to", input$pcode, "are:")})
  output$charger1 <- renderText({paste("1:", chargers()$name[1], chargers()$postcode[1])})
  output$charger2 <- renderText({paste("2:", chargers()$name[2], chargers()$postcode[2])})
  output$charger3 <- renderText({paste("3:", chargers()$name[3], chargers()$postcode[3])})

})



