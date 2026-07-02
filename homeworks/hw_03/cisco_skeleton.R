# =============================================================================
# Homework 03 — Cisco Body Size in Trout Lake, Wisconsin
# BIOL 3810 Data Science for Biology — Bill Perry
#
# Name:
# Date:
#
# Fill in every blank marked with _____  and answer every Q# below
# as a # comment. The Q numbers match the homework question sheet.
#
# Reference: Lecture 02 (loading data), Lecture 03 (wrangling + stats),
#            Lecture 04 (t-test), Worksheet 03, Worksheet 04
# =============================================================================


# ── STEP 1: Load packages ─────────────────────────────────────────────────────
# Put ALL library() calls here at the top of the script (see Lecture 02)
# You need: tidyverse, skimr, car

library(tidyverse)   # data wrangling + ggplot2
library(readxl)      # not used today, but always load it
library(_____  )     # fast summaries: skimr
library(_____  )     # Levene's test: car


# ── STEP 2: Load the data ─────────────────────────────────────────────────────
# read_csv() loads a CSV file from a URL (see Lecture 02 / Worksheet 02)
# No package to install — just paste the URL

cisco_raw_df <- read_csv(
  "https://raw.githubusercontent.com/fishR-Core-Team/FSAdata/main/data-raw/CiscoTL.csv"
)

# Check size of the raw file
# Q1 — Total rows:  _______
# Q2 — Total columns:  _______


# ── STEP 3: Inspect the raw data ──────────────────────────────────────────────
# glimpse() shows column names, types, and first values (see Worksheet 02)


# How many fish were caught each year?

# Q3 — Year with most fish: _______    n = _______
# Q4 — Year with second most fish: _______    n = _______


# ── STEP 4: Wrangle — filter, select, mutate, arrange ─────────────────────────
# See Lecture 03 / Worksheet 03 Parts 2-3 for each of these verbs
#
# Goal: reduce 8,594 rows → 201 rows (1981 and 1982 only, no missing values)
#
# NEW operator: %in%
#   year4 %in% c(1981, 1982) means "keep rows where year4 equals 1981 OR 1982"
#   More concise than writing two separate filter() conditions

cisco_cleaned_df <- cisco_raw_df %>%
  # Note you can do this in seperate chunks...

  # --- filter() keeps rows matching ALL conditions ---
  # (see Worksheet 03 Part 3 — filter section)
  filter(
    year4 %in% c(_____, _____),    # keep only 1981 and 1982
    !is.na(length),                # drop rows where length is missing
    !is.na(weight),                # drop rows where weight is missing
    weight > _____                 # drop zeros (real fish can't weigh 0)
  ) 


cisco_cleaned_df <- cisco_cleaned_df %>%
  # --- select() keeps only the columns you name ---
  # (see Worksheet 03 Part 3 — select section)
  select(year4, sampledate, gearid, _____, _____) %>%   # add length and weight

  # --- mutate() adds new columns ---
  # (see Worksheet 03 Part 3 — mutate section)
  mutate(
    year       = as.character(year4),            # year as a label, not a number
    length_cm  = round(length / _____, 1),       # convert mm → cm (divide by 10)
    size_class = if_else(length >= _____, "large", "small")  # threshold: 175 mm
  ) %>%

  # --- arrange() sorts the rows ---
  # (see Worksheet 03 Part 3 — arrange section)
  arrange(year, length)

# Confirm the result
dim(cisco_cleaned_df)
# Q5 — Rows after filtering: _______

count(cisco_cleaned_df, year)
# Q6 — n for 1981: _______
# Q7 — n for 1982: _______

# Sort by length descending to find the largest fish
cisco_cleaned_df %>% verb for sorting (desc(length)) %>% last way to see top only
# Q8 — Year of the heaviest fish: _______    Weight: _______ g


# ── STEP 5: Descriptive statistics ────────────────────────────────────────────
# group_by() + summarize() computes stats for each group
# sum(!is.na()) counts non-missing values — NOT length()
# (see Lecture 03 / Worksheet 03 Part 5-6)

cisco_stats_df <- cisco_cleaned_df %>%
  group_by(_____) %>%                              # group by the year column
  summarize(
    n        = sum(!is.na(_____)),                 # count non-missing weights
    mean_wt  = round(mean(weight,  na.rm = TRUE), 1),
    sd_wt    = round(sd(weight,    na.rm = TRUE), 1),
    se_wt    = round(sd_wt / sqrt(n), 1),
    mean_len = round(mean(length,  na.rm = TRUE), 1),
    sd_len   = round(sd(length,    na.rm = TRUE), 1),
    se_len   = round(sd_len / sqrt(n), 1)
  )

cisco_stats_df

# Fill in from the output above:
# Q9 — Is 1982 mean weight higher than 1981?  Y / N  _______
# Q10 — Difference in mean weight (1982 minus 1981):  _______ g

# Optional: run skim() for a fast overview (see Worksheet 03 Part 7)
cisco_cleaned_df %>% group_by(year) %>% skim(length, weight)


# ── STEP 6: Visualize ─────────────────────────────────────────────────────────
# See Lecture 03 / Worksheet 03 Parts 8-9 for boxplot and mean ± SE

# --- Plot 1: Boxplot with jittered points ---
cisco_box_plot <- cisco_cleaned_df %>%
  ggplot(aes(x = year, y = weight, fill = year)) +
  geom_boxplot(alpha = _____, outlier.shape = NA) +    # use 0.5 for alpha
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha = _____, size = 1.5                          # use 0.3 for alpha
  ) +
  labs(
    title    = "_____",                  # write a descriptive title
    subtitle = "Gill net samples — Trout Lake, WI (NTL-LTER)",
    x        = "Sampling Year",
    y        = "Body Weight (g)",
    caption  = "Data: Ogle 2023 / NTL-LTER"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

cisco_box_plot

# Q11 — Degree of overlap (none / some / substantial):  _______
# Q12 — Approximate median weight 1981 (from box):  _______ g
# Q13 — Approximate median weight 1982 (from box):  _______ g

# Save the plot — always PNG, always dpi = 300 (see Worksheet 02 Part 8)
ggsave("figures/cisco_weight_boxplot.png",
       plot = cisco_box_plot,
       width = 5, height = 5, units = "in", dpi = 300)


# --- Plot 2: Mean ± SE ---
# stat_summary() computes and draws the mean and error bars for you
# (see Lecture 03 / Worksheet 03 Part 9)
cisco_mean_se_plot <- cisco_cleaned_df %>%
  ggplot(aes(x = year, y = weight, color = year)) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha = 0.25, size = 1.5
  ) +
  stat_summary(fun      = mean,    geom = "point", size = 4) +
  stat_summary(fun.data = _____, geom = "errorbar",    # use mean_se
               width = 0.15, linewidth = 0.9) +
  labs(
    title    = "Mean ± SE Cisco Body Weight by Year",
    subtitle = "Trout Lake, Wisconsin — NTL-LTER Program",
    x        = "Sampling Year",
    y        = "Body Weight (g)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

cisco_mean_se_plot

# Q14 — Do the SE error bars overlap?  Y / N  _______
#        What does this suggest?  _______________________________________

ggsave("figures/cisco_weight_mean_se.png",
       plot = cisco_mean_se_plot,
       width = 5, height = 5, units = "in", dpi = 300)


# ── STEP 7: Five-step Welch's t-test ──────────────────────────────────────────
# Follow the SAME five steps as Lecture 04 / Worksheet 04
# ─────────────────────────────────────────────────────────────────────────────

# --- STEP 1: Hypotheses (write BEFORE running the test) ---
# Q15 — H0 (plain English):
#
# Q16 — Ha (plain English):
#
# Significance level: alpha = 0.05   Test type: two-tailed


# --- STEP 2: Normality — histogram ---
cisco_hist_plot <- cisco_cleaned_df %>%
  ggplot(aes(x = weight, fill = year)) +
  geom_histogram(binwidth = _____, color = "white", alpha = 0.8) +  # try binwidth = 5
  facet_wrap(~year, ncol = 2) +
  labs(title = "Distribution of Cisco Body Weight by Year",
       x = "Body Weight (g)", y = "Count") +
  theme_minimal() +
  theme(legend.position = "none")

cisco_hist_plot

# Q17 — Shape of 1981 distribution:  _______
# Q18 — Shape of 1982 distribution:  _______


# --- STEP 3: Normality — QQ plot + Shapiro-Wilk ---
# Pull each year's weights as a vector using filter() + pull()
# (same pattern as Worksheet 03 Part 5 and Worksheet 04 Step 3)
wt_1981 <- cisco_cleaned_df %>% filter(year == "_____") %>% pull(_____)
wt_1982 <- cisco_cleaned_df %>% filter(year == "_____") %>% pull(_____)

shapiro.test(wt_1981)
shapiro.test(wt_1982)

# Q19 — Shapiro-Wilk 1981:  W = _______   p = _______
# Q20 — Shapiro-Wilk 1982:  W = _______   p = _______
# Q21 — Proceed with t-test?  Y / N   Reason:


# --- STEP 4: Variance — Levene's test ---
# leveneTest() needs library(car) — did you load it above?
# Syntax: leveneTest(response ~ group, data = data_frame)
# (see Lecture 04 / Worksheet 04 Step 4)

leveneTest(_____ ~ _____, data = cisco_cleaned_df)

# Q22 — Levene's F: _______   p: _______
# Q23 — Are variances equal?  Y / N  _______
# Q24 — Does this change which t-test we use?  Y / N
#        Why: Welch's (var.equal = FALSE) is safe regardless


# --- STEP 5: Run the Welch's t-test ---
# Syntax: t.test(response ~ group, data, var.equal = FALSE, alternative = "two.sided")
# (see Lecture 04 / Worksheet 04 Step 5)

cisco_ttest_model <- t.test(
  _____ ~ _____,               # weight ~ year
  data        = cisco_cleaned_dfs,
  var.equal   = _____,         # always FALSE for Welch's
  alternative = "_____"        # two.sided
)

cisco_ttest_model

# Decode the output:
# Q25 — t-statistic:  _______
# Q26 — df (Welch-Satterthwaite):  _______
# Q27 — p-value (full number):  _______
# Q28 — 95% CI: _______ to _______ g
# Q29 — Mean weight 1981: _______ g     Mean weight 1982: _______ g
# Q30 — Is p < alpha?  Y / N     Decision (reject / fail to reject H0):  _______


# ── STEP 8: Results sentence ──────────────────────────────────────────────────
# Fill in every blank below — use numbers from cisco_stats_df and cisco_ttest_model
# (see Lecture 04 / Worksheet 04 Part 6)

# Q31 — Complete the results sentence as a comment:
# "Cisco body weight was significantly [higher / lower] in [year] than in [year]
#  (Welch's t-test: t([df]) = [t], p [< / >] [p-value]).
#  Mean ± SE body weight was [mean] ± [SE] g in 1981 and [mean] ± [SE] g in 1982,
#  a difference of [diff] g."

# Q32 — Biological explanation (1-2 sentences as a comment):
# Why might cisco body weight differ between these two consecutive years?


# ── FINAL CHECK ───────────────────────────────────────────────────────────────
# Run the FULL script with Ctrl/Cmd + Shift + Enter
# Confirm it finishes without errors
# Confirm both PNGs are in your figures/ folder

# Submit to Canvas:
#   1. This script (03_cisco.R) — with all Q# blanks filled
#   2. figures/cisco_weight_boxplot.png
#   3. figures/cisco_weight_mean_se.png
