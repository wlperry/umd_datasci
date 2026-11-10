# ==========================================================
# INSTRUCTOR ONLY - where the Pokemon data came from
#
# You do not need to run this. Both CSVs are already in
# content/pca_pokemon/data/ (and copied into
# content/pca_pokemon_2/data/). This file exists so the
# provenance is on the record.
#
# Run from the module folder:
#   Rscript --vanilla scripts/00_build_module_data.R
# ==========================================================

# ---- Source ----------------------------------------------
# PokeAPI - https://pokeapi.co - a free, open REST API with
# no account, key or rate-limit registration required. Two
# endpoints are used per species:
#
#   /api/v2/pokemon/{id}          stats, types, height, weight
#   /api/v2/pokemon-species/{id}  generation, legendary flags
#
# PokeAPI's data is community-maintained and the API is
# documented as free to use; please keep Sys.sleep() in the
# loop so we stay polite to a free server.
#
# ---- Two files -------------------------------------------
#   data/pokemon_151.csv    Generation I only - used IN CLASS
#   data/pokemon_1025.csv   every species    - used for HOMEWORK
#
# 151 for class on purpose: students recognise the names, so
# they can judge whether PC1 and PC2 mean anything. That
# recognition IS the validation step, and it does not work
# on a list of 1,025 names nobody knows.
#
# ---- Why this is not in the student module ---------------
# The original draft of this analysis downloaded the data
# live, which meant writing a function, looping with map(),
# and handling failures with possibly(). That is a good
# lesson and it is NOT this lesson - these two modules are
# the first time these students have seen PCA, and the brief
# was to keep the code as easy as possible. So the API work
# stays here and the students are handed finished CSVs.
#
# If you ever want to teach the API half, the code below is
# the whole thing and it still runs.
# ==========================================================

library(tidyverse)
library(jsonlite)   # reads JSON, the format web APIs return

dir.create("data", showWarnings = FALSE)

get_pokemon <- function(id) {
  p <- fromJSON(paste0("https://pokeapi.co/api/v2/pokemon/", id))
  s <- fromJSON(paste0("https://pokeapi.co/api/v2/pokemon-species/", id))

  stats <- setNames(p$stats$base_stat, p$stats$stat$name)
  types <- p$types$type$name

  Sys.sleep(0.1)   # be polite to a free server

  tibble(
    id           = p$id,
    name         = p$name,
    type1        = types[1],
    type2        = if (length(types) > 1) types[2] else NA_character_,
    height_m     = p$height / 10,    # API gives decimetres
    weight_kg    = p$weight / 10,    # API gives hectograms
    hp           = stats[["hp"]],
    attack       = stats[["attack"]],
    defense      = stats[["defense"]],
    sp_attack    = stats[["special-attack"]],
    sp_defense   = stats[["special-defense"]],
    speed        = stats[["speed"]],
    generation   = s$generation$name,
    is_legendary = s$is_legendary,
    is_mythical  = s$is_mythical
  )
}

build_file <- function(n, path) {
  if (file.exists(path)) {
    cat("already present, skipping:", path, "\n")
    return(invisible(NULL))
  }
  safe_get <- possibly(get_pokemon, otherwise = NULL)
  out <- map(seq_len(n), safe_get, .progress = TRUE) %>% list_rbind()
  write_csv(out, path)
  cat("wrote", path, nrow(out), "rows\n")
}

build_file(151,  "data/pokemon_151.csv")
build_file(1025, "data/pokemon_1025.csv")
