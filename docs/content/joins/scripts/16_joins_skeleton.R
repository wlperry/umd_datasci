# ==========================================================
# Activity 16: Joins - two fisher tables into one
# Name:
# Date:
#
# Save this file as scripts/16_joins.R
#
# YOU TYPE MOST OF THE CODE. Two things are already
# written for you:
#
#   - the libraries
#   - the two read_csv() lines
#
# Everywhere else you will find
#
#     # YOUR CODE:
#
# followed by a blank line. The code is on the lecture
# slides. Read it there and TYPE it in - do not paste.
#
# You answer the questions in the boxes marked # # # # # #
# after "ANSWER:", with every line starting with #
#
# Your ANSWERS and your HOMEWORK are what gets graded.
#
# ----------------------------------------------------------
# About the invisible(NULL) lines
#
# Every chunk below ends with
#
#     invisible(NULL)
#
# It is a BUMPER. When you press Ctrl/Cmd + Enter on the
# last real line of a chunk, the cursor jumps to the next
# line that has code on it. Without the bumper that is the
# next chunk, way down past the answer box. With it, the
# cursor stops right here and you keep your place.
#
# It does nothing and prints nothing. Leave it alone.
# ----------------------------------------------------------
# THE DATA (simulated for teaching, not real records)
#
# fisher_individuals.csv - one row per RELEASED fisher.
#   fisher_id, sex, age_class, source, site (RELEASE site),
#   release_date
#
# fisher_captures.csv - one row per CAPTURE EVENT.
#   capture_event, animal_id, capture_date, site (CAPTURE
#   site), mass_kg, collar_id
#
# Note that BOTH tables have a column called `site` and
# they do NOT mean the same thing. That matters in Part 5.
# ==========================================================

# Load libraries ------------------------------------------- [PRE-FILLED]
library(tidyverse) # dplyr + readr + stringr

invisible(NULL)


# ---- 1: Load both tables --------------------------------- [PRE-FILLED read]
individuals_df <- read_csv("data/fisher_individuals.csv")
captures_df    <- read_csv("data/fisher_captures.csv")

# Now write the two lines that report the SHAPE of each
# table.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. individuals_df: rows = ____  cols = ____
#     captures_df:    rows = ____  cols = ____
#     Which table has more rows, and why might that be?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 2: Find the key -------------------------------------
# Print the first few rows of the IDENTIFYING columns of
# each table so you can compare them side by side.
# From individuals_df: fisher_id, sex, site, release_date
# From captures_df:    animal_id, capture_date, site, mass_kg

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. Key in individuals_df:
#     Key in captures_df:
#     Are the names the same?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q3. Both tables ALSO have a `site` column. Do the two
#     mean the same thing? Look again at what each table
#     is a row OF.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 3: Clean the key ------------------------------------
# count() the capture key and look at the values. Then
# write the mutate() that fixes its CASE, and check how
# many DISTINCT keys each table has
# (n_distinct() is the function you want).

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4. animal_id is stored as "f07" but fisher_id is "F07".
#     Why must you fix the case BEFORE joining? What would
#     the join have produced if you had not?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q5. One value of animal_id is not a fisher ID at all.
#     What is it, and what does it mean about those
#     capture events?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 4: The left join ------------------------------------
# PREDICT FIRST. You want to keep EVERY capture event and
# attach who the animal is.
#
#     rows I expect:
#     rows with a missing sex I expect:
#
# Now write the left_join(). The key columns have DIFFERENT
# NAMES, so you need
#
#     by = c("animal_id" = "fisher_id")
#
# Call the result captures_joined, then report its row
# count and how many rows have an NA sex.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q6. Total rows after the left_join = ____
#     Rows WITH an identified individual = ____
#     Rows with NA individual info = ____
#     Was your prediction close?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# NOTE: the join hands you TWO site columns - site.x
# (capture site) and site.y (release site). Real fishers
# move, so those are genuinely different things and dplyr
# is right to keep both.


# ---- 5: The accidental-key trap --------------------------
# Run the SAME join again, on purpose, with NO by =
# argument at all. Watch the message dplyr prints, and
# count the rows.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q7. What column did dplyr announce it was joining on?
#     Why is joining on `site` completely wrong here -
#     what does it match a capture event TO?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q8. Rows in the accidental join = ____
#     Rows in the correct join (Part 4) = ____
#     Where did all those extra rows come from?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# WATCH OUT: this is the join bug that bites hardest,
# because NOTHING throws an error. When dplyr prints
# "Joining with `by = join_by(site)`" and you did not
# choose that column, treat it as a bug report, not a
# status update.


# ---- 6: Name the key every time --------------------------
# Redo the CORRECT join and select() down to
# capture_event, animal_id, capture_date, sex, age_class
# so you can actually read it.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q9. Do any of the first rows already show NA for sex?
#     What does that mean about that capture event?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 7: Run all three joins ------------------------------
# PREDICT FIRST. Rank these by row count, most to fewest:
#
#     inner_join / left_join / full_join:
#
# Store the key ONCE in a variable, then run all three and
# report the three row counts side by side with c().

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10. inner = ____   left = ____   full = ____
#      Was your ranking right?  Y / N
#      Why does full have MORE rows than left - which
#      fishers does it add back?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 8: What each join dropped or kept -------------------
# No code for this one. Answer from what you just ran.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q11. In your OWN words, what does each one keep?
#      inner_join keeps:
#      left_join keeps:
#      full_join keeps:
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q12. Which capture events does inner_join DROP that
#      left_join keeps?
#      Which fishers does full_join ADD that neither of
#      the others includes?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 9: Pick the right join ------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q13. You want a table of EVERY capture event for a
#      survival analysis, keeping the event even when the
#      animal was unmarked. Which join, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 10: anti_join() - what is missing -------------------
# PREDICT FIRST, two ways.
#
#   (a) capture events with no matching individual:
#   (b) released fishers never recaptured:
#
# Now write BOTH anti_joins. Watch out: (b) runs in the
# OTHER direction - individuals on the left - and the
# by = flips with it.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q14. Capture events with no individual = ____
#      Released fishers never recaptured = ____
#      Were your predictions close?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q15. Did anti_join() ADD any columns, or only filter
#      rows? Check the column names against the table you
#      started from.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 11: semi_join() - keep only matches -----------------
# Write the semi_join() that keeps the released fishers
# that WERE recaptured at least once. Call it recaptured,
# and count them.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q16. How is semi_join() different from inner_join()?
#      Look at the COLUMNS, not just the rows.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q17. recaptured rows + never-seen rows should equal
#      nrow(individuals_df). Does it?  Y / N
#      What would it mean if it did NOT?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 12: Build one analysis-ready table ------------------
# Write the pipe that:
#   - inner_join()s the two tables on the key
#   - mutate()s a days_since_release column from the two
#     dates (as.numeric() around the subtraction)
#   - select()s down to the columns worth keeping, and
#     RENAMES site.x to capture_site and site.y to
#     release_site as it goes
#
# Call it fisher_analysis, look at the head of it, then
# write_csv() it to "data/fisher_joined.csv".

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q18. Rows in fisher_analysis = ____
#      Why is it smaller than captures_df?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q19. Why inner_join() HERE, when Q13 argued for
#      left_join()? What is different about THIS table's
#      job?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q20. Check range(fisher_analysis$days_since_release).
#      Are all the values positive?  Y / N
#      What would a NEGATIVE value have told you about
#      the data?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# HOMEWORK
#
# Nothing below is filled in.
# ==========================================================

# ---- H1: Summarize the joined table ----------------------
# Using fisher_analysis, write TWO summaries of your own:
#   (1) mean mass_kg by sex, WITH the sample size for each
#   (2) capture-event count by release_site and sex

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. Mean mass of females = ____ kg  (n = ____)
#       Mean mass of males   = ____ kg  (n = ____)
#       Fishers are strongly sexually dimorphic - does
#       your answer match that?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q2. Which release-site-and-sex combination has the most
#       capture events? Does that tell you about the
#       ANIMALS, or about where the CREWS spent their time?
#       Say which, and how you would tell the two apart.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- H2: Recaptures per fisher ---------------------------
# Count how many times each IDENTIFIED fisher was caught.
# Use a FILTERING join, not a mutating one - you do not
# need any new columns to do this.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. Most-recaptured fisher = ____  caught ____ times
#       Fishers caught exactly once = ____
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- H3: Join in a table of your own ---------------------
# Build a SMALL table with tibble() - four or five rows is
# plenty - keyed by fisher_id, holding something you
# invent: a home-range size in km2, a collar battery
# status, a field crew name. Then join it onto the fisher
# data on the key.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. Which join did you choose, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q5. Your table covers only SOME of the fishers. How
#       many rows came back with NA from your new column,
#       and is that a problem or exactly what you asked
#       for?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- H4: The thing that surprised you --------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q6. Across everything in this activity, what surprised
#       you MOST about joining these two tables? Be
#       specific - name the numbers or the rows that
#       surprised you, and say what you expected instead.
#       "Nothing surprised me" is not an answer.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# Before you hand this in: run the whole script top to
# bottom with Ctrl/Cmd + Shift + Enter. It must run clean.
#
# NEXT TIME: a week off, then one-way ANOVA.
# ==========================================================
