# Timeline scroll Module
## UI
dataUI <- function(id) {
  ns <- NS(id)
  tagList(
    speciesUI = selectizeInput(ns("Species"), "Select Species", choices = c(NA), width = 200),
    timelineUI = sliderInput(ns("Timeline"), "Scroll Through Time", 
                                       min = as.Date("2016-01-01","%Y-%m-%d"),
                                       max = as.Date("2016-12-01","%Y-%m-%d"),
                                       value = as.Date("2016-12-01"),
                                       timeFormat="%Y-%m-%d"))
}

## Server
dataServer <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      # reactive values
      track.values = reactiveValues(
        data = data,
        filtered_data = data.frame()
      )
      
      # update Species user selection/filter options from the list of species available in the data
      observe({
        species %<-% unique(track.values$data$scientificName)
        species_vernacular %<-% unique(track.values$data$vernacularName)
        updateSelectizeInput(
          session = session,
          inputId = "Species",
          choices = c(species, species_vernacular, "All"),
          server = T
        )
      })
      
      # filter data based on user input
  
      observe({
        data %<-% track.values$data
        data = data %>% filter(individualCount > 0) %>% 
          filter(if (input$Species != "All") {data$scientificName == input$Species | data$vernacularName == input$Species} else
            !is.null(data$scientificName))
        
        track.values$filtered_data = data[data$eventDate < input$Timeline,] %>% data.frame() 
      })
      
      # update slider based on user input
      observe({
        min %<-% min(track.values$data$eventDate) 
        max %<-% max(track.values$data$eventDate)  
        
        updateSliderInput(
          session = shiny::getDefaultReactiveDomain(),
          inputId = "Timeline",
          min = min,
          max = max
        )
      })
  
  
      return(
        dataset = reactive(track.values$filtered_data))
      }
    )}

