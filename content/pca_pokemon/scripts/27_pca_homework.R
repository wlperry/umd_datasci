# ==========================================================
# Activity 21 - HOMEWORK: all 1,025 Pokemon
# Name:
# Date:
#
# Save as scripts/21_pca_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class we ran a PCA on the original 151 Pokemon. Here you
# run the identical analysis on ALL 1,025 - nine
# generations, twenty-five years of new designs.
#
# THE QUESTION: does PC1 still mean the same thing? Or was
# "overall power" just a quirk of the first 151?
#
# ----------------------------------------------------------
# HOW THIS ONE WORKS - READ THIS
#
# THE CODE IS ALREADY WRITTEN AND ALREADY RUNS. You do not
# have to write any code at all. Press Ctrl/Cmd + Shift +
# Enter and the whole thing executes.
#
# Your job is to READ THE OUTPUT and answer the questions in
# the ANSWERS block below. Almost all of the marks are for
# interpretation, not for typing.
#
# The only code you write is in the OPTIONAL section at the
# very bottom, and that is one line.
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section 2) How many Pokemon are in this file, and
#       how many of them are legendary? Compare both numbers
#       to class (151 Pokemon, 4 legendary).
# ANSWER:
#
#
# H-Q2. (section 3) Look at the correlation matrix. Name the
#       pair of stats with the STRONGEST positive
#       relationship, and give the number. Is it the same
#       pair that was strongest in class?
# ANSWER:
#
#
# H-Q3. (section 5) From summary(): what percentage of the
#       variance does PC1 explain? PC2? What is the
#       cumulative percentage for PC1 + PC2?
#       In class these were 39.6%, 21.5% and 61.1%.
# ANSWER:
#
#
# H-Q4. (section 5) Is PC1 capturing MORE or LESS of the
#       variance than it did with 151 Pokemon? Suggest one
#       reason why adding 874 more Pokemon might change it
#       in that direction.
# ANSWER:
#
#
# H-Q5. (section 6) Look at your scree plot. Where is the
#       elbow? How many components would you keep, and what
#       cumulative percentage does that give you?
# ANSWER:
#
#
# H-Q6. (section 7) Look at the PC1 column of the loadings.
#       Are all six numbers the same sign? What does that
#       tell you PC1 is measuring?
# ANSWER:
#
#
# H-Q7. (section 7) Look at the PC2 column. Which stat has
#       the LARGEST POSITIVE loading, and which has the
#       LARGEST NEGATIVE one? (Write both names and both
#       numbers - you will need this next class.)
# ANSWER:
#
#
# H-Q8. (section 9) Write down the top six Pokemon by PC1
#       and the bottom six. Do you recognise any of them?
#       Does the pattern match class, where the top was all
#       legendaries and the bottom was Magikarp and friends?
# ANSWER:
#
#
# H-Q9. (section 10) Give the mean PC1 for legendary and
#       non-legendary Pokemon, and both sample sizes. In
#       class the gap was 3.00 versus -0.08 but with only
#       n = 4 legendaries. Is the gap bigger or smaller
#       here - and which version do you trust more, and why?
# ANSWER:
#
#
# H-Q10. Four or five sentences, written as a short results
#        paragraph. Say what you did, report PC1 and PC2
#        variance explained, state what you think each axis
#        measures, and give your evidence for PC1 - naming
#        actual Pokemon. Finish with one sentence on whether
#        the 151 result held up.
# ANSWER:
#
#
# H-Q11. (OPTIONAL section 11) After adding height and
#        weight, what percentage does PC1 explain now, and
#        do height and weight load positively or negatively
#        on it? One sentence on whether adding them helped.
# ANSWER:
#
#
#

# ==========================================================
# CODE - already written. Just run it.
# ==========================================================

# ---- 1 Libraries -----------------------------------------
library(tidyverse)

invisible(NULL)


# ---- 2 Read the BIG file ---------------------------------
# The only real difference from class: pokemon_1025.csv
# instead of pokemon_151.csv. Identical columns.

pokemon <- read_csv("data/pokemon_1025.csv")

dim(pokemon)

pokemon %>% count(is_legendary)

# -> H-Q1

invisible(NULL)


# ---- 3 The six stats, and do they move together? ---------

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed)

poke_stats %>%
  cor() %>%
  round(2)

# Ignore the 1.00 diagonal. Look for the biggest off-diagonal
# number.
#
# -> H-Q2

invisible(NULL)


# ---- 4 Run the PCA ---------------------------------------
# scale. = TRUE, exactly as in class. Mind the full stop.

poke_pca <- prcomp(poke_stats, center = TRUE, scale. = TRUE)

invisible(NULL)


# ---- 5 Variance explained --------------------------------

summary(poke_pca)

# Read the "Proportion of Variance" and "Cumulative
# Proportion" rows.
#
# -> H-Q3 and H-Q4

invisible(NULL)


# ---- 6 Scree plot ----------------------------------------

var_df <- tibble(
  PC      = paste0("PC", 1:6),
  percent = round(100 * poke_pca$sdev^2 / sum(poke_pca$sdev^2), 1)
)

var_df

ggplot(var_df, aes(x = PC, y = percent)) +
  geom_col() +
  geom_text(aes(label = percent), vjust = -0.4)

# Look for the elbow - where the bars flatten out.
#
# -> H-Q5

invisible(NULL)


# ---- 7 The loadings - what the axes are made of ----------

round(poke_pca$rotation[, 1:2], 2)

# PC1 column: are all six the same sign?
# PC2 column: find the biggest positive and biggest negative.
#
# -> H-Q6 and H-Q7

invisible(NULL)


# ---- 8 Glue the scores back on ---------------------------

poke_scores <- pokemon %>%
  mutate(PC1 = poke_pca$x[, 1],
         PC2 = poke_pca$x[, 2])

invisible(NULL)


# ---- 9 The ends of PC1 -----------------------------------

poke_scores %>%
  arrange(desc(PC1)) %>%
  select(name, is_legendary, PC1) %>%
  head(6)

poke_scores %>%
  arrange(PC1) %>%
  select(name, PC1) %>%
  head(6)

# -> H-Q8

invisible(NULL)


# ---- 10 Legendary versus the rest ------------------------

poke_scores %>%
  group_by(is_legendary) %>%
  summarise(n = n(),
            mean_PC1 = round(mean(PC1), 2))

# -> H-Q9, and then write H-Q10

invisible(NULL)


# ==========================================================
# OPTIONAL - add body size to the PCA
#
# So far the PCA has only seen the six battle stats. The
# file also has height_m and weight_kg - real physical
# measurements.
#
# Add them and see what happens. This is ONE line of code:
# copy the select() from section 3 and add the two columns
# to it. Everything below it already works.
# ==========================================================

# ---- 11 Eight columns instead of six ---------------------
# -> then answer H-Q11.

# YOUR CODE - copy section 3's select() and add
#             height_m and weight_kg:
#
# poke_stats_big <- pokemon %>%
#   select(hp, attack, defense, sp_attack, sp_defense, speed,
#          height_m, weight_kg)

# These three lines already work once the line above runs:
#
# poke_pca_big <- prcomp(poke_stats_big, center = TRUE, scale. = TRUE)
# summary(poke_pca_big)
# round(poke_pca_big$rotation[, 1:2], 2)

invisible(NULL)


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and your
# scree plot must draw.
# ==========================================================
