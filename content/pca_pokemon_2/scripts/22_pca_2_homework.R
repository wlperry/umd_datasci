# ==========================================================
# Activity 22 - HOMEWORK: all 1,025 Pokemon, interpreted
# Name:
# Date:
#
# Save as scripts/22_pca_2_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# Last homework you ran the PCA on all 1,025 Pokemon and
# read the numbers. Now you INTERPRET it: name both axes,
# confirm them from the data, draw the picture, and draw the
# biplot.
#
# ----------------------------------------------------------
# HOW THIS ONE WORKS - READ THIS
#
# THE CODE IS ALREADY WRITTEN AND ALREADY RUNS. Press
# Ctrl/Cmd + Shift + Enter and the whole thing executes.
#
# Your job is to READ THE OUTPUT and answer the questions.
# Nearly all of the marks are for NAMING THE AXES and for
# the write-up. There is no output that will tell you
# whether you named them right - that is the whole point of
# today.
#
# The only code you write is in the OPTIONAL section at the
# bottom, and it is one number.
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section 3) Look at the PC1 column of the loadings.
#       Are all six loadings the same sign? Give the
#       smallest and largest. What kind of axis does that
#       make PC1 - a TOTAL or a TRADE-OFF?
# ANSWER:
#
#
# H-Q2. (section 3) Look at the PC2 column. Give the two
#       largest POSITIVE loadings and the two largest
#       NEGATIVE ones, with their numbers.
# ANSWER:
#
#
# H-Q3. (section 3) Based only on those loadings, give PC2 a
#       NAME - a short phrase describing what a high score
#       and a low score mean. This is your interpretation;
#       there is no output to check it against.
# ANSWER:
#
#
# H-Q4. (section 4) Now look at the Pokemon at each end of
#       PC2. List the top four and bottom four with their
#       defense and speed values. Do they support the name
#       you gave in H-Q3? If not, change the name - and say
#       that you changed it.
# ANSWER:
#
#
# H-Q5. (section 5) Describe your scores plot in two or
#       three sentences. What does moving LEFT TO RIGHT
#       mean? What does moving BOTTOM TO TOP mean? Roughly
#       what shape is the cloud of points?
# ANSWER:
#
#
# H-Q6. (section 6) In the plot coloured by legendary
#       status: where do the 71 legendaries sit? Is the
#       pattern clearer or messier than the 4 legendaries
#       from class, and why?
# ANSWER:
#
#
# H-Q7. (section 6) The is_legendary column was never given
#       to prcomp(). Why does that matter? What would be
#       wrong with including it in the PCA?
# ANSWER:
#
#
# H-Q8. (section 7) With 1,025 Pokemon the labelled plot is
#       crowded. Name ONE thing you would change to make it
#       readable, and say what you would lose by doing it.
# ANSWER:
#
#
# H-Q9. (section 8) On your biplot: do all six arrows point
#       the same way along PC1? Which two arrows are closest
#       to OPPOSITE each other? Which arrow is the LONGEST?
# ANSWER:
#
#
# H-Q10. Two sentences on the biplot trap. Pick any two
#        stats whose arrows look opposed on your biplot,
#        look up their actual correlation in section 2, and
#        explain why the two can disagree.
# ANSWER:
#
#
# H-Q11. Five or six sentences, written as a proper PCA
#        results paragraph for all 1,025 Pokemon. Follow the
#        model at the bottom of the in-class script: what
#        went in, that it was standardised, variance
#        explained per axis and cumulative, a NAME for each
#        axis, the loadings that justify each name, and
#        evidence from actual Pokemon. Do not use the word
#        "significant".
# ANSWER:
#
#
# H-Q12. (OPTIONAL section 9) What quantile cutoff did you
#        settle on, how many Pokemon did it label, and why
#        did you pick it?
# ANSWER:
#
#
#

# ==========================================================
# CODE - already written. Just run it.
# ==========================================================

# ---- 1 Libraries -----------------------------------------
library(tidyverse)
library(ggrepel)

invisible(NULL)


# ---- 2 Read it and re-run the PCA ------------------------
# The big file this time. Everything else is identical.

pokemon <- read_csv("data/pokemon_1025.csv")

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed)

# You will need this for H-Q10 - keep it where you can see it.
poke_stats %>%
  cor() %>%
  round(2)

poke_pca <- prcomp(poke_stats, center = TRUE, scale. = TRUE)

summary(poke_pca)

invisible(NULL)


# ---- 3 The loadings - name the axes ----------------------

round(poke_pca$rotation[, 1:3], 2)

# All same sign  -> a TOTAL axis
# Mixed signs    -> a TRADE-OFF axis
#
# -> H-Q1, H-Q2 and H-Q3

invisible(NULL)


# ---- 4 Confirm PC2 from the extremes ---------------------

poke_scores <- pokemon %>%
  mutate(PC1 = poke_pca$x[, 1],
         PC2 = poke_pca$x[, 2])

poke_scores %>%
  arrange(desc(PC2)) %>%
  select(name, defense, speed, PC2) %>%
  head(4)

poke_scores %>%
  arrange(PC2) %>%
  select(name, defense, speed, PC2) %>%
  head(4)

# Remember the two-step: read the loadings, THEN check the
# extremes. If they disagree, believe the extremes.
#
# -> H-Q4

invisible(NULL)


# ---- 5 The picture ---------------------------------------

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.5)

# -> H-Q5

invisible(NULL)


# ---- 6 Coloured by legendary status ----------------------
# 71 legendaries this time, not 4.

ggplot(poke_scores, aes(x = PC1, y = PC2, color = is_legendary)) +
  geom_point(alpha = 0.6, size = 1.8)

# -> H-Q6 and H-Q7

invisible(NULL)


# ---- 7 Label the extremes --------------------------------

extremes <- poke_scores %>%
  filter(abs(PC1) > quantile(abs(PC1), 0.97) |
         abs(PC2) > quantile(abs(PC2), 0.97))

nrow(extremes)

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(color = "grey75", alpha = 0.5) +
  geom_point(data = extremes, color = "firebrick", size = 1.8) +
  geom_text_repel(data = extremes, aes(label = name),
                  size = 2.5, max.overlaps = 30)

# -> H-Q8

invisible(NULL)


# ---- 8 The biplot ----------------------------------------

arrows_df <- as_tibble(poke_pca$rotation[, 1:2], rownames = "stat") %>%
  mutate(PC1 = PC1 * 4,
         PC2 = PC2 * 4)

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(color = "grey80", alpha = 0.5) +
  geom_segment(data = arrows_df,
               aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.2, "cm"))) +
  geom_text_repel(data = arrows_df, aes(label = stat),
                  fontface = "bold", size = 3.4)

# Read ANGLES, not positions.
#
# -> H-Q9, then H-Q10, then write H-Q11

invisible(NULL)


# ==========================================================
# OPTIONAL - make the labelled plot readable
#
# Section 7 labelled the top 3% on either axis. With 1,025
# Pokemon that is still a lot of labels.
#
# Change ONE number - the 0.97 - and re-run, until the plot
# is readable. Try 0.99, or 0.995. There is no correct
# value; it is a readability decision, and you make it by
# looking at the plot.
# ==========================================================

# ---- 9 Your own cutoff -----------------------------------
# -> then answer H-Q12.

# YOUR CODE - copy section 7 and change 0.97 to your value:

invisible(NULL)


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and all four
# plots must draw.
# ==========================================================
