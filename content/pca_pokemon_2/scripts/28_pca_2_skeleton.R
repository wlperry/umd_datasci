# ==========================================================
# Activity 28 - PCA II: loadings, scores, and the biplot
# Name:
# Date:
#
# Save as scripts/28_pca_2.R
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
# 28_pca_2_homework.R
#
# Install once, before class: install.packages("ggrepel")
# ==========================================================


# ---- 1 Re-run last class's PCA [ALREADY WRITTEN] ---------
library(tidyverse)
library(plotly)
library(ggrepel)

pokemon <- read_csv("data/pokemon_1025.csv") %>%
  mutate(status = case_when(
    is_legendary ~ "legendary",
    is_mythical  ~ "mythical",
    TRUE         ~ "regular"))

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed)

poke_pca <- prcomp(poke_stats, center = TRUE, scale. = TRUE)

summary(poke_pca)

invisible(NULL)


# ---- 2 The loadings table --------------------------------
# Loadings for PC1 to PC3, rounded



invisible(NULL)


# ---- 3 PC2 has mixed signs -------------------------------
# No code - read Part 3 on the activity page

invisible(NULL)


# ---- 4 Prove the PC2 name from the data ------------------
# Glue the scores on, then top 4 and bottom 4 of PC2



invisible(NULL)


# ---- 5 The picture, coloured by status -------------------



invisible(NULL)


# ---- 6 Hover to explore ----------------------------------
# ggplot() saved as pca_plot, then ggplotly()



invisible(NULL)


# ---- 7 Label only the extremes ---------------------------
# filter() the extremes, then a three-layer ggplot()



invisible(NULL)


# ---- 8 The biplot ----------------------------------------
# [ALREADY WRITTEN] loadings turned into arrows
arrows_df <- as_tibble(poke_pca$rotation[, 1:2], rownames = "stat") %>%
  mutate(PC1 = PC1 * 5,
         PC2 = PC2 * 5)

arrows_df

# Type the biplot ggplot() here:



invisible(NULL)
