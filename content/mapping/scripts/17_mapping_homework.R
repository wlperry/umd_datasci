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
# 1. ALL the graded questions are in the ANSWERS block right
#    below. Answer them THERE, as # comments. Each code
#    section tells you which questions it unlocks.
# 2. Each code section gives you the moose line from class,
#    commented out, right above a blank where your version
#    goes. Copy it, change the parts that are yours,
#    uncomment, run.
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
# H-Q2. (section H1 - answer BEFORE you download anything)
#       Where in the US do you expect it to be? Name the
#       regions, and say why.
# ANSWER:
#
#
# H-Q3. (section H3) How many records does GBIF hold for
#       your species in the US, and how many did you
#       actually download?
# ANSWER:
#
#
# H-Q4. (section H3) What years did your records come from?
#       Is that the whole history, or a slice off one end?
# ANSWER:
#
#
# H-Q5. (section H4) Which state has the most records for
#       your species?
# ANSWER:
#
#
# H-Q6. (section H5) Compare the US map to your H-Q2
#       prediction. What did you get right, and what
#       surprised you? (If you tightened the coord_sf()
#       limits to the lower 48, say so here.)
# ANSWER:
#
#
# H-Q7. (section H6) Which scale did you pick - the whole
#       world, or one state - and which one? What does that
#       map show that the US map did not? Did the number of
#       records or the years change?
# ANSWER:
#
#
# H-Q8. (section H7) Zoom in on your densest cluster. Do the
#       points sit in habitat that makes sense, or do they
#       trace roads, towns, parks, and trailheads?
# ANSWER:
#
#
# H-Q9. (section H7) Sampling effort: name ONE concrete
#       reason your map might show a pattern that is about
#       PEOPLE rather than about your species - and say how
#       you would check it.
# ANSWER:
#
#
# H-Q10. Three or four sentences, as if captioning your US
#        map for a report: what it shows, how many records
#        it is built on, what years they cover, and one
#        honest limitation.
# ANSWER:
#
#
#

# ==========================================================
# CODE - your species, start to finish
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(sf)
library(maps)
library(rgbif)
library(leaflet)

invisible(NULL)


# ---- H1 Pick your species --------------------------------
# -> then answer H-Q1 and H-Q2 at the top, BEFORE you
#    download anything.
#
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

my_species <- "Genus species" # <- PUT YOUR SPECIES HERE

my_species

invisible(NULL)


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
#   2. the species may have no US records - pick another
#      species, or jump ahead to H6 and map the world
#   3. your internet connection


# ---- H3 What did you actually get? -----------------------
# -> then answer H-Q3 and H-Q4 at the top.
#
# Section 5 in class. How many records exist, versus how
# many you pulled, and from when.
#
# In class:
#   occ_count(scientificName = "Alces alces", country = "US")
#   moose_raw %>% count(year, sort = TRUE)

# YOUR CODE:

invisible(NULL)


# ---- H4 Trim it and make it spatial ----------------------
# -> then answer H-Q5 at the top.
#
# In class:
#   moose_df <- moose_raw %>%
#     select(species, stateProvince, decimalLatitude,
#            decimalLongitude, year) %>%
#     filter(!is.na(decimalLongitude), !is.na(decimalLatitude))
#
#   moose_df %>% count(stateProvince, sort = TRUE) %>% head()
#
#   moose_sf <- moose_df %>%
#     st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
#              crs = 4326)
#
# LONGITUDE GOES FIRST.

# YOUR CODE:

invisible(NULL)


# ---- H5 Map it on the US basemap -------------------------
# -> then answer H-Q6 at the top.
#
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


# ---- H6 Change the scale: the world, OR one state --------
# -> then answer H-Q7 at the top.
#
# Pick ONE. Remember it is two knobs: the DOWNLOAD and the
# BASEMAP. Change both or they will not match.
#
# OPTION A - the whole world (leave country OUT):
#   moose_world_raw <- occ_data(scientificName = "Alces alces",
#                               hasCoordinate = TRUE,
#                               limit = 2000)$data
#
#   moose_world_raw %>% count(country, sort = TRUE) %>% head()
#
#   moose_world_sf <- moose_world_raw %>%
#     filter(!is.na(decimalLongitude), !is.na(decimalLatitude)) %>%
#     st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
#              crs = 4326)
#
#   world_sf <- st_as_sf(
#     maps::map("world", plot = FALSE, fill = TRUE)
#   ) %>% st_set_crs(4326)
#
#   ggplot() +
#     geom_sf(data = world_sf, fill = "grey96", color = "grey75") +
#     geom_sf(data = moose_world_sf, alpha = 0.3, size = 0.7,
#             color = "darkgreen") +
#     theme_void()
#
#   Globe instead of flat? Add to the end of the plot:
#     + coord_sf(crs = "+proj=ortho +lat_0=60 +lon_0=-30")
#
# OPTION B - one state (add stateProvince):
#   moose_mn_raw <- occ_data(scientificName = "Alces alces",
#                            country = "US",
#                            stateProvince = "Minnesota",
#                            hasCoordinate = TRUE,
#                            limit = 2000)$data
#
#   nrow(moose_mn_raw)
#   moose_mn_raw %>% count(year) %>% arrange(year)
#
#   moose_mn_sf <- moose_mn_raw %>%
#     filter(!is.na(decimalLongitude), !is.na(decimalLatitude)) %>%
#     st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
#              crs = 4326)
#
#   mn_sf <- st_as_sf(
#     maps::map("county", regions = "minnesota",
#               plot = FALSE, fill = TRUE)
#   ) %>% st_set_crs(4326)
#
#   ggplot() +
#     geom_sf(data = mn_sf, fill = "grey96", color = "grey75") +
#     geom_sf(data = moose_mn_sf, alpha = 0.4, size = 1,
#             color = "darkgreen") +
#     theme_void()
#
#   Two spellings: "Minnesota" for GBIF, "minnesota" for maps.
#   Pick a state where YOUR species actually lives (H4 told
#   you which one has the most records).

# YOUR CODE:

invisible(NULL)


# ---- H7 Make it live -------------------------------------
# -> then answer H-Q8 and H-Q9 at the top. H-Q10 is the
#    write-up - do it last.
#
# In class:
#   leaflet(moose_sf) %>%
#     addTiles() %>%
#     addCircleMarkers(radius = 4, stroke = FALSE,
#                      fillOpacity = 0.6, color = "darkgreen",
#                      popup = ~paste0(species, "<br>",
#                                      stateProvince, "<br>", year))

# YOUR CODE:

invisible(NULL)


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
# Tell us what the comparison shows in a # comment here.
# ==========================================================

# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and your
# maps must draw.
# ==========================================================
