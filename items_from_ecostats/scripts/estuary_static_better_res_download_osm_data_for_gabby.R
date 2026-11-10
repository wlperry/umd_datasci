# =========================================================
# UROP estuary sites — DOWNLOAD OPENSTREETMAP HARBOR DETAILS
# Run this script ONCE. It saves everything to one file
# (data/harbor_osm.RData) that estuary_static.R loads.
# You only need to run it again if you want a bigger area.
# =========================================================

library(sf)
library(osmdata)
library(readxl)
library(janitor)
library(tidyverse)

# The main OSM server (overpass-api.de) is often overloaded and
# answers "HTTP 504 Gateway Timeout". Use a different server.
# If this one is also busy, try the other one in the comment.
set_overpass_url("https://maps.mail.ru/osm/tools/overpass/api/interpreter")
# set_overpass_url("https://overpass.kumi.systems/api/interpreter")

# ---------------------------------------------------------
# 1. SITES (same as in estuary_static.R)
# ---------------------------------------------------------
sites_sf <- read_excel("data/urop_sites_xl.xlsx") %>%
  clean_names() %>%
  rename(lat = north, lon = south) %>%
  mutate(lon = -abs(lon)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(26915)

# ---------------------------------------------------------
# 2. SEARCH AREAS
#    2 km from each site to the edge. This is bigger than the
#    close-up maps, so you can zoom the maps in or out (up to
#    2000 m) without downloading again.
#    OSM wants its search box in plain lon/lat (crs 4326).
# ---------------------------------------------------------
silver_bay_osm_box <- sites_sf %>%
  filter(sample_site == "Silver Bay") %>%
  st_buffer(2000) %>%
  st_transform(4326) %>%
  st_bbox()

two_harbors_osm_box <- sites_sf %>%
  filter(sample_site == "Two Harbors") %>%
  st_buffer(2000) %>%
  st_transform(4326) %>%
  st_bbox()

bayfield_osm_box <- sites_sf %>%
  filter(sample_site == "Bayfield") %>%
  st_buffer(2000) %>%
  st_transform(4326) %>%
  st_bbox()

# ---------------------------------------------------------
# 3. DOWNLOAD
#    Buildings, roads/paths, and piers/breakwalls for each harbor.
#    If one block gives an error (504, 429, timeout), wait a
#    minute and run just that block again.
# ---------------------------------------------------------

# Silver Bay
silver_bay_buildings <- opq(silver_bay_osm_box) %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()

silver_bay_roads <- opq(silver_bay_osm_box) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

silver_bay_piers <- opq(silver_bay_osm_box) %>%
  add_osm_feature(
    key = "man_made",
    value = c("pier", "breakwater", "groyne")
  ) %>%
  osmdata_sf()

# Two Harbors
two_harbors_buildings <- opq(two_harbors_osm_box) %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()

two_harbors_roads <- opq(two_harbors_osm_box) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

two_harbors_piers <- opq(two_harbors_osm_box) %>%
  add_osm_feature(
    key = "man_made",
    value = c("pier", "breakwater", "groyne")
  ) %>%
  osmdata_sf()

# Bayfield
bayfield_buildings <- opq(bayfield_osm_box) %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()

bayfield_roads <- opq(bayfield_osm_box) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

bayfield_piers <- opq(bayfield_osm_box) %>%
  add_osm_feature(
    key = "man_made",
    value = c("pier", "breakwater", "groyne")
  ) %>%
  osmdata_sf()

# ---------------------------------------------------------
# 4. SAVE
#    save() keeps the objects with their names; load() in the
#    map script brings them back exactly as they are here.
# ---------------------------------------------------------
save(
  silver_bay_buildings,
  silver_bay_roads,
  silver_bay_piers,
  two_harbors_buildings,
  two_harbors_roads,
  two_harbors_piers,
  bayfield_buildings,
  bayfield_roads,
  bayfield_piers,
  file = "data/harbor_osm.RData"
)
