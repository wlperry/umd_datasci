---
title: "Worksheet 06 — Real Climate Data in R"
subtitle: "Downloading, summarizing, and modeling Duluth weather station data"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 6: Downloading and Summarizing Climate Data

### Recap from Worksheet 05

- **Loaded** the paper calibration data and made a scatter plot
- **Fit** a linear regression with `lm(area_cm2 ~ mass_g, data = paper_df)`
- **Read** every line of `summary()` — slope, intercept, R², p-value
- **Checked assumptions** — residual vs. fitted plot, QQ plot, Shapiro-Wilk on residuals
- **Predicted** leaf area from tracing mass using `predict()` with confidence and prediction intervals

### Today's Objectives

1.  Download real NOAA weather data directly into R using `GSODR`
2.  Explore the raw daily data and see why it's hard to read
3.  Summarize the data by month and by year using `group_by()` + `summarize()`
4.  Plot the raw data and each summary level side by side
5.  Fit a regression (`lm()`) to estimate the **rate of temperature change** over time
6.  Use `case_when()` to build a summer vs. winter season variable
7.  Fit separate models for each season and compare warming rates
8.  Interpret a real long-term climate trend in your own words

> # **How to use this worksheet**
>
> -   Work through each part in order. Type the code into a new R script in Positron and run it line by line.
>     -   Code blocks marked **▶ Run this** should be executed as written.
>     -   Blocks marked **✏️ Your turn** ask you to write, modify, or interpret.
>     -   The **Going further** section is optional.

------------------------------------------------------------------------

# Part 1 · Load libraries and download the data

### Libraries

**▶ Run this at the top of your script:**

``` r
# Load packages at the top — always ----------------------
library(tidyverse)   # data manipulation + ggplot2
library(GSODR)        # download NOAA weather station data
```

### Download Duluth's weather record

We will use the Duluth International Airport station (`727450-14913`), which has daily records back to 1948.

**▶ Run this (this may take a minute — it's downloading real data):**

``` r
# Download daily Duluth weather data, 1948-2025 ----------
duluth_df <- get_GSOD(years = 1948:2025,
                       station = "727450-14913")
```

✏️ **Your turn:** Run `dim(duluth_df)` and `glimpse(duluth_df)`. How many rows and columns does the raw download have?

``` r
# Write your code here:
```

```         
Rows:
Columns:
What does one row represent (a year? a month? a day?):
```

------------------------------------------------------------------------

# Part 2 · Trim to the columns we need

**▶ Run this:**

``` r
# Keep only the columns we actually need -------------------
dlh_temp_df <- duluth_df %>%
  select(
    STNID, NAME, YEARMODA,
    YEAR, MONTH, DAY,
    TEMP, MXSPD, PRCP, I_SNOW_ICE
  )

head(dlh_temp_df)
```

✏️ **Your turn:** Why do we use `select()` here instead of just working with the full `duluth_df`? (Hint: how many columns did `get_GSOD()` actually return?)

```         
Your answer:
```

------------------------------------------------------------------------

# Part 3 · Plot the raw daily data

**▶ Run this:**

``` r
# Plot every single daily temperature -----------------------
raw_temp_plot <- dlh_temp_df %>%
  ggplot(aes(x = YEARMODA, y = TEMP)) +
  geom_point(alpha = 0.2, size = 0.5) +
  geom_line(alpha = 0.3) +
  labs(
    title = "Duluth Daily Mean Temperature, 1948–2025",
    x     = "Date",
    y     = "Temperature (°C)"
  ) +
  theme_minimal()

raw_temp_plot
```

✏️ **Your turn:** Describe what you see. Can you tell whether Duluth is warming over time just by looking at this plot? Why or why not?

```         
What dominates the plot (seasonal cycle / long-term trend / both)?
Can you see a clear warming trend?  Y / N
Why or why not:
```

> 💡 **Key idea:** Raw data shows you *everything* that happened — which can hide the *one pattern* you're looking for. The seasonal cycle (summer ↔ winter) is much bigger than any year-to-year warming trend, so it drowns the trend out visually.

------------------------------------------------------------------------

# Part 4 · Summarize by month

**▶ Run this:**

``` r
# Mean temperature per year-month ----------------------------
dlh_month_df <- dlh_temp_df %>%
  group_by(YEAR, MONTH) %>%
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP     = mean(TEMP, na.rm = TRUE)
  )

head(dlh_month_df)
```

``` r
# Plot the monthly means --------------------------------------
month_temp_plot <- dlh_month_df %>%
  ggplot(aes(x = YEARMODA, y = TEMP)) +
  geom_point(alpha = 0.4, size = 0.8) +
  geom_line(alpha = 0.4) +
  geom_smooth(method = "lm", color = "steelblue") +
  labs(
    title = "Duluth Monthly Mean Temperature",
    x = "Date", y = "Temperature (°C)"
  ) +
  theme_minimal()

month_temp_plot
```

✏️ **Your turn:** How many rows does `dlh_month_df` have compared to `dlh_temp_df`? What pattern is now visible that wasn't visible in the raw daily plot?

```         
Rows in dlh_temp_df (daily):
Rows in dlh_month_df (monthly):
New pattern now visible:
```

------------------------------------------------------------------------

# Part 5 · Summarize by year

**▶ Run this:**

``` r
# Mean temperature per year ------------------------------------
dlh_year_df <- dlh_temp_df %>%
  group_by(YEAR) %>%
  summarize(
    YEARMODA = first(YEARMODA),
    TEMP     = mean(TEMP, na.rm = TRUE)
  )

head(dlh_year_df)
```

``` r
yearly_temp_plot <- dlh_year_df %>%
  ggplot(aes(x = YEAR, y = TEMP)) +
  geom_point(size = 2) +
  geom_line() +
  geom_smooth(method = "lm", color = "firebrick") +
  labs(
    title = "Duluth Annual Mean Temperature, 1948–2025",
    x = "Year", y = "Mean Temp (°C)"
  ) +
  theme_minimal()

yearly_temp_plot
```

✏️ **Your turn:** Fill in the table comparing all three levels of summary:

```         
Level      Rows     What it shows clearly      What it hides
--------   ------   -------------------------  -------------------------
Daily                
Monthly              
Yearly               
```

✏️ **Your turn:** Which summary level would you use if you wanted to know about a single extreme heat wave? Which would you use to study climate change? Explain why they're different.

```         
Best level for a single heat wave:
Best level for climate change:
Why they're different:
```

------------------------------------------------------------------------

# Part 6 · Model the rate of change with `lm()`

**▶ Run this:**

``` r
# Fit a regression: TEMP predicted by YEAR ----------------------
yearly_temp_model <- lm(TEMP ~ YEAR, data = dlh_year_df)

summary(yearly_temp_model)
```

✏️ **Your turn:** This is the exact same `lm()` syntax from Worksheet 05. Fill in what X and Y are in this new context:

```         
Worksheet 05:  X = mass_g       Y = area_cm2
Worksheet 06:  X = _____        Y = _____
```

**▶ Run this:**

``` r
# Pull the slope and convert to °C per decade --------------------
yearly_intercept <- coef(yearly_temp_model)[1]
yearly_slope     <- coef(yearly_temp_model)[2]

cat("Slope (b)      =", round(yearly_slope, 4), "°C/year\n")
cat("Warming rate   =", round(yearly_slope * 10, 3), "°C per decade\n")
```

✏️ **Your turn:** Report the results from your `summary()` output:

```         
Slope (b) =
p-value for the slope =
R-squared =
Warming rate in °C per decade =
Is the warming trend statistically significant at α = 0.05?  Y / N
```

> 📖 **Whitlock & Schluter §17.3:** the slope's p-value tests H₀: β = 0. A significant slope means temperature is changing systematically with year — not just by chance.

------------------------------------------------------------------------

# Part 7 · Build a season variable with `case_when()`

We now ask a sharper question: **is winter warming at the same rate as summer?**

**▶ Run this:**

``` r
# Label each day as summer, winter, or shoulder season -------------
dlh_season_df <- dlh_temp_df %>%
  mutate(
    season = case_when(
      MONTH %in% c(6, 7, 8)   ~ "summer",
      MONTH %in% c(12, 1, 2)  ~ "winter",
      TRUE                     ~ "shoulder"
    )
  )

# Quick check - did it work? -----------------------------------------
dlh_season_df %>%
  count(season)
```

✏️ **Your turn:** How many rows fall into each season category? Does the count roughly make sense given there are 12 months and 3 are assigned to summer, 3 to winter?

```         
n(summer):
n(winter):
n(shoulder):
Does this make sense?  Y / N
```

✏️ **Your turn:** In your own words, explain what each line of the `case_when()` is doing. What does `TRUE ~ "shoulder"` mean?

```         
What MONTH %in% c(6, 7, 8) ~ "summer" does:
What TRUE ~ "shoulder" does:
```

------------------------------------------------------------------------

# Part 8 · Summarize each season by year

**▶ Run this:**

``` r
# Keep only summer and winter, then summarize by year ----------------
season_year_df <- dlh_season_df %>%
  filter(season %in% c("summer", "winter")) %>%
  group_by(YEAR, season) %>%
  summarize(
    TEMP = mean(TEMP, na.rm = TRUE)
  )

head(season_year_df)
```

✏️ **Your turn:** What does `group_by(YEAR, season)` do differently from `group_by(YEAR)` alone? Why do we need both?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 9 · Plot both seasons together

**▶ Run this:**

``` r
# Plot both seasons with separate trend lines --------------------------
season_temp_plot <- season_year_df %>%
  ggplot(aes(x = YEAR, y = TEMP, color = season)) +
  geom_point(size = 1.8, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  scale_color_manual(values = c(
    "summer" = "firebrick",
    "winter" = "steelblue"
  )) +
  labs(
    title = "Duluth Summer vs. Winter Temperature Trends",
    x = "Year", y = "Mean Temp (°C)",
    color = "Season"
  ) +
  theme_minimal()

season_temp_plot
```

✏️ **Your turn:** Just from looking at the plot, which trend line looks steeper — summer or winter? Make a prediction before you run the models in the next part.

```         
Visual prediction — steeper line:
```

------------------------------------------------------------------------

# Part 10 · Fit a separate model for each season

**▶ Run this:**

``` r
# Summer-only model -------------------------------------------------
summer_df <- season_year_df %>% filter(season == "summer")
summer_model <- lm(TEMP ~ YEAR, data = summer_df)
summer_slope <- coef(summer_model)[2]
summary(summer_model)
```

``` r
# Winter-only model -------------------------------------------------
winter_df <- season_year_df %>% filter(season == "winter")
winter_model <- lm(TEMP ~ YEAR, data = winter_df)
winter_slope <- coef(winter_model)[2]
summary(winter_model)
```

``` r
# Compare the two slopes ----------------------------------------------
cat("Summer warming rate:", round(summer_slope * 10, 3), "°C/decade\n")
cat("Winter warming rate:", round(winter_slope * 10, 3), "°C/decade\n")
```

✏️ **Your turn:** Fill in the comparison table:

```         
Season    Slope (°C/year)   Rate (°C/decade)   p-value   Significant? (Y/N)
-------   ----------------  ------------------  --------  -------------------
Summer
Winter
```

✏️ **Your turn:** Was your visual prediction from Part 9 correct? Which season is warming faster in Duluth's data? Does this match what you might expect from the news or your own experience with winters here?

```         
Faster-warming season:
Did this match your prediction?  Y / N
Does this match your real-world experience?  Y / N
Why might winter and summer warm at different rates? (Hint: think about ice cover, snow reflectivity, cloud cover)
```

------------------------------------------------------------------------

# Part 11 · Write a short results paragraph

✏️ **Your turn:** Write a short paragraph (4–6 sentences) summarizing what you found. Include:

-   The overall annual warming rate (°C/decade) and whether it was significant
-   The summer warming rate and the winter warming rate, compared
-   One sentence connecting this to something you've personally noticed about Duluth winters (optional, but encouraged)

```         
Write your results paragraph here:
```

------------------------------------------------------------------------

# Part 12 · Review and checkpoint

At this point you should be able to:

-   [ ] Download real station data into R with `get_GSOD()`
-   [ ] Explain why raw daily data can hide long-term trends
-   [ ] Use `group_by() %>% summarize()` to collapse data to monthly or yearly means
-   [ ] Fit `lm(Y ~ YEAR, data)` and extract the slope as a rate of change
-   [ ] Convert a yearly slope into a more interpretable "per decade" rate
-   [ ] Use `case_when()` to build a new multi-condition categorical variable
-   [ ] Filter to specific categories with `filter(x %in% c(...))`
-   [ ] Fit and compare two group-specific regression models

✏️ **Your turn — before you move on:** Run your entire script with **Ctrl/Cmd + Shift + Enter**. Does it run from top to bottom without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 13 · Going further

> This section is optional — work through it if you finish early or want to push deeper.

### Try a different season split

**▶ Try this:** Instead of strict 3-month summer/winter, try defining seasons using meteorological vs. astronomical boundaries, or add a "spring" and "fall" category to the `case_when()`.

``` r
# Add all four seasons instead of just summer/winter -----------------
dlh_four_season_df <- dlh_temp_df %>%
  mutate(
    season = case_when(
      MONTH %in% c(3, 4, 5)   ~ "spring",
      MONTH %in% c(6, 7, 8)   ~ "summer",
      MONTH %in% c(9, 10, 11) ~ "fall",
      MONTH %in% c(12, 1, 2)  ~ "winter"
    )
  )

dlh_four_season_df %>% count(season)
```

✏️ **Your turn:** Does adding spring and fall change your interpretation at all?

```         
Your answer:
```

### Look at snow instead of temperature

**▶ Try this:**

``` r
# Explore snow/ice flag data -------------------------------------------
dlh_snow_df <- dlh_temp_df %>%
  mutate(
    snow_mm = case_when(
      I_SNOW_ICE == 1 ~ PRCP,
      TRUE             ~ NA
    )
  ) %>%
  mutate(snow_mm = ifelse(snow_mm == 0, NA, snow_mm))

yearly_snow_df <- dlh_snow_df %>%
  group_by(YEAR) %>%
  summarize(sum_snow = sum(snow_mm, na.rm = TRUE))

yearly_snow_df %>%
  ggplot(aes(x = YEAR, y = sum_snow)) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm") +
  labs(x = "Year", y = "Total Yearly Snow (mm)") +
  theme_minimal()
```

✏️ **Your turn:** Has total yearly snowfall changed over time the same way temperature has? Why might these two trends differ?

```         
Your answer:
```

------------------------------------------------------------------------

# What your `figures/` folder should contain after this worksheet

```         
figures/
├── raw_temp_plot.png        ← from Part 3
├── month_temp_plot.png      ← from Part 4
├── yearly_temp_plot.png     ← from Part 5
├── season_temp_plot.png     ← from Part 9
```

------------------------------------------------------------------------

# Getting unstuck

1.  **`get_GSOD()` taking forever / failing:** check your internet connection — this function reaches out to NOAA's servers. If it keeps failing, ask for the saved `.csv` backup.
2.  **`select()` error — object not found:** run `names(duluth_df)` first to confirm exact column names; capitalization matters (`TEMP`, not `temp`).
3.  **`case_when()` returns all `NA`:** check that your conditions use `%in%` for multiple values (`MONTH %in% c(6,7,8)`), not `==` with a vector.
4.  **`group_by()` summary looks wrong:** always check with `head()` immediately after summarizing — did you group by the right combination of variables?
5.  **Plot legend missing or wrong colors:** confirm `color = season` is inside `aes()`, and that `scale_color_manual()` values exactly match your `case_when()` labels (`"summer"`, `"winter"`).
6.  **Cheat sheets** — <https://posit.co/resources/cheatsheets/>

> 💡 **Key idea:** Every dataset you'll ever download from NOAA, eBird, or any other public source will need this same workflow — download → trim → explore raw → summarize → model. You now have it.

------------------------------------------------------------------------

*End of Worksheet 06. Next: Homework — repeat this entire workflow for a city of your choice and compare your city's warming rate to Duluth's.*
