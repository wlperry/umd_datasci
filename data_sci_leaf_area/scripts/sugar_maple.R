library(readxl)
library(tidyverse)
library(janitor)


df <- read_excel("data/leaf area sugar maple.xlsx") %>% clean_names()


df %>% ggplot(aes(side, total_area_cm2)) + geom_boxplot()

df %>% ggplot(aes(side, total_area_cm2)) + geom_boxplot()

df_red <- df %>%
  group_by(tree, side) %>%
  summarise(
    across(total_area_cm2:stem_length_cm, mean, na.rm = TRUE),
    .groups = "drop"
  )


df_red %>% ggplot(aes(side, mass_g)) + geom_boxplot()


t.test(total_area_cm2 ~ side, data = df)


t.test(mass_g ~ side, data = df)
