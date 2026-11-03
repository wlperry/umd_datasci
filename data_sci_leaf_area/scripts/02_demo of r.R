# # install packages
# install.packages("readxl")
# install.packages("tidyverse")
# install.packages("janitor")

# loading libraries
library(janitor)
library(readxl)
library(tidyverse)


leaf_df <- read_csv("data/2026_09_03_data_sci_leaf_area.csv")


# leaf2_df <- read_excel("data/leaf area_kleven_jordan_backlund_moore.xlsx")

leaf_df$shade
leaf_df

glimpse(leaf_df)
summary(leaf_df)

# this makes a plot
leaf_plot <- ggplot(leaf_df, aes(shade, mass_g, fill = shade, shape = shade)) +
  geom_violin() + # this is a violing
  geom_jitter(width = 0.1) + #these are points in the plot
  theme_classic()
leaf_plot


pet_plot <- ggplot(
  leaf_df,
  aes(shade, paper_mass_g, fill = shade, shape = teams)
) +
  # geom_violin() + # this is a violing
  geom_boxplot() + #these are points in the plot
  # geom_line(aes(group=teams))+
  theme_classic()
pet_plot

ggsave(leaf_plot, file = "figures/leaf.pdf")

write_csv(leaf_df, "output/leaf_modified.csv")
