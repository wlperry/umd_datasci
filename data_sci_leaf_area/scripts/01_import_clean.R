# # install packages
# install.packages("tidyverse")
# install.packages("readxl")
# install.packages("janitor")

library(tidyverse)
library(readxl)
library(janitor)


leaf_df <- read_csv("data/2026_09_03_data_sci_leaf_area.csv")


leaf_df %>%
  ggplot(aes(shade, mass_g)) +
  geom_boxplot() +
  geom_point()

leaf_red_df <- leaf_df %>%
  group_by(teams, shade) %>%
  summarize(
    mass_g = mean(mass_g, na.rm = TRUE),
    petiole_mm = mean(petiole_mm, na.rm = TRUE),
    thickness_mm = mean(thickness_mm, na.rm = TRUE),
    paper_mass_g = mean(paper_mass_g, na.rm = TRUE),
    .groups = "drop_last"
  )


leaf_red_df %>%
  ggplot(aes(shade, mass_g)) +
  geom_boxplot() +
  geom_point() +
  geom_line(aes(group = teams))


leaf_red_df %>%
  ggplot(aes(shade, petiole_mm)) +
  geom_boxplot() +
  geom_point() +
  geom_line(aes(group = teams))

leaf_red_df %>%
  ggplot(aes(shade, thickness_mm)) +
  geom_boxplot() +
  geom_point() +
  geom_line(aes(group = teams))

leaf_red_df %>%
  ggplot(aes(shade, paper_mass_g)) +
  geom_boxplot() +
  geom_point() +
  geom_line(aes(group = teams))
