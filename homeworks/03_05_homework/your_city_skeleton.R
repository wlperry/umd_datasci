# =============================================================================
# Homework 05 — Is Your City Warming? A Climate Regression Comparison
# BIOL 3810 Data Science for Biology — Bill Perry
#
# Name:
# Date:
#
# Fill in every blank marked with _____  and answer every Q# below
# as a # comment. The Q numbers match the homework question sheet.
#
# Reference: Lecture 06 (downloading + summarizing climate data),
#            Worksheet 06 (regression + summer/winter case_when)
# =============================================================================


# ── STEP 1: Load packages ─────────────────────────────────────────────────────
# Put ALL library() calls here at the top of the script (see Lecture 02, 06)
# You need: tidyverse, GSODR

library(tidyverse)   # data wrangling + ggplot2
library(_____  )     # download NOAA weather station data: GSODR


# ── STEP 2: Find a station for your city ──────────────────────────────────────
# Run this once in the console to explore stations - not part of your script
#
#   load(system.file("extdata", "isd_history.rda", package = "GSODR"))
#   isd_history[grepl("YOUR CITY NAME", isd_history$NAME), ]
#
# Pick a station with at least 30+ years of record (check BEGIN and END columns)

# Q1 — City and station ID you chose: _______________________________
# Q2 — Years of record you downloaded: _______ to _______


# ── STEP 3: Download your city's daily data ───────────────────────────────────
# Same function as Lecture 06 — just a different station ID and year range

city_df <- get_GSOD(
  years   = _____:_____,        # fill in your start and end year
  station = "_____"              # fill in your station ID, in quotes
)

# Check size of the raw download
dim(city_df)
# Q3 — Total rows in the raw daily download: _______


# ── STEP 4: Trim to the columns we need ───────────────────────────────────────
# Same select() pattern as Lecture 06 / Worksheet 06

city_temp_df <- city_df %>%
  select(
    STNID, NAME, YEARMODA,
    YEAR, MONTH, DAY,
    TEMP
  )

head(city_temp_df)


# ── STEP 5: Summarize by year ─────────────────────────────────────────────────
# group_by() + summarize() — same pattern as Worksheet 06 Part 5

city_year_df <- city_temp_df %>%
  group_by(_____) %>%                          # group by YEAR
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP     = mean(_____, na.rm = TRUE)        # mean of TEMP
  )

head(city_year_df)
tail(city_year_df)

# Q4 — Rows in your yearly-summarized data frame: _______
# Q5 — Mean temperature in your city's first year of record: _______ °C
# Q6 — Mean temperature in your city's most recent year of record: _______ °C


# ── STEP 6: Plot the yearly trend ─────────────────────────────────────────────
# Same plot structure as Lecture 06 yearly_temp_plot

city_yearly_plot <- city_year_df %>%
  ggplot(aes(x = YEAR, y = TEMP)) +
  geom_point(size = 2) +
  geom_line() +
  geom_smooth(method = "_____", color = "firebrick") +   # use "lm"
  labs(
    title = "_____",                       # write a descriptive title with your city's name
    x = "Year", y = "Mean Temp (°C)"
  ) +
  theme_minimal()

city_yearly_plot

ggsave("figures/your_city_yearly_trend.png",
       plot = city_yearly_plot,
       width = 5, height = 5, units = "in", dpi = 300)


# ── STEP 7: Fit the regression — rate of change ───────────────────────────────
# Same lm() syntax as Lecture 06 / Worksheet 06 Part 6

city_year_model <- lm(_____ ~ _____, data = city_year_df)   # TEMP ~ YEAR

summary(city_year_model)

# Pull the slope and convert to °C per decade
city_slope <- coef(city_year_model)[2]

cat("Slope (b)    =", round(city_slope, 4), "°C/year\n")
cat("Warming rate =", round(city_slope * _____, 3), "°C per decade\n")  # multiply by 10

# Q7 — Slope (b), in °C per year: _______
# Q8 — Warming rate, in °C per decade: _______
# Q9 — p-value for the slope: _______
# Q10 — Is the trend statistically significant at alpha = 0.05?  Y / N
# Q11 — R-squared: _______


# ── STEP 8: Compare to Duluth ─────────────────────────────────────────────────
# Use your Duluth warming rate from Worksheet 06 (fill in the number you found)

duluth_decade_rate <- _____    # paste in Duluth's °C/decade rate from Worksheet 06
city_decade_rate   <- round(city_slope * 10, 3)

cat("Duluth rate:  ", duluth_decade_rate, "°C/decade\n")
cat("Your city rate:", city_decade_rate, "°C/decade\n")
cat("Difference:    ", round(city_decade_rate - duluth_decade_rate, 3), "°C/decade\n")

# Q12 — Duluth's warming rate (°C/decade), from Worksheet 06: _______
# Q13 — Is your city warming faster or slower than Duluth?  Faster / Slower / About the same
# Q14 — Difference between your city's rate and Duluth's rate (°C/decade): _______

# Optional comparison plot — put your city and Duluth on the same axes
# (only run this if you still have dlh_year_df from Worksheet 06 in your environment)
#
# compare_df <- bind_rows(
#   city_year_df   %>% mutate(place = "Your City"),
#   dlh_year_df    %>% mutate(place = "Duluth")
# )
#
# city_vs_duluth_plot <- compare_df %>%
#   ggplot(aes(x = YEAR, y = TEMP, color = place)) +
#   geom_point(alpha = 0.6) +
#   geom_smooth(method = "lm", se = FALSE) +
#   labs(title = "Your City vs. Duluth — Annual Mean Temperature Trend",
#        x = "Year", y = "Mean Temp (°C)", color = "Location") +
#   theme_minimal()
#
# city_vs_duluth_plot
#
# ggsave("figures/your_city_vs_duluth.png",
#        plot = city_vs_duluth_plot,
#        width = 5, height = 5, units = "in", dpi = 300)


# ── STEP 9: Build a season variable with case_when() ──────────────────────────
# Same pattern as Lecture 06 / Worksheet 06 Part 7
# NOTE: if your city is in the Southern Hemisphere, swap which months
#       count as "summer" and "winter" (see callout in the homework sheet)

city_season_df <- city_temp_df %>%
  mutate(
    season = case_when(
      MONTH %in% c(_____, _____, _____)  ~ "summer",   # fill in 3 summer months
      MONTH %in% c(_____, _____, _____)  ~ "winter",   # fill in 3 winter months
      TRUE                                 ~ "shoulder"
    )
  )

city_season_df %>% count(season)

# Q15 — Hemisphere of your city (Northern / Southern): _______


# ── STEP 10: Summarize each season by year ────────────────────────────────────

city_season_year_df <- city_season_df %>%
  filter(season %in% c("summer", "winter")) %>%
  group_by(YEAR, season) %>%
  summarize(
    TEMP = mean(TEMP, na.rm = TRUE)
  )

head(city_season_year_df)


# ── STEP 11: Plot summer vs. winter trends ────────────────────────────────────
# Same plot structure as Lecture 06 season_temp_plot

city_season_plot <- city_season_year_df %>%
  ggplot(aes(x = YEAR, y = TEMP, color = season)) +
  geom_point(size = 1.8, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  scale_color_manual(values = c(
    "summer" = "_____",      # pick a color, e.g. "firebrick"
    "winter" = "_____"       # pick a color, e.g. "steelblue"
  )) +
  labs(
    title = "_____",         # write a descriptive title with your city's name
    x = "Year", y = "Mean Temp (°C)", color = "Season"
  ) +
  theme_minimal()

city_season_plot

ggsave("figures/your_city_season_trend.png",
       plot = city_season_plot,
       width = 5, height = 5, units = "in", dpi = 300)


# ── STEP 12: Fit a separate model for each season ─────────────────────────────
# Same pattern as Lecture 06 / Worksheet 06 Part 10

city_summer_df <- city_season_year_df %>% filter(season == "_____")   # "summer"
city_summer_model <- lm(TEMP ~ YEAR, data = city_summer_df)
city_summer_slope <- coef(city_summer_model)[2]
summary(city_summer_model)

city_winter_df <- city_season_year_df %>% filter(season == "_____")   # "winter"
city_winter_model <- lm(TEMP ~ YEAR, data = city_winter_df)
city_winter_slope <- coef(city_winter_model)[2]
summary(city_winter_model)

cat("Summer warming rate:", round(city_summer_slope * 10, 3), "°C/decade\n")
cat("Winter warming rate:", round(city_winter_slope * 10, 3), "°C/decade\n")

# Q16 — Summer warming rate (°C/decade): _______    p-value: _______
# Q17 — Winter warming rate (°C/decade): _______    p-value: _______
# Q18 — Which season is warming faster in your city?  Summer / Winter / About the same
# Q19 — Does this match the pattern you found for Duluth (winter warming faster)?  Y / N


# ── STEP 13: Results paragraph ────────────────────────────────────────────────
# Fill in as a comment — use numbers from city_year_model, city_summer_model,
# city_winter_model, and your Worksheet 06 Duluth results

# Q20 — Results paragraph (4-6 sentences):
#
#
#
#


# ── FINAL CHECK ───────────────────────────────────────────────────────────────
# Run the FULL script with Ctrl/Cmd + Shift + Enter
# Confirm it finishes without errors
# Confirm all three PNGs are in your figures/ folder

# Submit to Canvas:
#   1. This script (05_your_city.R) — with all Q# blanks filled
#   2. figures/your_city_yearly_trend.png
#   3. figures/your_city_vs_duluth.png  (if completed)
#   4. figures/your_city_season_trend.png
