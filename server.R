library(leaflet)
library(sf)

shinyServer(function(input, output) {
  counties <- reactive(er_all_gu[[input$policy]][,c("stco_code", "state_name", "county", "pop_allages", input$ho, paste(input$ho, "ir", sep = "_"), paste(input$ho, "ircolor", sep = "_"), paste(input$ho, "irsq", sep = "_"))])
  output$test <- renderDataTable(counties())
  output$cmaq <- renderLeaflet(leaflet() %>% addTiles())
  
  options(scipen = 10)
  
  output$col <- renderPlot({
    par(mar=c(15,6,4,1))
    barplot(as.numeric(sums[[input$policy]]), names.arg = row.names(sums), main = paste("Health Outcomes Under ", input$policy, " Policy"),
            col = "darkgreen", log = "y", ylim = c(.1,100000), las=2)
    abline(h = c(.1, .31, 1,3.1,10,31,100,310,1000,3100, 10000, 31000,100000), lty = "dashed", col = "gray30")
    title(ylab="Count Prevented", line=4, cex.lab=1, family ="sans")
  })
  
  output$bar <- renderPlot({ 
    par(mar=c(5,7,4,1))
    barplot(as.numeric(sums[as.character(input$ho),]), names.arg = colnames(sums), 
            col = "darkblue", xlab = paste(input$ho, "Prevented"), las =1, horiz = T)
    title(strwrap(paste(input$ho, "Prevented Under Each Policy"), width = 40))
  })
  
  output$er <- renderLeaflet({
    leaflet()%>%
      addPolygons(data = counties(),
                  group = "No Fill",
                  weight = .1,
                  smoothFactor = .8,
                  opacity = 1,
                  label = paste(counties()[[3]], " || ", format(round(counties()[[5]], 2), nsmall = 2), " ", input$ho, " Prevented Annually || ", format(round(counties()[[6]], 2), nsmall = 2), " per ", oneOrTen[[input$ho]], " Million Population", sep = ""),
                  color = "Black",
                  fillOpacity = 0) %>%
      addPolygons(data = counties(),
                  group = "Choropleth View",
                  layerId = 420,
                  weight = .5,
                  smoothFactor = 0.5,
                  opacity = .4,
                  color = "Black",
                  label = paste(counties()[[3]], " || ", format(round(counties()[[5]], 2), nsmall = 2), " ", input$ho, " Prevented Annually || ", format(round(counties()[[6]], 2), nsmall = 2), " per ", oneOrTen[[input$ho]], " Million Population", sep = ""),
                  fillOpacity = .8,
                  fillColor = counties()[[7]],
                  highlightOptions = highlightOptions(color = "white", weight =2, bringToFront = T)) %>%
      addCircleMarkers( data = er_centroids,
                        group = "Centroid View",
                        layerId = 420,
                        radius = 12*counties()[[8]]/sqrt(LegendMax[[input$ho]]),
                        weight = .5,
                        opacity = 1,
                        color = "Black",
                        label = paste(counties()[[3]], " || ", format(round(counties()[[5]], 2), nsmall = 2), " ", input$ho, " Prevented Annually || ", format(round(counties()[[6]], 2), nsmall = 2), " per ", oneOrTen[[input$ho]], " Million Population", sep = ""),
                        fillOpacity = .8,
                        fillColor = counties()[[7]]) %>%
      addProviderTiles(providers$CartoDB.Voyager, options = tileOptions(minZoom = 5, maxZoom = 9)) %>%
      setView(lng = -74.3989, lat = 41.6000, zoom = 5)  %>%
      addLayersControl(position = "topleft",
                       baseGroups = c("Choropleth View", "Centroid View"),
                       options = layersControlOptions(collapsed = F)) %>%
      addLegend("bottomright", pal = colorNumeric(palgrcust, c(0,LegendMax[[input$ho]])), values = 0:LegendMax[[input$ho]], title = paste(input$ho, " Prevented</br>Annually per", oneOrTen[[input$ho]], "</br>Million Population"))
  })
})
