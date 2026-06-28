---
title: "03_Class_Activity Descriptive Statistics"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 3: Describing Our Leaf Data

### Recap from Lecture 02

- Installed R and Positron; organized project folders
- Used R as a calculator and stored values with `<-`
- Learned about vectors, data types, and calling functions
- Loaded our leaf data with `read_excel()` and made a first `ggplot`

### Today's Objectives

1.  Load the leaf Excel file and inspect its structure
2.  Understand why `NA` values require special handling with `sum(!is.na())`
3.  Calculate mean, median, SD, and SE in base R using `filter()` and `pull()`
4.  Use `group_by()` + `summarize()` to compute stats the tidy way
5.  Explore data quickly with `skimr`
6.  Build a boxplot with individual points overlaid
7.  Create a mean ± SE summary plot using `stat_summary()`

> # **How to use this worksheet**
>
> Work through each part at your own pace. Type the code into a new R script in Positron and run it line by line. Code blocks marked **▶ Run this** should be executed exactly as written. Blocks marked **✏️ Your turn** ask you to write or modify something. The **Going further** section at the end is optional — work through it if you finish early.

------------------------------------------------------------------------

# Part 1 · Load libraries and data

### Libraries first

Always load all packages at the very top of your script. They go before any data or analysis.

**▶ Run this at the top of your script:**

``` r
# Load all packages — always at the top of the script --------
library(readxl)      # reading Excel files
library(tidyverse)   # data manipulation + ggplot2
library(skimr)       # fast descriptive summaries
```

> ⚠️ **Watch out!** If R says *"could not find function `read_excel`"* you forgot `library(readxl)`. You must reload libraries every time you restart R.

### Load the leaf data

The Excel file is already in your `data/` folder.

**▶ Run this:**

``` r
# Read the Excel file ----------------------------------------
tree_df <- read_excel(
  "data/2026_06_25_tree_experiment_raw_data.xlsx"
)
```

> 💡 **Key idea:** `"data/..."` is a *relative* path — it looks inside your project folder for the `data/` sub-folder. This works on any computer, not just yours.

✏️ **Your turn:** Run `dim(tree_df)`. The output gives you two numbers. What does each one mean?

``` r
# Write your code here:
```

```         
First number means:
Second number means:
```

✏️ **Your turn:** How many leaves are from the sunny side? How many from shady? Use `table(tree_df$side)` to find out.

``` r
# Write your code here:
```

```         
Sunny leaves:
Shady leaves:
Is the design balanced (equal n per group)?  Y / N
```

------------------------------------------------------------------------

# Part 2 · Inspect the data

### Get a first look

**▶ Run each of these:**

``` r
# Show the first 6 rows
head(tree_df)
```

``` r
# Show column names, types, and first values
glimpse(tree_df)
```

✏️ **Your turn:** Fill in the table below from the `glimpse()` output.

```         
Column name     | Data type (chr / dbl / int)  | Example value
----------------|------------------------------|---------------
index           |                              |
side            |                              |
weight_g        |                              |
width_cm        |                              |
height_cm       |                              |
```

✏️ **Your turn:** This data is in **long format** — one row per leaf, with `side` as a grouping column. How would you describe the difference between *long* and *wide* format in your own words?

```         
Long format means:

Wide format would look like:
```

------------------------------------------------------------------------

# Part 3 · The NA problem — counting observations correctly

### What is an NA?

`NA` stands for "Not Available" — it marks a **missing value**. Missing data are common in real ecological studies (a leaf blew away, a measurement was smudged, equipment failed). Understanding how R handles them is critical.

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

✏️ **Your turn:** In the space below, trace through what each step does to the vector `c(4, 3, NA, 7, NA)`:

```         
is.na(x)       produces: 
!is.na(x)      produces: 
sum(!is.na(x)) produces: 
```

### Apply to real data

**▶ Run this:**

``` r
# Count non-missing values in our leaf data -----------
n_sunny <- tree_df %>%
  filter(side == "sunny") %>%
  pull(weight_g) %>%
  sum(!is.na(.))

n_shady <- tree_df %>%
  filter(side == "shady") %>%
  pull(weight_g) %>%
  sum(!is.na(.))

cat("Non-missing sunny weights =", n_sunny, "\n")
cat("Non-missing shady weights =", n_shady, "\n")
```

> ⚠️ **Watch out!** Any stats function run on a vector containing `NA` will return `NA` — not an error. R will not tell you something went wrong. Always include `na.rm = TRUE`.

------------------------------------------------------------------------

# Part 4 · Descriptive statistics in base R

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

# Part 5 · Tidy stats with `group_by()` + `summarize()`

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

✏️ **Your turn:** Do the numbers in `stats_df` match what you calculated by hand in Part 4?

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
    n         = n(),
    mean_wt   = round(mean(weight_g,  na.rm = TRUE), 2),
    mean_ht   = round(mean(height_cm, na.rm = TRUE), 2),
    mean_wd   = round(mean(width_cm,  na.rm = TRUE), 2)
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

# Part 6 · Fast overview with `skimr`

### `skim()` in one line

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

✏️ **Your turn:** Look at the `mean` and `p50` (50th percentile = median) values in the skim output for `weight_g`. Are mean and median close for each group? What does that suggest about skewness?

```         
Your answer:
```

> 💡 **Key idea:** `skim()` is the fastest first look at any dataset. Use it on every new dataset you encounter — it takes one line and shows everything.

------------------------------------------------------------------------

# Part 7 · Visualizing with boxplots

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

✏️ **Your turn:** Label the five key parts of a boxplot from memory (or look it up):

```         
The line inside the box represents:
The top and bottom of the box represent:
The whiskers represent:
Dots beyond the whiskers represent:
```

✏️ **Your turn:** Do the two boxes overlap? What does that suggest about whether the groups are different?

```         
Do the boxes overlap?  Y / N
What it suggests:
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

✏️ **Your turn:** Change `width = 0.15` inside `position_jitter()` to `width = 0.8`. What happens? Is `0.15` or `0.8` more appropriate for this plot, and why?

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

Check your `figures/` folder — the PNG should be there.

> 💡 **Key idea:** `dpi = 300` is the standard for publication-quality figures. The default (72 dpi) is fine for exploring but too blurry for papers.

------------------------------------------------------------------------

# Part 8 · Mean ± SE plot with `stat_summary()`

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
  stat_summary(fun      = mean,    geom = "point",
               size = 4) +
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

✏️ **Your turn:** The large dot shows the **mean**. The vertical bars show **± 1 SE**. Do the error bars for the two groups overlap? What does non-overlapping bars suggest (informally) about the groups?

```         
Do the error bars overlap?  Y / N
What non-overlap suggests:
```

✏️ **Your turn:** In the second `stat_summary()` line, change `width = 0.15` to `width = 0.5`. What does `width` control in an error bar?

``` r
# Write your modified code here:
```

```         
What width controls in an error bar:
```

✏️ **Your turn:** Change `fun = mean` in the first `stat_summary()` to `fun = median`. What changes in the plot? Why might you sometimes report median instead of mean?

``` r
# Write your modified code here:
```

```         
What changed:
When you'd use median:
```

### Save this plot too

**▶ Run this:**

``` r
# Save the mean SE plot to figures -------------------
ggsave("figures/leaf_weight_mean_se.png",
       plot   = tree_mean_se_plot,
       width  = 5,
       height = 5,
       units  = "in",
       dpi    = 300)
```

------------------------------------------------------------------------

# Part 9 · Review and checkpoint

At this point you should be able to:

- [ ] Load an Excel file with `read_excel()` into R
- [ ] Use `dim()`, `head()`, and `glimpse()` to inspect a data frame
- [ ] Explain why `length()` is unreliable with NAs and use `sum(!is.na())` instead
- [ ] Use `filter()` and `pull()` to extract a group's values as a vector
- [ ] Calculate mean, median, SD, and SE with `na.rm = TRUE`
- [ ] Use `group_by()` + `summarize()` to compute stats for all groups at once
- [ ] Use `skim()` for a fast full-dataset overview
- [ ] Build a boxplot with jittered points using `geom_boxplot()` + `geom_point()`
- [ ] Add a mean ± SE layer using `stat_summary()`
- [ ] Save plots to `figures/` with `ggsave()`

✏️ **Your turn — before you move on:** Run your entire script from top to bottom with **Ctrl/Cmd + Shift + Enter**. Does it complete without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 10 · Going further

> This section is optional — work through it if you finish early or want to explore more. There are no wrong answers here.

### Explore `height_cm` and `width_cm`

The data has two more variables you have not plotted yet.

**▶ Try this for `height_cm`:**

``` r
# Boxplot for leaf height ----------------------------
tree_height_plot <- tree_df %>%
  ggplot(aes(x = side, y = height_cm, fill = side)) +
  geom_boxplot(alpha = 0.5, outlier.shape = NA) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha = 0.6, size = 2.5
  ) +
  labs(
    title = "Leaf Height by Tree Side",
    x     = "Side of Tree",
    y     = "Leaf Height (cm)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

tree_height_plot
```

✏️ **Your turn:** Make the same plot for `width_cm`. Copy and adapt the code above.

``` r
# Write your modified code here:
```

✏️ **Your turn:** Does `width_cm` show the same pattern as `weight_g` and `height_cm`? Are there any surprising values in the shady `width_cm` data? (Hint: look at the raw points.)

```         
Your observation:
```

### The `[[ ]]` notation

The double-bracket `[[ ]]` is another way to extract a column as a vector. It is more flexible than `$` because you can store the column name in a variable first.

**▶ Try this:**

``` r
# All three do the same thing -------------------------
tree_df$weight_g
tree_df[["weight_g"]]

col <- "weight_g"
mean(tree_df[[col]], na.rm = TRUE)   # works!
# mean(tree_df$col, na.rm = TRUE)    # does NOT work
```

✏️ **Your turn:** Combine `filter()` and `[[ ]]` to calculate the SE of `height_cm` for the shady side only.

``` r
# Write your code here:
```

```         
SE of shady height_cm:
```

### Violin plot

A violin plot shows the full *shape* of the distribution, not just the quartile box.

**▶ Try this:**

``` r
# Violin plot of leaf weight -------------------------
tree_violin_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, fill = side)) +
  geom_violin(alpha = 0.5) +
  geom_point(
    position = position_jitter(width = 0.1, seed = 42),
    alpha = 0.6, size = 2
  ) +
  labs(
    title = "Violin Plot of Leaf Weight",
    x     = "Side of Tree",
    y     = "Leaf Weight (g)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

tree_violin_plot
```

✏️ **Your turn:** What does the width of the violin at any given weight value show you, compared to a boxplot?

```         
Your observation:
```

### Change the theme

**▶ Try swapping themes — add one of these to the end of any plot above:**

``` r
+ theme_bw()       # clean white background
+ theme_classic()  # classic axis lines, no grid
+ theme_light()    # light grey lines
```

✏️ **Your turn:** Which theme do you prefer for comparing two biological groups? Why?

```         
Your answer:
```

------------------------------------------------------------------------

# What your finished `figures/` folder should contain

After completing this worksheet:

```         
project/
├── data/
│   └── 2026_06_25_tree_experiment_raw_data.xlsx   <- never edit this
├── figures/
│   ├── leaf_weight_boxplot.png                     <- Part 7
│   └── leaf_weight_mean_se.png                     <- Part 8
└── scripts/
    └── 03_leaf_descriptions.R                      <- your script
```

------------------------------------------------------------------------

# Getting unstuck

When code breaks — and it will — work through this list in order:

1.  **Read the error message out loud.** R usually names the line and the problem.
2.  **Check the usual suspects:**
    - Did you load `library(readxl)`, `library(tidyverse)`, and `library(skimr)`?
    - Spelling? R is **case-sensitive** — `"Sunny"` ≠ `"sunny"`
    - Missing `)`, `%>%`, or `+` at the *end* of a line?
3.  **`na.rm = TRUE` missing?** Any stat function on a column with NAs returns `NA` without it — no error, just a silent wrong answer.
4.  **Column name typo?** Check with `names(tree_df)`.
5.  **File not found?** Check your working directory with `getwd()` and confirm the `data/` folder is inside it.
6.  **Cheat sheets** — <https://posit.co/resources/cheatsheets/>
7.  **Bring the exact error** (copy-paste it) to class, Canvas, or office hours.

> 💡 **Key idea:** Getting stuck is not failing — every working data scientist googles error messages daily. The skill is knowing what to google.

------------------------------------------------------------------------

*End of Worksheet 03. Next: Worksheet 04 will cover the two-sample t-test — formally testing whether the difference in leaf weight between sunny and shady sides is statistically significant.*