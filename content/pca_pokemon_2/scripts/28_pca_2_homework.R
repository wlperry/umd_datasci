# ==========================================================
# Activity 28 - HOMEWORK: add the body, name the axes
# Name:
# Date:
#
# Save as scripts/28_pca_2_homework.R
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class the PCA saw six battle stats. The file also has
# two REAL physical measurements: height_m and weight_kg.
# Here you put all EIGHT into the PCA, and then YOU name
# the axes. No answer is printed anywhere.
#
# HOW THIS FILE WORKS
# 1. The QUESTIONS are right below. Answer each one in the
#    # ANSWER: box, as # comments.
# 2. The CODE is below the questions, in numbered sections.
#    The section numbers match your in-class script.
# 3. HELPER CODE is written where something is new.
# 4. Where it says YOUR CODE, copy the same-numbered section
#    from your in-class scripts/28_pca_2.R.
#
# Class numbers, for comparing (six stats, 1,025 Pokemon):
#   PC1 44.1% (overall power), PC2 18.4% (tank vs glass
#   cannon), PC1 + PC2 62.5%
# ==========================================================


# ==========================================================
# QUESTIONS
# ==========================================================

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. (section 1) With eight columns, what % does PC1
#       hold? PC2? PC1 + PC2? More or less than in class?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q2. (section 2) Are all eight PC1 loadings the same
#       sign? Do height and weight join in? Give PC1 a name.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. (section 2) In the PC2 column, give the two biggest
#       positive and two biggest negative loadings. Then
#       give PC2 a name: what does high mean, what does low
#       mean?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. (section 4) Name the top 4 and bottom 4 Pokemon on
#       PC2. Do their stats support your name from H-Q3?
#       If not, change the name - and say that you did.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q5. (sections 5 and 6) Where do the legendaries and
#       mythicals sit on the new plot? Same as in class?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q6. (section 6) One Pokemon is so far out on PC1 it
#       squashes the whole plot. Hover to find it. Who is
#       it, and what about its height and weight puts it
#       there? (Look it up in pokemon.)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q7. (section 8) On your biplot, which arrow points
#       closest to weight_kg? Which arrows point nearly
#       opposite to it on PC2? What does that tell you?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q8. Five or six sentences, written as a PCA results
#       paragraph (follow the model in Activity 28, Part
#       10): what went in, that it was standardised,
#       variance per axis and together, a NAME for each
#       axis with the loadings that justify it, and real
#       Pokemon as evidence. Do not use "significant".
# ANSWER:
#
#
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# CODE
# ==========================================================

# ---- 1 Read the data, and the PCA on EIGHT columns -------
# [HELPER CODE] the same as class, except the select() now
# has height_m and weight_kg added on the end.
library(tidyverse)
library(plotly)
library(ggrepel)

pokemon <- read_csv("data/pokemon_1025.csv") %>%
  mutate(status = case_when(
    is_legendary ~ "legendary",
    is_mythical  ~ "mythical",
    TRUE         ~ "regular"))

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed,
         height_m, weight_kg)

# Scaling matters MORE now: metres and kilograms are not
# stat points. scale. = TRUE puts all eight on equal terms.

# YOUR CODE - the prcomp() and summary() lines from class
# section 1:  -> H-Q1



invisible(NULL)


# ---- 2 The loadings table --------------------------------
# YOUR CODE (copy section 2 from class):  -> H-Q2, H-Q3



invisible(NULL)


# ---- 4 Check your PC2 name from the extremes -------------
# YOUR CODE (copy section 4 from class). One change: add
# weight_kg to both select() lines, so they read
#   select(name, defense, speed, weight_kg, PC2)
# -> H-Q4



invisible(NULL)


# ---- 5 The picture, coloured by status -------------------
# YOUR CODE (copy section 5 from class):  -> H-Q5



invisible(NULL)


# ---- 6 Hover to explore ----------------------------------
# YOUR CODE (copy section 6 from class):  -> H-Q6



invisible(NULL)


# ---- 7 Label only the extremes ---------------------------
# YOUR CODE (copy section 7 from class)



invisible(NULL)


# ---- 8 The biplot ----------------------------------------
# [HELPER CODE] same as class - it now makes eight arrows
arrows_df <- as_tibble(poke_pca$rotation[, 1:2], rownames = "stat") %>%
  mutate(PC1 = PC1 * 5,
         PC2 = PC2 * 5)

arrows_df

# YOUR CODE - the biplot ggplot() from class:  -> H-Q7



invisible(NULL)


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and every
# plot must draw.
# ==========================================================
