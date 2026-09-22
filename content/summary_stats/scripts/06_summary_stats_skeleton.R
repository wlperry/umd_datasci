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

glimpse(leaf_df)     # look at the data right after loading

# ---- Load our theme file and summary_stats() helper ------
# (same themes/ folder you made in Activity 04 — add these
#  two files to it if they aren't there yet)
source("themes/r_themes_for_3_sizes.R")
source("themes/summary_stats_function.R")


# ============================================================
# Part 2 - The NA problem: counting observations correctly
# ============================================================

# a small vector with two missing values, for demonstration


# length() vs. sum(!is.na()) on that vector


# is.na(), !is.na(), and sum(!is.na()) step by step


# your turn: compare nrow(leaf_df) to sum(!is.na(leaf_df$paper_mass_g))


# ============================================================
# Part 3 - A reusable summary_stats() function
# ============================================================

# use summary_stats() on the sunny leaves (filter, then pipe in)


# your turn: use summary_stats() on the shady leaves


# ============================================================
# Part 4 - Tidy stats with group_by() + summary_stats()
# ============================================================

# group by shade, then call summary_stats() once for both groups


# summary across multiple variables: mean of mass_g, petiole_mm,
# and thickness_mm, by shade


# ============================================================
# Part 5 - Fast overview with skimr
# ============================================================

# skim() grouped by shade


# ============================================================
# Part 6 - The fast way: across()
# ============================================================

# apply the SAME function to every measurement column at once


# your turn: change mean to sd inside across() and run it again


# ============================================================
# Part 7 - Review and checkpoint
# ============================================================
# Run this entire script top to bottom with Ctrl/Cmd + Shift + Enter.
# Does it complete without errors?


# ============================================================
# Extension - out of class (~30-40 min)
# ============================================================

# E1: extend the grouped summary of mass_g to also include
#     iqr_mass, range_mass, and cv_mass (sd / mean)


# E2: BEFORE running E1, write your predictions here as comments


# E3: explain your cv_mass values here as comments
