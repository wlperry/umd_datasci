# Load libraries -------------------------------------------
library(readxl) # read Excel files
library(tidyverse) # dplyr + ggplot2
library(janitor) # clean_names()
library(car) # leveneTest()

# Load the leaf data (Part A) ------------------------------
leaf_df <-
  read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names() %>%
  mutate(leaf_n = row_number())

# Look at summary stats - Mean and SD of leaf mass for each side
leaf_df %>%
  group_by(shade) %>%
  summarize(
    n = sum(!is.na(mass_g)),
    mean = mean(mass_g, na.rm = TRUE),
    sd = sd(mass_g, na.rm = TRUE)
  )

# Remove issue of multiple leaves form same tree - average them to a single leaf per side per tree
leaf_df <- leaf_df %>%
  group_by(teams, shade) %>%
  summarize(mass_g = mean(mass_g, na.rm = TRUE))

# Make a plot of the data
leaf_df %>%
  ggplot(aes(shade, mass_g)) +
  geom_boxplot() +
  geom_point(aes(color = teams, group = teams)) +
  geom_line(aes(color = teams, group = teams))

# check assumptions
# Normality with a qqplot
leaf_df %>%
  ggplot(aes(sample = mass_g)) +
  stat_qq() +
  stat_qq_line()

# normality with Shapir Wilk Test
leaf_df %>%
  group_by(shade) %>%
  summarize(shapiro_p = shapiro.test(mass_g)$p.value)

#Equal variances
# Levene's test for equal variance
leveneTest(mass_g ~ shade, data = leaf_df)

# run the T Test
mass_model <- t.test(mass_g ~ shade, data = leaf_df)
mass_model

# interpretation

# paired T test
# Need to have sunny and shady in their own columns
# we use pivot_wider
leaf_wide_df <- leaf_df %>%
  pivot_wider(names_from = shade, values_from = mass_g)

paired_ttest_model <- t.test(
  leaf_wide_df$shady,
  leaf_wide_df$sunny,
  paired = TRUE
)
paired_ttest_model
