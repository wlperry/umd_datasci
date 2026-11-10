# =========================================================
# UROP estuary sites — INTERACTIVE (ZOOMABLE) MAP OF ALL SITES
# Opens on the same area as the static map: the Duluth-Superior
# estuary (west) to Madeline Island (east).
# Base maps are OpenStreetMap and Esri tiles (no API key).
# =========================================================

library(sf)
library(leaflet)
library(htmlwidgets)
library(readxl)
library(janitor)
library(tidyverse)

# ---------------------------------------------------------
# 1. LOAD SITES
#    In the sheet, "north" = latitude and "south" = longitude.
#    Longitude was entered as a positive number, so we make it
#    negative (west of Greenwich).
# ---------------------------------------------------------
sites_df <- read_excel("data/urop_sites_xl.xlsx") %>%
  clean_names() %>%
  rename(lat = north, lon = south) %>%
  mutate(lon = -abs(lon))

# Turn the table into map points. Leaflet wants plain lon/lat
# (crs 4326), so there is no st_transform() here.
# remove = FALSE keeps the lat and lon columns for the pop-ups.
sites_sf <- sites_df %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

# ---------------------------------------------------------
# 2. BUILD THE MAP
#    Each %>% adds one piece. Base maps can be switched in the
#    menu at the top right; click a red dot to see its coordinates.
# ---------------------------------------------------------
estuary_leaflet <- leaflet(sites_sf) %>%
  # Base maps
  addProviderTiles(providers$OpenStreetMap, group = "Streets") %>%
  addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Light gray") %>%
  addProviderTiles(providers$Esri.WorldTopoMap, group = "Topographic") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  # Sample sites (red dots) with names always showing
  addCircleMarkers(
    radius = 7,
    color = "white",
    weight = 1.5,
    fillColor = "red",
    fillOpacity = 0.9,
    label = ~sample_site,
    labelOptions = labelOptions(
      noHide = TRUE,
      direction = "right",
      textsize = "13px"
    ),
    popup = ~ paste0(
      "<b>",
      sample_site,
      "</b><br>",
      round(lat, 5),
      ", ",
      round(lon, 5)
    )
  ) %>%
  # Menu to switch base maps
  addLayersControl(
    baseGroups = c("Streets", "Light gray", "Topographic", "Satellite"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  # Scale bar and a ruler tool for measuring distances
  addScaleBar(
    position = "bottomleft",
    options = scaleBarOptions(imperial = FALSE)
  ) %>%
  addMeasure(
    primaryLengthUnit = "meters",
    secondaryLengthUnit = "kilometers"
  ) %>%
  # Starting view: the same four edges as the static map
  fitBounds(lng1 = -92.25, lat1 = 46.55, lng2 = -90.55, lat2 = 47.40)

estuary_leaflet

# ---------------------------------------------------------
# 3. SAVE
#    A single HTML file that opens in any web browser.
# ---------------------------------------------------------
saveWidget(
  estuary_leaflet,
  "urop_estuary_interactive_map.html",
  selfcontained = TRUE
)
