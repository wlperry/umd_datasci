# ==========================================================
# Activity 17 - Mapping: Bigfoot, moose, and live maps
# Name:
# Date:
#
# Save as scripts/17_mapping.R
#
# ALL the code is written for you today. Run it chunk by
# chunk, look at what comes out, then change things and see
# what breaks. That is the point of today.
#
# The THINK lines are to talk about, not to answer here.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file: 17_mapping_homework.R
# ==========================================================

# Install these ONCE, from the Console, BEFORE class:
# install.packages("rgbif")
# install.packages("leaflet")

# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf)       # spatial data frames
library(maps)     # ready-made country and state outlines
library(rgbif)    # download species records from GBIF
library(leaflet)  # live, zoomable maps

invisible(NULL)


# ---- 1 Bigfoot reports, trimmed to the lower 48 ----------
# The four numbers are a BOUNDING BOX around the lower 48.
# It throws Alaska and Hawaii away on purpose - remember
# that in section 7, when we want Alaska back.

bigfoot_df <- read_csv("data/bfro_reports_geocoded.csv") %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  filter(longitude > -125, longitude < -66,
         latitude  >   24, latitude  <  50)

nrow(bigfoot_df)

invisible(NULL)


# ---- 2 Make it spatial -----------------------------------
# x FIRST: coords = c("longitude", "latitude")

bigfoot_sf <- bigfoot_df %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

ggplot(bigfoot_sf) +
  geom_sf(alpha = 0.2, size = 0.5)

# THINK: the points drew a recognizable USA with no map
# underneath. What is a "map", then?

invisible(NULL)


# ---- 3 Put it on a real map ------------------------------
# Basemap FIRST, points on top.

states_sf <- st_as_sf(
  maps::map("state", plot = FALSE, fill = TRUE)
) %>%
  st_set_crs(4326)

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey75") +
  geom_sf(data = bigfoot_sf, alpha = 0.2, size = 0.5, color = "firebrick") +
  theme_void()

# THINK: is this map about BIGFOOT, or about PEOPLE - where
# they live, hike, and file reports? Hold onto that. The
# moose data has the same problem.

invisible(NULL)


# ---- 4 Meet GBIF -----------------------------------------
# GBIF pools occurrence records from museums, herbaria,
# surveys, and apps like iNaturalist. rgbif queries it from
# R. You need the SCIENTIFIC name - "moose" will not work.
#
#   scientificName - genus and species, spelled exactly
#   country        - two-letter code
#   hasCoordinate  - skip records with no lat/long
#   limit          - how many records to bring back
#   $data          - occ_data() returns a list; the records
#                    are in its `data` slot

moose_raw <- occ_data(
  scientificName = "Alces alces",
  country        = "US",
  hasCoordinate  = TRUE,
  limit          = 2000
)$data

dim(moose_raw)

# 119 columns. GBIF carries everything anyone recorded.

invisible(NULL)


# ---- 5 What did limit actually give you? -----------------
# How many US moose records does GBIF actually have?
occ_count(scientificName = "Alces alces", country = "US")

# And what years did OUR 2000 records come from?
moose_raw %>%
  count(year, sort = TRUE)

# THINK: about 28,000 records exist, you asked for 2000,
# and they all came from ONE year. So limit is not a random
# sample - it is a CUTOFF. What does that do to any claim
# you make about "the range" of a species?

invisible(NULL)


# ---- 6 Trim and make it spatial --------------------------
# GBIF calls its coordinates decimalLongitude and
# decimalLatitude. Same recipe, different names.
# LONGITUDE STILL GOES FIRST.

moose_df <- moose_raw %>%
  select(species, stateProvince, decimalLatitude,
         decimalLongitude, year) %>%
  filter(!is.na(decimalLongitude), !is.na(decimalLatitude))

moose_df %>%
  count(stateProvince, sort = TRUE) %>%
  head()

moose_sf <- moose_df %>%
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
           crs = 4326)

moose_sf

# THINK: which state has the most moose records?

invisible(NULL)


# ---- 7 A basemap with Alaska in it -----------------------
# states_sf from section 3 is the lower 48 ONLY. The biggest
# cluster of moose in the country is in Alaska, so we need a
# different basemap.
#
# The coord_sf() limits matter: without them the map runs
# out to the Aleutians, which cross the date line, and the
# whole country squashes into a sliver.

usa_sf <- st_as_sf(
  maps::map("world", regions = "USA", plot = FALSE, fill = TRUE)
) %>%
  st_set_crs(4326)

ggplot() +
  geom_sf(data = usa_sf, fill = "grey96", color = "grey75") +
  geom_sf(data = moose_sf, alpha = 0.3, size = 0.7, color = "darkgreen") +
  coord_sf(xlim = c(-170, -60), ylim = c(25, 72)) +
  theme_void()

# THINK: where are the moose? Does that match what you know
# about the species - and about where it is cold?

invisible(NULL)


# ---- 8 Your first live map -------------------------------
# leaflet makes a REAL web map - tiles, pan, zoom - in the
# RStudio Viewer pane.
#
#   leaflet(moose_sf)   start a map from your sf object
#   addTiles()          the world map underneath, from the web
#   addCircleMarkers()  a dot on every record
#
# ZOOM IN. Anchorage. The Colorado Rockies. Maine.

leaflet(moose_sf) %>%
  addTiles() %>%
  addCircleMarkers(radius = 4, stroke = FALSE,
                   fillOpacity = 0.6, color = "darkgreen")

# THINK: zoom all the way in on a cluster. Do the points
# land in forest and wetland, or along ROADS and TOWNS?

invisible(NULL)


# ---- 9 Labels on the dots --------------------------------
# The ~ makes popup a FORMULA - "look these columns up for
# each row". <br> is a line break, because the popup is a
# little web page.

leaflet(moose_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    radius      = 4,
    stroke      = FALSE,
    fillOpacity = 0.6,
    color       = "darkgreen",
    popup       = ~paste0(species, "<br>", stateProvince, "<br>", year)
  )

# THINK: click a few dots. Is every record the species you
# asked for?

invisible(NULL)


# ---- 10 If there is time: sightings per state ------------
# Last class's left_join(), pointed at a map. Counts are one
# table, polygons are another, and `state` is the key.

sightings_by_state <- bigfoot_df %>%
  mutate(state = str_to_lower(state)) %>%
  count(state, name = "sightings")

states_map <- states_sf %>%
  mutate(state = str_remove(ID, ":.*")) %>%   # drop ":north" etc.
  left_join(sightings_by_state, by = "state")

# direction = -1 makes MORE sightings = DARKER.
# crs = 5070 is an equal-area projection for the lower 48 -
# which is why we did NOT use it on the moose map, where it
# would have mangled Alaska.

ggplot(states_map) +
  geom_sf(aes(fill = sightings), color = "white") +
  scale_fill_viridis_c(option = "magma", direction = -1) +
  coord_sf(crs = 5070) +
  theme_void()

# THINK: exactly one polygon comes back NA and draws grey.
# Broken join, or a true zero? How would you tell?

invisible(NULL)


# ==========================================================
# End of the in-class script.
#
# THE HOMEWORK IS A SEPARATE FILE:
#   17_mapping_homework.R
#
# Open it now and read the top of it.
# ==========================================================
