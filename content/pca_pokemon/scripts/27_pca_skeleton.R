# ==========================================================
# Activity 27 - PCA I: many measurements, few axes
# Name:
# Date:
#
# Save as scripts/27_pca.R
#
# HOW THIS FILE WORKS
# - Each section matches a Part on the activity page.
# - Type the code from the activity into the blank space
#   under each section, then run it.
# - Sections marked [ALREADY WRITTEN] are done for you -
#   just run them.
# - The explanations are on the activity page, not here.
#
# You do NOT turn this file in. The homework is
# 27_pca_homework.R
# ==========================================================


# ---- 2 Libraries and data [ALREADY WRITTEN] --------------
library(tidyverse)
library(plotly)

pokemon <- read_csv("data/pokemon_1025.csv") %>%
  mutate(status = case_when(
    is_legendary ~ "legendary",
    is_mythical  ~ "mythical",
    TRUE         ~ "regular"))

pokemon %>% count(status)

invisible(NULL)


# ---- 3 Three stats in 3-D [ALREADY WRITTEN] --------------
# Drag to rotate, hover for names
plot_ly(pokemon, x = ~attack, y = ~defense, z = ~speed,
        color = ~status, text = ~name,
        colors = c("firebrick", "darkorange", "grey60"),
        type = "scatter3d", mode = "markers", marker = list(size = 3))

invisible(NULL)


# ---- 4 Pull the six stats into their own table -----------
# select() the six battle stats



invisible(NULL)


# ---- 5 Do the stats move together? -----------------------
# Correlation table of the six stats



invisible(NULL)


# ---- 6 Where a PC comes from -----------------------------
# No code - read Part 6 on the activity page

invisible(NULL)


# ---- 7 Why we scale --------------------------------------
# Standard deviation of each stat



invisible(NULL)


# ---- 8 Run the PCA ---------------------------------------
# prcomp() then summary()



invisible(NULL)


# ---- 9 Scree plot ----------------------------------------
# [ALREADY WRITTEN] percent of variance for each PC
var_df <- tibble(
  PC      = paste0("PC", 1:6),
  percent = round(100 * poke_pca$sdev^2 / sum(poke_pca$sdev^2), 1)
)

var_df

# Type the ggplot() bar chart here:



invisible(NULL)


# ---- 10 Loadings - what PC1 and PC2 are made of ----------
# The rotation table, rounded



invisible(NULL)


# ---- 11 Scores, and who is at each end of PC1 ------------
# Glue the scores on, then top 6 and bottom 6



invisible(NULL)


# ---- 12 Mean PC1 for each status -------------------------
# group_by() status, then summarise()



invisible(NULL)


# ---- 13 The picture - hover for names --------------------
# ggplot() saved as pca_plot, then ggplotly()



invisible(NULL)
