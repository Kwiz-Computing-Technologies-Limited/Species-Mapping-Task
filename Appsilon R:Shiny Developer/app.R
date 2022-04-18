library(shiny)
library(readr)
library(tidyverse)
library(future)
library(data.table)
library(leaflet)
library(rhandsontable)
library(plotly)
library(bslib)

source("modules/Data_Module.R")
source("modules/Map_Module.R")
source("modules/Trend_Plot_Module.R")
source("modules/Preview_Module.R")


occurence = read_csv("WWW/occurence_poland_.csv",  show_col_types = F)

ui <- fluidPage(
  theme = bs_theme(version = 4, 
                   bootswatch = "sketchy"),
  wellPanel(
    fluidRow(
      mainPanel(
        theme = bs_theme(version = 4, bootswatch = "sketchy"),
        h2("Mapping Species Counts in Poland Through Time"),
        mappingUI("map")
      ),
      
      sidebarPanel(
        datapreviewUI(id = "Datapreview"),
        trendUI(id = "Trend"),
        dataUI(id = "Species")
        ))
  )
  )


server <- function(input, output, session) { 
  # species selection
 dataset = dataServer(id = "Species", data = occurence)
 mappingServer(id = "map", data = dataset)
 trendServer(id = "Trend", data = dataset)
 datapreviewServer(id = "Datapreview", data = dataset)
  }


shinyApp(ui, server)









