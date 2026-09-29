# ==========================================================
# Activity 09: T-Tests I — Setting Up the Test
# Name:
# Date:
#
# Save this file as scripts/09_t_tests_1.R
#
# PART A (in class): run the leaf code, answer the questions.
# PART B (hand in):  check the assumptions yourself for the
#                    sugar maple leaves and answer the questions.
#                    (Sugar maple t-tests come in T-Tests II.)
#
# Answers go in the boxes marked  # # # # # #  — type after
# "ANSWER:" and start every line with #
# ==========================================================

# Load libraries -------------------------------------------
library(readxl)      # read Excel files
library(tidyverse)   # dplyr + ggplot2
library(janitor)     # clean_names()
library(car)         # leveneTest()

# Load the leaf data (Part A) ------------------------------
leaf_df <-
  read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names()

# Load the sugar maple data (Part B) -----------------------
maple_df <-
  read_excel("data/2026_09_02_sugar_maple_leaf_area.xlsx") %>%
  clean_names()

glimpse(leaf_df)
glimpse(maple_df)


# ##########################################################
# PART A — IN CLASS: leaf data (leaf_df, groups in `shade`)
# ##########################################################

# ---- A2: Descriptive stats --------------------------------

# Mean and SD of leaf mass for each side
leaf_df %>%
  group_by(shade) %>%
  summarize(
    n    = sum(!is.na(mass_g)),
    mean = mean(mass_g, na.rm = TRUE),
    sd   = sd(mass_g, na.rm = TRUE)
  )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA2. How far apart are the two means?
#      Which side has the bigger SD?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A3: Hypotheses ---------------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA3. Write H0 and HA for leaf mass in words AND symbols
#      (use mu for "mean"). One- or two-tailed? Alpha?
# ANSWER:
# H0:
# HA:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A4: Normality — stacked histograms -------------------

# Histograms of leaf mass, one on top of the other
leaf_df %>%
  ggplot(aes(x = mass_g)) +
  geom_histogram(binwidth = 0.05) +
  facet_wrap(~shade, ncol = 1)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA4. Each side: roughly bell-shaped, or a long tail?
#      Which side spreads wider?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A5: Normality — box plot and QQ plot -----------------

# Box plot of leaf mass by side
leaf_df %>%
  ggplot(aes(x = shade, y = mass_g)) +
  geom_boxplot()

# QQ plot of leaf mass for each side
leaf_df %>%
  ggplot(aes(sample = mass_g)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~shade)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA5. Each side: do the dots follow the line? Where do
#      they bend away? Does that match the long whisker
#      in the box plot?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A6: Normality — Shapiro-Wilk test --------------------

# Shapiro-Wilk p-value for each side
leaf_df %>%
  group_by(shade) %>%
  summarize(shapiro_p = shapiro.test(mass_g)$p.value)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA6. p for each side? Normal or not (p > 0.05)?
#      Does the test agree with your QQ plots?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A7: Equal variance — Levene's test -------------------

# Levene's test for equal variance
leveneTest(mass_g ~ shade, data = leaf_df)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA7. F and p? Equal spread or not?
#      Why do we use Welch's t-test either way?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A8: Welch's t-test -----------------------------------

# Welch's two-sample t-test
leaf_model <- t.test(mass_g ~ shade, data = leaf_df,
                     var.equal = FALSE)
leaf_model

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA8. t = ?   df = ?   p = ?
#      Reject H0 or fail to reject H0?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# PART B — HAND IN: sugar maple data (maple_df)
# Check the assumptions only — no t-test yet. We run the
# sugar maple t-tests (two-sample AND paired) in T-Tests II.
#
# Write the code yourself. Copy the matching Part A code
# and change what needs changing. Things that are different:
#   - the data frame is maple_df
#   - the groups are in a column called `side`
#   - mass is much bigger (check your histogram binwidth!)
# Every chunk needs a # comment saying what it does.
# ##########################################################

# ---- B2: Descriptive stats --------------------------------
# TODO: n, mean, and SD of mass_g for each side


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB2. How far apart are the two means?
#      Which side has the bigger SD?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B3: Hypotheses ---------------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB3. H0 and HA for sugar maple leaf mass, in words AND
#      symbols. One- or two-tailed? Alpha?
# ANSWER:
# H0:
# HA:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B4: Normality — stacked histograms -------------------
# TODO: histograms of mass_g, stacked with ncol = 1


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB4. Each side: bell-shaped, or a long tail?
#      What binwidth did you use, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B5: Normality — box plot and QQ plot -----------------
# TODO: box plot of mass_g by side


# TODO: QQ plot of mass_g for each side


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB5. Do the dots follow the line on each side?
#      Where (if anywhere) do they bend away?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B6: Normality — Shapiro-Wilk test --------------------
# TODO: Shapiro-Wilk p-value for each side


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB6. p for each side? Normal or not?
#      Does it agree with your QQ plots?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B7: Equal variance — Levene's test -------------------
# TODO: Levene's test for mass_g by side


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB7. F and p? Equal spread or not?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B8: Now check leaf AREA (total_area_cm2) ------------
# One more change: the variable. Same checks as B2, B4-B7.

# TODO: n, mean, and SD of total_area_cm2 for each side


# TODO: stacked histograms of total_area_cm2


# TODO: QQ plot of total_area_cm2 for each side


# TODO: Shapiro-Wilk p-value of total_area_cm2 for each side


# TODO: Levene's test for total_area_cm2 by side


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB8. Is leaf area normal enough for a t-test on each
#      side? Equal spread? Compare the shady and sunny
#      means — which side has bigger leaves?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B9: Look at the design -------------------------------
# TODO: count how many leaves came from each tree and side
#       (hint: count(tree, side))


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB9. Every tree has leaves from BOTH the sunny and the
#      shady side, and 2 leaves from each side.
#      a) Are the 2 leaves from one side of one tree really
#         independent of each other? Why or why not?
#      b) Why might it matter that the same tree gives us
#         both a sunny and a shady value?
#      (We come back to both next lecture.)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B10: Your decision ---------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB10. Put your checks together. For leaf MASS and for
#       leaf AREA: is a t-test OK, or would you switch to
#       a rank-based test? Which results (QQ plot,
#       Shapiro-Wilk, Levene's) back up your decision?
#       Next lecture we run the tests — so this decision
#       comes first.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in -----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
