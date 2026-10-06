# ==========================================================
# Activity 11: Linear Regression
# Name:
# Date:
#
# Save this file as scripts/11_regression.R
#
# The code is already written. Run it chunk by chunk and
# type your answers in the boxes marked  # # # # # #  —
# after "ANSWER:", with every line starting with #
#
# Your ANSWERS are what gets graded.
# ==========================================================

# Load libraries -------------------------------------------
library(readxl) # read Excel files
library(tidyverse) # dplyr + ggplot2
library(janitor) # clean_names()

# Load the paper calibration data -------------------------
paper_df <- read_excel("data/paper_area_weights.xlsx")

# Load our leaf data (used in Step 8) ----------------------
leaf_df <-
  read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names()

glimpse(paper_df)


# ---- 1: Which variable is which -------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. Which column is the explanatory variable (X) and
#      which is the response (Y)? Why that direction,
#      given that what we want is leaf AREA?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 2: Plot it before you fit it -----------------------

# Scatter plot of area against mass
paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. Straight or curved? Any obvious outlier?
#      Is a straight line the right tool here?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 3: Fit the regression ------------------------------

# Fit the regression line (Y ~ X)
paper_lm_model <- lm(area_cm2 ~ mass_g, data = paper_df)

# Read the model
summary(paper_lm_model)

# ---- 4: Read the summary() output -----------------------
# slope       = Coefficients, mass_g row, Estimate column
# intercept   = Coefficients, (Intercept) row, Estimate
# p for slope = Coefficients, mass_g row, Pr(>|t|)
# R-squared   = Multiple R-squared, near the bottom
# F and df    = the F-statistic line at the very bottom

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4a. The slope, with units: every extra 1 g of this
#       paper is another ____ cm2 of area.
# ANSWER:
#
# Q4b. The intercept is ____ and its p-value is 0.126 —
#       not significant. Why is that the RIGHT answer
#       physically? (What is the area of a piece of paper
#       that weighs nothing?)
# ANSWER:
#
# Q4c. The fitted equation:
#       area = ____ + ____ x mass
# ANSWER:
#
# Q4d. The slope's p-value = ____   R-squared = ____
#       What does each one tell you, and why are they
#       answering different questions?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 5: Draw the fitted line ----------------------------

# Scatter plot with the fitted line and 95% band
paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point() +
  geom_smooth(method = "lm")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q5. Where is the grey band widest, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 6: Check the residuals -----------------------------

# All four residual plots in one call
par(mfrow = c(2, 2))
plot(paper_lm_model)

# Put the plotting window back to one panel
par(mfrow = c(1, 1))

# How big are the misses at each square size?
paper_df %>%
  mutate(residual = residuals(paper_lm_model)) %>%
  group_by(area_cm2) %>%
  summarize(biggest_miss = round(max(abs(residual)), 2))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q6a. Describe panel 1. Flat cloud, curve, or funnel?
# ANSWER:
#
# Q6b. Worst miss for a 1 cm2 square = ____
#       Worst miss for a 567 cm2 square = ____
#       Which assumption does that pattern break?
# ANSWER:
#
# Q6c. R-squared is 0.9999 and the residual plot still
#       has a problem. How can both be true at once?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 7: Predict one tracing -----------------------------

# Predict the area of one leaf tracing
one_tracing <- tibble(mass_g = 0.138)

predict(paper_lm_model, newdata = one_tracing)

# Two tracings, with 95% prediction intervals
two_tracings <- tibble(mass_g = c(0.092, 0.138))

predict(paper_lm_model, newdata = two_tracings, interval = "prediction")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q7. Predicted area for the 0.138 g tracing = ____
#      95% prediction interval = ____ to ____
#      Which tracing is predicted larger, and does that
#      make sense?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 8: Convert a whole column of tracings --------------

# Turn every tracing mass into an area
# predict() needs the column to be called mass_g —
# the same name the model was built with
leaf_df <- leaf_df %>%
  mutate(
    leaf_area_cm2 = predict(
      paper_lm_model,
      newdata = tibble(mass_g = paper_mass_g)
    )
  )

leaf_df %>%
  select(teams, shade, mass_g, paper_mass_g, leaf_area_cm2)

# Predicted leaf area by side
leaf_df %>%
  ggplot(aes(x = shade, y = leaf_area_cm2)) +
  geom_boxplot() +
  geom_jitter(width = 0.15)

# Mean predicted area per side
leaf_df %>%
  group_by(shade) %>%
  summarize(
    n = sum(!is.na(leaf_area_cm2)),
    mean_area = mean(leaf_area_cm2, na.rm = TRUE)
  )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q8a. Mean predicted area: shady = ____  sunny = ____
#       Does that match what the t-test told you about
#       leaf MASS in Activities 9-10?
# ANSWER:
#
# Q8b. Some leaves have NA for leaf_area_cm2. Why?
#       (Look at paper_mass_g for that team.) Is R right
#       to leave them missing?
# ANSWER:
#
# Q8c. Why is "shady leaves are about 1 cm2 bigger" more
#       useful to a reader than "shady leaves weigh
#       0.02 g more"?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 9: Write the results sentence ----------------------
# Read every number off YOUR summary() output.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q9. Fill this in, then add one sentence about what the
#      residual plot showed and what you are being
#      careful about because of it.
#
#      ____ was a strong predictor of ____ (linear
#      regression: F(___, ___) = ____, p ____,
#      R2 = ____). The fitted equation was
#      area = ____ + ____ x mass.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# EXTENSION — out of class. Answers as # comments below.
# ##########################################################

# ---- E1: Calibrate something only you have ---------------
# Cut a shape out of paper, weigh it, predict its area
# from paper_lm_model with a prediction interval, then
# measure the real area on graph paper.
# TODO: your predict() code here


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# E1. Shape = ____   mass = ____ g
#     Predicted area = ____   interval ____ to ____
#     Counted area = ____
#     Did the counted area land inside the interval?
# ANSWER:
#
# E2a. Using YOUR R-squared from Step 4: what fraction of
#      the variation in area does the line account for,
#      and what does R-squared NOT tell you?
# ANSWER:
#
# E2b. Why is a PREDICTION interval wider than a
#      CONFIDENCE interval at the same mass?
# ANSWER:
#
# E2c. Run max(paper_df$mass_g). If your shape had been
#      cardboard weighing 9 g, why would predicting its
#      area be a different kind of mistake?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in ----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
