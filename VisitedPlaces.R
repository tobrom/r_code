library(shiny)
library(leaflet)
library(dplyr)

splat <- read.table(gzfile("worldcitiespop.txt.gz"), header=T, sep = ",")




cordData <- data.frame(place = c("Singapore", "Dublin"),
                       year = c(2012, 2013), 
                       latitude = c(1.290270, 53.350140),
                       longitude = c(103.851959, -6.266155))



ui <- fluidPage(titlePanel("Visited Places"),
  
                sidebarLayout(
                  
                  sidebarPanel(helpText("Choose a year and see on the map 
                                        which places you travelled to."),
                               
                               sliderInput("year", "Year:",
                                           min = 1988, max = 2017, value = 2017, step = 1, sep = "")),
                  
                  mainPanel(leafletOutput("mymap")), position = "right"))



server <- function(input, output) {

 points <- reactive({

   cordData %>% 
     subset(year <= input$year) 
   
  })
  

  
   output$mymap <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addMarkers(lat = points()[,3], lng = points()[,4], popup = points()[,1])
    
    })
}

shinyApp(ui, server)


