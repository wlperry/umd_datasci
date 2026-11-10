# =========================================================
# UROP estuary sites — STEP 1: DOWNLOAD THE MAP LAYERS
# Run this script ONCE. It saves everything into one file
# (data/map_layers.RData) that 02_make_maps.R loads.
# Run it again only if you add sites or want a bigger area.
# =========================================================

library(sf)
library(tigris)        # US states, counties, and water (Census)
library(rnaturalearth) # Canada
library(osmdata)       # buildings, roads, piers (OpenStreetMap)
library(readxl)
library(janitor)
library(tidyverse)

options(tigris_use_cache = TRUE)

# OSM data comes from an "Overpass" server. Servers get busy and
# answer "HTTP 504 Gateway Timeout". If that happens, put a # in
# front of the active line and remove the # from another one.
set_overpass_url("https://overpass-api.de/api/interpreter")
# set_overpass_url("https://maps.mail.ru/osm/tools/overpass/api/interpreter")
# set_overpass_url("https://overpass.kumi.systems/api/interpreter")

# ---------------------------------------------------------
# 1. SITES
#    In the sheet, "north" = latitude and "south" = longitude.
#    Longitude was entered as a positive number, so we make it
#    negative (west of Greenwich).
#    st_transform(26915) puts the points in UTM zone 15
#    (units = meters), so a 2000 m buffer really is 2 km.
# ---------------------------------------------------------
sites_sf <- read_excel("data/urop_sites_xl.xlsx") %>%
  clean_names() %>%
  rename(lat = north, lon = south) %>%
  mutate(lon = -abs(lon)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(26915)

# ---------------------------------------------------------
# 2. OVERVIEW MAP LAYERS (the whole western end of the lake)
#    cb = TRUE gives state outlines already cut at the shoreline.
# ---------------------------------------------------------
states_sf <- states(cb = TRUE, resolution = "500k") %>%
  filter(STUSPS %in% c("MN", "WI", "MI"))

ontario_sf <- ne_states(country = "Canada", returnclass = "sf") %>%
  filter(name == "Ontario")

# ---------------------------------------------------------
# 3. CLOSE-UP MAP LAYERS (land and lake around each harbor)
#    Silver Bay and Two Harbors are in Lake County, MN.
#    Bayfield is in Bayfield County, WI.
#    cb = FALSE gives the detailed county shapes. These run out
#    into the lake, so we also download the water (Lake
#    Superior, harbors like Agate Bay, rivers, inland lakes)
#    and paint it on top in the map script.
# ---------------------------------------------------------
counties_sf <- bind_rows(
  counties(state = "MN", cb = FALSE) %>% filter(NAME == "Lake"),
  counties(state = "WI", cb = FALSE) %>% filter(NAME == "Bayfield")
)

water_sf <- bind_rows(
  area_water(state = "MN", county = "Lake"),
  area_water(state = "WI", county = "Bayfield")
)

# ---------------------------------------------------------
# 4. OSM SEARCH AREAS
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
# 5. OSM DOWNLOAD
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
# 6. SAVE
#    save() keeps the objects with their names; load() in the
#    map script brings them back exactly as they are here.
# ---------------------------------------------------------
save(
  states_sf,
  ontario_sf,
  counties_sf,
  water_sf,
  silver_bay_buildings,
  silver_bay_roads,
  silver_bay_piers,
  two_harbors_buildings,
  two_harbors_roads,
  two_harbors_piers,
  bayfield_buildings,
  bayfield_roads,
  bayfield_piers,
  file = "data/map_layers.RData"
)
