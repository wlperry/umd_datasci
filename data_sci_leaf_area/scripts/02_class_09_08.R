# # install packages
# install.packages("tidvyerse")
# install.packages("readxl")

# load libraries
library(janitor)
library(readxl)
library(tidyverse)

tree_df <- read_csv("data/2026_09_03_data_sci_leaf_area.csv")

tree_xls_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx")


head(tree_df)
glimpse(tree_df)
dim(tree_df)

tree_df %>% glimpse()
write_csv(tree_df, "output/leave_karl.csv")

leaf_plot <- ggplot(tree_df, aes(x = shade, y = mass_g)) +
  geom_boxplot() +
  geom_violin(alpha = .2) +
  geom_point() +
  labs(x = "Side", y = "Leaf Mass (g)")
leaf_plot

# save file to output dir
write_csv(tree_df, "output/leaves-2.csv")

# save plot
ggsave(leaf_plot, file = "figures/plot.pdf")

X <- 7
