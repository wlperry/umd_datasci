# =========================================================
# UROP estuary sites — STEP 2: MAKE THE MAPS
# Run 01_download_map_data.R once first. This script only
# loads the saved layers, so it runs fast and works offline.
#
# Maps made:
#   1. Overview map of all three sites
#   2. Close-up map of Silver Bay
#   3. Close-up map of Two Harbors
#   4. Close-up map of Bayfield
# Each one is saved as a .png in the figures folder.
# =========================================================

library(sf)
library(ggspatial) # scale bar and north arrow
library(readxl)
library(janitor)
library(tidyverse)

# ---------------------------------------------------------
# 1. LOAD
# ---------------------------------------------------------
load("data/map_layers.RData")

# In the sheet, "north" = latitude and "south" = longitude.
# Longitude was entered as a positive number, so we make it
# negative (west of Greenwich).
sites_sf <- read_excel("data/urop_sites_xl.xlsx") %>%
  clean_names() %>%
  rename(lat = north, lon = south) %>%
  mutate(lon = -abs(lon)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(26915)

# ---------------------------------------------------------
# 2. COLORS
#    Change them here and every map changes.
# ---------------------------------------------------------
lake_color <- "#bcd9ea"
land_color <- "#f3efe6"
border_color <- "grey60"
road_color <- "grey60"
highway_color <- "#e0a458"
building_color <- "grey45"
pier_color <- "#6b4e31"
site_color <- "#d7301f"

# ---------------------------------------------------------
# 3. OVERVIEW MAP
#    The panel background is painted the lake color, and the
#    land is drawn on top, so anything that is not land
#    looks like water.
#    coord_sf() does two jobs:
#      crs = 26915      -> draw the map in UTM zone 15 (meters)
#      xlim and ylim    -> the edges of the map, given in
#                          longitude and latitude because of
#                          default_crs = 4326
#    To zoom in or out, change the four numbers in xlim/ylim.
# ---------------------------------------------------------
overview_map <- ggplot() +
  geom_sf(data = states_sf, fill = land_color, color = border_color) +
  geom_sf(data = ontario_sf, fill = land_color, color = border_color) +
  geom_sf(
    data = sites_sf,
    shape = 21,
    size = 4,
    fill = site_color,
    color = "white",
    stroke = 1
  ) +
  geom_sf_label(
    data = sites_sf,
    aes(label = sample_site),
    nudge_x = -0.12, # move labels left (degrees of longitude)
    nudge_y = 0.04, # and up (degrees of latitude)
    size = 3.5
  ) +
  annotate(
    "text",
    x = -91.20,
    y = 46.95,
    label = "Lake Superior",
    fontface = "italic",
    color = "#3b6e8f",
    size = 5
  ) +
  annotation_scale(location = "bl", width_hint = 0.25) +
  annotation_north_arrow(
    location = "tr",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    style = north_arrow_orienteering()
  ) +
  coord_sf(
    crs = 26915,
    default_crs = 4326,
    xlim = c(-92.25, -90.55),
    ylim = c(46.55, 47.40)
  ) +
  labs(x = NULL, y = NULL) +
  theme_bw() +
  theme(panel.background = element_rect(fill = lake_color))

overview_map

ggsave(
  "figures/01_overview_map.png",
  overview_map,
  width = 8,
  height = 6,
  dpi = 300
)

# ---------------------------------------------------------
# 4. CLOSE-UP MAPS
#    Same idea, with more layers:
#      land (county)  -> water on top -> roads -> buildings
#      -> piers -> the site
#    Layers are drawn in the order you add them, so later
#    layers sit on top of earlier ones.
#
#    The OSM downloads hold several kinds of shapes.
#      roads and piers  -> lines are in $osm_lines
#      buildings        -> shapes are in $osm_polygons
#
#    zoom_m is how far (in meters) the map reaches from the
#    site to each edge. Try 500 or 2000. The downloads reach
#    2000 m, so do not go bigger than that.
# ---------------------------------------------------------
zoom_m <- 1000

# The main highway (Hwy 61 / Hwy 13) is drawn thicker.
main_roads <- c("trunk", "primary", "secondary")

# --- Silver Bay ------------------------------------------
silver_bay_sf <- sites_sf %>%
  filter(sample_site == "Silver Bay")

silver_bay_box <- silver_bay_sf %>%
  st_buffer(zoom_m) %>%
  st_bbox()

silver_bay_map <- ggplot() +
  geom_sf(data = counties_sf, fill = land_color, color = NA) +
  geom_sf(data = water_sf, fill = lake_color, color = lake_color) +
  geom_sf(
    data = silver_bay_roads$osm_lines,
    color = road_color,
    linewidth = 0.3
  ) +
  geom_sf(
    data = silver_bay_roads$osm_lines %>% filter(highway %in% main_roads),
    color = highway_color,
    linewidth = 1.2
  ) +
  geom_sf(
    data = silver_bay_buildings$osm_polygons,
    fill = building_color,
    color = NA
  ) +
  geom_sf(
    data = silver_bay_piers$osm_lines,
    color = pier_color,
    linewidth = 1.5
  ) +
  geom_sf(
    data = silver_bay_sf,
    shape = 21,
    size = 5,
    fill = site_color,
    color = "white",
    stroke = 1.2
  ) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(
    location = "tr",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    style = north_arrow_orienteering()
  ) +
  coord_sf(
    crs = 26915,
    xlim = c(silver_bay_box["xmin"], silver_bay_box["xmax"]),
    ylim = c(silver_bay_box["ymin"], silver_bay_box["ymax"]),
    expand = FALSE
  ) +
  labs(title = "Silver Bay, MN", x = NULL, y = NULL) +
  theme_bw() +
  theme(panel.background = element_rect(fill = lake_color))

silver_bay_map

ggsave(
  "figures/02_silver_bay_map.png",
  silver_bay_map,
  width = 6,
  height = 6,
  dpi = 300
)

# --- Two Harbors -----------------------------------------
two_harbors_sf <- sites_sf %>%
  filter(sample_site == "Two Harbors")

two_harbors_box <- two_harbors_sf %>%
  st_buffer(zoom_m) %>%
  st_bbox()

two_harbors_map <- ggplot() +
  geom_sf(data = counties_sf, fill = land_color, color = NA) +
  geom_sf(data = water_sf, fill = lake_color, color = lake_color) +
  geom_sf(
    data = two_harbors_roads$osm_lines,
    color = road_color,
    linewidth = 0.3
  ) +
  geom_sf(
    data = two_harbors_roads$osm_lines %>% filter(highway %in% main_roads),
    color = highway_color,
    linewidth = 1.2
  ) +
  geom_sf(
    data = two_harbors_buildings$osm_polygons,
    fill = building_color,
    color = NA
  ) +
  geom_sf(
    data = two_harbors_piers$osm_lines,
    color = pier_color,
    linewidth = 1.5
  ) +
  geom_sf(
    data = two_harbors_sf,
    shape = 21,
    size = 5,
    fill = site_color,
    color = "white",
    stroke = 1.2
  ) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(
    location = "tr",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    style = north_arrow_orienteering()
  ) +
  coord_sf(
    crs = 26915,
    xlim = c(two_harbors_box["xmin"], two_harbors_box["xmax"]),
    ylim = c(two_harbors_box["ymin"], two_harbors_box["ymax"]),
    expand = FALSE
  ) +
  labs(title = "Two Harbors, MN", x = NULL, y = NULL) +
  theme_bw() +
  theme(panel.background = element_rect(fill = lake_color))

two_harbors_map

ggsave(
  "figures/03_two_harbors_map.png",
  two_harbors_map,
  width = 6,
  height = 6,
  dpi = 300
)

# --- Bayfield --------------------------------------------
bayfield_sf <- sites_sf %>%
  filter(sample_site == "Bayfield")

bayfield_box <- bayfield_sf %>%
  st_buffer(zoom_m) %>%
  st_bbox()

bayfield_map <- ggplot() +
  geom_sf(data = counties_sf, fill = land_color, color = NA) +
  geom_sf(data = water_sf, fill = lake_color, color = lake_color) +
  # The ice road to Madeline Island crosses the lake, so we drop it
  geom_sf(
    data = bayfield_roads$osm_lines %>% filter(is.na(ice_road)),
    color = road_color,
    linewidth = 0.3
  ) +
  geom_sf(
    data = bayfield_roads$osm_lines %>% filter(highway %in% main_roads),
    color = highway_color,
    linewidth = 1.2
  ) +
  geom_sf(
    data = bayfield_buildings$osm_polygons,
    fill = building_color,
    color = NA
  ) +
  geom_sf(
    data = bayfield_piers$osm_lines,
    color = pier_color,
    linewidth = 1.5
  ) +
  geom_sf(
    data = bayfield_sf,
    shape = 21,
    size = 5,
    fill = site_color,
    color = "white",
    stroke = 1.2
  ) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(
    location = "tr",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    style = north_arrow_orienteering()
  ) +
  coord_sf(
    crs = 26915,
    xlim = c(bayfield_box["xmin"], bayfield_box["xmax"]),
    ylim = c(bayfield_box["ymin"], bayfield_box["ymax"]),
    expand = FALSE
  ) +
  labs(title = "Bayfield, WI", x = NULL, y = NULL) +
  theme_bw() +
  theme(panel.background = element_rect(fill = lake_color))

bayfield_map

ggsave(
  "figures/04_bayfield_map.png",
  bayfield_map,
  width = 6,
  height = 6,
  dpi = 300
)
