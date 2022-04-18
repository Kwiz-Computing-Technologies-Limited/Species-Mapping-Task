# Timeline scroll Module
## UI

mappingUI <- function(id) {
  ns <- NS(id)
  tagList(
    mapUI = leafletOutput(ns("map"), height = 900))
}

## Server
mappingServer <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      
      output$map = renderLeaflet({
        data() %>% 
          leaflet() %>% 
          addTiles() %>% 
          addCircleMarkers(lng = data()$lng, lat = data()$lat, 
                           popup = paste(paste(h5("Date"), data()$eventDate),
                                         paste(h4("coordinates"), "[", data()$lat, "N:",
                                               data()$lng, "E]", sep = " "),
                                         paste(h4("Species"), 
                                               unique(data()$scientificName),
                                               "(",
                                               unique(data()$vernacularName),
                                               ")"),
                                         paste(h4("Count"), 
                                               "(", 
                                               data()$individualCount, ")"), 
                                         paste(h4("Occupancy %"), 
                                               "(", 
                                               round(data()$proportion*100, 2), ")"),
                                         paste(h4("Other Species Present"),  
                                               ifelse(data()$proportion == 1, NA, 
                                                      unlist(data()$other_species))), sep = "  "), 
                           popupOptions = list(autoClose = F),
                           clusterOptions = markerClusterOptions(),
                           opacity = data()$proportion) 
      })
      
      

    })
}



