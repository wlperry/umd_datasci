# ==========================================================
# Activity 27 - HOMEWORK: does Gen 1 tell the same story?
# Name:
# Date:
#
# Save as scripts/27_pca_homework.R
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class you ran a PCA on all 1,025 Pokemon. The original
# game had only 151 (Generation I). If you only had those
# 151, would PCA have found the same axes?
#
# HOW THIS FILE WORKS
# 1. The QUESTIONS are right below. Answer each one in the
#    # ANSWER: box, as # comments.
# 2. The CODE is below the questions, in numbered sections.
#    The section numbers match your in-class script.
# 3. HELPER CODE is written where something is new.
# 4. Where it says YOUR CODE, copy the same-numbered section
#    from your in-class scripts/27_pca.R. Same code - only
#    the data changed.
#
# Class numbers, for comparing (all 1,025 Pokemon):
#   PC1 44.1%, PC2 18.4%, PC1 + PC2 62.5%
#   mean PC1: legendary 2.38 (n = 71), regular -0.24
# ==========================================================


# ==========================================================
# QUESTIONS
# ==========================================================

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. (section 5) Which pair of stats has the strongest
#       correlation in Gen 1? Is it the same pair as for
#       all 1,025 (defense & sp_defense, 0.50)?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q2. (section 8) What % does PC1 hold in Gen 1? PC2?
#       PC1 + PC2? Is PC1 bigger or smaller than in class?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. (section 9) Looking at your scree plot, how many
#       PCs would you keep, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. (section 10) Are all six PC1 loadings the same
#       sign? Is PC1 still an "overall power" axis?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q5. (section 11) Name the top 3 and bottom 3 Pokemon on
#       PC1. Do they make sense as strongest and weakest?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q6. (section 12) Give the mean PC1 for legendaries and
#       how many there are. In class there were 71. Which
#       gap do you trust more, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q7. (section 13) Hover over your plot. Pick ONE Pokemon
#       whose position surprised you. Where is it, and what
#       in its stats explains it? (Look it up in pokemon.)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q8. Three or four sentences: what you did, how much PC1
#       and PC2 hold, what PC1 means and your evidence
#       (name real Pokemon). Does Gen 1 tell the same story
#       as all 1,025? No p-values - nothing was tested.
# ANSWER:
#
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# CODE
# ==========================================================

# ---- 1 Libraries [HELPER CODE] ---------------------------
library(tidyverse)
library(plotly)

invisible(NULL)


# ---- 2 Read the data, keep only Generation I [HELPER CODE]
# Same file as class. The filter() line is the only new
# thing in this whole homework.
pokemon <- read_csv("data/pokemon_1025.csv") %>%
  mutate(status = case_when(
    is_legendary ~ "legendary",
    is_mythical  ~ "mythical",
    TRUE         ~ "regular")) %>%
  filter(generation == "generation-i")

pokemon %>% count(status)

# Should be 151 Pokemon. Because the data is now called
# pokemon again, ALL of your class code works unchanged.

invisible(NULL)


# ---- 4 The six stats -------------------------------------
# YOUR CODE (copy section 4 from class):



invisible(NULL)


# ---- 5 Correlation table ---------------------------------
# YOUR CODE (copy section 5 from class):  -> H-Q1



invisible(NULL)


# ---- 8 Run the PCA, and summary() ------------------------
# YOUR CODE (copy section 8 from class):  -> H-Q2



invisible(NULL)


# ---- 9 Scree plot ----------------------------------------
# [HELPER CODE] percent of variance for each PC
var_df <- tibble(
  PC      = paste0("PC", 1:6),
  percent = round(100 * poke_pca$sdev^2 / sum(poke_pca$sdev^2), 1)
)

var_df

# YOUR CODE - the ggplot() bar chart from class:  -> H-Q3



invisible(NULL)


# ---- 10 Loadings -----------------------------------------
# YOUR CODE (copy section 10 from class):  -> H-Q4



invisible(NULL)


# ---- 11 Scores, top and bottom of PC1 --------------------
# YOUR CODE (copy section 11 from class):  -> H-Q5



invisible(NULL)


# ---- 12 Mean PC1 for each status -------------------------
# YOUR CODE (copy section 12 from class):  -> H-Q6



invisible(NULL)


# ---- 13 The hover plot -----------------------------------
# YOUR CODE (copy section 13 from class):  -> H-Q7



invisible(NULL)


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and both
# plots must draw.
# ==========================================================
