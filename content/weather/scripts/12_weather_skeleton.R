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

# Install these two once, from the Console:
# install.packages("GSODR")
# install.packages("nasapower")
#
# Loading GSODR prints a notice that the GSOD data retired
# in Aug 2025. That is EXPECTED - not an error. The
# historical archive still downloads fine.

# Load libraries -------------------------------------------
library(tidyverse)   # dplyr + ggplot2
library(janitor)     # clean_names()
library(GSODR)       # NOAA station data - Duluth, in class
library(nasapower)   # NASA data by lat/long - your city, homework


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

# ---- 10: Get the coordinates for YOUR city ---------------
# No station ID this time. NASA POWER takes a LONGITUDE and a
# LATITUDE and gives you daily data for anywhere on Earth,
# 1981 to now, with no gaps.
#
# Look up your city's lat/long in any search engine.
#   SOUTH of the equator -> NEGATIVE latitude
#   WEST of Greenwich    -> NEGATIVE longitude
#
# Note the order: lonlat = c(LONGITUDE, LATITUDE)
#
# London is filled in below as an EXAMPLE. Replace those two
# numbers with your own city before you go any further.

city_df <- get_power(community = "ag",
                     lonlat = c(-0.13, 51.51),
                     pars = "T2M",
                     dates = c("1981-01-01", "2024-12-31"),
                     temporal_api = "daily") %>%
  clean_names() %>%
  rename(month = mm, temp = t2m)

# Did it work? Expect about 16000 rows.
dim(city_df)

# TODO: put YOUR city's lon and lat in the line above and
#       run it again before you leave class.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10a. City = ____  longitude = ____  latitude = ____
# ANSWER:
#
# Q10b. Rows = ____   Years of record = ____
#       How does that compare with Duluth's 69?
# ANSWER:
#
# Q10c. Northern or southern hemisphere? Will you need to
#       swap the season labels?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# HOMEWORK - out of class. Answers as # comments below.
# ##########################################################

# ---- H1: Your city's warming rate ------------------------
# Parts 4 and 5 again, on city_df from Part 10.

city_year_df <- city_df %>%
  group_by(year) %>%
  summarize(temp = mean(temp, na.rm = TRUE))

city_year_df %>%
  ggplot(aes(x = year, y = temp)) +
  geom_point() +
  geom_smooth(method = "lm")

city_model <- lm(temp ~ year, data = city_year_df)

summary(city_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H1. Slope = ____ deg C per year = ____ per DECADE
#     p = ____   R-squared = ____
#     Is your city warming?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H2: Your city's seasons -----------------------------
# Parts 6 to 9 again. NORTHERN hemisphere labels are below.
# SOUTHERN hemisphere? Swap them:
#   month %in% c(12, 1, 2) ~ "summer",
#   month %in% c(6, 7, 8)  ~ "winter",

city_season_df <- city_df %>%
  mutate(season = case_when(
    month %in% c(6, 7, 8) ~ "summer",
    month %in% c(12, 1, 2) ~ "winter",
    TRUE ~ "shoulder"
  )) %>%
  filter(season != "shoulder") %>%
  group_by(year, season) %>%
  summarize(temp = mean(temp, na.rm = TRUE),
            .groups = "drop")

city_season_df %>%
  ggplot(aes(x = year, y = temp, color = season)) +
  geom_point() +
  geom_smooth(method = "lm")

city_summer_model <- lm(temp ~ year,
                        data = city_season_df %>%
                          filter(season == "summer"))

summary(city_summer_model)

city_winter_model <- lm(temp ~ year,
                        data = city_season_df %>%
                          filter(season == "winter"))

summary(city_winter_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H2. Summer = ____ deg C per decade
#     Winter = ____ deg C per decade
#     Does winter warm faster in your city too?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H3: Is your slope DIFFERENT from Duluth's? ----------
# Two slopes can look different and still not be
# distinguishable. This tests it.
#
# First: get Duluth from the SAME source and the SAME years
# as your city. Otherwise you are comparing a difference in
# PLACE with a difference in source and years mixed in.

duluth_power_df <- get_power(community = "ag",
                             lonlat = c(-92.19, 46.84),
                             pars = "T2M",
                             dates = c("1981-01-01", "2024-12-31"),
                             temporal_api = "daily") %>%
  clean_names() %>%
  rename(month = mm, temp = t2m)

duluth_year_df <- duluth_power_df %>%
  group_by(year) %>%
  summarize(temp = mean(temp, na.rm = TRUE)) %>%
  mutate(station = "duluth")

city_labeled_df <- city_year_df %>%
  mutate(station = "my_city")

# Stack them into one data frame
both_df <- bind_rows(duluth_year_df, city_labeled_df)

# Both lines on one plot
both_df %>%
  ggplot(aes(x = year, y = temp, color = station)) +
  geom_point() +
  geom_smooth(method = "lm")

# temp ~ year * station fits a SEPARATE SLOPE per station.
# The year:stationmy_city row tests whether the two slopes
# differ. Read its t value and Pr(>|t|) - the same two
# columns you read for a t-test.
#
# SANITY CHECK: if that row is exactly 0 with p = 1, you are
# still comparing Duluth with Duluth - go back to Part 10
# and put in your own coordinates.

slope_model <- lm(temp ~ year * station, data = both_df)

summary(slope_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H3a. year row            = ____ (Duluth slope)
#      year:stationmy_city = ____ (the DIFFERENCE)
#      Your city's slope = year + year:stationmy_city
#                        = ____
# ANSWER:
#
# H3b. p-value on the year:stationmy_city row = ____
#      Below 0.05? If YES the two cities warm at
#      measurably different rates. If NO you cannot tell
#      them apart - even if the numbers look different.
# ANSWER:
#
# H3c. Write one sentence reporting the comparison: both
#      slopes in deg C per decade, the difference, and the
#      p-value.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H4: Explain your numbers ----------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H4a. Using YOUR R-squared from H1: what fraction of the
#      year-to-year variation does year alone explain?
#      What is the rest?
# ANSWER:
#
# H4b. How can a low R-squared sit next to a p-value below
#      0.001? What is each one telling you?
# ANSWER:
#
# H4c. Duluth in class used 69 years. Your city used 44.
#      Why does a longer record make a trend easier to
#      detect?
# ANSWER:
#
# H4d. A significant trend at one place does not prove WHY
#      it is warming. Name one thing that could inflate a
#      single location's trend with nothing to do with
#      global climate - and how you might check for it.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in -----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
