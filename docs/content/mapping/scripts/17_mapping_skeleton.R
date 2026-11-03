# ==========================================================
# Activity 17 - Mapping Bigfoot sightings
# Name:
# Date:
#
# Save as scripts/17_mapping.R
#
# The code is written for you everywhere except section 9.
# Section 9 is yours to type - the code is on the activity
# page.
#
# The THINK lines are to talk about, not to answer here.
# The EXTENSION at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf)     # spatial data frames
library(maps)   # ready-made state outlines

invisible(NULL)


# ---- 1 Read the sighting reports -------------------------
bigfoot_df <- read_csv("data/bfro_reports_geocoded.csv")

dim(bigfoot_df)

bigfoot_df %>%
  select(title, state, latitude, longitude, classification, season) %>%
  head()

invisible(NULL)


# ---- 2 Clean the coordinates -----------------------------
# The four numbers are a bounding box around the lower 48.
# Alaska and Hawaii would stretch the map and squash
# everything else into a corner.

bigfoot_df <- bigfoot_df %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  filter(longitude > -125, longitude < -66,
         latitude  >   24, latitude  <  50)

nrow(bigfoot_df)

# THINK: why must the NA coordinates go BEFORE
# st_as_sf()?

invisible(NULL)


# ---- 3 Build the sf object -------------------------------
# x FIRST: coords = c("longitude", "latitude")

bigfoot_sf <- bigfoot_df %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

bigfoot_sf

ggplot(bigfoot_sf) +
  geom_sf(alpha = 0.2, size = 0.5)

# THINK: the points drew a recognizable USA with no map
# underneath. What is a "map", then?

invisible(NULL)


# ---- 4 Get US states as sf -------------------------------
states_sf <- st_as_sf(
  maps::map("state", plot = FALSE, fill = TRUE)
) %>%
  st_set_crs(4326)

nrow(states_sf)

states_sf %>%
  head(3)

# THINK: what CASE are the state names in? You need that
# in section 8.

invisible(NULL)


# ---- 5 Layer the sightings on the map --------------------
# Basemap FIRST, points on top.

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey75") +
  geom_sf(data = bigfoot_sf, aes(color = classification),
          alpha = 0.3, size = 0.6) +
  theme_void()

# THINK: why does the order of the two geom_sf() layers
# matter?

invisible(NULL)


# ---- 6 Who is reporting what -----------------------------
bigfoot_df %>%
  count(classification)

# THINK: is the geographic pattern about BIGFOOT or about
# PEOPLE - where they live, hike, and file reports?

invisible(NULL)


# ---- 7 Count sightings per state -------------------------
# Lowercase now so the key matches the map's ID column.

sightings_by_state <- bigfoot_df %>%
  mutate(state = str_to_lower(state)) %>%
  count(state, name = "sightings") %>%
  arrange(desc(sightings))

head(sightings_by_state)

# THINK: predict the top state before you look.

invisible(NULL)


# ---- 8 Join counts to the map ----------------------------
# Last class's joins lecture, pointed at a map. The
# polygons are one table, the counts are another, and
# `state` is the key.
#
# Some IDs are "washington:main", "washington:whidbey
# island" - one row per LANDMASS. str_remove() cuts
# everything from the colon on so the key matches.

states_map <- states_sf %>%
  mutate(state = str_remove(ID, ":.*")) %>%
  left_join(sightings_by_state, by = "state")

states_map %>%
  st_drop_geometry() %>%
  head()

# Did every polygon find a count?
states_map %>%
  st_drop_geometry() %>%
  filter(is.na(sightings))

# THINK: exactly one polygon came back NA. Which one, and
# is that a broken join or a true zero?

invisible(NULL)


# ---- 9 Shade the choropleth ------------------------------
# THIS ONE IS YOURS TO TYPE. The code is on the activity
# page, Part 9. It is where we left off in class.
#
# ggplot the states_map, map sightings to fill inside
# aes(), add scale_fill_viridis_c(option = "magma",
# direction = -1), and finish with theme_void().
#
# direction = -1 makes MORE sightings = DARKER. The
# default reads backwards to almost everyone.

# YOUR CODE:


invisible(NULL)


# ---- 10 Reproject for a proper US look -------------------
# 4326 is degrees. 5070 is Albers Equal-Area, in meters.

ggplot(states_map) +
  geom_sf(aes(fill = sightings), color = "white") +
  scale_fill_viridis_c(option = "magma", direction = -1) +
  coord_sf(crs = 5070) +
  theme_void()

# THINK: what changed about the SHAPE of the country? Why
# does an area-based map deserve an equal-area projection?

invisible(NULL)


# ---- 11 If there is time: by season ----------------------
# The filter drops season == "Unknown", which would draw a
# fifth panel that means nothing.

bigfoot_sf %>%
  filter(season %in% c("Spring", "Summer", "Fall", "Winter")) %>%
  ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(alpha = 0.2, size = 0.4, color = "firebrick") +
  facet_wrap(~ season) +
  coord_sf(crs = 5070) +
  theme_void()

# THINK: which season dominates, and is that about
# Bigfoot or about people?

invisible(NULL)


# ---- 12 Save your map ------------------------------------
# This is the one plot that gets a title, because it is
# leaving your screen.

choropleth_plot <- ggplot(states_map) +
  geom_sf(aes(fill = sightings), color = "white") +
  scale_fill_viridis_c(option = "magma", direction = -1) +
  coord_sf(crs = 5070) +
  labs(title = "Bigfoot Sightings by State",
       fill = "Sightings") +
  theme_void()

ggsave("figures/bigfoot_choropleth.png",
       plot = choropleth_plot,
       width = 7, height = 5, units = "in", dpi = 300)

invisible(NULL)


# ==========================================================
# EXTENSION - this is the graded part
#
# Map a real species you pick, pulled live from GBIF.
# You need install.packages("rgbif") the first time.
#
# E2 and E3 must be HANDWRITTEN, photographed, and
# embedded. Typed answers get at most half credit.
# ==========================================================

# ---- E1 Map your own species -----------------------------
# library(rgbif)
#
# occ <- occ_data(scientificName = "Genus species",
#                 country = "US", hasCoordinate = TRUE,
#                 limit = 1500)$data
#
# Then filter out NA decimalLongitude / decimalLatitude,
# st_as_sf() them (x = longitude FIRST), and draw them on
# the same states_sf basemap you used in class.
# Save to figures/ at dpi = 300.

# YOUR CODE:


invisible(NULL)

# E1. Your species:
#     Records returned:


# ---- E2 Predict, then check (BY HAND) --------------------
# BEFORE running E1: sketch on a rough US outline where you
# expect your species to occur, and why. Then compare your
# prediction to the real map in 2-3 sentences, and note
# anything that looks like a SAMPLING artifact rather than
# real range.


# ---- E3 Explain it (BY HAND) -----------------------------
# 1. GBIF records are where people REPORTED the species.
#    Give one concrete way that could bias YOUR map.
# 2. What extra data would make a state-to-state
#    comparison of your species fair?
# 3. The choropleth recipe did not change from Bigfoot to
#    your species. Why is that recipe dataset-independent?


# ==========================================================
# End of Activity 17. Run the whole script top to bottom
# (Ctrl/Cmd + Shift + Enter). It must run clean.
# ==========================================================
