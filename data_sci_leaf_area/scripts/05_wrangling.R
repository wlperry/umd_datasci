library(tidyverse)
library(readxl)
library(janitor)

leaf_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx")

!is.na(leaf_df$paper_mass_g)

leaf_df <- leaf_df %>%  filter(!is.na(paper_mass_g))

leaf_df %>% filter(shade == "sunny", mass_g > .6)

leaf_df <- leaf_df %>% select(side = shade, everything())

junk <- leaf_df %>% select(-c(twig_id, leaf_id))
junk <- leaf_df %>% select(-c(contains("_id")))

leaf_df <- leaf_df %>% mutate(thick = if_else(thickness_mm <= .12, "thin", "thick")) %>% 
  arrange(thickness_mm)

pgo_df <- pgo_df %>% mutate(level_cat = case_when(
  level <= 20 ~ "trash",
  level >20 ~ "ok",
  level>39~"awesome",
  TRUE~ 99999
)

