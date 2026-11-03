# ==========================================================
# Activity 06 - Summary statistics
# Name:
# Date:
#
# Save as scripts/06_summary_stats.R
#
# The plumbing at the top is done for you. Everything below
# it is a prompt - the code is on the activity page, so read
# it there and type it in under the matching comment.
#
# The THINK lines are to talk about, not to answer here.
# ==========================================================

# ---- Libraries -------------------------------------------
library(readxl)      # read Excel files
library(tidyverse)   # dplyr + ggplot2
library(janitor)     # clean_names()
library(skimr)       # fast descriptive summaries

invisible(NULL)


# ---- Load data -------------------------------------------
leaf_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names()

invisible(NULL)


# ---- Load the theme file and summary_stats() helper ------
# (same themes/ folder you made in Activity 04 - add these
#  two files to it if they aren't there yet)
source("themes/r_themes_for_3_sizes.R")
source("themes/summary_stats_function.R")

invisible(NULL)


# ---- 2 The NA problem: counting observations -------------

# which rows are MISSING a paper_mass_g value?


# flip it with ! - keep only the rows that HAVE a value


# a small vector with two missing values, for demonstration


# length() vs. sum(!is.na()) on that vector


# compare nrow(leaf_df) to sum(!is.na(leaf_df$paper_mass_g))


# THINK: n is not the number of rows - it is the number of
# rows that actually have a value. Which one does a mean
# need?

invisible(NULL)


# ---- 3 Do it by hand: summarize() ------------------------

# sunny leaves: mean, variance, sd, n = sum(!is.na()), se


# the same summarize() for the shady leaves


# both groups at once: group_by(shade) + the same summarize()


# THINK: se is sd / sqrt(n). Why does a bigger sample make
# the standard error smaller when the sd stays the same?

invisible(NULL)


# ---- 4 Package it: summary_stats() -----------------------

# use summary_stats() on the sunny leaves (filter, then pipe in)


# group by shade, then call summary_stats() once for both groups


# run summary_stats() on petiole_mm or thickness_mm


# THINK: one word changed and you got a whole new table.
# That is what writing a function bought you.

invisible(NULL)


# ---- 5 Several variables at once -------------------------

# mean of mass_g, petiole_mm, and thickness_mm, by shade


# THINK: are the shady leaves larger on all three
# measurements, or only some?

invisible(NULL)


# ---- 6 Fast overview with skimr --------------------------

# skim() grouped by shade


invisible(NULL)


# ---- 7 The fast way: across() ----------------------------

# apply the SAME function to every measurement column at once


# change mean to sd inside across() and run it again


# THINK: mean and sd answer different questions. Which one
# tells you where the leaves sit, and which tells you how
# spread out they are?

invisible(NULL)


# ==========================================================
# Review and checkpoint
#
# Run this entire script top to bottom with
# Ctrl/Cmd + Shift + Enter. It must run clean.
# ==========================================================
