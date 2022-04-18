library(shiny)
library(readr)
library(tidyverse)
datapreviewUI <- function(id) {
  ns <- NS(id)
  tagList(
    datasetpreviewUI = 
      wellPanel(
        h5("data preview"), 
        rHandsontableOutput(ns("Datapreview"), height = "280px")))
}

datapreviewServer <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      output$Datapreview = renderRHandsontable({
        data() %>% rhandsontable(readOnly = TRUE)
      })
    })
}


