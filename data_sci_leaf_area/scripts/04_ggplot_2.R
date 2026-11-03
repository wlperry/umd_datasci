# Installing packages for today
install.packages("palmerpenguins")
install.packages("FSA")
install.packages("patchwork")

# Load all packages at the top of every script ----------
library(tidyverse) # data wrangling + ggplot2
library(palmerpenguins) # penguins data, Palmer Station LTER
library(FSA) # fisheries analsysis data

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


# The exact same recipe you used on leaf_df ------------
penguins_df %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.7, size = 2) +
  labs(
    title = "Body Mass vs. Flipper Length",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  ) +
  theme_minimal()

# boxplot + jitter, exactly like the leaf_df pattern ---
penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.4) +
  labs(x = "Species", y = "Body Mass (g)", title = "Body Mass by Species") +
  theme_minimal() +
  theme(legend.position = "none")

# coord_cartesian() zooms the VIEW, keeps all the data -
penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  coord_cartesian(ylim = c(3000, 5000)) +
  labs(
    x = "Species",
    y = "Body Mass (g)",
    title = "Zoomed with coord_cartesian()"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# ylim() DELETES rows outside the range first ----------
penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  ylim(3000, 4500) +
  labs(
    x = "Species",
    y = "Body Mass (g)",
    title = "ylim() — boxes recomputed on fewer penguins"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


penguins_df %>%
  ggplot(aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "steelblue", color = "white") +
  labs(x = "Body Mass (g)", y = "Count", title = "Distribution of Body Mass") +
  theme_minimal()

# geom_density() smooths the same shape into a curve ---
penguins_df %>%
  ggplot(aes(x = body_mass_g)) +
  geom_density(fill = "steelblue", alpha = 0.5) +
  labs(x = "Body Mass (g)", y = "Density", title = "Density of Body Mass") +
  theme_minimal()

# source() loads functions from another .R file -------
source("themes/r_themes_for_3_sizes.R")

penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  labs(x = "Species", y = "Body Mass (g)", title = "Body Mass by Species") +
  theme_regular() +
  theme(legend.position = "none")

library(patchwork) # combine ggplot objects with + and /

xy_plot <- penguins_df %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.7) +
  labs(x = "Flipper Length (mm)", y = "Body Mass (g)", color = "Species") +
  theme_regular()

box_plot <- penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  labs(x = "Species", y = "Body Mass (g)") +
  theme_regular() +
  theme(legend.position = "none")

xy_plot +
  box_plot +
  plot_annotation(
    title = "Penguin Body Mass, Two Ways",
    tag_levels = "A"
  )

# +guides(color = guide_legend(override.aes = list(size = 5)))
