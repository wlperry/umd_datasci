# Access NOAA from within R to get the data
# # - note this is DAILY data so dont freak at the number of rows

# # install packages - if not installed
# install.packages("GSODR")

# libraries needed for analysis
library(tidyverse)
library(GSODR)
# https://cran.r-project.org/web/packages/GSODR/vignettes/GSODR.html

# # Or access the vignette which has full descriptions
# vignette("GSODR")

# get a list of stations
load(system.file("extdata", "isd_history.rda", package = "GSODR"))
mn_stations_df <- subset(isd_history, STATE == "MN")
no_stations_df <- subset(isd_history, CTRY == "IC")

# we can alos look for countries that have data
no_stations_df <- subset(isd_history, CTRY == "IC")
no_stations_df

station_df

# Cleaner interface for daily summaries
duluth_df <- get_GSOD(years = 1948:2025, station = "727450-14913")
