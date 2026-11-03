# # Installing packages for today
# install.packages("palmerpenguins")
# install.packages("FSA")
# install.packages("patchwork")

# Load all packages at the top of every script ----------
library(tidyverse) # data wrangling + ggplot2
library(palmerpenguins) # penguins data, Palmer Station LTER
library(FSA) # fisheries analsysis data
library(patchwork)

source("r_themes_for_3_sizes.R")

# to see the data in FSA available
data(package = "FSA") # browse the full catalog — this is where the species variety lives

# load chinkook salmon data from argentina
chinook_df <- ChinookArg

# load the palmer pneguins data
# palmerpenguins ships the data already clean -----------
penguins_df <- penguins %>%
  drop_na(
    species,
    bill_length_mm,
    bill_depth_mm,
    flipper_length_mm,
    body_mass_g
  )

plot_1 <- penguins_df %>%
  ggplot(aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point() +
  theme_crazy()
plot_1

plot_2 <- penguins_df %>%
  ggplot(aes(species, body_mass_g, color = species)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(3000, 5000))
plot_2

source("r_themes_for_3_sizes.R")

fish_plot <- chinook_df %>%
  ggplot(aes(loc, w)) +
  geom_boxplot()

# patchwork final figure -----
(plot_1 +
  theme(legend.position = "none") +
  plot_2 +
  theme(axis.title.y = element_blank(), axis.text.y = element_blank())) /
  fish_plot
