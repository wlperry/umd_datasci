# ---- Activity 06: Summary statistics ---------------------
# your name, today's date

# ---- Libraries -------------------------------------------
library(readxl)      # read Excel files
library(tidyverse)   # dplyr + ggplot2
library(janitor)     # clean_names()
library(skimr)       # fast descriptive summaries

# ---- Load data ------------------------------------------
leaf_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names()

# ---- Load our theme file and summary_stats() helper ------
# (same themes/ folder you made in Activity 04 - add these
#  two files to it if they aren't there yet)
source("themes/r_themes_for_3_sizes.R")
source("themes/summary_stats_function.R")


# ============================================================
# Part 2 - The NA problem: counting observations correctly
# ============================================================

# which rows are MISSING a paper_mass_g value?


# flip it with ! - keep only the rows that HAVE a value


# a small vector with two missing values, for demonstration


# length() vs. sum(!is.na()) on that vector


# your turn: compare nrow(leaf_df) to sum(!is.na(leaf_df$paper_mass_g))


# ============================================================
# Part 3 - Do it by hand: summarize()
# ============================================================

# sunny leaves: mean, variance, sd, n = sum(!is.na()), se


# your turn: the same summarize() for the shady leaves


# both groups at once: group_by(shade) + the same summarize()


# ============================================================
# Part 4 - Package it: summary_stats()
# ============================================================

# use summary_stats() on the sunny leaves (filter, then pipe in)


# group by shade, then call summary_stats() once for both groups


# your turn: run summary_stats() on petiole_mm or thickness_mm


# ============================================================
# Part 5 - Several variables at once
# ============================================================

# mean of mass_g, petiole_mm, and thickness_mm, by shade


# ============================================================
# Part 6 - Fast overview with skimr
# ============================================================

# skim() grouped by shade


# ============================================================
# Part 7 - The fast way: across()
# ============================================================

# apply the SAME function to every measurement column at once


# your turn: change mean to sd inside across() and run it again


# ============================================================
# Part 8 - Review and checkpoint
# ============================================================
# Run this entire script top to bottom with Ctrl/Cmd + Shift + Enter.
# Does it complete without errors?
