---
title: "Worksheet 03 — Describing Our Data"
subtitle: "Wrangling, descriptive statistics, and first visualizations"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 3: Describing Our Leaf Data

### Recap from Worksheet 02

- Installed R and Positron; created a project folder (`data/`, `scripts/`, `figures/`)
- Used R as a calculator and stored values with `<-`
- Built vectors, learned data types, wrote scripts with `#` comments
- Loaded our leaf data with `read_excel()` and learned how `read_csv()` differs
- Inspected a data frame with `glimpse()`, `head()`, `dim()`
- Used the pipe `%>%` to chain steps
- Made and saved a first `ggplot` as a PNG (`dpi = 300`)

### Today's Objectives

1. Use `filter()`, `select()`, `mutate()`, and `arrange()` to wrangle data
2. Chain all four verbs into a single pipeline
3. Understand why `NA` values require special handling with `sum(!is.na())`
4. Calculate mean, median, SD, and SE using `filter()` and `pull()`
5. Use `group_by()` + `summarize()` to compute stats the tidy way
6. Explore data quickly with `skimr`
7. Build a boxplot with individual points overlaid
8. Create a mean ± SE summary plot using `stat_summary()`

> # **How to use this worksheet**
>
> Work through each part at your own pace. Type the code into a new R script in Positron and run it line by line. Code blocks marked **▶ Run this** should be executed exactly as written. Blocks marked **✏️ Your turn** ask you to write or modify something. The **Going further** section at the end is optional — work through it if you finish early.

------------------------------------------------------------------------

# Part 1 · Load libraries and data

### Libraries first

Always load all packages at the very top of your script.

**▶ Run this at the top of your script:**

``` r
# Load all packages — always at the top of the script --------
library(readxl)      # reading Excel files
library(tidyverse)   # data manipulation + ggplot2
library(skimr)       # fast descriptive summaries
```

> ⚠️ **Watch out!** If R says *"could not find function `read_excel`"* you forgot `library(readxl)`. You must reload libraries every time you restart R.

### Load the leaf data

**▶ Run this:**

``` r
# Read the Excel file — path is relative to your project folder
tree_df <- read_excel("data/2026_06_25_tree_experiment_raw_data.xlsx")
```

------------------------------------------------------------------------

# Part 2 · Inspect the data

**▶ Run each of these:**

``` r
head(tree_df)       # first 6 rows
glimpse(tree_df)    # column names, types, first values — use this!
dim(tree_df)        # rows × columns
```

✏️ **Your turn:** Fill in the table below from the `glimpse()` output.

```         
Column name     | Data type (<chr> / <dbl>)  | Example value
----------------|----------------------------|---------------
index           |                            |
side            |                            |
weight_g        |                            |
width_cm        |                            |
height_cm       |                            |
```

✏️ **Your turn:** How many leaves are from the sunny side and how many from the shady side? Use `table(tree_df$side)`.

``` r
# Write your code here:
```

```         
Sunny leaves:
Shady leaves:
Is the design balanced (equal n per group)?  Y / N
```

------------------------------------------------------------------------

# Part 3 · The core tidyverse verbs — filter, select, mutate, arrange

These four functions do most of the work in data wrangling. All take a data frame and return a data frame.

### `filter()` — keeping rows you want

**▶ Run this:**

``` r
# filter() keeps rows where the condition is TRUE ------

# Keep only sunny leaves
tree_df %>% filter(side == "sunny")

# Keep only leaves heavier than 5 g
tree_df %>% filter(weight_g > 5)

# Combine conditions (AND = both must be true)
tree_df %>% filter(side == "shady", weight_g > 7)
```

> ⚠️ **Watch out!** `=` assigns a value. `==` tests equality. Always use `==` inside `filter()`.

✏️ **Your turn:** Use `filter()` to find all leaves where `height_cm` is greater than 25. How many rows does the result have?

``` r
# Write your code here:
```

```         
Number of leaves with height_cm > 25:
Are they mostly sunny or shady side?
```

------------------------------------------------------------------------

### `select()` — keeping columns you want

**▶ Run this:**

``` r
# select() keeps the columns you name ------------------

# Keep only side and weight
tree_df %>% select(side, weight_g)

# Drop the index column (use minus sign)
tree_df %>% select(-index)

# Keep columns that end with a unit label
tree_df %>% select(side, ends_with("_cm"))
```

✏️ **Your turn:** Create a data frame called `lean_df` that has only `side` and `height_cm`. Then run `glimpse(lean_df)` to verify.

``` r
# Write your code here:
```

```         
How many columns does lean_df have?
What are they?
```

------------------------------------------------------------------------

### `mutate()` — adding new columns

`mutate()` adds new columns (or changes existing ones) without removing anything.

**▶ Run this:**

``` r
# mutate() adds a new column to the data frame ---------

# Convert grams to milligrams
tree_df %>%
  mutate(weight_mg = weight_g * 1000)

# Add a size category based on weight
tree_df %>%
  mutate(size_class = if_else(weight_g > 5, "large", "small"))
```

✏️ **Your turn:** Use `mutate()` to add a column called `height_mm` (height converted to millimetres — multiply by 10). What is the maximum height in mm?

``` r
# Write your code here:
```

```         
Column name you added:
Maximum height in mm:
```

------------------------------------------------------------------------

### `arrange()` — sorting rows

**▶ Run this:**

``` r
# arrange() sorts rows by a column ---------------------

# Lightest leaves first (ascending — default)
tree_df %>% arrange(weight_g)

# Heaviest leaves first (descending — use desc())
tree_df %>% arrange(desc(weight_g))

# Sort by side, then by weight within each side
tree_df %>% arrange(side, desc(weight_g))
```

✏️ **Your turn:** Sort the data by `height_cm` descending. What is the `index` number and `side` of the tallest leaf?

``` r
# Write your code here:
```

```         
Index of tallest leaf:
Side (sunny or shady):
Height (cm):
```

------------------------------------------------------------------------

### The full pipeline — chaining all four verbs

**▶ Run this:**

``` r
# Chain all four verbs — read it as a recipe ----------
tree_clean_df <- tree_df %>%
  filter(weight_g > 0) %>%              # remove any zeros
  select(side, weight_g, height_cm) %>%  # keep three columns
  mutate(
    weight_mg   = weight_g * 1000,
    size_class  = if_else(weight_g > 5, "large", "small")
  ) %>%
  arrange(side, desc(weight_g))          # sort by side, then weight

head(tree_clean_df)
```

✏️ **Your turn:** Read the pipeline out loud, one `%>%` step at a time. Write in plain English what each step does:

```         
Step 1 (filter):
Step 2 (select):
Step 3 (mutate):
Step 4 (arrange):
```

------------------------------------------------------------------------

# Part 4 · The NA problem — counting observations correctly

### What is an NA?

`NA` stands for "Not Available" — it marks a **missing value**. Missing data are common in real ecological studies.

### The problem with `length()`

**▶ Run this:**

``` r
# Create a small vector with missing values for demonstration
x <- c(4, 3, NA, 7, NA)

# length() counts ALL positions — including NAs
length(x)
```

✏️ **Your turn:** What did `length(x)` return? How many of those positions are real data values?

```         
length(x) returned:
Number of real (non-NA) values:
```

### Breaking down `is.na()` step by step

**▶ Run each line one at a time:**

``` r
# Step 1: is.na() marks where the NAs are
is.na(x)
```

``` r
# Step 2: ! flips TRUE to FALSE and FALSE to TRUE
!is.na(x)
```

``` r
# Step 3: sum() counts the TRUEs — TRUEs are real values!
sum(!is.na(x))
```

✏️ **Your turn:** Trace through what each step does to `c(4, 3, NA, 7, NA)`:

```         
is.na(x)       produces: 
!is.na(x)      produces: 
sum(!is.na(x)) produces: 
```

> ⚠️ **Watch out!** Any stats function on a vector containing `NA` returns `NA` — not an error. R will not tell you something went wrong. Always include `na.rm = TRUE`.

------------------------------------------------------------------------

# Part 5 · Descriptive statistics in base R

### Extract one group with `filter()` and `pull()`

**▶ Run this:**

``` r
# Extract sunny leaf weights as a plain vector --------
sunny_wt <- tree_df %>%
  filter(side == "sunny") %>%
  pull(weight_g)

sunny_wt    # print the raw values
```

✏️ **Your turn:** Write the code to extract the shady leaf weights as a vector called `shady_wt`.

``` r
# Write your code here:
```

### Mean

**▶ Run this:**

``` r
# Mean for the sunny side ----------------------------
mean_sunny <- mean(sunny_wt, na.rm = TRUE)
cat("Mean sunny weight:", round(mean_sunny, 2), "g\n")
```

✏️ **Your turn:** Calculate the mean for the shady side. Store it as `mean_shady` and print it.

``` r
# Write your code here:
```

```         
Mean shady leaf weight (g):
Is the shady mean larger than sunny?  Y / N
Does this match the hypothesis?       Y / N
```

### Median

**▶ Run this:**

``` r
# Median for each side --------------------------------
med_sunny <- median(sunny_wt, na.rm = TRUE)
med_shady <- median(shady_wt, na.rm = TRUE)

cat("Median sunny:", round(med_sunny, 2), "\n")
cat("Median shady:", round(med_shady, 2), "\n")
```

✏️ **Your turn:** Compare the mean and median for the sunny side. If they are about equal, what does that tell you about the shape of the distribution?

```         
Mean sunny:
Median sunny:
What it suggests about distribution shape:
```

### Standard Deviation

**▶ Run this:**

``` r
# SD for each side ------------------------------------
sd_sunny <- sd(sunny_wt, na.rm = TRUE)
sd_shady <- sd(shady_wt, na.rm = TRUE)

cat("SD sunny:", round(sd_sunny, 2), "g\n")
cat("SD shady:", round(sd_shady, 2), "g\n")
```

✏️ **Your turn:** Which side has more variable leaf weights? What does a larger SD tell you biologically?

```         
More variable side:
Biological interpretation:
```

### Standard Error

**▶ Run this:**

``` r
# SE = SD / sqrt(n) — must use the correct n ----------
n_sun  <- sum(!is.na(sunny_wt))
n_sha  <- sum(!is.na(shady_wt))

se_sunny <- sd_sunny / sqrt(n_sun)
se_shady <- sd_shady / sqrt(n_sha)

cat("n sunny  =", n_sun, "\n")
cat("SE sunny =", round(se_sunny, 2), "g\n\n")
cat("n shady  =", n_sha, "\n")
cat("SE shady =", round(se_shady, 2), "g\n")
```

✏️ **Your turn:** In your own words, what does the SE tell you that the SD does not?

```         
Your answer:
```

✏️ **Your turn:** If you collected 40 leaves per side instead of 10, would the SE get larger or smaller? Why?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 6 · Tidy stats with `group_by()` + `summarize()`

### All groups, all stats, one pipeline

**▶ Run this:**

``` r
# group_by() + summarize() — the core tidyverse pattern ------
stats_df <- tree_df %>%
  group_by(side) %>%
  summarize(
    n       = sum(!is.na(weight_g)),
    mean_wt = round(mean(weight_g,   na.rm = TRUE), 2),
    med_wt  = round(median(weight_g, na.rm = TRUE), 2),
    sd_wt   = round(sd(weight_g,     na.rm = TRUE), 2),
    se_wt   = round(sd_wt / sqrt(n), 2)
  )

stats_df
```

> 💡 **Key idea:** `group_by(side)` splits the data by the `side` column. Everything after it happens *within each group*. You get one output row per group.

✏️ **Your turn:** The `se_wt` line references `sd_wt` and `n` that were just created in the same `summarize()` call. Rewrite the SE formula in plain words:

```         
SE equals:
```

✏️ **Your turn:** Do the numbers in `stats_df` match what you calculated by hand in Part 5?

```         
Y / N — if not, explain any differences:
```

### Summary across multiple variables

**▶ Run this:**

``` r
# Summarize all three measurements at once -----------
size_stats_df <- tree_df %>%
  group_by(side) %>%
  summarize(
    n       = n(),
    mean_wt = round(mean(weight_g,  na.rm = TRUE), 2),
    mean_ht = round(mean(height_cm, na.rm = TRUE), 2),
    mean_wd = round(mean(width_cm,  na.rm = TRUE), 2)
  )

size_stats_df
```

✏️ **Your turn:** Looking at `size_stats_df`, fill in the table:

```         
Measurement    | Sunny mean | Shady mean | Shady larger? (Y/N)
---------------|------------|------------|---------------------
weight_g       |            |            |
height_cm      |            |            |
width_cm       |            |            |

Overall: does the data support the hypothesis?
```

------------------------------------------------------------------------

# Part 7 · Fast overview with `skimr`

**▶ Run this:**

``` r
# skim() grouped by side — everything at once --------
tree_df %>%
  group_by(side) %>%
  skim()
```

✏️ **Your turn:** Look at the `n_missing` row for `weight_g`. How many values are missing per group?

```         
n_missing sunny weight_g:
n_missing shady weight_g:
```

✏️ **Your turn:** Look at the `mean` and `p50` (50th percentile = median) values for `weight_g`. Are mean and median close for each group? What does that suggest about skewness?

```         
Your answer:
```

> 💡 **Key idea:** `skim()` is the fastest first look at any dataset. Use it on every new dataset you encounter — it takes one line and shows everything.

------------------------------------------------------------------------

# Part 8 · Visualizing with boxplots

### Basic boxplot

Because our data is already in **long format**, we can plot directly — no reshaping required.

**▶ Run this:**

``` r
# Boxplot — data is already long, plot it directly ----
tree_box_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, fill = side)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  labs(
    title = "Leaf Weight by Tree Side",
    x     = "Side of Tree",
    y     = "Leaf Weight (g)",
    fill  = "Side"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

tree_box_plot
```

✏️ **Your turn:** Label the four key parts of a boxplot from memory:

```         
The line inside the box represents:
The top and bottom of the box represent:
The whiskers represent:
Dots beyond the whiskers represent:
```

### Add individual data points

**▶ Run this:**

``` r
# Add jittered raw data points over the boxplot ------
tree_jitter_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, fill = side)) +
  geom_boxplot(alpha = 0.5, outlier.shape = NA) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha    = 0.6,
    size     = 2.5
  ) +
  labs(
    title = "Leaf Weight by Tree Side",
    x     = "Side of Tree",
    y     = "Leaf Weight (g)",
    fill  = "Side"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

tree_jitter_plot
```

✏️ **Your turn:** In `geom_point()`, change `alpha = 0.6` to `alpha = 1.0`. Then try `alpha = 0.1`. What does `alpha` control?

``` r
# Write your modified code here:
```

```         
What alpha controls:
Which alpha value looks best for 10 points?
```

✏️ **Your turn:** Change `width = 0.15` inside `position_jitter()` to `width = 0.8`. What happens? Is `0.15` or `0.8` more appropriate?

``` r
# Write your modified code here:
```

```         
What changed:
Better choice and why:
```

### Save your plot

**▶ Run this:**

``` r
# Save the boxplot to the figures folder -------------
ggsave("figures/leaf_weight_boxplot.png",
       plot   = tree_jitter_plot,
       width  = 5,
       height = 5,
       units  = "in",
       dpi    = 300)
```

------------------------------------------------------------------------

# Part 9 · Mean ± SE plot with `stat_summary()`

**▶ Run this:**

``` r
# stat_summary() computes and plots mean and SE ------
tree_mean_se_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, color = side)) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha    = 0.35,
    size     = 2
  ) +
  stat_summary(fun      = mean,    geom = "point", size = 4) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.15, linewidth = 0.9) +
  labs(
    title = "Mean ± SE Leaf Weight by Tree Side",
    x     = "Side of Tree",
    y     = "Leaf Weight (g)",
    color = "Side"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

tree_mean_se_plot
```

✏️ **Your turn:** The large dot shows the **mean**. The vertical bars show **± 1 SE**. Do the error bars overlap? What does non-overlapping bars suggest (informally)?

```         
Do the error bars overlap?  Y / N
What non-overlap suggests:
```

✏️ **Your turn:** Change `fun = mean` in the first `stat_summary()` to `fun = median`. What changes in the plot?

``` r
# Write your modified code here:
```

```         
What changed:
```

### Save this plot

**▶ Run this:**

``` r
ggsave("figures/leaf_weight_mean_se.png",
       plot   = tree_mean_se_plot,
       width  = 5,
       height = 5,
       units  = "in",
       dpi    = 300)
```

------------------------------------------------------------------------

# Part 10 · Review and checkpoint

At this point you should be able to:

- [ ] Load an Excel file with `read_excel()` and inspect with `glimpse()`, `head()`, `dim()`
- [ ] Use `filter()` to keep rows matching a condition
- [ ] Use `select()` to keep specific columns
- [ ] Use `mutate()` to add a new calculated column
- [ ] Use `arrange()` to sort rows
- [ ] Chain all four verbs into a single `%>%` pipeline
- [ ] Explain why `length()` is unreliable with NAs and use `sum(!is.na())` instead
- [ ] Use `filter()` and `pull()` to extract a group's values as a vector
- [ ] Calculate mean, median, SD, and SE with `na.rm = TRUE`
- [ ] Use `group_by()` + `summarize()` to compute stats for all groups at once
- [ ] Use `skim()` for a fast full-dataset overview
- [ ] Build a boxplot with jittered points and save as PNG with `dpi = 300`
- [ ] Add a mean ± SE layer using `stat_summary()`

✏️ **Your turn — before you move on:** Run your entire script with **Ctrl/Cmd + Shift + Enter**. Does it complete without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 11 · Going further

> This section is optional — work through it if you finish early.

### Explore `height_cm` and `width_cm`

**▶ Try this for `height_cm`:**

``` r
tree_height_plot <- tree_df %>%
  ggplot(aes(x = side, y = height_cm, fill = side)) +
  geom_boxplot(alpha = 0.5, outlier.shape = NA) +
  geom_point(position = position_jitter(width = 0.15, seed = 42),
             alpha = 0.6, size = 2.5) +
  labs(title = "Leaf Height by Tree Side",
       x = "Side of Tree", y = "Leaf Height (cm)") +
  theme_minimal() +
  theme(legend.position = "none")

tree_height_plot
```

✏️ **Your turn:** Make the same plot for `width_cm`. Copy and adapt the code above.

``` r
# Write your modified code here:
```

### Use `mutate()` to add a column, then plot it

**▶ Try this:**

``` r
# Add size_class column, then make a bar chart
tree_df %>%
  mutate(size_class = if_else(weight_g > 5, "large", "small")) %>%
  ggplot(aes(x = side, fill = size_class)) +
  geom_bar(position = "dodge") +
  labs(title = "Number of large vs small leaves by side",
       x = "Side", y = "Count", fill = "Size class") +
  theme_minimal()
```

✏️ **Your turn:** What does `position = "dodge"` do to the bars? What happens if you change it to `position = "fill"`?

```         
dodge does:
fill does:
```

### Violin plots

**▶ Try this:**

``` r
tree_violin_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, fill = side)) +
  geom_violin(alpha = 0.5) +
  geom_point(position = position_jitter(width = 0.1, seed = 42),
             alpha = 0.6, size = 2) +
  labs(title = "Violin Plot of Leaf Weight",
       x = "Side of Tree", y = "Leaf Weight (g)") +
  theme_minimal() +
  theme(legend.position = "none")

tree_violin_plot
```

✏️ **Your turn:** What does the width of the violin at any given weight value show you, compared to a boxplot?

```         
Your observation:
```

------------------------------------------------------------------------

# What your `figures/` folder should contain

After completing this worksheet:

```         
tree_project/
├── data/
│   └── 2026_06_25_tree_experiment_raw_data.xlsx   <- never edit this
├── figures/
│   ├── leaf_weight_boxplot.png                     <- Part 8
│   └── leaf_weight_mean_se.png                     <- Part 9
└── scripts/
    └── 03_leaf_descriptions.R                      <- your script
```

------------------------------------------------------------------------

# Getting unstuck

1. **Read the error message out loud.** R usually names the line and the problem.
2. **Check the usual suspects:** Did you load `library(readxl)`, `library(tidyverse)`, and `library(skimr)`?
3. **Spelling?** R is **case-sensitive** — `"Sunny"` ≠ `"sunny"`. Check with `names(tree_df)`.
4. **`na.rm = TRUE` missing?** Any stat function on a column with NAs returns `NA` without it — no error, just a silent wrong answer.
5. **File not found?** Check with `getwd()` and confirm the `data/` folder is inside your project.
6. **Cheat sheets** — <https://posit.co/resources/cheatsheets/>
7. **Bring the exact error** (copy-paste it) to class, Canvas, or office hours.

> 💡 **Key idea:** Getting stuck is not failing — every working data scientist googles error messages daily.

------------------------------------------------------------------------

*End of Worksheet 03. Next: Worksheet 04 will cover the two-sample Welch's t-test — formally testing whether the difference in leaf weight between sunny and shady sides is statistically significant.*
