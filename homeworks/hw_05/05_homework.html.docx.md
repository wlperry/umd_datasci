---
title: "Homework 05 — Is Your City Warming? A Climate Regression Comparison"
subtitle: "Downloading real weather data and comparing warming rates to Duluth, MN"
author: "Name: _________________________________ | Date: _____________"
date: today
format:
  html:
    embed-resources: true
    fig-align: center
  docx: default
---

------------------------------------------------------------------------

# Overview

In Lecture 06 and Worksheet 06 you downloaded Duluth's long-term weather record directly into R, summarized it at the yearly level, and used `lm()` to estimate a warming rate in °C per decade. You also split the data into summer and winter to see whether one season is warming faster than the other.

This homework asks you to repeat that **same workflow** for a **city of your own choosing** anywhere in the world with a long GSOD weather station record, and compare what you find to Duluth's numbers.

> **Submit to Canvas:** (1) your completed `.R` script and (2) three saved PNG figures. Fill in all answer boxes **in the script as `#` comments** below the relevant code. The question numbers here match the `# Q__` markers in the skeleton script.

------------------------------------------------------------------------

# The Data

You will download **daily station data** using the same `GSODR` package from Lecture 06. You need two things:

1.  **A station ID** for your city of choice
2.  **A range of years** — pick the longest record available (many stations go back to the 1940s–1970s)

### Finding a station ID

**▶ Run this in your console (not graded, just for exploration):**

``` r
library(GSODR)
load(system.file("extdata", "isd_history.rda", package = "GSODR"))

# Search for stations by country code (2-letter ISO) or name
# Example: find stations in the United Kingdom
subset(isd_history, CTRY == "UK")

# Example: search by partial city name
isd_history[grepl("CHICAGO", isd_history$NAME), ]
```

Pick a station with a **long period of record** (check the `BEGIN` and `END` columns — both are in YYYYMMDD format). Avoid stations with only a few years of data; you want at least **30+ years** for a meaningful trend.

| Column  | What it holds                            |
|---------|------------------------------------------|
| `STNID` | the station ID to plug into `get_GSOD()` |
| `NAME`  | station name                             |
| `CTRY`  | 2-letter country code                    |
| `BEGIN` | first date of record (YYYYMMDD)          |
| `END`   | last date of record (YYYYMMDD)           |

------------------------------------------------------------------------

# Part 1 · Download and inspect (→ see Lecture 06, Worksheet 06)

After downloading your city's data:

> **Q1 — City and station ID you chose:** \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
>
> **Q2 — Years of record you downloaded:** \_\_\_\_\_\_\_\_ to \_\_\_\_\_\_\_\_
>
> **Q3 — Total rows in the raw daily download:** \_\_\_\_\_\_\_\_

------------------------------------------------------------------------

# Part 2 · Summarize by year (→ see Lecture 06, Worksheet 06)

Summarize your city's daily data to **one mean temperature per year**, the same way you did for Duluth.

> **Q4 — Rows in your yearly-summarized data frame:** \_\_\_\_\_\_\_\_
>
> **Q5 — Mean temperature in your city's first year of record:** \_\_\_\_\_\_\_\_ °C
>
> **Q6 — Mean temperature in your city's most recent year of record:** \_\_\_\_\_\_\_\_ °C

------------------------------------------------------------------------

# Part 3 · Regression — rate of change (→ see Lecture 06, Worksheet 06)

Fit `lm(TEMP ~ YEAR, data = your_yearly_df)`, the same model structure from Lecture 06.

> **Q7 — Slope (b), in °C per year:** \_\_\_\_\_\_\_\_
>
> **Q8 — Warming rate, in °C per decade (slope × 10):** \_\_\_\_\_\_\_\_
>
> **Q9 — p-value for the slope:** \_\_\_\_\_\_\_\_
>
> **Q10 — Is the trend statistically significant at α = 0.05? Y / N:** \_\_\_\_\_\_\_\_
>
> **Q11 — R²:** \_\_\_\_\_\_\_\_

### Compare to Duluth

Duluth's annual warming rate from Worksheet 06 (fill in from your own worksheet results):

> **Q12 — Duluth's warming rate (°C/decade), from Worksheet 06:** \_\_\_\_\_\_\_\_
>
> **Q13 — Is your city warming faster or slower than Duluth?** Faster / Slower / About the same
>
> **Q14 — Difference between your city's rate and Duluth's rate (°C/decade):** \_\_\_\_\_\_\_\_

------------------------------------------------------------------------

# Part 4 · Summer vs. winter (→ see Lecture 06, Worksheet 06)

Use `case_when()` to label summer (Jun/Jul/Aug) and winter (Dec/Jan/Feb) months, then fit a **separate** `lm()` for each season — exactly as you did for Duluth.

::: callout-note
If your city is in the **Southern Hemisphere**, summer and winter months are reversed (summer = Dec/Jan/Feb, winter = Jun/Jul/Aug). Adjust your `case_when()` accordingly and note this in Q15.
:::

> **Q15 — Hemisphere of your city (Northern / Southern):** \_\_\_\_\_\_\_\_
>
> **Q16 — Summer warming rate (°C/decade):** \_\_\_\_\_\_\_\_ **p-value:** \_\_\_\_\_\_\_\_
>
> **Q17 — Winter warming rate (°C/decade):** \_\_\_\_\_\_\_\_ **p-value:** \_\_\_\_\_\_\_\_
>
> **Q18 — Which season is warming faster in your city?** Summer / Winter / About the same
>
> **Q19 — Does this match the pattern you found for Duluth (winter warming faster)?** Y / N

------------------------------------------------------------------------

# Part 5 · Results paragraph

✏️ Write a short paragraph (4–6 sentences) summarizing your findings. Include:

- Your city, the years of record, and the overall annual warming rate
- How your city's overall warming rate compares to Duluth's
- The summer vs. winter comparison, and whether it matches Duluth's pattern
- One sentence on a possible reason for any difference (e.g., latitude, proximity to water, urban heat island)

> **Q20 — Results paragraph:**
>
> ------------------------------------------------------------------------
>
> ------------------------------------------------------------------------
>
> ------------------------------------------------------------------------

------------------------------------------------------------------------

# Submission checklist

Before uploading to Canvas, confirm:

- [ ] `05_your_city.R` runs top to bottom without errors
- [ ] All `# Q__` answers are filled in the script
- [ ] `figures/your_city_yearly_trend.png` exists (5 × 5 in, dpi = 300)
- [ ] `figures/your_city_vs_duluth.png` exists (5 × 5 in, dpi = 300)
- [ ] `figures/your_city_season_trend.png` exists (5 × 5 in, dpi = 300)
- [ ] Results paragraph (Q20) is complete

------------------------------------------------------------------------

*Data: NOAA Global Surface Summary of the Day (GSOD), accessed via the GSODR R package.*