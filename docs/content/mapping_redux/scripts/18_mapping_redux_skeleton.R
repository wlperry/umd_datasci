# ==========================================================
# Activity 18 - Mapping Redux: ranges that move
# Name:
# Date:
#
# Save as scripts/18_mapping_redux.R
#
# ALL the code is written for you today. Run it section by
# section, look at what comes out, then change things and
# see what breaks. That is the point of today.
#
# The THINK lines are to talk about, not to answer here.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file:
#   18_mapping_redux_homework.R
# ==========================================================

# Install this ONCE, from the Console, BEFORE class:
# install.packages("plotly")

# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf) # spatial data frames
library(maps) # ready-made country and state outlines
library(rgbif) # download species records from GBIF
library(plotly) # interactive plots

invisible(NULL)


# ---- 1 Three snapshot years ------------------------------
# Three identical calls. ONLY year changes.
# limit = 1500 is a CEILING, not a target.
# Takes about 20 seconds.

slf_2018 <- occ_data(
  scientificName = "Lycorma delicatula",
  country = "US",
  hasCoordinate = TRUE,
  year = 2018,
  limit = 1500
)$data

slf_2021 <- occ_data(
  scientificName = "Lycorma delicatula",
  country = "US",
  hasCoordinate = TRUE,
  year = 2021,
  limit = 1500
)$data

slf_2025 <- occ_data(
  scientificName = "Lycorma delicatula",
  country = "US",
  hasCoordinate = TRUE,
  year = 2025,
  limit = 1500
)$data

# If a download fails, jump to section 15 - there is a
# cached copy of all of this in data/.

invisible(NULL)


# ---- 2 Stack them and read the counts --------------------
# select() renames while it selects: new = old

slf_df <- bind_rows(slf_2018, slf_2021, slf_2025) %>%
  select(
    species,
    state = stateProvince,
    year,
    longitude = decimalLongitude,
    latitude = decimalLatitude
  ) %>%
  filter(!is.na(longitude), !is.na(latitude))

count(slf_df, year)

# THINK: one year hit the ceiling of 1500 and one did not.
# So you CANNOT compare the number of dots between panels.
# You CAN compare where they are. Shape, not count.

invisible(NULL)


# ---- 3 Make it spatial -----------------------------------
# Same recipe as the Bigfoot map. Longitude FIRST.

slf_sf <- slf_df %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

states_sf <- st_as_sf(
  maps::map("state", plot = FALSE, fill = TRUE)
) %>%
  st_set_crs(4326)

slf_sf

invisible(NULL)


# ---- 4 Time on the map -----------------------------------
# facet_wrap(~ year) is the ONLY new line on this plot.

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(data = slf_sf, color = "firebrick", size = 0.7, alpha = 0.5) +
  coord_sf(xlim = c(-92, -69), ylim = c(33, 45)) +
  facet_wrap(~year) +
  theme_void()

# THINK: the 2018 cluster is Berks County, Pennsylvania,
# where it was first found in 2014. Does the 2025 spread
# look like something that walked, or something that
# hitched a ride?

invisible(NULL)


# ---- 5 The convex hull -----------------------------------
# A rubber band stretched around all the points.
# group_by + summarise: the same two verbs as always.

slf_hulls <- slf_sf %>%
  group_by(year) %>%
  summarise(geometry = st_union(geometry)) %>%
  st_convex_hull()
slf_hulls


ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(
    data = slf_hulls,
    aes(fill = factor(year)),
    alpha = 0.35,
    color = "grey30"
  ) +
  geom_sf(data = slf_sf, size = 0.4, alpha = 0.3) +
  coord_sf(xlim = c(-92, -69), ylim = c(33, 45)) +
  facet_wrap(~year) +
  theme_void() +
  theme(legend.position = "none")

# st_area() reports square METRES, so divide by a million.

# a better version
slf_hulls_2 <- slf_sf %>%
  group_by(year) %>%
  summarise(geometry = st_union(geometry)) %>%
  st_concave_hull(ratio = 0.3)
slf_hulls_2

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(
    data = slf_hulls_2,
    aes(fill = factor(year)),
    alpha = 0.35,
    color = "grey30"
  ) +
  geom_sf(data = slf_sf, size = 0.4, alpha = 0.3) +
  coord_sf(xlim = c(-92, -69), ylim = c(33, 45)) +
  facet_wrap(~year) +
  theme_void() +
  theme(legend.position = "none")

slf_hulls %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6) %>%
  st_drop_geometry()


# THINK: find a big patch of the 2025 hull with no dots in
# it at all. Is the lanternfly there?

invisible(NULL)


# ---- 6 A second species: the collared-dove ---------------
# Escaped a pet shop in the Bahamas in the 1970s, reached
# Florida in the early 1980s, crossed the continent in
# about thirty years.
#
# This file was downloaded for you: one capped batch per
# year, 1990-2025. That is 36 downloads - see
# scripts/00_build_cached_data.R.

dove_df <- read_csv("data/collared_dove_gbif.csv")

# case_when() straight out of the factors module.
# The labels sort alphabetically INTO chronological order.
# That is on purpose.

dove_df <- dove_df %>%
  mutate(
    period = case_when(
      year <= 1998 ~ "1990-1998",
      year <= 2006 ~ "1999-2006",
      year <= 2014 ~ "2007-2014",
      TRUE ~ "2015-2025"
    )
  )

count(dove_df, period)

dove_sf <- dove_df %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(data = dove_sf, color = "firebrick", size = 0.4, alpha = 0.4) +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50)) +
  facet_wrap(~period, nrow = 1) +
  theme_void()

invisible(NULL)


# ---- 7 The same hull recipe, and it fails ----------------

dove_hulls <- dove_sf %>%
  group_by(period) %>%
  summarise(geometry = st_union(geometry)) %>%
  st_convex_hull()

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(
    data = dove_hulls,
    fill = "steelblue",
    alpha = 0.3,
    color = "steelblue4"
  ) +
  geom_sf(data = dove_sf, color = "firebrick", size = 0.3, alpha = 0.3) +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50)) +
  facet_wrap(~period, nrow = 1) +
  theme_void()

# The expansion IS in the data - just not in the hull.

dove_df %>%
  group_by(period) %>%
  summarise(
    records = n(),
    west_of_100W = sum(longitude < -100),
    percent_west = round(100 * mean(longitude < -100), 1)
  )

# THINK: a convex hull is set ONLY by its outermost points.
# One escaped pet in Oregon in 1991 redraws the continent.

invisible(NULL)


# ---- 8 Build a hex grid ----------------------------------
# square = FALSE is what makes them hexagons.
# cellsize = 0.5 degrees is roughly 55 km across.

east_box <- st_bbox(
  c(xmin = -92, xmax = -69, ymin = 33, ymax = 45),
  crs = 4326
) %>%
  st_as_sfc()

hex_grid <- st_make_grid(east_box, cellsize = 0.5, square = FALSE) %>%
  st_as_sf() %>%
  mutate(hex_id = row_number())

nrow(hex_grid)

# TRY IT: change cellsize to 2 and re-run. How many cells?

invisible(NULL)


# ---- 9 Which hexagon is each record in? ------------------
# st_join() is left_join() with geometry as the key.
# Notice there is NO by = argument. There does not need to
# be one: the key is "is this point inside that polygon?"

slf_hex_counts <- st_join(slf_sf, hex_grid) %>%
  st_drop_geometry() %>%
  count(year, hex_id, name = "records")

head(slf_hex_counts)

invisible(NULL)


# ---- 10 The hex map and its number -----------------------
# inner_join() DROPS the empty cells, which is the point.
# One flat fill colour, on purpose: a cell is drawn if it
# holds at least one record, so the map shows exactly what
# the occupied_hexes table counts.

slf_hex_map <- hex_grid %>%
  inner_join(slf_hex_counts, by = "hex_id")

slf_hex_map %>%
  st_drop_geometry() %>%
  count(year, name = "occupied_hexes")

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(
    data = slf_hex_map,
    fill = "firebrick",
    alpha = 0.75,
    color = NA
  ) +
  coord_sf(xlim = c(-92, -69), ylim = c(33, 45)) +
  facet_wrap(~year) +
  theme_void()

# Same three steps for the dove, on a coarser grid.

us_box <- st_bbox(
  c(xmin = -125, xmax = -66, ymin = 24, ymax = 50),
  crs = 4326
) %>%
  st_as_sfc()

us_hex <- st_make_grid(us_box, cellsize = 1.5, square = FALSE) %>%
  st_as_sf() %>%
  mutate(hex_id = row_number())

dove_hex_counts <- st_join(dove_sf, us_hex) %>%
  st_drop_geometry() %>%
  count(period, hex_id, name = "records")

dove_hex_map <- us_hex %>%
  inner_join(dove_hex_counts, by = "hex_id")

dove_hex_map %>%
  st_drop_geometry() %>%
  count(period, name = "occupied_hexes")

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(
    data = dove_hex_map,
    fill = "firebrick",
    alpha = 0.75,
    color = NA
  ) +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50)) +
  facet_wrap(~period, nrow = 1) +
  theme_void()

# THINK: the four hulls were four identical blobs. The four
# hex counts are not. Why can one summary see it and the
# other cannot?

invisible(NULL)


# ---- 11 Colour by count, and what it really shows --------
# The records column is still sitting there unused. Put it
# on the map. scale_fill_viridis_b() - the b is for BINNED -
# cuts the counts into classes you can read off the legend.

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(data = dove_hex_map, aes(fill = records), color = NA) +
  scale_fill_viridis_b(
    option = "magma",
    direction = -1,
    breaks = c(1, 3, 10, 30, 100)
  ) +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50)) +
  facet_wrap(~period, nrow = 1) +
  theme_void()

# TRY IT: swap viridis_b for viridis_c and drop breaks.
# Nearly everything goes pale - in the first period 104 of
# the 116 occupied cells hold under 5% of what the busiest
# cell holds, so a smooth ramp squashes them into one shade.

# Where are the dark cells? The busiest cell in all four
# panels is in the FIRST one: 344 records in one hexagon
# over Miami. By the last panel the busiest is down to 123,
# while occupied cells climbed from 116 to 267.

dove_hex_map %>%
  st_drop_geometry() %>%
  group_by(period) %>%
  summarise(occupied = n(), busiest_cell = max(records))

# THINK: the range more than doubled while the busiest cell
# shrank. The doves did not get rarer in Miami. What are the
# dark cells a map of?

invisible(NULL)


# ---- 12 Two species on one map ---------------------------
# Southern flying squirrel: oak and hickory.
# Northern flying squirrel: spruce and fir.
# They meet in a band right over the top of Duluth.

squirrel_df <- read_csv("data/flying_squirrels_gbif.csv")

count(squirrel_df, species)

squirrel_sf <- squirrel_df %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# color = species is the whole trick.
# coord_sf() crops to the East: the northern squirrel has a
# second population down the Pacific coast.

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(data = squirrel_sf, aes(color = species), size = 0.7, alpha = 0.6) +
  coord_sf(xlim = c(-100, -66), ylim = c(25, 50)) +
  theme_void()

ggplot() +
  geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
  geom_sf(data = squirrel_sf, aes(color = species), size = 0.7, alpha = 0.6) +
  coord_sf(xlim = c(-100, -66), ylim = c(25, 50)) +
  facet_wrap(~species) +
  theme_void() +
  theme(legend.position = "none")

# THINK: 3400 southern records and 770 northern ones. Four
# times as common, or four times as findable?

invisible(NULL)


# ---- 13 Interactive with ggplotly() ----------------------
# ggplotly() does NOT handle geom_sf() well - it throws away
# custom hover text. So for the interactive version we go
# back to plain lon/lat columns:
#   geom_polygon() for the basemap, geom_point() for records
#
# map_data("state") is the same outlines as an ordinary
# data frame. The group column stops Michigan's two
# peninsulas being joined by a stray line.

states_df <- map_data("state")

head(states_df)

slf_gg <- ggplot() +
  geom_polygon(
    data = states_df,
    aes(long, lat, group = group),
    fill = "grey96",
    color = "grey80"
  ) +
  geom_point(
    data = slf_df,
    aes(
      longitude,
      latitude,
      color = factor(year),
      text = paste0(state, " ", year)
    ),
    size = 1,
    alpha = 0.6
  ) +
  coord_fixed(1.3, xlim = c(-92, -69), ylim = c(33, 45)) +
  theme_void()

# ggplot warns "Ignoring unknown aesthetics: text".
# That warning is EXPECTED - plotly uses it, ggplot does not.

ggplotly(slf_gg, tooltip = "text")

# TRY IT: swap tooltip = "text" for tooltip = "all".

invisible(NULL)


# ---- 14 A slider instead of an animation -----------------
# frame = factor(year) is the only change.
# Three scatterplots with a slider, not a rendered movie -
# it runs on any laptop.

slf_anim <- ggplot() +
  geom_polygon(
    data = states_df,
    aes(long, lat, group = group),
    fill = "grey96",
    color = "grey80"
  ) +
  geom_point(
    data = slf_df,
    aes(
      longitude,
      latitude,
      frame = factor(year),
      text = paste0(state, " ", year)
    ),
    color = "firebrick",
    size = 1,
    alpha = 0.6
  ) +
  coord_fixed(1.3, xlim = c(-92, -69), ylim = c(33, 45)) +
  theme_void()

ggplotly(slf_anim, tooltip = "text")

# THINK: interactive is for EXPLORING. Facets are for
# EXPLAINING. Which one belongs in a paper?

invisible(NULL)


# ---- 15 If there is time: was your download honest? ------
# You mapped 1500 records from 2025. GBIF holds about
# 21000. The cached file is a capped batch from every year,
# pulled the same way.

slf_cached <- read_csv("data/spotted_lanternfly_gbif.csv") %>%
  filter(year == 2025)

slf_live <- slf_df %>%
  filter(year == 2025)

slf_cached %>% count(state, sort = TRUE) %>% head(8)

slf_live %>% count(state, sort = TRUE) %>% head(8)

# THINK: neither list is the truth. Both are cutoffs of the
# same 21000 records.

invisible(NULL)

# ==========================================================
# Done. The homework is a SEPARATE file:
#   18_mapping_redux_homework.R
# ==========================================================
