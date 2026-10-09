# Access NOAA from within R to get the data
# # - note this is DAILY data so dont freak at the number of rows

# # install packages - if not installed
# install.packages("GSODR")

# libraries needed for analysis
library(tidyverse)
library(GSODR)
# https://cran.r-project.org/web/packages/GSODR/vignettes/GSODR.html

# # Or access the vignette which has full descriptions
# vignette("GSODR")

# get a list of stations
load(system.file("extdata", "isd_history.rda", package = "GSODR"))
mn_stations_df <- subset(isd_history, STATE == "MN")
no_stations_df <- subset(isd_history, CTRY == "IC")

# we can alos look for countries that have data
no_stations_df <- subset(isd_history, CTRY == "IC")
no_stations_df

station_df

# Cleaner interface for daily summaries
duluth_df <- get_GSOD(years = 1948:2025, station = "727450-14913")

# Create a dataframe of yearly temps
# Calculate yearly mean temperature
duluth_yearly_temp <- duluth_df |>
  mutate(year = year(YEARMODA)) |>
  group_by(year) |>
  summarize(duluth_mean_temp = mean(TEMP, na.rm = TRUE))


# Plot with regression line
ggplot(duluth_yearly_temp, aes(x = year, y = duluth_mean_temp)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(
    x = "Year",
    y = "Mean Annual Temperature (°C)",
    title = "Duluth Temperature Trend"
  ) +
  theme_minimal()


# Fit linear model
duluth_temp_model <- lm(duluth_mean_temp ~ year, data = duluth_yearly_temp)

# Get equation components
duluth_intercept <- coef(duluth_temp_model)[1]
duluth_slope <- coef(duluth_temp_model)[2]

# Report the equation
cat(sprintf(
  "Temperature = %.2f + %.4f × Year\n",
  duluth_intercept,
  duluth_slope
))

# Or more interpretably (temperature change per decade)
cat(sprintf("Temperature increases %.3f°C per decade\n", duluth_slope * 10))

# now to download Norway
# Norway daily summaries
no_df <- get_GSOD(years = 1949:2025, station = "010230-99999")

# Create a dataframe of yearly temps
# Calculate yearly mean temperature
no_yearly_temp <- no_df |>
  mutate(year = year(YEARMODA)) |>
  group_by(year) |>
  summarize(no_mean_temp = mean(TEMP, na.rm = TRUE))


# now to join the two dataframes

# Plot with regression line
ggplot(no_yearly_temp, aes(x = year, y = no_mean_temp)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(
    x = "Year",
    y = "Mean Annual Temperature (°C)",
    title = "no Temperature Trend"
  ) +
  theme_minimal()


# Fit linear model
no_temp_model <- lm(no_mean_temp ~ year, data = no_yearly_temp)

# Get equation components
no_intercept <- coef(no_temp_model)[1]
no_slope <- coef(no_temp_model)[2]

# Report the equation
cat(sprintf("Temperature = %.2f + %.4f × Year\n", no_intercept, no_slope))

# Or more interpretably (temperature change per decade)
cat(sprintf("Temperature increases %.3f°C per decade\n", no_slope * 10))


# now lets do Morrocco
# NADOR-AROUI
# 603400-99999
mo_df <- get_GSOD(years = 1950:2025, station = "603400-99999")

# Create a dataframe of yearly temps
# Calculate yearly mean temperature
mo_yearly_temp <- mo_df |>
  mutate(year = year(YEARMODA)) |>
  group_by(year) |>
  summarize(mo_mean_temp = mean(TEMP, na.rm = TRUE))


# now to join the two dataframes

# Plot with regression line
ggplot(mo_yearly_temp, aes(x = year, y = mo_mean_temp)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(
    x = "Year",
    y = "Mean Annual Temperature (°C)",
    title = "mo Temperature Trend"
  ) +
  theme_minimal()


# Fit linear model
mo_temp_model <- lm(mo_mean_temp ~ year, data = mo_yearly_temp)

# Get equation components
mo_intercept <- coef(mo_temp_model)[1]
mo_slope <- coef(mo_temp_model)[2]

# Report the equation
cat(sprintf("Temperature = %.2f + %.4f × Year\n", mo_intercept, mo_slope))

# Or more interpretably (temperature change per decade)
cat(sprintf("Temperature increases %.3f°C per decade\n", mo_slope * 10))


# lets put it all together...
all_temps <- full_join(
  duluth_yearly_temp,
  no_yearly_temp,
  mo_yearly_temp,
  by = "year"
)
all_temps <- full_join(all_temps, mo_yearly_temp, by = "year")

# we need to make it long format
all_temps_long <- all_temps %>%
  pivot_longer(cols = -year, names_to = "country", values_to = "temp_c")


all_temps_long <- all_temps_long %>%
  mutate(Country = as.factor(country)) %>%
  mutate(
    Country = fct_recode(
      Country,
      "Duluth" = "duluth_mean_temp",
      "Norway" = "no_mean_temp",
      "Morrocco" = "mo_mean_temp"
    )
  )


# Now we can plot all together
ggplot(all_temps_long, aes(x = year, y = temp_c, color = Country)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Year",
    y = "Mean Annual Temperature (°C)",
    title = "Temperature Trend in Morrocco, Norway and Duluth"
  ) +
  theme_minimal()
