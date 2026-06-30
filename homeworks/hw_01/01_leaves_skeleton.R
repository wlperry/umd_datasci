# =============================================================================
# Homework 01 — Sunny vs. Shady Leaves
# BIOL 3810 Data Science for Biology — Bill Perry
#
# Name:
# Date:
#
# Fill in every blank marked with _____  and answer every Q# below
# as a # comment. The Q numbers match the homework question sheet.
#
# Reference: Lecture 01 (hypotheses, data design),
#            Lecture 02 (R basics, loading data, ggplot),
#            Worksheet 01, Worksheet 02
#
# R for Data Science: https://r4ds.hadley.nz/
# Data Carpentry:     https://datacarpentry.github.io/R-ecology-lesson/
# =============================================================================


# ── STEP 1: Load packages ─────────────────────────────────────────────────────
# ALL library() calls go here at the top — never buried in the middle of a script
# If you see "there is no package called ...", run install.packages("name") first

library(tidyverse)   # data wrangling + ggplot2 (includes dplyr, readr, ggplot2)
library(readxl)      # for read_excel() — not used today but always good to load
library(skimr)       # fast data summaries: skim()


# ── STEP 2: Load the data ─────────────────────────────────────────────────────
# read_csv() loads a CSV file (see Lecture 02 / Worksheet 02, Part 6)
# Make sure tree_leaves.csv is inside your data/ folder first

leaf_df <- read_csv("data/tree_leaves.csv")

# Inspect the data frame
glimpse(leaf_df)   # column names, types, and first values
head(leaf_df)      # first 6 rows
dim(leaf_df)       # rows × columns

# Q1 — Total rows in the dataset:  _______
# Q2 — Total columns:  _______
# Q3 — Data type of the side column (from glimpse):  _______

# Count how many leaves per side
count(leaf_df, side)

# Q4 — Number of sunny leaves:  _______
# Q5 — Number of shady leaves:  _______


# ── STEP 3: Why sum(!is.na()) beats length() ──────────────────────────────────
# length() counts ALL values including NA — it gives the wrong n when data are missing
# sum(!is.na()) counts only real (non-missing) values — always use this for n
# (see Lecture 02)

# The wrong way — includes NA values in the count
length(leaf_df$area_cm2)

# The right way — only counts real values
sum(!is.na(leaf_df$area_cm2))

# Q6 — What does length() return?  _______
# Q7 — What does sum(!is.na()) return?  _______
# Q8 — Are those numbers the same?  Y / N  _______
# Q9 — If they differ, what does the difference tell you?
#


# ── STEP 4: Descriptive statistics with group_by() + summarize() ──────────────
# group_by() tells R which groups to compute stats for
# summarize() calculates one row of stats per group
# See Lecture 02 / Worksheet 02, and R4DS Ch. 3: https://r4ds.hadley.nz/data-transform.html

leaf_stats_df <- leaf_df %>%
  group_by(_____) %>%                                      # group by the side column
  summarize(
    n_weight   = sum(!is.na(_____)),                       # count non-missing weight values
    mean_wt    = round(mean(weight_g,  na.rm = TRUE), 2),  # mean leaf weight
    sd_wt      = round(sd(weight_g,    na.rm = TRUE), 2),  # standard deviation
    se_wt      = round(sd_wt / sqrt(n_weight), 2),         # standard error = SD / sqrt(n)
    mean_width = round(mean(width_cm,  na.rm = TRUE), 2),  # mean leaf width
    mean_ht    = round(mean(height_cm, na.rm = TRUE), 2)   # mean leaf height
  )

leaf_stats_df

# Fill in the table on the homework sheet from this output:
# Q10 — Is mean weight higher for shady than sunny?  Y / N  _______
# Q11 — Difference in mean weight (shady minus sunny):  _______ g
# Q12 — Which side has a larger SE for weight?  _______
# Q13 — What does a larger SE tell you about that group?
#


# ── STEP 5: Quick summary with skimr ──────────────────────────────────────────
# skim() gives a fast overview of every column — means, missing counts, histograms
# (see Lecture 02)

skim(leaf_df)

# Q14 — How many NA values does skim() report for area_cm2?  _______
# Q15 — Does this match what sum(!is.na()) found in Step 3?  Y / N  _______


# ── STEP 6: The [[ ]] shortcut for one column at a time ───────────────────────
# leaf_df[["weight_g"]] pulls the weight_g column out as a plain vector
# This is the most direct way to get one number fast
# (see Lecture 02)

# Overall mean weight (all leaves combined)
mean(leaf_df[["weight_g"]], na.rm = TRUE)

# Overall SD
sd(leaf_df[["weight_g"]], na.rm = TRUE)

# n (the safe way)
sum(!is.na(leaf_df[["weight_g"]]))

# Standard error = SD / sqrt(n)
sd(leaf_df[["weight_g"]], na.rm = TRUE) /
  sqrt(sum(!is.na(leaf_df[["weight_g"]])))

# Q16 — Overall mean leaf weight (all leaves):  _______ g
# Q17 — Overall SE of leaf weight:  _______ g
# Q18 — Why do we write na.rm = TRUE inside mean() and sd()?
#


# ── STEP 7: Boxplot with jittered points ──────────────────────────────────────
# geom_boxplot() draws the box (median, quartiles, whiskers)
# geom_point() with position_jitter() overlays the individual data points
# position_jitter() spreads points sideways so they don't stack on top of each other
# (see Lecture 02 / Worksheet 02 Parts 8-9)

leaf_box_plot <- ggplot(leaf_df, aes(x = _____, y = weight_g, fill = _____)) +
  geom_boxplot(alpha = 0.5,                 # semi-transparent boxes
               outlier.shape = NA) +        # hide the default outlier dots (we show all points)
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),  # jitter width controls spread
    alpha    = 0.5,                         # semi-transparent points
    size     = 2
  ) +
  labs(
    title    = "_____",                     # write a descriptive title
    subtitle = "Each point is one leaf",
    x        = "Side of tree",
    y        = "Leaf weight (g)",
    caption  = "Data: BIOL 3810 class collection"
  ) +
  theme_minimal() +
  theme(legend.position = "none")           # legend not needed — x-axis already labels groups

leaf_box_plot

# Q19 — Which side has a higher median weight?  _______
# Q20 — Do the boxes overlap substantially, somewhat, or not at all?  _______
# Q21 — Approximate median weight for sunny leaves (read from the box):  _______ g
# Q22 — Approximate median weight for shady leaves (read from the box):  _______ g
# Q23 — Any unusual outlier leaves?  Y / N   Which side?  _______

# Save the plot — always PNG, always dpi = 300 (see Worksheet 02 Part 8)
ggsave("figures/leaf_weight_boxplot.png",
       plot   = leaf_box_plot,
       width  = 6,
       height = 6,
       units  = "in",
       dpi    = 300)


# ── STEP 8: Mean ± SE plot with stat_summary() ────────────────────────────────
# stat_summary() computes and draws the mean and error bars automatically
# fun = mean draws the mean point
# fun.data = mean_se draws the mean ± 1 SE error bar
# (see Lecture 02 / Worksheet 02)

leaf_mean_se_plot <- ggplot(leaf_df, aes(x = _____, y = weight_g, color = _____)) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha    = 0.25,                        # light points in the background
    size     = 2
  ) +
  stat_summary(fun      = mean,             # draw the mean as a large point
               geom     = "point",
               size     = 5) +
  stat_summary(fun.data = _____,            # fill in: mean_se
               geom     = "errorbar",
               width    = 0.15,
               linewidth = 0.9) +
  labs(
    title    = "Mean ± SE Leaf Weight — Sunny vs. Shady",
    subtitle = "Background points are individual leaves",
    x        = "Side of tree",
    y        = "Leaf weight (g)",
    caption  = "Data: BIOL 3810 class collection"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

leaf_mean_se_plot

# Q24 — Do the SE error bars for sunny and shady overlap?  Y / N  _______
# Q25 — Does the data appear to support the alternate hypothesis?  Y / N
#        Explain:
#

# Save the mean ± SE plot
ggsave("figures/leaf_weight_mean_se.png",
       plot   = leaf_mean_se_plot,
       width  = 6,
       height = 6,
       units  = "in",
       dpi    = 300)


# ── STEP 9: Science questions (answer as comments) ────────────────────────────

# Q26 — Restate the null hypothesis in your own words:
#

# Q27 — Restate the alternate hypothesis in your own words:
#

# Q28 — Why do shady leaves need to be larger to survive?
#

# Q29 — Why is it important to measure leaves from more than one tree?
#


# ── FINAL CHECK ───────────────────────────────────────────────────────────────
# Run the FULL script with Ctrl/Cmd + Shift + Enter
# Confirm it finishes without errors
# Confirm both PNGs are in your figures/ folder

# Submit to Canvas:
#   1. This script (01_leaves.R) — with all Q# blanks filled
#   2. figures/leaf_weight_boxplot.png
#   3. figures/leaf_weight_mean_se.png
