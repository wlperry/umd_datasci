# ==========================================================
# Activity 12: Real Climate Data in R
# Name:
# Date:
#
# Save this file as scripts/12_weather.R
#
# The code is already written. Run it chunk by chunk and
# type your answers in the boxes marked  # # # # # #  —
# after "ANSWER:", with every line starting with #
#
# Your ANSWERS, plus the EXTENSION at the bottom
# (your own city), are what gets graded.
# ==========================================================

# Install GSODR once, from the Console:
# install.packages("GSODR")
#
# Loading GSODR prints a notice that the GSOD data retired
# in Aug 2025. That is EXPECTED - not an error. The
# historical archive still downloads fine.

# Load libraries -------------------------------------------
library(tidyverse)   # dplyr + ggplot2
library(janitor)     # clean_names()
library(GSODR)       # NOAA weather station data


# ---- 1: Download the Duluth record -----------------------
# clean_names() makes every column lower case, so you never
# have to think about NOAA's CAPITALS again.
#
# Duluth reported under a DIFFERENT station ID from 1965 to
# 1972, so this station has no files for those 8 years.
# setdiff() removes them from the year vector. Leave them in
# and the WHOLE download fails - not just those years.
#
# This takes a minute - 69 years of daily records.
gap_years <- 1965:1972

duluth_df <- get_GSOD(years = setdiff(1948:2024, gap_years),
                      station = "727450-14913") %>%
  clean_names()

# How big is it, and what is in it?
dim(duluth_df)

names(duluth_df)[13:18]

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. Rows = ____   Columns = ____
#     What is ONE ROW - a day, a month, or a year?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 2: Trim to what you need ----------------------------

# Keep only the columns we actually use
dlh_df <- duluth_df %>%
  select(name, yearmoda, year, month, temp)

head(dlh_df, 3)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. What is in yearmoda that is not already in year and
#     month? Why keep all three?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 3: Plot the raw daily data --------------------------

# Every single daily temperature
dlh_df %>%
  ggplot(aes(x = yearmoda, y = temp)) +
  geom_point(alpha = 0.2, size = 0.5)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q3a. How tall is the band of points, roughly, in deg C?
#      What causes that spread - climate change, or
#      something else?
# ANSWER:
#
# Q3b. Can you see a warming trend here? Why not?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 4: Summarize to one mean per year -------------------

# Mean temperature per year
dlh_year_df <- dlh_df %>%
  group_by(year) %>%
  summarize(temp = mean(temp, na.rm = TRUE))

head(dlh_year_df, 3)

nrow(dlh_year_df)

# Yearly means with the regression line
dlh_year_df %>%
  ggplot(aes(x = year, y = temp)) +
  geom_point() +
  geom_smooth(method = "lm")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4a. Rows now = ____   Rows you started with = ____
# ANSWER:
#
# Q4b. Now the trend is visible. What did summarizing
#      remove, and what did it keep?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 5: Fit the trend and read the rate ------------------
# slope     = Coefficients, year row, Estimate column
# p-value   = Coefficients, year row, Pr(>|t|)
# R-squared = Multiple R-squared, near the bottom

# Temperature predicted by year
dlh_year_model <- lm(temp ~ year, data = dlh_year_df)

summary(dlh_year_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q5a. Slope = ____ deg C per year.
#      Positive or negative - warming or cooling?
# ANSWER:
#
# Q5b. Slope x 10 = ____ deg C per DECADE.
#      The record spans 77 years (1948-2024), so that is
#      roughly ____ degrees in total.
# ANSWER:
#
# Q5c. p-value = ____   Is the trend real, or luck?
# ANSWER:
#
# Q5d. R-squared = ____   Year explains what fraction of
#      the variation? What is the REST of it?
# ANSWER:
#
# Q5e. The intercept is about -49 deg C. Why is that
#      number meaningless here?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 6: Label each day with a season ---------------------
# NORTHERN hemisphere seasons.
# South of the equator you must SWAP summer and winter.

dlh_season_df <- dlh_df %>%
  mutate(season = case_when(
    month %in% c(6, 7, 8) ~ "summer",
    month %in% c(12, 1, 2) ~ "winter",
    TRUE ~ "shoulder"
  ))

# Did it work?
dlh_season_df %>% count(season)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q6a. Days in each season? Does a quarter / quarter /
#      half make sense?
# ANSWER:
#
# Q6b. Duluth is at latitude +46.84 - northern hemisphere.
#      If you ran this exact code on Melbourne, Australia
#      (latitude -37.7), what would be wrong?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 7: Summarize by year AND season ---------------------

# Drop the shoulder, then one mean per year per season
season_year_df <- dlh_season_df %>%
  filter(season != "shoulder") %>%
  group_by(year, season) %>%
  summarize(temp = mean(temp, na.rm = TRUE),
            .groups = "drop")

head(season_year_df, 4)

nrow(season_year_df)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q7. Rows = ____   Where does that number come from?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 8: Plot both seasons --------------------------------
# color = season inside aes() colors the points AND makes
# geom_smooth() fit a separate line for each season.

season_year_df %>%
  ggplot(aes(x = year, y = temp, color = season)) +
  geom_point() +
  geom_smooth(method = "lm")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q8a. Roughly what temperature is each band centered on?
# ANSWER:
#
# Q8b. Which line is STEEPER? Why is steepness the thing
#      to compare, not which band sits higher?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 9: A model for each season --------------------------

# Summer only
summer_df <- season_year_df %>%
  filter(season == "summer")

summer_model <- lm(temp ~ year, data = summer_df)
summary(summer_model)

# Winter only
winter_df <- season_year_df %>%
  filter(season == "winter")

winter_model <- lm(temp ~ year, data = winter_df)
summary(winter_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q9a. Read the `year` row of each summary():
#
#              slope (C/yr)   x10 (C/decade)   p-value
#   annual       ______          ______         ______
#   summer       ______          ______         ______
#   winter       ______          ______         ______
# ANSWER:
#
# Q9b. Which season warms faster, and by roughly how much?
#      Does the annual rate sit between them?
# ANSWER:
#
# Q9c. Why does an annual mean HIDE this? Name one
#      biological thing that depends on winter temperature
#      but not on the annual average.
# ANSWER:
#
# Q9d. Write a results sentence for the ANNUAL trend:
#      slope with units, the per-decade rate, F with both
#      df, p, and R-squared.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 10: Find the station for YOUR city ------------------
# nearest_stations() takes a latitude, a longitude, and a
# radius in km.  Duluth is 46.84, -92.19.
#   SOUTH of the equator  -> NEGATIVE latitude
#   WEST of Greenwich     -> NEGATIVE longitude

nearest_stations(LAT = 46.84, LON = -92.19,
                 distance = 50) %>%
  clean_names() %>%
  select(stnid, name, begin, end) %>%
  head(3)

# TODO: look up YOUR city's lat/long and run it again here.
#       Pick a station whose `begin` year is 1970 or EARLIER
#       - a trend needs decades.
#
# If your download fails, your station is missing a year in
# the range you asked for. Request one year at a time to
# find the hole, then setdiff() it out like we did above.


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10a. City = ____   latitude = ____  longitude = ____
# ANSWER:
#
# Q10b. stnid = ____   name = ____
#       begin = ____   end = ____
# ANSWER:
#
# Q10c. Northern or southern hemisphere? Will you need to
#       swap the season labels?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# EXTENSION — out of class. Answers as # comments below.
# ##########################################################

# ---- E1: Your city's warming rate ------------------------
# Only ONE line changes - the station. Use the years your
# station actually has (see `begin` and `end` above).

# TODO: fill in your station id and year range
# city_df <- get_GSOD(years = 1973:2024,
#                     station = "YOUR-STATION-ID") %>%
#   clean_names()

# TODO: same as Parts 2, 4 and 5 - trim, summarize by year,
#       plot, then lm(temp ~ year) and summary()


# ---- E2: Your city's seasons -----------------------------
# Repeat Parts 6-9 on your city.
# SOUTHERN hemisphere? Swap the labels:
#   month %in% c(12, 1, 2) ~ "summer",
#   month %in% c(6, 7, 8)  ~ "winter",

# TODO: season column, summarize, plot, two models


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# E1. City = ____   station = ____   years = ____
#     Slope = ____ deg C per decade   p = ____  R2 = ____
#     Faster or slower than Duluth?
# ANSWER:
#
# E2. Summer rate = ____ C/decade
#     Winter rate = ____ C/decade
#     Is winter warming faster in your city too?
# ANSWER:
#
# E3a. Using YOUR R-squared: what fraction of the
#      year-to-year variation does year alone explain?
#      What is the rest?
# ANSWER:
#
# E3b. How can a low R-squared sit next to a p-value below
#      0.001? What is each one telling you?
# ANSWER:
#
# E3c. One station's trend does not prove WHY a city is
#      warming. Name one thing that could inflate a single
#      station's trend with nothing to do with global
#      climate - and how you might check for it.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in -----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
