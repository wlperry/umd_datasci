---
title: "Worksheet 07 — Wide, Long, and Wild: Pivoting Real Data"
subtitle: "Reshaping Lake Superior ice cover data with pivot_longer() and pivot_wider()"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 7: Pivoting a Messy Real-World Dataset

### Recap from Worksheet 06

- **Downloaded** real NOAA weather data directly into R with `get_GSOD()`
- **Compared** raw daily data to monthly and yearly summaries
- **Fit `lm()`** to estimate a rate of temperature change (°C per decade)
- **Used `case_when()`** to build a summer vs. winter season variable
- **Compared** two group-specific regression models

### Today's Objectives

1.  Read a genuinely messy, wide text file directly from a NOAA web server
2.  Understand why wide data resists `ggplot()` and `group_by()`
3.  Use `pivot_longer()` to reshape wide data into tidy long data
4.  Fix a tricky real-world date problem — winters that cross the new year
5.  Use `pivot_wider()` to build a human-readable summary table
6.  Recreate NOAA's own "spaghetti plot" of ice cover by year
7.  Use `slice_max()` to find each year's peak ice cover and model the trend

> # **How to use this worksheet**
>
> - Work through each part in order. Type the code into a new R script in Positron and run it line by line.
>   - Code blocks marked **▶ Run this** should be executed as written.
>   - Blocks marked **✏️ Your turn** ask you to write, modify, or interpret.
>   - The **Going further** section is optional.

------------------------------------------------------------------------

# Part 1 · Load libraries and read the raw file

### Libraries

**▶ Run this at the top of your script:**

``` r
# Load packages at the top — always ----------------------
library(tidyverse)   # data manipulation + ggplot2
library(janitor)      # clean_names() and friends
```

### Read the data straight from NOAA's server

**▶ Run this:**

``` r
# Read the messy text file directly from the web -----------
url <- "https://www.glerl.noaa.gov/data/ice/glicd/daily/sup.txt"

ice_raw <- read.table(
  url,
  header = TRUE,
  na.strings = c("-999", "-99.00", "NA")) %>%
  rownames_to_column(var = "date") %>%
  as_tibble()

head(ice_raw)
```

✏️ **Your turn:** Run `dim(ice_raw)` and `View(ice_raw)`. How many rows and columns? What does each column header look like, and why does it start with an `X`?

``` r
# Write your code here:
```

```         
Rows:
Columns:
Why do column names start with X:
```

> 💡 **Key idea:** R does not allow column names to start with a number, so when `read.table()` saw a column literally named `1973`, it automatically renamed it `X1973` to make it valid.

------------------------------------------------------------------------

# Part 2 · Why is this format a problem?

✏️ **Your turn:** Try running this and see what happens:

``` r
# This will NOT work - there is no "year" column yet --------
ice_raw %>%
  group_by(year) %>%
  summarize(mean_ice = mean(ice_cover, na.rm = TRUE))
```

```         
What error message did you get?
Why doesn't R have a "year" column to group by?
```

✏️ **Your turn:** Look back at the raw data. Where is the year information actually stored right now — in the rows, or in the column names?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 3 · `pivot_longer()` — wide to long

**▶ Run this:**

``` r
# Collapse all year columns into year + ice_cover -----------
ice_long <- ice_raw %>%
  pivot_longer(
    cols         = -date,
    names_to     = "year",
    names_prefix = "X",
    values_to    = "ice_cover"
  )

ice_long <- ice_long %>%
  arrange(year, date)

head(ice_long)
```

✏️ **Your turn:** Fill in what each argument is doing, in your own words:

```         
cols = -date            means:
names_to = "year"        means:
names_prefix = "X"       means:
values_to = "ice_cover"  means:
```

✏️ **Your turn:** Run `dim(ice_long)`. How many rows does it have now, and why is that number so much bigger than `ice_raw`?

```         
Rows in ice_raw:
Rows in ice_long:
Why did the row count change this way:
```

------------------------------------------------------------------------

# Part 4 · A tricky wrinkle — winters cross the new year

Ice seasons run **Nov → May**, but NOAA labels the whole season by the year **winter ends in**. So a `Nov-10` reading under column `1974` actually happened in **November 1973**.

**▶ Run this:**

``` r
# Assign Nov/Dec to the PREVIOUS calendar year ---------------
ice_clean <- ice_long %>%
  mutate(
    year          = as.numeric(year),
    calendar_year = if_else(
      str_starts(date, "Nov|Dec"),
      year - 1,
      year
    ),
    full_date = ymd(paste(calendar_year, date, sep = "-")),
    month     = month(full_date, label = TRUE)
  ) %>%
  drop_na(ice_cover, full_date)

head(ice_clean)
```

✏️ **Your turn:** In your own words, explain what `str_starts(date, "Nov|Dec")` is checking, and why we subtract 1 from `year` when it's TRUE.

```         
What str_starts(date, "Nov|Dec") checks:
Why we subtract 1 from year:
```

✏️ **Your turn:** Why do we need `drop_na(ice_cover, full_date)` at the end? What would happen if we skipped this step?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 5 · Summarize now that we're long

**▶ Run this:**

``` r
# Mean ice cover per year-month -------------------------------
monthly_avg <- ice_clean %>%
  group_by(year, month) %>%
  summarize(
    mean_ice = mean(ice_cover, na.rm = TRUE),
    .groups  = "drop"
  )

monthly_avg <- monthly_avg %>%
  mutate(month_date = ymd(paste(year, month, "01", sep = "-")))

head(monthly_avg)
```

✏️ **Your turn:** This is the exact same `group_by() %>% summarize()` pattern from Worksheet 06. Could you have written this code on `ice_raw` (the wide version)? Why or why not?

```         
Could this work on ice_raw?  Y / N
Why or why not:
```

------------------------------------------------------------------------

# Part 6 · `pivot_wider()` — long back to a summary table

**▶ Run this:**

``` r
# Turn long data into a year-by-month summary table ------------
ice_pivot_table <- ice_clean %>%
  pivot_wider(
    id_cols     = year,
    names_from  = month,
    values_from = ice_cover,
    values_fn   = mean
  )

print(ice_pivot_table)
```

✏️ **Your turn:** Fill in what each argument is doing:

```         
id_cols = year             means:
names_from = month          means:
values_from = ice_cover     means:
values_fn = mean            means:
```

✏️ **Your turn:** Compare this table to `ice_raw`. Is `ice_pivot_table` the same shape as the original file? What's different about how it was built?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 7 · Recreate NOAA's spaghetti plot

NOAA publishes a live plot comparing the current ice season to history. Let's build our own version.

**▶ Run this:**

``` r
# Force every date onto one fake shared year -------------------
ice_plot_data <- ice_clean %>%
  mutate(
    plot_date = if_else(
      month(full_date) >= 10,
      update(full_date, year = 1999),
      update(full_date, year = 2000)
    )
  )

# Historical average for each day-of-winter -----------------------
historical_avg <- ice_plot_data %>%
  group_by(plot_date) %>%
  summarize(avg_ice = mean(ice_cover, na.rm = TRUE))

current_yr        <- max(ice_plot_data$year)
past_years        <- ice_plot_data %>% filter(year < current_yr)
current_year_data <- ice_plot_data %>% filter(year == current_yr)
```

✏️ **Your turn:** Why do we force every date onto a fake shared year (1999/2000) instead of just plotting `full_date` directly?

```         
Your answer:
```

**▶ Run this:**

``` r
# Build the spaghetti plot ---------------------------------------
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
```

✏️ **Your turn:** Compare your plot to NOAA's published version at `https://www.glerl.noaa.gov/data/ice/spaghetti/sup_ice_compare.png`. Does the most recent year (black line) look like a heavy ice year or a light ice year compared to the historical average (red line)?

```         
Heavy or light ice year compared to average:
```

✏️ **Your turn:** Save your plot.

``` r
ggsave("figures/ice_spaghetti_plot.png",
       plot = ice_spaghetti_plot,
       width = 7, height = 5, units = "in", dpi = 300)
```

------------------------------------------------------------------------

# Part 8 · Is maximum ice cover changing over time?

**▶ Run this:**

``` r
# Find the single highest ice-cover day each year ----------------
max_ice_per_year <- ice_clean %>%
  group_by(year) %>%
  slice_max(order_by = ice_cover, n = 1, with_ties = FALSE)

head(max_ice_per_year %>% arrange(ice_cover))
```

✏️ **Your turn:** What does `slice_max(order_by = ice_cover, n = 1, with_ties = FALSE)` keep, for each year?

```         
Your answer:
```

✏️ **Your turn:** Sort `max_ice_per_year` to find the lowest- and highest-ice years on record.

``` r
# Lowest max ice cover on record ----------------------------------
max_ice_per_year %>% arrange(ice_cover) %>% head(3)

# Highest max ice cover on record ----------------------------------
max_ice_per_year %>% arrange(desc(ice_cover)) %>% head(3)
```

```         
Lowest-ice year on record:      max ice = _______ %    date = _______
Highest-ice year on record:     max ice = _______ %    date = _______
```

------------------------------------------------------------------------

# Part 9 · Model the trend in maximum ice cover

**▶ Run this:**

``` r
# Fit a regression: max ice cover by year --------------------------
max_ice_model <- lm(ice_cover ~ year, data = max_ice_per_year)
summary(max_ice_model)
```

``` r
max_ice_plot <- max_ice_per_year %>%
  ggplot(aes(x = year, y = ice_cover)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", color = "firebrick") +
  labs(
    title = "Lake Superior — Annual Maximum Ice Cover",
    x = "Year", y = "Max Ice Cover (%)"
  ) +
  theme_minimal()

max_ice_plot

ggsave("figures/max_ice_plot.png",
       plot = max_ice_plot,
       width = 5, height = 5, units = "in", dpi = 300)
```

✏️ **Your turn:** Report your results:

```         
Slope (b):
p-value for the slope:
R-squared:
Is the trend statistically significant at alpha = 0.05?  Y / N
```

✏️ **Your turn:** Look at the scatter of points around the line. Is the year-to-year variability large or small compared to any long-term trend? What does that suggest about predicting next year's ice cover from this model alone?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 10 · Review and checkpoint

At this point you should be able to:

- [ ] Read a messy, wide text file directly from a web URL with `read.table()`
- [ ] Explain why wide data resists `group_by()` and `ggplot()`
- [ ] Use `pivot_longer()` to reshape wide data into tidy long data
- [ ] Handle a date variable that crosses the calendar year boundary
- [ ] Use `pivot_wider()` to build a readable summary table from long data
- [ ] Build a multi-layer `ggplot()` with several `geom_line()` calls from different data frames
- [ ] Use `slice_max()` to extract one extreme value per group
- [ ] Fit and interpret `lm()` on a yearly extreme value (not just a yearly mean)

✏️ **Your turn — before you move on:** Run your entire script with **Ctrl/Cmd + Shift + Enter**. Does it run from top to bottom without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 11 · Going further

> This section is optional — work through it if you finish early or want to push deeper.

### Challenge 1 — Which year had the lowest seasonal maximum?

✏️ **Try it yourself:** You already answered this in Part 8 — but now write one sentence connecting it to a real-world cause. (Hint: search "Lake Superior ice cover \[that year\]" — was it an unusually warm winter, an El Niño year, or something else?)

```         
Your sentence:
```

### Challenge 2 — Ice-on and ice-off timing

The **date** of each year's maximum is itself a kind of "peak winter" marker. Try plotting the date (not just the percentage) of each year's maximum ice cover over time:

``` r
max_ice_per_year %>%
  ggplot(aes(x = year, y = yday(full_date))) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Day of Year of Maximum Ice Cover, Lake Superior",
    x = "Year", y = "Day of Year (1 = Jan 1)"
  ) +
  theme_minimal()
```

✏️ **Your turn:** Is the date of peak ice cover trending earlier, later, or staying about the same over the 50+ year record?

```         
Your answer:
```

### Challenge 3 — Try another lake

NOAA publishes the same daily file format for every Great Lake. Swap the URL for a different lake and repeat the whole workflow:

```         
Lake Michigan:  https://www.glerl.noaa.gov/data/ice/glicd/daily/mic.txt
Lake Huron:     https://www.glerl.noaa.gov/data/ice/glicd/daily/hur.txt
Lake Erie:      https://www.glerl.noaa.gov/data/ice/glicd/daily/eri.txt
Lake Ontario:   https://www.glerl.noaa.gov/data/ice/glicd/daily/ont.txt
```

✏️ **Your turn:** Does the lake you chose show a similar long-term trend in maximum ice cover to Lake Superior?

```         
Your answer:
```

------------------------------------------------------------------------

# What your `figures/` folder should contain after this worksheet

```         
figures/
├── ice_spaghetti_plot.png   ← from Part 7
├── max_ice_plot.png         ← from Part 9
```

------------------------------------------------------------------------

# Getting unstuck

1.  **`read.table()` fails or times out:** check your internet connection — this reaches NOAA's server directly. If it keeps failing, ask for a saved local copy of `sup.txt`.
2.  **Column names look like `X1973` instead of `1973`:** this is expected — R cannot start a column name with a number. `names_prefix = "X"` in `pivot_longer()` removes it.
3.  **`group_by(year)` error — object not found:** you're still working with `ice_raw` (wide). Make sure you've run the `pivot_longer()` step first and are using `ice_long` or `ice_clean`.
4.  **Dates look wrong (off by one year):** double check the `calendar_year` logic in Part 4 — Nov/Dec dates must be assigned to the *previous* calendar year.
5.  **Spaghetti plot looks empty or only shows one line:** confirm `past_years`, `historical_avg`, and `current_year_data` were all built *after* `ice_plot_data`, and that each `geom_line()` correctly points to its own `data =` argument.
6.  **Cheat sheets** — <https://posit.co/resources/cheatsheets/>

> 💡 **Key idea:** `pivot_longer()` and `pivot_wider()` are two of the most-used functions in the entire tidyverse. Almost every real dataset you download from a government agency, lab instrument, or field data sheet will need one or the other before you can analyze it.

------------------------------------------------------------------------

*End of Worksheet 07. Data: NOAA-GLERL Great Lakes Ice Cover Database, glerl.noaa.gov/data/ice. Next: Homework — pivot and analyze data for a Great Lake of your choice.*