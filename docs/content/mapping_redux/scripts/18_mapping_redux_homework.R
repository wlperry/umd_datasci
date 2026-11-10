# ==========================================================
# Activity 18 - HOMEWORK: a species that moves
# Name:
# Date:
#
# Save as scripts/18_mapping_redux_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class we watched the spotted lanternfly spread out of
# Pennsylvania and the collared-dove cross the continent.
# Here you do the same thing with a species of your own.
#
# HOW THIS WORKS
# 1. ALL the graded questions are in the ANSWERS block
#    right below. Answer them THERE, as # comments. Each
#    code section tells you which questions it unlocks.
# 2. Each code section gives you the class line, commented
#    out, right above a blank where your version goes.
#    Copy it, change the parts that are yours, uncomment,
#    run.
#
# It must run top to bottom (Ctrl/Cmd + Shift + Enter) with
# no errors before you hand it in - and when it does, the
# maps should draw.
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section H1) What species did you pick, common AND
#       scientific name, and why that one?
# ANSWER:
#
#
# H-Q2. (section H1 - answer BEFORE you look at any map)
#       Do you expect its range to have MOVED over the last
#       thirty years? Which direction, and why?
# ANSWER:
#
#
# H-Q3. (section H2) How many records do you have in each
#       period? Are the periods anywhere near equal?
# ANSWER:
#
#
# H-Q4. (section H3) Describe your faceted map in one
#       sentence per panel.
# ANSWER:
#
#
# H-Q5. (section H4) What is the hull area in each period?
#       Does the hull cover ground your species almost
#       certainly does not occupy? Where?
# ANSWER:
#
#
# H-Q6. (section H5) How many hexes are occupied in each
#       period?
# ANSWER:
#
#
# H-Q7. (section H5) Hull area and occupied hexes are two
#       answers to the same question. Where do they
#       disagree for your species, and which do you
#       believe? Say why in one or two sentences.
# ANSWER:
#
#
# H-Q8. (section H6) Pick ONE number that you would quote
#       in a talk as evidence your species did or did not
#       move - percent of records past some latitude or
#       longitude, occupied hexes, anything you can defend.
#       What is it, and what does it say?
# ANSWER:
#
#
# H-Q9. (THE HARD ONE - answer after everything else)
#       Is your species moving, or are there just more
#       people with phones? Give the strongest argument
#       for each side, then say which one you land on.
#       "I cannot tell from this data" is an acceptable
#       answer IF you say what would settle it.
# ANSWER:
#
#
# H-Q10. (section H7 - bonus, only if you did it) What did
#        the interactive map let you see that the faceted
#        one did not?
# ANSWER:
#
#


# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf)
library(maps)
library(rgbif)
library(plotly)

invisible(NULL)


# ==========================================================
# H1 - Pick a species and get the records
#      Unlocks H-Q1, H-Q2
# ==========================================================
#
# TWO WAYS TO DO THIS. Pick ONE.
#
# WAY A (easier): use a cached file we downloaded for you.
#   data/opossum_gbif.csv            Virginia opossum
#   data/giant_swallowtail_gbif.csv  giant swallowtail
# Both are 1990-2025, one capped batch per year.
#
# WAY B (more interesting): download your own species, one
# snapshot year at a time, the way we did in class. You
# need its SCIENTIFIC NAME - GBIF does not take common
# names. Three or four years, spread out.


# ---- WAY A: read a cached file ---------------------------
# species_df <- read_csv("data/opossum_gbif.csv")

 species_df <- 


# ---- WAY B: download your own ----------------------------
# Delete this block if you used WAY A.
# In class:
# slf_2018 <- occ_data(scientificName = "Lycorma delicatula",
#                      country = "US", hasCoordinate = TRUE,
#                      year = 2018, limit = 1500)$data
#
# Then stack and rename:
# species_df <- bind_rows(mine_1995, mine_2005, mine_2015, mine_2025) %>%
#   select(species,
#          state     = stateProvince,
#          year,
#          longitude = decimalLongitude,
#          latitude  = decimalLatitude) %>%
#   filter(!is.na(longitude), !is.na(latitude))


# Always look at what you got:

 count(species_df, year)

invisible(NULL)


# ==========================================================
# H2 - Cut the years into periods
#      Unlocks H-Q3
# ==========================================================
# In class:
# dove_df <- dove_df %>%
#   mutate(period = case_when(
#     year <= 1998 ~ "1990-1998",
#     year <= 2006 ~ "1999-2006",
#     year <= 2014 ~ "2007-2014",
#     TRUE         ~ "2015-2025"))
#
# Write your labels so they sort alphabetically INTO
# chronological order, like those do.

 species_df <- species_df %>%
   mutate(period = case_when(
     ))

 count(species_df, period)

invisible(NULL)


# ==========================================================
# H3 - Make it spatial and facet it
#      Unlocks H-Q4
# ==========================================================
# In class:
# slf_sf <- slf_df %>%
#   st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
#
# states_sf <- st_as_sf(
#   maps::map("state", plot = FALSE, fill = TRUE)
# ) %>%
#   st_set_crs(4326)

 species_sf <- 

 states_sf <- 


# In class:
# ggplot() +
#   geom_sf(data = states_sf, fill = "grey96", color = "grey80") +
#   geom_sf(data = slf_sf, color = "firebrick", size = 0.7, alpha = 0.5) +
#   coord_sf(xlim = c(-92, -69), ylim = c(33, 45)) +
#   facet_wrap(~ year) +
#   theme_void()
#
# Set coord_sf() limits that FIT YOUR SPECIES. The lanternfly
# limits are the mid-Atlantic. The lower 48 is roughly
# xlim = c(-125, -66), ylim = c(24, 50).

 

invisible(NULL)


# ==========================================================
# H4 - A convex hull, and its area
#      Unlocks H-Q5
# ==========================================================
# In class:
# slf_hulls <- slf_sf %>%
#   group_by(year) %>%
#   summarise(geometry = st_union(geometry)) %>%
#   st_convex_hull()
#
# slf_hulls %>%
#   mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6) %>%
#   st_drop_geometry()

 species_hulls <- 


# Draw the hulls with the points on top, faceted by period.

 

invisible(NULL)


# ==========================================================
# H5 - A hex grid, and occupied cells
#      Unlocks H-Q6, H-Q7
# ==========================================================
# In class:
# east_box <- st_bbox(c(xmin = -92, xmax = -69, ymin = 33, ymax = 45),
#                     crs = 4326) %>%
#   st_as_sfc()
#
# hex_grid <- st_make_grid(east_box, cellsize = 0.5, square = FALSE) %>%
#   st_as_sf() %>%
#   mutate(hex_id = row_number())
#
# Use the SAME four numbers you used in coord_sf() above,
# and pick a cellsize that suits the area: 0.5 degrees for
# a few states, 1.5 for the whole country.

 my_box <- 

 my_hex <- 


# In class:
# slf_hex_counts <- st_join(slf_sf, hex_grid) %>%
#   st_drop_geometry() %>%
#   count(year, hex_id, name = "records")
#
# slf_hex_map <- hex_grid %>%
#   inner_join(slf_hex_counts, by = "hex_id")
#
# slf_hex_map %>%
#   st_drop_geometry() %>%
#   count(year, name = "occupied_hexes")

 species_hex_counts <- 

 species_hex_map <- 


# The occupied-hex table - this is H-Q6:

 


# And the hex map, faceted by period:

 

invisible(NULL)


# ==========================================================
# H6 - One number you would defend
#      Unlocks H-Q8
# ==========================================================
# In class, for the dove:
# dove_df %>%
#   group_by(period) %>%
#   summarise(records      = n(),
#             west_of_100W = sum(longitude < -100),
#             percent_west = round(100 * mean(longitude < -100), 1))
#
# Pick the edge that matters for YOUR species. Moving
# north? Use latitude. Moving west? Use longitude.
# PERCENT, not a raw count - the periods are not equal.

 

invisible(NULL)


# ==========================================================
# H7 - BONUS: make it interactive
#      Unlocks H-Q10. Skip it if you are out of time.
# ==========================================================
# In class:
# states_df <- map_data("state")
#
# slf_anim <- ggplot() +
#   geom_polygon(data = states_df, aes(long, lat, group = group),
#                fill = "grey96", color = "grey80") +
#   geom_point(data = slf_df,
#              aes(longitude, latitude,
#                  frame = factor(year),
#                  text  = paste0(state, " ", year)),
#              color = "firebrick", size = 1, alpha = 0.6) +
#   coord_fixed(1.3, xlim = c(-92, -69), ylim = c(33, 45)) +
#   theme_void()
#
# ggplotly(slf_anim, tooltip = "text")
#
# Use frame = period, not frame = factor(year).

 

invisible(NULL)


# ==========================================================
# Before you hand this in:
#
#   [ ] Every H-Q above has an answer written under it
#   [ ] The file runs top to bottom with no errors
#   [ ] Your faceted map draws, with limits that fit
#   [ ] Your hull map draws
#   [ ] Your hex map draws
#   [ ] H-Q9 is answered honestly, not optimistically
# ==========================================================
