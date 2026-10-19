# ==========================================================
# Activity 15: Pivoting Lake Superior ice data
# Name:
# Date:
#
# Save this file as scripts/15_ice_pivot.R
#
# YOU TYPE MOST OF THE CODE. Three things are already
# written for you:
#
#   - the libraries
#   - reading NOAA's file off the web
#   - the long spaghetti-plot block in Part 7
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
# ==========================================================

# Load libraries ------------------------------------------- [PRE-FILLED]
library(tidyverse) # dplyr + tidyr + ggplot2 + stringr
library(lubridate) # ymd(), month(), update()

invisible(NULL)


# ---- 1: Read the raw file -------------------------------- [PRE-FILLED]
# This is a plain-text, SPACE-separated file, not a CSV -
# that is why it needs read.table() and not read_csv().
# The day labels (Nov-10 ...) arrive as ROW NAMES, so
# rownames_to_column() turns them into a real column.
#
# You need an internet connection for this line.

url <- "https://www.glerl.noaa.gov/data/ice/glicd/daily/sup.txt"

ice_raw <- read.table(
  url,
  header     = TRUE,
  na.strings = c("-999", "-99.00", "NA")
) %>%
  rownames_to_column(var = "date") %>%
  as_tibble()

head(ice_raw)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. Why can't read_csv() open this file?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 2: Inspect the wide shape ---------------------------
# Write the two lines that report the SHAPE of ice_raw and
# its COLUMN NAMES.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. Rows = ____   Columns = ____
#     What does ONE ROW represent (a day? a year? a
#     day-of-winter?):
#     What do the COLUMN NAMES look like:
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q3. R glued an X onto the front of every year column -
#     X1973. Why? What rule do R column names follow?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4. "Year" is hiding as 50-odd COLUMN NAMES, not as
#     values in a column. Explain why that makes
#     ggplot(aes(x = year)) and group_by(year) impossible
#     right now.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 3: Pivot from wide to long --------------------------
# PREDICT FIRST. ice_raw is about 209 rows x 55 columns.
# After pivot_longer() collapses every year column:
#
#     columns I expect:
#     rows I expect:
#
# Now write it. pivot_longer() needs FOUR arguments here:
# cols, names_to, names_prefix, values_to. Call the result
# ice_long, arrange() it by year and date, then report its
# shape.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q5. Rows in ice_long = ____  Columns = ____
#     Was your prediction close?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q6. What does names_prefix = "X" do? What would the
#     year column hold if you left it out?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 4: Fix winters that cross the new year --------------
# An ice season runs Nov -> May, but NOAA labels the whole
# season by the year it ENDS in. So Nov-10 under column
# 1974 really happened in November 1973.
#
# Write the mutate() that:
#   - turns year numeric
#   - builds calendar_year with if_else() - Nov/Dec go to
#     the PREVIOUS year
#   - pastes a real full_date together and parses it
#     with ymd()
#   - pulls month out of full_date, label = TRUE
# then drops rows with no ice value and no date.
# Call the result ice_clean.
#
# EXPECT A WARNING: ymd() will say about 40 dates "failed
# to parse". Those are Feb-29 in years with no February
# 29th. drop_na() removes them - correctly, there was no
# such day.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q7. Explain the if_else() in plain English.
#     Condition tested:
#     What happens when TRUE:
#     Why we subtract 1 from year:
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q8. Compare nrow(ice_long) and nrow(ice_clean). How many
#     rows did drop_na() remove, and what were they?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 5: Summarize now that we are long -------------------
# Write the group_by() / summarize() that gives the MEAN
# ice cover for every year-month combination. Call it
# monthly_avg, and use .groups = "drop".

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q9. This is the SAME pattern you used in Summary
#     Statistics. Why was it impossible to run on ice_raw?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 6: Pivot back to a wide summary table ---------------
# PREDICT FIRST. One row per year, one column per month.
#
#     rows (years) I expect:
#     columns (months + 1) I expect:
#
# Now write the pivot_wider() on ice_clean, using id_cols,
# names_from, values_from, and values_fn = mean. arrange()
# it by year so it reads top to bottom, call it
# ice_pivot_table, and print it.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10. Rows = ____  Columns = ____
#      Was your prediction close?  Y / N
#      Why is there a Jun column, and why is it almost
#      all NA?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q11. When do you reach for pivot_longer(), and when for
#      pivot_wider()? One sentence each.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 7: NOAA's spaghetti plot ---------------------------- [PRE-FILLED]
# This is the long one, so it is written for you. Run it
# and READ it.
#
# The idea worth keeping: to stack 50 winters on one axis,
# every date is forced onto a single FAKE year - October
# onward becomes 1999, January onward becomes 2000 - so the
# x-axis runs November through June exactly once.

ice_plot_data <- ice_clean %>%
  mutate(
    plot_date = if_else(
      month(full_date) >= 10,
      update(full_date, year = 1999),
      update(full_date, year = 2000)
    )
  )

historical_avg <- ice_plot_data %>%
  group_by(plot_date) %>%
  summarize(avg_ice = mean(ice_cover, na.rm = TRUE))

current_yr        <- max(ice_plot_data$year)
past_years        <- ice_plot_data %>% filter(year < current_yr)
current_year_data <- ice_plot_data %>% filter(year == current_yr)

ice_spaghetti_plot <- ggplot() +
  geom_line(
    data = past_years,
    aes(x = plot_date, y = ice_cover, group = year),
    color = "blue", alpha = 0.15
  ) +
  geom_line(
    data = historical_avg,
    aes(x = plot_date, y = avg_ice),
    color = "red", linewidth = 1.2
  ) +
  geom_line(
    data = current_year_data,
    aes(x = plot_date, y = ice_cover),
    color = "black", linewidth = 1.2
  ) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  labs(
    title    = "Lake Superior Average Ice Cover",
    subtitle = paste("Comparing", current_yr, "to Historical Data"),
    x = NULL, y = "Ice Cover (%)"
  ) +
  theme_bw()

ice_spaghetti_plot

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q12. Open NOAA's own version:
#   glerl.noaa.gov/data/ice/spaghetti/sup_ice_compare.png
#      Did you recreate it?  Y / N
#      What does the RED line represent:
#      Why is the current year drawn LAST:
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q13. The thin blue lines use group = year inside aes().
#      Take it out in your head - what would the plot look
#      like instead, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 8: Each winter's peak ice with slice_max() ----------
# PREDICT FIRST. slice_max() keeps the single highest
# ice-cover day per year.
#
#     rows I expect:
#
# Now write the group_by() + slice_max() that keeps one row
# per year - the highest ice_cover. Call it
# max_ice_per_year, and use with_ties = FALSE so you get
# exactly one row even when two days tie. Then look at it
# sorted by ice_cover.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q14. Rows = ____
#      Lowest maximum ice cover:  year = ____  value = ____ %
#      Highest maximum ice cover: year = ____  value = ____ %
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q15. Look at the DATE of each year's peak. Early season
#      or late? Does that date move much from winter to
#      winter?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- 9: Model the trend in maximum ice cover -------------
# PREDICT FIRST.
#
#     declining / flat / rising:
#     significant at alpha = 0.05?  Y / N
#
# Now write the lm() of ice_cover on year using
# max_ice_per_year, call it max_ice_model, and summary() it.
# Then plot the yearly peaks: geom_point() plus a
# geom_smooth(method = "lm") trend line.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q16. Report the model.
#      Slope (% per year) =
#      p-value for the slope =
#      R-squared =
#      Significant at alpha = 0.05?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q17. The slope is significant, and the R-squared is small
#      - around 0.13. Say what EACH number tells you, and
#      why they are NOT in conflict.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q18. One sentence: is Lake Superior's peak ice cover
#      changing, and how confident are you given the
#      scatter?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# HOMEWORK - a different Great Lake
#
# Nothing below is filled in. Copy your OWN chunks from
# above and change what needs changing - for most chunks
# that is the URL and nothing else.
#
# Pick ONE lake and change only the file name in the URL:
#
#     mic.txt  Michigan
#     hur.txt  Huron
#     eri.txt  Erie
#     ont.txt  Ontario
#
# https://www.glerl.noaa.gov/data/ice/glicd/daily/<lake>.txt
# ==========================================================

# ---- H1: Read and pivot your lake ------------------------
# Read it, pivot_longer() it, fix the Nov/Dec dates with
# the same if_else(), and drop the NAs.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. My lake:
#       Rows x columns BEFORE the pivot:
#       Rows x columns AFTER the pivot:
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- H2: Peak ice per winter -----------------------------
# slice_max() one row per year.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q2. Winters in my lake's record = ____
#       Lowest-peak winter:  year = ____  value = ____ %
#       Highest-peak winter: year = ____  value = ____ %
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ---- H3: Model the trend ---------------------------------
# lm(ice_cover ~ year), summary() it, and plot it with a
# geom_smooth(method = "lm") trend line.

# YOUR CODE:


invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. Slope (% per year) =
#       p-value =
#       R-squared =
#       Significant at alpha = 0.05?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. Lake Superior's slope is about -0.7 %/year. Is your
#       lake losing maximum ice FASTER or SLOWER than
#       Superior, and by how much?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q5. Using YOUR slope, say in plain language how fast
#       your lake is losing (or gaining) maximum ice cover,
#       and how much total change that adds up to across
#       the whole record.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q6. Your lake is shallower than Superior, and shallower
#       water holds less heat. Explain in your own words how
#       depth could make one lake's ice respond faster to
#       the same warming - then say whether your slope
#       actually came out the way that reasoning predicts.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ==========================================================
# Before you hand this in: run the whole script top to
# bottom with Ctrl/Cmd + Shift + Enter. It must run clean.
#
# NEXT TIME: Lecture 16 - two tables that each hold half
# the story, and the joins that put them back together.
# ==========================================================
