# ==========================================================
# Activity 16 - Joins: two fisher tables into one
# Name:
# Date:
#
# Save as scripts/16_joins.R
#
# The code is written for you through section 10. Section
# 11 is yours to type - the code is on the activity page.
#
# The THINK lines are to talk about, not to answer here.
# The HOMEWORK at the bottom is what gets graded.
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)

invisible(NULL)


# ---- 1 Load both tables ----------------------------------
# captures_df    - one row per CAPTURE EVENT
# individuals_df - one row per RELEASED fisher

captures_df    <- read_csv("data/fisher_captures.csv")
individuals_df <- read_csv("data/fisher_individuals.csv")

dim(captures_df)

dim(individuals_df)

# THINK: which table has more rows, and why?

invisible(NULL)


# ---- 2 Find the key --------------------------------------
captures_df %>%
  select(animal_id, capture_date, site, mass_kg) %>%
  head(3)

individuals_df %>%
  select(fisher_id, sex, site, release_date) %>%
  head(3)

# THINK: the key is animal_id here and fisher_id there.
# Both tables also have a `site` column - do the two mean
# the same thing?

invisible(NULL)


# ---- 3 Clean the key -------------------------------------
# The capture key is lowercase, the individual key is not.

captures_df %>%
  count(animal_id) %>%
  head()

captures_df <- captures_df %>%
  mutate(animal_id = str_to_upper(animal_id))   # "f07" -> "F07"

n_distinct(individuals_df$fisher_id)

n_distinct(captures_df$animal_id)   # includes "UNK"

# THINK: a join does not error on a case mismatch - it
# just returns NA. What is "UNK"?

invisible(NULL)


# ---- 4 The left join -------------------------------------
# Keep every capture event, attach who the animal is.

captures_joined <- captures_df %>%
  left_join(individuals_df, by = c("animal_id" = "fisher_id"))

nrow(captures_joined)

sum(is.na(captures_joined$sex))

# THINK: the join made site.x (capture) and site.y
# (release). Why is dplyr right to keep both?

invisible(NULL)


# ---- 5 Name the key every time ---------------------------
captures_df %>%
  left_join(individuals_df, by = c("animal_id" = "fisher_id")) %>%
  select(capture_event, animal_id, capture_date, sex, age_class) %>%
  head()

invisible(NULL)


# ---- 6 Run all three joins -------------------------------
# Store the key once so all three use the same rule.

key <- c("animal_id" = "fisher_id")

inner <- inner_join(captures_df, individuals_df, by = key)
left  <- left_join (captures_df, individuals_df, by = key)
full  <- full_join (captures_df, individuals_df, by = key)

c(inner = nrow(inner), left = nrow(left), full = nrow(full))

# THINK: predict the ranking before you look. Why does
# full have MORE rows than left?

invisible(NULL)


# ---- 7 What each join kept -------------------------------
# inner_join - only events with a KNOWN animal
# left_join  - ALL capture events
# full_join  - all events AND every released fisher
#
# THINK: which events does inner drop that left keeps?

invisible(NULL)


# ---- 8 Pick the right join -------------------------------
# THINK: for a survival analysis you want every capture
# event, even of an unmarked animal. Which join, and why?

invisible(NULL)


# ---- 9 anti_join - what is missing -----------------------
# (a) capture events of unmarked animals
captures_df %>%
  anti_join(individuals_df, by = c("animal_id" = "fisher_id")) %>%
  nrow()

# (b) released fishers never recaptured - the OTHER
# direction, so the by = flips too
never_seen <- individuals_df %>%
  anti_join(captures_df, by = c("fisher_id" = "animal_id"))

never_seen %>%
  select(fisher_id, sex, site)

# THINK: did anti_join ADD any columns, or only filter?

invisible(NULL)


# ---- 10 semi_join - keep only matches --------------------
recaptured <- individuals_df %>%
  semi_join(captures_df, by = c("fisher_id" = "animal_id"))

nrow(recaptured)

nrow(recaptured) + nrow(never_seen)

nrow(individuals_df)

# THINK: how is semi_join different from inner_join? Look
# at the COLUMNS, not the rows.

invisible(NULL)


# ---- 11 Build one analysis-ready table -------------------
# THIS ONE IS YOURS TO TYPE. The code is on the activity
# page, Part 11. It is where we left off in class.
#
# inner_join the two tables, mutate a days_since_release
# column from the two dates, select down to the columns
# worth keeping - renaming site.x to capture_site and
# site.y to release_site - then write_csv() the result to
# data/fisher_joined.csv

# YOUR CODE:


invisible(NULL)


# ==========================================================
# HOMEWORK - this is the graded part
# ==========================================================

# ---- H1 Summarize the joined table -----------------------
# Using fisher_analysis, write TWO summaries:
#   1. mean mass_kg by sex, with the sample size for each
#   2. capture-event count by release_site and sex

# YOUR CODE:


invisible(NULL)

# H-Q1. Mean mass of females and of males, with both
#       sample sizes. Fishers are strongly sexually
#       dimorphic - does your answer match that?
# ANSWER:
#
# H-Q2. Which release-site-and-sex combination has the
#       most capture events? Does that tell you about the
#       ANIMALS or about where the CREWS spent their time?
# ANSWER:
#


# ---- H2 Recaptures per fisher ----------------------------
# Count how many times each IDENTIFIED fisher was caught.
# Use a filtering join, not a mutating one.

# YOUR CODE:


invisible(NULL)

# H-Q3. The most-recaptured fisher and its count, and how
#       many fishers were caught exactly once.
# ANSWER:
#


# ---- H3 Join in a table of your own ----------------------
# Build a small tibble() - four or five rows - keyed by
# fisher_id, holding something you invent (home-range size
# in km^2, collar battery status, field crew name). Then
# join it onto the fisher data on the key.

# YOUR CODE:


invisible(NULL)

# H-Q4. Paste your tibble() and say which join you chose
#       and why.
# ANSWER:
#
# H-Q5. Your table covers only some of the fishers. How
#       many rows came back NA, and is that a problem or
#       exactly what you asked for?
# ANSWER:
#


# ---- H4 The thing that surprised you ---------------------
# H-Q6. What surprised you MOST about joining these two
#       tables? Name the numbers or rows that surprised
#       you and say what you expected instead.
#       "Nothing surprised me" is not an answer.
# ANSWER:
#


# ==========================================================
# End of Activity 16. Run the whole script top to bottom
# (Ctrl/Cmd + Shift + Enter). It must run clean.
# ==========================================================
