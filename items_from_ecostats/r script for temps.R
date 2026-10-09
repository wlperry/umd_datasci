# # install packages
# install.packages("GSODR")

# Load Libraries
library(janitor)
library(readxl)
library(GSODR)
library(tidyverse)

# get a list of stations
# this is specific to this package and is download a file to be used to find a list of stations
load(system.file("extdata", "isd_history.rda", package = "GSODR"))

# We can find all Minnesota stations by typing
mn_stations_df <- subset(isd_history, STATE == "MN")
mn_stations_df

# we can look fo rthe Duluth Airport as it has one of the longest records
# Cleaner interface for daily summaries
duluth_df <- get_GSOD(years = 1948:2025, station = "727450-14913")
# we can look at the data - just the top few rows
head(duluth_df)


# We can also get the names of the variables -
names(duluth_df)

# lets save the DLH dataframe as it is in case the internet goes out
write_csv(duluth_df, "output/duluth_weather_data.csv")

dlh_temp_df <- duluth_df %>%
  select(
    STNID,
    NAME,
    COUNTRY_NAME,
    ISO2C,
    STATE,
    LATITUDE,
    LONGITUDE,
    ELEVATION,
    YEARMODA,
    YEAR,
    MONTH,
    DAY,
    YDAY,
    TEMP,
    MXSPD,
    PRCP,
    PRCP_ATTRIBUTES,
    I_SNOW_ICE
  )
dlh_temp_df

dlh_temp_df %>%
  ggplot(aes(YEARMODA, TEMP)) +
  geom_point() +
  geom_line()

dlh_temp_month_df <- dlh_temp_df %>%
  group_by(YEAR, MONTH) %>%
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP = mean(TEMP, na.rm = TRUE)
  )

dlh_temp_month_df %>%
  ggplot(aes(YEARMODA, TEMP)) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm")

dlh_temp_yrh_df <- dlh_temp_df %>%
  group_by(YEAR) %>%
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP = mean(TEMP, na.rm = TRUE)
  )
head(dlh_temp_yrh_df)

dlh_temp_yrh_df %>%
  ggplot(aes(YEAR, TEMP)) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm")

dlh_temp_winter_df <- dlh_temp_df %>%
  filter(MONTH %in% c(12,1,2)) %>% 
  group_by(YEAR) %>%
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP = mean(TEMP, na.rm = TRUE)
  ) %>% 
  mutate(TEMP_F =  (TEMP* 9/5)+32)


head(dlh_temp_winter_df)

winter_temp_plot <- dlh_temp_winter_df %>%
  ggplot(aes(YEAR, TEMP) ) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm")+
  theme_light() +
  labs(
    x= "Year",
  y = "Mean Temp in Dec, Jan (C)",
  caption = "temp increasing 0.3C/decade")+
  geom_smooth(method = "lm") +
  theme(
    axis.text = (element_text(
      color = "black",
      size = 16,
      face = "bold"
    )),
    axis.title = (element_text(
      face = "bold",
      color = "black",
      size = 18
    )),
    panel.grid = element_blank(),
    panel.border = element_rect(
      color = "black",
      linewidth = 1
    ),
    axis.ticks = element_line(
      color = "black",
      linewidth = 0.9
    )
  )
winter_temp_plot


ggsave(
  winter_temp_plot,
  file = "winter temnp c.pdf",
  width = 7,
  height = 7,
  units = "in"
)

winter_temp_f_plot <- dlh_temp_winter_df %>%
  ggplot(aes(YEAR, TEMP_F) ) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm")+
  theme_light() +
  labs(
    x= "Year",
    y = "Mean Temp in Dec, Jan (F)"
    )+
  geom_smooth(method = "lm") +
  theme(
    axis.text = (element_text(
      color = "black",
      size = 16,
      face = "bold"
    )),
    axis.title = (element_text(
      face = "bold",
      color = "black",
      size = 18
    )),
    panel.grid = element_blank(),
    panel.border = element_rect(
      color = "black",
      linewidth = 1
    ),
    axis.ticks = element_line(
      color = "black",
      linewidth = 0.9
    )
  )
winter_temp_f_plot


ggsave(
  winter_temp_f_plot,
  file = "winter temnp f.pdf",
  width = 7,
  height = 7,
  units = "in"
)

winter_temp_model <- lm(TEMP~YEAR, data=dlh_temp_winter_df)
summary(winter_temp_model)

mnthly_model = lm(TEMP ~ YEAR, data = dlh_temp_yrh_df)
summary(mnthly_model)

yrly_model = lm(TEMP ~ YEAR, data = dlh_temp_yrh_df)
summary(yrly_model)

# Note we could look at snow if you were interested ; ) did they used to have more snow in the past...
dlh_snow_df <- dlh_temp_df %>%
  mutate(
    snow = case_when(
      I_SNOW_ICE == 1 ~ "snow",
      TRUE ~ "other"
    )
  ) %>%
  mutate(
    snow_mm = case_when(
      I_SNOW_ICE == 1 ~ PRCP,
      TRUE ~ NA
    )
  ) %>%
  mutate(snow_mm = ifelse(snow_mm == 0, NA, snow_mm))


yearly_sum_snow_df <- dlh_snow_df %>%
  group_by(YEAR) %>%
  summarize(
    sum_snow = sum(snow_mm, na.rm = TRUE)
  )

yearly_snow.plot <- yearly_sum_snow_df %>%
  ggplot(aes(YEAR, sum_snow)) +
  geom_point(size = 2) +
  geom_line(linewidth = 0.9) +
  labs(
    x = "year",
    y = "Total Yearly Snow (mm)"
  ) +
  scale_x_continuous(breaks = seq(1948, 2026, by = 5)) +
  theme_light() +
  geom_smooth(method = "lm") +
  theme(
    axis.text = (element_text(
      color = "black",
      size = 16,
      face = "bold"
    )),
    axis.title = (element_text(
      face = "bold",
      color = "black",
      size = 18
    )),
    panel.grid = element_blank(),
    panel.border = element_rect(
      color = "black",
      linewidth = 1
    ),
    axis.ticks = element_line(
      color = "black",
      linewidth = 0.9
    )
  )
yearly_snow.plot

ggsave(
  yearly_snow.plot,
  file = "figures/yearly_snow.pdf",
  width = 7,
  height = 7,
  units = "in"
)
