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
library(readxl)      # read Excel files
library(tidyverse)   # dplyr + ggplot2 + pivot_wider()
library(janitor)     # clean_names()
library(car)         # leveneTest()

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
leaf_model <- t.test(mass_g ~ shade, data = leaf_df,
                     var.equal = FALSE)
leaf_model

# Pull out t, df, and p for the results sentence
tibble(
  t  = leaf_model$statistic,
  df = leaf_model$parameter,
  p  = leaf_model$p.value
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
  count(teams, shade) %>%
  pivot_wider(names_from = shade, values_from = n)

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
leaf_paired_model <- t.test(leaf_wide_df$shady,
                            leaf_wide_df$sunny,
                            paired = TRUE)
leaf_paired_model

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
  summarize(mass_g = mean(mass_g),
            .groups = "drop")
leaf_df

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA5. How many rows does leaf_df have now? What is ONE
#      row - a leaf, a side, a team, or a tree?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A6: Rerun the same code and compare ------------------

# Park the pseudoreplicated results so we can compare
pseudo_2s     <- leaf_model
pseudo_paired <- leaf_paired_model

# ---- The same two-sample code as A2, not one character
#      changed. Only leaf_df changed.
leaf_model <- t.test(mass_g ~ shade, data = leaf_df,
                     var.equal = FALSE)
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

leaf_paired_model <- t.test(leaf_wide_df$shady,
                            leaf_wide_df$sunny,
                            paired = TRUE)
leaf_paired_model

# All four results side by side
tibble(
  analysis = c("Two-sample, every leaf",
               "Paired, every leaf",
               "Two-sample, team means",
               "Paired, team means"),
  t  = c(pseudo_2s$statistic, pseudo_paired$statistic,
         leaf_model$statistic, leaf_paired_model$statistic),
  df = c(pseudo_2s$parameter, pseudo_paired$parameter,
         leaf_model$parameter, leaf_paired_model$parameter),
  p  = c(pseudo_2s$p.value, pseudo_paired$p.value,
         leaf_model$p.value, leaf_paired_model$p.value)
)

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
maple_tree_df <- maple_df %>%
  group_by(tree, side) %>%
  summarize(area = mean(total_area_cm2),
            .groups = "drop")
maple_tree_df

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA7. Why do we average the 2 leaves from one side of
#      one tree? How many values per side do we have now?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A8: Two-sample — check, then test --------------------

# Normality of each side (tree means)
maple_tree_df %>%
  group_by(side) %>%
  summarize(shapiro_p = shapiro.test(area)$p.value)

# Equal spread?
leveneTest(area ~ side, data = maple_tree_df)

# Welch's two-sample t-test on the tree means
maple_2s_model <- t.test(area ~ side,
                         data = maple_tree_df,
                         var.equal = FALSE)
maple_2s_model

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA8. Were the assumptions OK? Two-sample t, df, p?
#      Reject or fail to reject?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A9: The slope plot -----------------------------------

# One line per tree: sunny -> shady
maple_tree_df %>%
  ggplot(aes(x = side, y = area, group = tree)) +
  geom_line() +
  geom_point() +
  scale_x_discrete(limits = c("sunny", "shady"))

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
maple_wide_df %>%
  ggplot(aes(sample = diff)) +
  stat_qq() +
  stat_qq_line()

# Shapiro-Wilk on the differences
shapiro.test(maple_wide_df$diff)

# Paired t-test
maple_paired_model <- t.test(maple_wide_df$shady,
                             maple_wide_df$sunny,
                             paired = TRUE)
maple_paired_model

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA10. Are the differences normal enough? Paired t, df,
#      p, and mean difference? Compare with the two-sample
#      p — why is the paired test so much stronger?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A11: Plot and report the paired result ----------------

# Label with the paired test result
paired_label <- paste0(
  "Paired t-test: t = ",
  round(maple_paired_model$statistic, 2),
  ", df = ", maple_paired_model$parameter, ", ",
  scales::pvalue(maple_paired_model$p.value,
                 add_p = TRUE)
)

# Each tree in grey + mean ± SE in color
maple_results_plot <- maple_tree_df %>%
  ggplot(aes(x = side, y = area)) +
  geom_line(aes(group = tree), color = "grey70") +
  geom_point(color = "grey70") +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.1, color = "darkgreen") +
  stat_summary(fun = mean, geom = "point",
               size = 4, color = "darkgreen") +
  scale_x_discrete(limits = c("sunny", "shady")) +
  labs(x = "Side of tree",
       y = "Mean leaf area (cm²)",
       subtitle = paired_label) +
  theme_minimal()
maple_results_plot

# Save it (make a figures/ folder first if you need one)
ggsave("figures/maple_area_paired_plot.png",
       plot = maple_results_plot,
       width = 5, height = 4, dpi = 300)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA11. Write the results sentence:
#      [Finding] (paired t-test: t(df) = X.XX, p = X.XXX;
#      mean difference = X.X cm²).
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A12: Rank-based backups -------------------------------

# Mann-Whitney U: two-sample partner
wilcox.test(area ~ side, data = maple_tree_df)

# Wilcoxon signed-rank: paired partner
wilcox.test(maple_wide_df$shady, maple_wide_df$sunny,
            paired = TRUE)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA12. p for each? Which one "misses" that the t-test
#      caught? Would you use these here — why or why not?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# PART B — HAND IN: sugar maple leaf MASS (mass_g)
#                   (matches A7-A12)
#
# Write the code yourself. Copy the matching Part A code
# and change what needs changing:
#   - the variable is mass_g, not total_area_cm2
#   - call the averaged column `mass` (not `area`)
#   - use new names so you don't overwrite Part A:
#     mass_tree_df, mass_wide_df, mass_2s_model,
#     mass_paired_model, mass_results_plot
# Every chunk needs a # comment saying what it does.
# ##########################################################

# ---- B7: Average per tree and side ------------------------
# TODO: mass_tree_df — mean mass_g per tree and side


# ---- B8: Two-sample — check, then test --------------------
# TODO: Shapiro-Wilk p for each side (tree means)


# TODO: Levene's test


# TODO: Welch's two-sample t-test -> mass_2s_model


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB8. Assumptions OK? t, df, p? Reject or fail to reject?
#      Is this the same answer you got for leaf area?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B9: The slope plot -----------------------------------
# TODO: one line per tree, sunny -> shady


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB9. How many lines go up? What does that suggest,
#      whatever the two-sample test said?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B10: Paired — check, then test ------------------------
# TODO: mass_wide_df — pivot_wider + diff column


# TODO: QQ plot of the differences


# TODO: Shapiro-Wilk on the differences


# TODO: paired t-test -> mass_paired_model


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB10. Differences normal enough? Paired t, df, p, and
#      mean difference? The two-sample and paired tests
#      disagree for mass — which one do you trust, and
#      WHY? (Think about the design.)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B11: Plot and report the paired result ----------------
# TODO: label from mass_paired_model


# TODO: mass_results_plot — grey tree lines + mean ± SE
#       (fix the y-axis label: this is mass in g!)


# TODO: save it as figures/maple_mass_paired_plot.png


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB11. Results sentence for the paired test on mass:
#      [Finding] (paired t-test: t(df) = X.XX, p = X.XXX;
#      mean difference = X.XX g).
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B12: Rank-based backups -------------------------------
# TODO: Mann-Whitney U on the tree means


# TODO: Wilcoxon signed-rank (paired)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB12. Do the rank-based tests tell the same story as the
#      t-tests? Based on your assumption checks, which
#      test should go in a report — and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in -----------------------------------
# Run the whole script top to bottom (Ctrl/Cmd + Shift + Enter)
# and make sure there are no errors.
