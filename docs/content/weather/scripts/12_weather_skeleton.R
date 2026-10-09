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
library(tidyverse) # dplyr + ggplot2
library(janitor) # clean_names()
library(GSODR) # NOAA station data - Duluth, in class # it has been mothballed so had to switch
library(nasapower) # NASA data by lat/long - another source, example only


# ---- 1: Download the Duluth record -----------------------
# clean_names() makes every column lower case, so you never
# have to think about NOAA's CAPITALS again.
#
# Ask for the whole record: 1948 to 2025.
#
# NOAA has no files for 1965-1972, so those years simply
# will not be there. get_GSOD() skips them and carries on.
# The hole shows up in your plots, which is honest - real
# archives have gaps, and the regression does not care.
#
# This takes a minute - 70 years of daily records.
duluth_df <- get_GSOD(years = 1948:2025,
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
#      The record spans 78 years (1948-2025), so that is
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
  mutate(
    season = case_when(
      month %in% c(6, 7, 8) ~ "summer",
      month %in% c(12, 1, 2) ~ "winter",
      TRUE ~ "shoulder"
    )
  )

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
  summarize(temp = mean(temp, na.rm = TRUE), .groups = "drop")

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

# ---- 10: Pick a place of your own ------------------------
# Same analysis, somewhere else - using the SAME GSODR
# package you just used, so you get a long station record
# to compare against Duluth's.

# --- What GSOD actually has, for any country --------------
# GSODR ships a table of EVERY station in the world and the
# years each one covers. Put YOUR country in the filter, in
# CAPITALS.

load(system.file("extdata", "isd_history.rda", package = "GSODR"))

stations_df <- isd_history %>%
  clean_names() %>%
  filter(country_name == "AUSTRALIA") %>%
  mutate(begin_year = as.integer(str_sub(begin, 1, 4)),
         end_year   = as.integer(str_sub(end, 1, 4))) %>%
  filter(begin_year <= 1970,
         end_year >= 2025) %>%
  select(stnid, name, begin_year, end_year) %>%
  arrange(begin_year)

stations_df

# Scan the name column for a city you want, and note two
# things: its stnid, and its begin_year.


# --- Download your city -----------------------------------
# stnid goes into get_GSOD(). begin_year tells you what to
# put at the START of the year range.
#
# Melbourne is filled in as an EXAMPLE. Replace BOTH the
# years and the stnid with your own.
#
# get_GSOD() hands back the SAME columns as Duluth - year,
# month, temp, already lower case from clean_names(). There
# is nothing to rename, so every line below is code you
# have already run, with city_df in place of dlh_df.
#
# Stations outside the US are gappier than Duluth. If you
# get far fewer years than you asked for, or an error, go
# back to stations_df and pick another station in the same
# country - a capital city or a major airport is safest.

city_df <- get_GSOD(years = 1966:2025,
                    station = "959360-99999") %>%
  clean_names()

# Did it work?
dim(city_df)

# TODO: put YOUR station in and run it again before you
#       leave class.


# --- Another source worth knowing: NASA POWER -------------
# You are NOT using this for the homework, but a station is
# not the only way to get climate data.
#
# nasapower needs no station at all - just a longitude and
# a latitude - and gives you 1981 to now for anywhere on
# Earth with NO gaps.
#
# Note the order: lonlat = c(LONGITUDE, LATITUDE)
#   SOUTH of the equator -> NEGATIVE latitude
#   WEST of Greenwich    -> NEGATIVE longitude
#
# Its columns come back as MM and T2M, so rename() IS
# needed here - the small translation every new source
# needs. Run it once, with London, just to see it work.

power_df <- get_power(community = "ag",
                      lonlat = c(-0.13, 51.51),
                      pars = "T2M",
                      dates = c("1981-01-01", "2024-12-31"),
                      temporal_api = "daily") %>%
  clean_names() %>%
  rename(month = mm, temp = t2m)

dim(power_df)

# GSOD station : country + stnid, 1930s-2025, WITH gaps,
#                columns already named year/month/temp
# NASA POWER   : longitude + latitude, 1981-now, no gaps,
#                a modelled ~50 km grid cell, needs rename()
#
# Use GSOD for the homework. The longer record is the point,
# and it lets you compare against the Duluth data you
# already have in dlh_year_df.


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10a. Country = ____  stnid = ____  begin_year = ____
#       What city is it?
# ANSWER:
#
# Q10b. Rows = ____   Years of record = ____
#       How does that compare with Duluth's 70?
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
  mutate(
    season = case_when(
      month %in% c(6, 7, 8) ~ "summer",
      month %in% c(12, 1, 2) ~ "winter",
      TRUE ~ "shoulder"
    )
  ) %>%
  filter(season != "shoulder") %>%
  group_by(year, season) %>%
  summarize(temp = mean(temp, na.rm = TRUE), .groups = "drop")

city_season_df %>%
  ggplot(aes(x = year, y = temp, color = season)) +
  geom_point() +
  geom_smooth(method = "lm")

city_summer_model <- lm(
  temp ~ year,
  data = city_season_df %>%
    filter(season == "summer")
)

summary(city_summer_model)

city_winter_model <- lm(
  temp ~ year,
  data = city_season_df %>%
    filter(season == "winter")
)

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
# Both records came from the SAME source - GSODR - so you
# already have what you need: dlh_year_df from Part 4 and
# city_year_df from H1.

# --- Step 1: match the years ------------------------------
# The two stations do not start in the same year. Compare
# them over the span they SHARE, or a difference in PLACE
# gets mixed up with a difference in YEARS.

start_year <- max(min(dlh_year_df$year), min(city_year_df$year))

start_year

# --- Step 2: label each one, then stack them --------------
# The station column is the whole trick. Stacking alone
# would throw away which rows came from where, so you add
# the label BEFORE you stack.

duluth_labeled_df <- dlh_year_df %>%
  filter(year >= start_year) %>%
  mutate(station = "duluth")

city_labeled_df <- city_year_df %>%
  filter(year >= start_year) %>%
  mutate(station = "my_city")

# bind_rows() puts one data frame UNDERNEATH the other and
# matches columns by NAME - which is why both frames having
# year, temp and station matters.

both_df <- bind_rows(duluth_labeled_df, city_labeled_df)

# Did it work?
both_df %>% count(station)

# --- Step 3: plot both places -----------------------------
both_df %>%
  ggplot(aes(x = year, y = temp, color = station)) +
  geom_point() +
  geom_smooth(method = "lm")

# --- Step 4: test the two slopes --------------------------
# temp ~ year * station fits a SEPARATE SLOPE per station.
# The year:stationmy_city row tests whether the two slopes
# differ. Read its t value and Pr(>|t|) - the same two
# columns you read for a t-test.
#
# SANITY CHECK: if that row is exactly 0 with p = 1, you are
# still comparing Duluth with Duluth - go back to Part 10
# and put in your own stnid.

slope_model <- lm(temp ~ year * station, data = both_df)

summary(slope_model)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H3a. start_year = ____
#      Years used in the comparison = ____
# ANSWER:
#
# H3b. year row            = ____ (Duluth slope)
#      year:stationmy_city = ____ (the DIFFERENCE)
#      Your city's slope = year + year:stationmy_city
#                        = ____
#      Both in deg C per DECADE = ____ and ____
# ANSWER:
#
# H3c. p-value on the year:stationmy_city row = ____
#      Below 0.05? If YES the two cities warm at
#      measurably different rates. If NO you cannot tell
#      them apart - even if the numbers look different.
# ANSWER:
#
# H3d. Write one sentence reporting the comparison: both
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
# H4c. Duluth in class used 70 years. How many did your
#      station give you, and how many did the H3
#      comparison use once you matched the years?
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
