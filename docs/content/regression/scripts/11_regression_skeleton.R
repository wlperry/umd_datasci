# ==========================================================
# Activity 11: Regression — tracing mass into leaf area
# Name:
# Date:
#
# Save this file as scripts/11_regression.R
#
# ALL the code is written for you. Run it chunk by chunk and
# watch what comes out.
#
# You answer FOUR questions, in the boxes marked # # # # # #
# after "ANSWER:", with every line starting with #
#
# Your ANSWERS are what gets graded.
# ==========================================================

# Load libraries -------------------------------------------
library(readxl) # read Excel files
library(tidyverse) # dplyr + ggplot2
library(janitor) # clean_names()


# ---- 1: The study ----------------------------------------
# We picked a tree and took leaves from the SUNNY side and
# from the SHADY side. Each team traced their leaves onto
# paper, cut out the tracings, and weighed them.
#
# A tracing mass is not an area. So we also weighed pieces
# of the SAME paper cut to areas we already knew. That is
# what the regression is for.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. What is the QUESTION this study is asking?
#     One sentence.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. What are the HYPOTHESES?
#     Give the null and the alternative, for leaf area and
#     for leaf mass.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 2: Read the calibration data ------------------------

paper_df <- read_excel("data/paper_area_weights.xlsx") %>%
  clean_names()

paper_df


# ---- 3: The regression -----------------------------------
# We CHOSE the areas and MEASURED the masses, so area goes
# on x and mass goes on y. The thing you measured, with the
# error in it, always goes on the y axis.

paper_df %>%
  ggplot(aes(x = area_cm2, y = mass_g)) +
  geom_point() +
  geom_smooth(method = "lm")

paper_model <- lm(mass_g ~ area_cm2, data = paper_df)

summary(paper_model)

# These numbers are tiny, so R prints them in SCIENTIFIC
# notation. In the Coefficients table you will see:
#
#   (Intercept) -2.058e-03     which is  -0.002058
#   area_cm2     7.660e-03     which is   0.007660
#
# 7.660e-03 means 7.660 x 10^-3: move the decimal point
# three places to the LEFT.
#
# OPTIONAL - if you would rather read plain decimals:
#   options(scipen = 999)     # scientific notation off
#   options(scipen = 0)       # and back on again
# We leave it on, because with it off a tiny p-value
# prints as <0.0000000000000002.

# ---- 4: Are the regression assumptions met? --------------
# All four residual plots in one call
par(mfrow = c(2, 2))
plot(paper_model)

# Put the plotting window back to one panel
par(mfrow = c(1, 1))

# Panel 1  Residuals vs Fitted - straight? equal scatter?
# Panel 2  Normal Q-Q          - misses bell-shaped?
# Panel 3  Scale-Location      - scatter constant?
# Panel 4  Residuals vs Leverage - any one point in charge?

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q3. Looking at the four plots, are the assumptions of
#     the regression met? Say what you SEE in each plot,
#     not what you hope to see. If something looks wrong,
#     say which plot and what it means.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 5: Turn every tracing mass into a leaf area ---------

# The model says
#     mass = intercept + slope * area
# We have the mass and we want the area, so rearrange:
#     area = (mass - intercept) / slope
#
# Type the two numbers in from the summary() output above,
# written out of scientific notation.

intercept <- -0.002058
slope <- 0.007660

# Paper is sold by mass per square METRE. 1 m2 = 10000 cm2.
slope * 10000

leaf_df <- read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names() %>%
  mutate(area_cm2 = (paper_mass_g - intercept) / slope)

leaf_df

# Some leaves have NA for area - that team never weighed
# their tracings. R keeps the gap instead of inventing a
# number, which is what you want.

# ---- 5b: OPTIONAL - let R hand you the numbers -----------
# You do not have to type the coefficients in. coef() pulls
# them straight out of the model.

coef(paper_model)

# Notice coef() prints plain decimals - there is no
# scientific notation to convert.

# One at a time, by position:
coef(paper_model)[1] # the intercept
coef(paper_model)[2] # the slope

# Or by name, which is harder to get wrong:
coef(paper_model)["(Intercept)"]
coef(paper_model)["area_cm2"]

# So Part 5 could be written with no typed numbers at all.
# This makes a SECOND copy so the rest of the script keeps
# using the version you typed:
leaf_coef_df <- leaf_df %>%
  mutate(
    area_cm2 = (paper_mass_g - coef(paper_model)[1]) /
      coef(paper_model)[2]
  )

# Same answer either way - compare the first three:
head(leaf_df$area_cm2, 3)
head(leaf_coef_df$area_cm2, 3)

# Either way is fine. Typing them in keeps the arithmetic
# visible; coef() means you cannot mistype a digit.

# ---- 6: One value per team per side ----------------------
# Leaves from the same team on the same side are NOT
# independent - they came off the same branch of the same
# tree. Using all 53 leaves as if they were independent is
# PSEUDOREPLICATION.
#
# The fix: average them, so each team gives ONE sunny value
# and ONE shady value.

team_df <- leaf_df %>%
  group_by(teams, shade) %>%
  summarize(
    area_cm2 = mean(area_cm2, na.rm = TRUE),
    mass_g = mean(mass_g, na.rm = TRUE),
    .groups = "drop"
  )

team_df


# ---- 7: Paired t-tests -----------------------------------
# Each team measured BOTH sides of the tree, so sunny and
# shady are paired within a team. A paired test needs one
# row per team, so reshape first.

wide_df <- team_df %>%
  pivot_wider(names_from = shade, values_from = c(area_cm2, mass_g))

wide_df

# Paired t-test on leaf AREA
area_paired_model <- t.test(
  wide_df$area_cm2_shady,
  wide_df$area_cm2_sunny,
  paired = TRUE
)

area_paired_model

# Paired t-test on leaf MASS
mass_paired_model <- t.test(
  wide_df$mass_g_shady,
  wide_df$mass_g_sunny,
  paired = TRUE
)

mass_paired_model

# Note the df. One team has no tracings at all, so the AREA
# test uses 4 teams and the MASS test uses 5.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4. What do you CONCLUDE from the two paired t-tests?
#     For each test give the mean difference, t, df and p,
#     and say in plain words what it means for sunny
#     versus shady leaves. Do the two tests agree?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ##########################################################
# HOMEWORK - sugar maple
#
# Now do the same thing on your own, with leaves I collected
# from sugar maple trees:
#
#   data/2026_09_02_sugar_maple_leaf_area.xlsx
#
# Write your own script - nothing is filled in below. Use
# the activity above as your model; the steps are the same
# and most lines change only by a name.
#
# ONE difference: these leaves were measured on a scanner,
# so the area is already in the file as total_area_cm2.
# There is no tracing paper to convert. Your regression is
# therefore leaf MASS against leaf AREA, which gives you the
# mass of one square centimetre of LEAF.
#
# The columns you need: tree, side, total_area_cm2, mass_g
#
# Answer the SAME four questions, as comments, in your
# script.
# ##########################################################

# ---- H1: Read the data -----------------------------------
# TODO: library() calls, then read_excel() + clean_names()
#       Look at it. How many trees? How many leaves per
#       tree per side?

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. What is the QUESTION of this study?
# ANSWER:
#
# H-Q2. What are the HYPOTHESES, for area and for mass?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H2: The regression ----------------------------------
# TODO: plot mass_g against total_area_cm2 - area on x,
#       mass on y, for the same reason as in class.
# TODO: fit it with lm(), then summary().
# TODO: write down the intercept and the slope, out of
#       scientific notation. What is the mass of 1 cm2 of
#       leaf? And of 1 m2?
#
# NOTE: the maple areas were scanned, so you do NOT need to
#       convert anything. You already have the area.

# ---- H3: Check the assumptions ---------------------------
# TODO: par(mfrow = c(2, 2)), plot() the model, then set
#       par(mfrow = c(1, 1)) again.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. Are the assumptions of the regression met? Say
#       what you see in each of the four plots. Is it
#       better or worse behaved than the paper?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H4: One value per tree per side ---------------------
# Two leaves from the same side of the same tree are not
# independent - same pseudoreplication problem as in class.
#
# TODO: group_by() the tree and the side, then summarize()
#       the mean area and the mean mass.
#       How many rows should you end up with?

# ---- H5: Paired t-tests ----------------------------------
# Each tree has a sunny side AND a shady side, so the tree
# is the pair.
#
# TODO: pivot_wider() to one row per tree.
# TODO: paired t-test on area, and on mass.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. What do you CONCLUDE from the two paired t-tests?
#       Mean difference, t, df and p for each, then what it
#       means in plain words. Which side has the bigger
#       leaves, and is the result clearer or murkier than
#       the class data? Why might that be?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in -----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
