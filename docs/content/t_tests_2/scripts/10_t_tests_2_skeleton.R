# ==========================================================
# Activity 10: T-Tests II — Two-Sample vs. Paired
# Name:
# Date:
#
# Save this file as scripts/10_t_tests_2.R
#
# PART A (in class): run the code, answer the questions.
#                    A2-A6  our leaf data: two-sample and
#                           paired, pseudoreplication, the
#                           summarize() fix, rerun.
#                    A7-A12 sugar maple leaf AREA.
# PART B (hand in):  the same workflow on sugar maple leaf
#                    MASS — you write the code.
#
# Answers go in the boxes marked  # # # # # #  — type after
# "ANSWER:" and start every line with #
# ==========================================================

# Load libraries -------------------------------------------
library(readxl) # read Excel files
library(tidyverse) # dplyr + ggplot2 + pivot_wider()
library(janitor) # clean_names()
library(car) # leveneTest()

# Load the leaf data ---------------------------------------
leaf_df <-
  read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names()

# Load the sugar maple data --------------------------------
maple_df <-
  read_excel("data/2026_09_02_sugar_maple_leaf_area.xlsx") %>%
  clean_names()


# ##########################################################
# PART A — IN CLASS
# ##########################################################

# ---- A2: Two-sample t-test on every leaf ------------------

# Welch's two-sample t-test on the leaf data

# Pull out t, df, and p for the results sentence
tibble(
  t = leaf_model$statistic,
  df = leaf_model$parameter,
  p = leaf_model$p.value
)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA2. Reject or fail to reject H0? Does the 95% CI
#      include zero? Write the results sentence:
#      [Finding] (Welch's t-test: t(df) = X.XX, p = X.XX).
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A3: Where did these leaves come from? ----------------

# How many leaves did each team turn in?
leaf_df %>%
  count(teams, shade)

# %>%
#   pivot_wider(names_from = shade, values_from = n)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA3. How many teams are there? Did every team turn in
#      the same number of leaves? Which teams did not?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A4: Paired t-test on every leaf ----------------------

# Number the leaves within each team and side, then put
# the shady and sunny leaf with the same number in one row
leaf_wide_df <- leaf_df %>%
  group_by(teams, shade) %>%
  mutate(leaf_n = row_number()) %>%
  ungroup() %>%
  select(teams, leaf_n, shade, mass_g) %>%
  pivot_wider(names_from = shade, values_from = mass_g) %>%
  mutate(diff = shady - sunny)
leaf_wide_df

# Paired t-test on all the leaves

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA4. Record t, df, and p. How many pairs does df say
#      you have? Look at your table: WHY does shady leaf
#      #1 get paired with sunny leaf #1? Is there any
#      real reason those two leaves belong together?
#      (Note the NA rows - t.test() dropped those.)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A5: Pseudoreplication — the one-line fix -------------

# Those 6 shady leaves all came off ONE tree. They are not
# 6 independent data points. We sampled 5 trees, not 53.
#
# THE FIX: add the averaging step to the END of the chain
# that LOADS the data, keeping the same name (leaf_df) and
# the same column name (mass_g). In your own work you would
# scroll up and edit the load chunk at the top of the file,
# then rerun from there. Here it is again with the two new
# lines, so this script still runs top to bottom:

leaf_df <-
  read_excel("data/2026_09_03_data_sci_leaf_area.xlsx") %>%
  clean_names() %>%
  group_by(teams, shade) %>%
  summarize(mass_g = mean(mass_g), .groups = "drop")
leaf_df

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA5. How many rows does leaf_df have now? What is ONE
#      row - a leaf, a side, a team, or a tree?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A6: Rerun the same code and compare ------------------

# Park the pseudoreplicated results so we can compare
pseudo_2s <- leaf_model
pseudo_paired <- leaf_paired_model

# ---- The same two-sample code as A2, not one character
#      changed. Only leaf_df changed.
leaf_model <- t.test(mass_g ~ shade, data = leaf_df, var.equal = FALSE)
leaf_model

# ---- The same reshape + paired code as A4
leaf_wide_df <- leaf_df %>%
  group_by(teams, shade) %>%
  mutate(leaf_n = row_number()) %>%
  ungroup() %>%
  select(teams, leaf_n, shade, mass_g) %>%
  pivot_wider(names_from = shade, values_from = mass_g) %>%
  mutate(diff = shady - sunny)
leaf_wide_df

leaf_paired_model <- t.test(
  leaf_wide_df$shady,
  leaf_wide_df$sunny,
  paired = TRUE
)
leaf_paired_model


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA6. What happened to df? Did you lose data, or stop
#      double-counting it? The sign of t flips - shady
#      looked heavier before averaging and lighter after.
#      Given the uneven leaf counts from QA3, why would
#      averaging change the DIRECTION of the difference?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A7: Sugar maple — average per tree and side ----------

# How many leaves from each tree and side?
maple_df %>%
  count(tree, side)

# Average the 2 leaves per tree and side

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA7. Why do we average the 2 leaves from one side of
#      one tree? How many values per side do we have now?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A8: Two-sample — check, then test --------------------

# Normality of each side (tree means)

# Equal spread?

# Welch's two-sample t-test on the tree means

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA8. Were the assumptions OK? Two-sample t, df, p?
#      Reject or fail to reject?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A9: The slope plot -----------------------------------

# One line per tree: sunny -> shady - see if you can do it...

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA9. How many lines go up? Why can this pattern be
#      clear even when the two-sample test is borderline?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A10: Paired — check, then test ------------------------

# One row per tree + the shady - sunny difference
maple_wide_df <- maple_tree_df %>%
  pivot_wider(names_from = side, values_from = area) %>%
  mutate(diff = shady - sunny)
maple_wide_df

# QQ plot of the differences

# Shapiro-Wilk on the differences

# Paired t-test

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA10. Are the differences normal enough? Paired t, df,
#      p, and mean difference? Compare with the two-sample
#      p — why is the paired test so much stronger?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A11: Plot and report the paired result ----------------

# Save it (make a figures/ folder first if you need one)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA11. Write the results sentence:
#      [Finding] (paired t-test: t(df) = X.XX, p = X.XXX;
#      mean difference = X.X cm²).
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
