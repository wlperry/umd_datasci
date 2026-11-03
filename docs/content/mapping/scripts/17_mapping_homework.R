# ==========================================================
# Activity 17 - HOMEWORK: map a species of your own
# Name:
# Date:
#
# Save as scripts/17_mapping_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class we mapped moose. Here you do the same thing with
# a species YOU pick - something you actually care about.
# If you want to compare two or three species, do that; see
# the bonus at the bottom.
#
# HOW THIS WORKS
# Each section gives you the moose line from class, commented
# out, right above a blank where your version goes. Copy it,
# change the parts that are yours, uncomment, run.
#
# Answer the H-Q questions as # comments where they appear.
# Those answers are graded along with your code.
#
# It must run top to bottom (Ctrl/Cmd + Shift + Enter) with
# no errors before you hand it in.
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf)
library(maps)
library(rgbif)
library(leaflet)

invisible(NULL)


# ---- H1 Pick your species --------------------------------
# You need the SCIENTIFIC name. GBIF will not take a common
# name. Look it up - Wikipedia's info box, or search the
# common name at gbif.org and read the species page.
#
# Examples of the shape it takes:
#   "Alces alces"        moose
#   "Lynx canadensis"    Canada lynx
#   "Danaus plexippus"   monarch butterfly
#   "Acer saccharum"     sugar maple
#
# Store it in a variable so you only type it once, and
# every line below keeps working when you change your mind.

my_species <- "Genus species"   # <- PUT YOUR SPECIES HERE

my_species

invisible(NULL)

# H-Q1. What species did you pick, common AND scientific
#       name, and why that one?
# ANSWER:
#
# H-Q2. BEFORE you download anything: where in the US do you
#       expect it to be? Name the regions, and say why.
# ANSWER:
#


# ---- H2 Download it from GBIF ----------------------------
# In class:
#   moose_raw <- occ_data(scientificName = "Alces alces",
#                         country = "US", hasCoordinate = TRUE,
#                         limit = 2000)$data
#
# Yours - note it uses my_species, so there is nothing to
# retype if you switch species:

# YOUR CODE:
# my_raw <- occ_data(scientificName = my_species,
#                    country        = "US",
#                    hasCoordinate  = TRUE,
#                    limit          = 2000)$data
#
# dim(my_raw)


invisible(NULL)

# If dim() says 0 rows, three things to check:
#   1. spelling of the scientific name
#   2. the species may have no US records - try country = NULL
#      for the whole world, or pick another species
#   3. your internet connection


# ---- H3 What did you actually get? -----------------------
# Section 5 in class. How many records exist, versus how
# many you pulled, and from when.
#
# In class:
#   occ_count(scientificName = "Alces alces", country = "US")
#   moose_raw %>% count(year, sort = TRUE)

# YOUR CODE:


invisible(NULL)

# H-Q3. How many records does GBIF hold for your species in
#       the US, and how many did you actually download?
# ANSWER:
#
# H-Q4. What years did your records come from? Is that the
#       whole history, or a slice off one end?
# ANSWER:
#


# ---- H4 Trim it and make it spatial ----------------------
# In class:
#   moose_df <- moose_raw %>%
#     select(species, stateProvince, decimalLatitude,
#            decimalLongitude, year) %>%
#     filter(!is.na(decimalLongitude), !is.na(decimalLatitude))
#
#   moose_sf <- moose_df %>%
#     st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
#              crs = 4326)
#
# LONGITUDE GOES FIRST.

# YOUR CODE:


invisible(NULL)

# H-Q5. Which state has the most records for your species?
# ANSWER:
#


# ---- H5 Map it on the US basemap -------------------------
# In class (the Alaska-included basemap and the crop):
#   usa_sf <- st_as_sf(
#     maps::map("world", regions = "USA", plot = FALSE, fill = TRUE)
#   ) %>% st_set_crs(4326)
#
#   ggplot() +
#     geom_sf(data = usa_sf, fill = "grey96", color = "grey75") +
#     geom_sf(data = moose_sf, alpha = 0.3, size = 0.7,
#             color = "darkgreen") +
#     coord_sf(xlim = c(-170, -60), ylim = c(25, 72)) +
#     theme_void()
#
# Pick your own point color. If your species has no Alaska
# records you may tighten the coord_sf() limits to the lower
# 48 - say so in H-Q6 if you do.

# YOUR CODE:


invisible(NULL)

# Save it. Make the figures/ folder first if you do not
# have one.
#
# ggsave("figures/my_species_map.png",
#        width = 8, height = 5, units = "in", dpi = 300)

# YOUR CODE:


invisible(NULL)

# H-Q6. Compare the map to your H-Q2 prediction. What did
#       you get right, and what surprised you?
# ANSWER:
#


# ---- H6 Make it live -------------------------------------
# In class:
#   leaflet(moose_sf) %>%
#     addTiles() %>%
#     addCircleMarkers(radius = 4, stroke = FALSE,
#                      fillOpacity = 0.6, color = "darkgreen",
#                      popup = ~paste0(species, "<br>",
#                                      stateProvince, "<br>", year))

# YOUR CODE:


invisible(NULL)

# H-Q7. Zoom in on your densest cluster. Do the points sit
#       in habitat that makes sense, or do they trace roads,
#       towns, parks, and trailheads?
# ANSWER:
#
# H-Q8. Sampling effort: name ONE concrete reason your map
#       might show a pattern that is about PEOPLE rather
#       than about your species - and say how you would
#       check it.
# ANSWER:
#


# ---- H7 Write it up --------------------------------------
# H-Q9. Three or four sentences, as if captioning the figure
#       for a report: what the map shows, how many records
#       it is built on, what years they cover, and one
#       honest limitation.
# ANSWER:
#
#
#


# ==========================================================
# BONUS (optional) - more than one species
#
# To compare two or three species, download each one, add a
# column naming it, and stack them with bind_rows():
#
#   a <- occ_data(scientificName = "Species one", country = "US",
#                 hasCoordinate = TRUE, limit = 1000)$data %>%
#        mutate(which_species = "Species one")
#
#   b <- occ_data(scientificName = "Species two", country = "US",
#                 hasCoordinate = TRUE, limit = 1000)$data %>%
#        mutate(which_species = "Species two")
#
#   both_df <- bind_rows(a, b) %>%
#     filter(!is.na(decimalLongitude), !is.na(decimalLatitude))
#
# Then map color = which_species in ggplot, or use
# addCircleMarkers(color = ~pal(which_species)) in leaflet.
#
# Tell us what the comparison shows in a # comment.
# ==========================================================


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean.
# ==========================================================
