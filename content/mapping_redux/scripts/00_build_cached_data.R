# =====================================================================
# INSTRUCTOR PREP SCRIPT - not for students
# ---------------------------------------------------------------------
# Builds the cached CSVs that Module 21 (mapping_redux) ships with.
# Run from the project root. Takes ~15 minutes.
#
# WHY THIS EXISTS -----------------------------------------------------
# GBIF's `limit` is a CUTOFF, not a random sample. Ask for 2,000
# records spanning 1990-2025 and GBIF hands back the first 2,000 in its
# own internal order, which in practice all come from one or two recent
# years. Any "range change over time" map built that way is garbage.
#
# The fix is to download YEAR BY YEAR with a per-year cap, so every
# year contributes a comparable number of records. That also roughly
# levels out the explosion in observer effort after ~2015.
#
# It needs a loop, which this course never teaches. That is the other
# reason students get a finished CSV instead of running this.
#
# SPECIES NOTE --------------------------------------------------------
# The nine-banded armadillo (Dasypus novemcinctus) was tried and
# DROPPED. occ_count() reports ~27,000 US records, but nearly all of
# them are filed at GENUS level ("Dasypus"), and 1,697 more are the
# extinct Pleistocene Dasypus bellus. Searching the species name
# returns only ~800 usable records. Good story, unusable data.
# =====================================================================

library(tidyverse)
library(rgbif)

out_dir <- "content/mapping_redux/data"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

`%||%` <- function(a, b) if (is.null(a)) b else a

# ---------------------------------------------------------------------
# One species, one year, capped --------------------------------------
# ---------------------------------------------------------------------
pull_one_year <- function(sci_name, yr, cap) {
  res <- try(
    occ_data(scientificName = sci_name, country = "US",
             hasCoordinate = TRUE, year = yr, limit = cap)$data,
    silent = TRUE
  )
  if (inherits(res, "try-error") || is.null(res) || nrow(res) == 0) return(NULL)
  if (!all(c("decimalLatitude", "decimalLongitude") %in% names(res))) return(NULL)

  tibble(
    species   = if ("species" %in% names(res)) as.character(res$species) else sci_name,
    state     = if ("stateProvince" %in% names(res)) as.character(res$stateProvince) else NA_character_,
    year      = yr,
    longitude = res$decimalLongitude,
    latitude  = res$decimalLatitude,
    basis     = if ("basisOfRecord" %in% names(res)) as.character(res$basisOfRecord) else NA_character_
  )
}

# ---------------------------------------------------------------------
# One species, many years --------------------------------------------
# ---------------------------------------------------------------------
pull_species <- function(sci_name, years, cap) {
  message("--- ", sci_name, " (", min(years), "-", max(years), ", cap ", cap, "/yr)")
  out <- vector("list", length(years))
  for (i in seq_along(years)) {
    out[[i]] <- pull_one_year(sci_name, years[i], cap)
    message("    ", years[i], ": ", nrow(out[[i]] %||% data.frame()))
  }
  bind_rows(out) %>%
    filter(!is.na(longitude), !is.na(latitude)) %>%
    # lower 48 bounding box - every species here is a lower-48 species
    filter(longitude > -125, longitude < -66, latitude > 24, latitude < 50)
}

# ---------------------------------------------------------------------
# The five species ----------------------------------------------------
# ---------------------------------------------------------------------

# 1. Spotted lanternfly - the in-class demo. Also a safety net: if the
#    live GBIF download fails in class, students read this instead.
slf <- pull_species("Lycorma delicatula", 2014:2025, cap = 600)
write_csv(slf, file.path(out_dir, "spotted_lanternfly_gbif.csv"))

# 2. Eurasian collared-dove - the 35-year continental invasion.
#    Florida in 1990, coast to coast by 2015.
ecd <- pull_species("Streptopelia decaocto", 1990:2025, cap = 250)
write_csv(ecd, file.path(out_dir, "collared_dove_gbif.csv"))

# 3 + 4. The two flying squirrels - two species, one map, one contact
#    zone. Not a time series: too few records to slice by year.
fsq <- bind_rows(
  pull_species("Glaucomys volans",   1990:2025, cap = 400),
  pull_species("Glaucomys sabrinus", 1990:2025, cap = 400)
)
write_csv(fsq, file.path(out_dir, "flying_squirrels_gbif.csv"))

# 5. Homework options.
opo <- pull_species("Didelphis virginiana", 1990:2025, cap = 400)
write_csv(opo, file.path(out_dir, "opossum_gbif.csv"))

gst <- pull_species("Papilio cresphontes", 1990:2025, cap = 400)
write_csv(gst, file.path(out_dir, "giant_swallowtail_gbif.csv"))

# ---------------------------------------------------------------------
# Sanity check --------------------------------------------------------
# ---------------------------------------------------------------------
check <- function(d, nm) cat(sprintf("%-14s %6d rows  %d-%d  lat %.1f-%.1f  lon %.1f-%.1f\n",
  nm, nrow(d), min(d$year), max(d$year), min(d$latitude), max(d$latitude),
  min(d$longitude), max(d$longitude)))

check(slf, "lanternfly"); check(ecd, "collared-dove"); check(fsq, "flying sq")
check(opo, "opossum");    check(gst, "swallowtail")
