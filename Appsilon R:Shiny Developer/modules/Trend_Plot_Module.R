library(shiny)
library(readr)
library(tidyverse)
library(future)

trendUI <- function(id) {
  ns <- NS(id)
  tagList(
    trendplotUI = wellPanel(plotlyOutput(ns("Trend"), height = "280px")))
}


trendServer <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      # plot title
      ## plot Trend
      output$Trend = renderPlotly({
        if(length(data()$cum_total > 0)) {
          ggplot() +
            geom_line(data = data(), aes(x = eventDate, y = cum_total)) +
            theme_classic() + xlab("Event Date") + ylab("Number of Observations") + 
            ggtitle(paste("Observed Trend"))
        }
      })
    })
}

