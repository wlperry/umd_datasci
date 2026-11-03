library(tidyverse)
library(readxl)
library(janitor)

leaf_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx")

leaf_df <- leaf_df %>%
  mutate(
    mass_cat = case_when(
      mass_g <= 0.4 ~ "small",
      mass_g > 0.4 & mass_g <= 0.7 ~ "medium",
      mass_g > 0.7 ~ "large",
      TRUE ~ "other"
    )
  ) %>%
  mutate(
    mass_cat_2 = case_when(
      mass_g <= 0.5 ~ "small",
      mass_g > 0.5 & mass_g <= 0.6 ~ "medium",
      mass_g > 0.6 ~ "large",
      TRUE ~ "other"
    )
  ) %>%
  arrange(mass_g)

leaf_counts_df <- leaf_df %>%
  group_by(shade) %>%
  count(mass_cat)

leaf_df %>%
  group_by(shade) %>%
  summarize(count = sum(!is.na(mass_cat)))

# is.na(leaf_df$mass_cat)

scale_color <- scale_color_manual(
  name = "Side",
  values = c(
    shady = "blue",
    sunny = "green"
  ),
  labels = c(
    "shady" = "Shady",
    "sunny" = "Sunny"
  )
)

leaf_df %>%
  filter(shade == "sunny") %>%
  ggplot(aes(mass_g, petiole_mm, shape = shade, color = shade)) +
  geom_point(size = 3, alpha = 0.55) +
  scale_shape_manual(
    name = "Side",
    values = c(
      shady = 15,
      sunny = 18
    ),
    labels = c(
      "shady" = "Shady",
      "sunny" = "Sunny"
    )
  ) +
  theme_light() +
  theme(legend.position = "bottom")


master_color <- c(
  shady = "blue",
  sunny = "green"
)

leaf_df %>%
  filter(shade == "sunny") %>%
  ggplot(aes(mass_g, petiole_mm, shape = shade, color = shade)) +
  geom_point(size = 3, alpha = 0.55) +
  scale_alpha_manual(values = master_color)

leaf_df %>%
  filter(mass_cat == mass_cat_2)
