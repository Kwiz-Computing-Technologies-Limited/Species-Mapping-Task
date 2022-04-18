# Species-Mapping-Task
This is a submission as part of the Interview process for the Rshiny Developer Role


# This file contains information on the Shiny Web Application created to visualize the number of select species in Poland through time. Data for Poland was extracted and processed to include:

- "other_species": a column with list of all species in that location
- "cumsum_all": total number of individuals observed on the observation day irrespective of species or location
- "total_occurence": total number of individuals observed at a location on the observation day irrespective of species
- "proportion": the proportion of individuals of a particular species, observed on the event day relative to the "total_occurence" on the observation day
- "cum_total": the cummulative observations of a species with time
These required no user inputs and the preprocessing was done locally such that only the ready dataset is used in the application.  

# Code used to process the Map Data outside of the Application
_________________________________________________________________________
library(data.table)
library(dplyr)
library(readr)

occurence = fread("~/Downloads/biodiversity-data/occurence.csv",
                  select = c("scientificName",  "vernacularName", "individualCount", "longitudeDecimal", "latitudeDecimal", "country",  "eventDate")) %>% filter(country == "Poland") %>%
  select(-country)
  
occurence2 = distinct(occurence)

occurence2 = occurence2[order(occurence2$eventDate, decreasing = F),]

# rename the longitude and latitude columns
occurence2 = rename(occurence2, lng = longitudeDecimal, lat = latitudeDecimal) 

# get list of species on each location on the event day and
other_species = occurence2[,.(
  other_species = as.character(list(unique(paste(scientificName, "(", vernacularName,")"))))
),
by = list(lng, lat, eventDate)] %>% ungroup()
occurence2 = left_join(occurence2, other_species)

# calculate cumulative occurrence of species per location on the event day
total_occurence = aggregate(individualCount ~ lng + lat + eventDate, data = occurence2, FUN = sum) 
total_occurence = rename(total_occurence, total_occurence = individualCount)
occurence2 = left_join(occurence2, total_occurence)


# calculate cumulative occurrence of EACH species on the event day
cum_total = aggregate(individualCount ~ eventDate + scientificName, data = occurence2, FUN = sum)
cum_total = rename(cum_total, cum_total = individualCount)
cum_total$cum_total = unlist(cum_total$cum_total)
occurence2 = left_join(occurence2, cum_total)

# calculate cumulative occurrence of species on the event day
cumsum_all = aggregate(individualCount ~ eventDate, data = occurence2, FUN = sum)
cumsum_all = rename(cumsum_all, cumsum_all = individualCount)
cumsum_all$cumsum_all = unlist(cumsum_all$cumsum_all)
occurence2 = left_join(occurence2, cumsum_all)

# calculate proportion of each species in a location
occurence2 = mutate(occurence2, proportion = cum_total/total_occurence)
# convert column with list of other species from list to character
fwrite(occurence2, "WWW/occurence_poland_.csv")
_________________________________________________________________________

# The application has 4 modules; 

- "Data_Module.R" defines the "species selection" and "timeline/scrol" UI elements and uses these inputs to filter the data for the specific user inputs. *Selectisize* is used to efficiently handle the large number of species selection options. Users can search/select a species by both the scientific or vernacular name. 

- "Trend_Module.R" uses the filtered data to produce a reactive *gg-line plot*  tracing "cum_total"  based on the user inputs

- "Preview_Module.R" uses the filtered data to produce a reactive table with the data matching the user inputs

- "Map_Module.R" defines the *leaflet* Map UI and updates it with the counts for the species in a location. Counts are aggregated as you zoom out while you get a pop_up with additional specific information to that point 

The application is hosted at shinyapps.io and can be accessed through:
https://zp1mwp-jean0victor-kwizera.shinyapps.io/Appsilon_code_challenge/

The"Sketchy" theme from Bootswatch is used to style the UI
