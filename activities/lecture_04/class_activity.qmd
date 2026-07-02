---
title: "Worksheet 04 — Testing Our Hypothesis"
subtitle: "The two-sample Welch's t-test from assumptions to scientific report"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 4: The Welch's Two-Sample t-Test

### Recap from Worksheet 03

- Loaded our Excel leaf data with `read_excel()`
- Used `group_by()` + `summarize()` to compute mean, SD, and SE per group
- Checked for missing values with `sum(!is.na())`
- Made boxplots with jittered points and mean ± SE plots with `stat_summary()`
- **Prediction:** shady leaves appeared heavier, taller, and wider than sunny leaves

### Today's Objectives

1.  State null and alternate hypotheses formally before running any test
2.  Check the normality assumption — histogram, QQ plot, and Shapiro-Wilk test
3.  Check the variance assumption — Levene's test
4.  Run a Welch's two-sample t-test (`var.equal = FALSE`, two-tailed)
5.  Read and decode every line of the `t.test()` output
6.  Make a formal statistical decision and state a conclusion
7.  Write a results sentence in proper scientific format

> # **How to use this worksheet**
>
> - Work through each part in order — the steps build on each other. Type the code into your script in Positron and run it line by line.
> - Code blocks marked **▶ Run this** should be executed as written.
> - Blocks marked **✏️ Your turn** ask you to write, modify, or interpret something.
> - The **Going further** section is optional if you finish early.

------------------------------------------------------------------------

# Part 1 · Load libraries and data

### Libraries

**▶ Run this at the top of your script — in this exact order:**

``` r
# Load all packages at the top of the script -----------
library(readxl)      # reading Excel files
library(tidyverse)   # data manipulation + ggplot2
library(skimr)       # fast dataset summaries
library(car)         # Levene's test for variance
```

> ⚠️ **Watch out!**
>
> - If R says `"could not find function 'leveneTest'"`
>   - you forgot `library(car)`.
> - Install it once with `install.packages("car")`, then load it every session `library(car)`

### Load the data

**▶ Run this:**

``` r
# Load the leaf data from the data folder --------------
tree_df <- read_excel("data/2026_06_25_tree_experiment_raw_data.xlsx")
head(tree_df)
```

✏️ **Your turn:** Before anything else — do you remember the structure of this data frame? Fill in from memory, then check with `glimpse(tree_df)`.

```         
Number of rows:
Number of columns:
Column holding the grouping variable (sunny/shady):
Column we are testing today:
```

------------------------------------------------------------------------

# Part 2 · State your hypotheses FIRST

> 💡 **Key idea:** Always write down your hypotheses *before* you look at the data or run any test. This is how you stay scientifically honest.

✏️ **Your turn:** Write the null and alternate hypotheses for leaf weight. Use words first, then symbols.

```         
In words:
  H₀ (null hypothesis):

  Hₐ (alternate hypothesis):

In symbols (use μ for "mean"):
  H₀:
  Hₐ:

Test type (circle one):   one-tailed   /   two-tailed

Significance level α:
```

✏️ **Your turn:** Why do we use a two-tailed test here even though we predicted shady leaves would be *heavier*?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 3 · Quick descriptive stats review

**▶ Run this:**

``` r
# Recap stats from Lecture 03 — both groups at once ----
recap_df <- tree_df %>%
  group_by(side) %>%
  summarize(
    n       = sum(!is.na(weight_g)),
    mean_wt = round(mean(weight_g, na.rm = TRUE), 2),
    sd_wt   = round(sd(weight_g,   na.rm = TRUE), 2),
    se_wt   = round(sd_wt / sqrt(n), 2)
  )

recap_df
```

✏️ **Your turn:** Record the values you will need for the t-test formula:

```         
Shady:  mean = _____ g   SD = _____   n = _____
Sunny:  mean = _____ g   SD = _____   n = _____
Difference in means = _____  g
```

✏️ **Your turn:** Looking at the SD values, do the two groups appear to have **similar** or **different** variance? (Does one group have much more spread than the other?)

```         
Your observation:
```

------------------------------------------------------------------------

# Part 4 · Check normality — histogram

The t-test assumes that data within each group are approximately normally distributed.

**▶ Run this:**

``` r
# Histogram per group — look for bell-shaped distribution
hist_norm_plot <- tree_df %>%
  ggplot(aes(x = weight_g, fill = side)) +
  geom_histogram(binwidth = 1, color = "white", alpha = 0.8) +
  facet_wrap(~side, ncol = 2) +
  labs(
    title = "Leaf Weight Distribution by Side",
    x     = "Leaf Weight (g)",
    y     = "Count"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

hist_norm_plot
```

✏️ **Your turn:** Describe the shape of each histogram:

```         
Sunny side shape (bell-shaped, skewed, flat, bimodal?):

Shady side shape:

Any obvious outliers?  Y / N
```

✏️ **Your turn:** With only 10 values per group, histograms will look lumpy even if the data are normal. Does this mean we should reject normality? Why or why not?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 5 · Check normality — QQ plot

A QQ (quantile-quantile) plot compares your data's quantiles to what a perfect normal distribution would look like. Points on the diagonal line = normal.

**▶ Run this:**

``` r
# Q-Q plot — points should fall along the diagonal ----
qq_norm_plot <- tree_df %>%
  ggplot(aes(sample = weight_g, color = side)) +
  stat_qq() +
  stat_qq_line(color = "black", linewidth = 0.8) +
  facet_wrap(~side, scales = "free") +
  labs(
    title = "Normal Q-Q Plots by Side",
    x     = "Theoretical Quantiles",
    y     = "Sample Quantiles"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

qq_norm_plot
```

✏️ **Your turn:** Do the points for each group fall approximately along the diagonal line? What would it mean if they curved strongly away at the ends?

```         
Sunny side — on the line?  Y / mostly / no
Shady side — on the line?  Y / mostly / no

What strong curvature at the ends would indicate:
```

------------------------------------------------------------------------

# Part 6 · Check normality — Shapiro-Wilk test

The Shapiro-Wilk test formally tests whether a sample could have come from a normal distribution.

- **H₀ (Shapiro-Wilk):** the data are normally distributed
- **p \> 0.05** → fail to reject normality → proceed with t-test
- **p \< 0.05** → evidence of non-normality → consider alternatives

**▶ Run this:**

``` r
# Shapiro-Wilk for the sunny side --------------------
tree_df %>%
  filter(side == "sunny") %>%
  pull(weight_g) %>%
  shapiro.test()
```

``` r
# Shapiro-Wilk for the shady side -------------------
tree_df %>%
  filter(side == "shady") %>%
  pull(weight_g) %>%
  shapiro.test()
```

✏️ **Your turn:** Record the results and state your decision:

```         
Sunny:  W = _____   p = _____   Decision (normal / not normal):
Shady:  W = _____   p = _____   Decision (normal / not normal):
```

✏️ **Your turn:** With n = 10 per group, the Shapiro-Wilk test has low **statistical power**. What does that mean in plain language for interpreting this result?

```         
Your answer:
```

> ⚠️ **Watch out!** Even if Shapiro-Wilk returns *p* \< 0.05 with very small samples, the t-test may still be appropriate — the QQ plot and histogram give important visual context. None of these checks alone is definitive.

------------------------------------------------------------------------

# Part 7 · Check variance — Levene's test

Levene's test checks whether the two groups have the same population variance.

- **H₀ (Levene's):** the two groups have equal variance
- **p \> 0.05** → variances are not significantly different
- **p \< 0.05** → variances are significantly different

**▶ Run this:**

``` r
# Levene's test for equal variance -------------------
leveneTest(weight_g ~ side, data = tree_df)
```

✏️ **Your turn:** Record the result and decide:

```         
F-statistic = _____   p = _____
Decision (variances equal / not equal):
```

✏️ **Your turn:** We are going to use Welch's t-test (`var.equal = FALSE`) regardless of Levene's result. In your own words, why is Welch's the safe default even when Levene's says variances are equal?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 8 · Run the Welch's t-test

Now that we have checked our assumptions, we can run the test.

**▶ Run this:**

``` r
# Welch's two-sample t-test --------------------------
leaf_ttest_model <- t.test(
  weight_g ~ side,          # response ~ grouping variable
  data        = tree_df,
  var.equal   = FALSE,      # Welch's — no pooled variance
  alternative = "two.sided" # two-tailed test
)

leaf_ttest_model
```

✏️ **Your turn:** Copy the full output below:

```         
Paste or write the t.test() output here:
```

------------------------------------------------------------------------

# Part 9 · Decode the output line by line

**▶ Run this to extract individual values:**

``` r
# Pull specific values from the model object ---------
cat("t-statistic:", round(leaf_ttest_model$statistic,  3), "\n")
cat("df (Welch): ", round(leaf_ttest_model$parameter,  2), "\n")
cat("p-value:    ", signif(leaf_ttest_model$p.value,   3), "\n")
cat("95% CI:     ", round(leaf_ttest_model$conf.int[1],2),
    "to", round(leaf_ttest_model$conf.int[2], 2), "g\n")
cat("Mean shady: ", round(leaf_ttest_model$estimate[1],2), "g\n")
cat("Mean sunny: ", round(leaf_ttest_model$estimate[2],2), "g\n")
```

✏️ **Your turn:** Match each piece of output to its meaning:

```         
t-statistic = _____

  → This is large/small (circle one) because the difference in means
    is large/small relative to the variability (circle one).

df = _____

  → This is a non-integer. Why? (hint: Welch-Satterthwaite equation)

p-value = _____

  → In plain language, this means: if H₀ were true, the probability
    of seeing a t-statistic this extreme just by chance is _____.

95% CI = _____ to _____ g

  → This CI is for the ________________ (the true difference in means).
    It does / does not include zero (circle one).
    What does it mean when the CI excludes zero?

Mean shady = _____ g
Mean sunny = _____ g
```

------------------------------------------------------------------------

# Part 10 · Calculate t by hand

**▶ Run this:**

``` r
# Reproduce the t-statistic manually -----------------
m_sha <- recap_df$mean_wt[recap_df$side == "shady"]
m_sun <- recap_df$mean_wt[recap_df$side == "sunny"]
s_sha <- recap_df$sd_wt[recap_df$side == "shady"]
s_sun <- recap_df$sd_wt[recap_df$side == "sunny"]
n_sha <- recap_df$n[recap_df$side == "shady"]
n_sun <- recap_df$n[recap_df$side == "sunny"]

# Welch's SE of the difference
se_diff  <- sqrt((s_sha^2 / n_sha) + (s_sun^2 / n_sun))

# t-statistic
t_manual <- (m_sha - m_sun) / se_diff

cat("Difference in means:", round(m_sha - m_sun, 2), "g\n")
cat("SE of difference:   ", round(se_diff, 4), "\n")
cat("Manual t:           ", round(t_manual, 3), "\n")
```

✏️ **Your turn:** Does your manually calculated t match the value from `t.test()`? (They may differ very slightly due to rounding in `recap_df`.)

```         
Manual t = _____
t.test() t = _____
Match?  Y / close / no
```

✏️ **Your turn:** Write the Welch's t-test formula below and label each part:

```         
t = _________________

  Numerator means:
  Denominator means:
```

------------------------------------------------------------------------

# Part 11 · Make a formal decision

✏️ **Your turn:** State your decision and conclusion. Use the formal language of hypothesis testing.

```         
Our p-value:
Our α:

Decision (circle one):   REJECT H₀   /   FAIL TO REJECT H₀

In one sentence, what does this mean biologically?
```

> 💡 **Key idea:** We never say "H₀ is true" or "H₀ is false." We say "we reject H₀" (evidence was strong enough) or "we fail to reject H₀" (evidence was not strong enough). Statistics gives us a decision rule, not certainty.

------------------------------------------------------------------------

# Part 12 · Visualize the result

### Boxplot with test statistics in the subtitle

**▶ Run this:**

``` r
# Boxplot with t and p embedded in subtitle ----------
leaf_box_04_plot <- tree_df %>%
  ggplot(aes(x = side, y = weight_g, fill = side)) +
  geom_boxplot(alpha = 0.5, outlier.shape = NA) +
  geom_point(
    position = position_jitter(width = 0.15, seed = 42),
    alpha = 0.6, size = 2.5
  ) +
  labs(
    title    = "Leaf Weight by Tree Side",
    subtitle = paste0("Welch's t-test: t = ",
                      round(leaf_ttest_model$statistic, 2),
                      ", p = ",
                      signif(leaf_ttest_model$p.value, 2)),
    x = "Side of Tree",
    y = "Leaf Weight (g)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

leaf_box_04_plot
```

✏️ **Your turn:** The `subtitle` line uses `paste0()` to build the label from the model object. What happens to the subtitle if you re-run this with different data? Why is this better than typing the numbers yourself?

```         
Your answer:
```

### Save the plot

**▶ Run this:**

``` r
ggsave("figures/leaf_weight_boxplot_ttest.png",
       plot   = leaf_box_04_plot,
       width  = 5,
       height = 5,
       units  = "in",
       dpi    = 300)
```

------------------------------------------------------------------------

# Part 13 · Write a scientific results sentence

✏️ **Your turn:** Write a complete results sentence as you would in a lab report or paper. Include:

- Which group was larger
- The word "significantly" (if appropriate)
- Test name, t-statistic, df, and *p*-value in parentheses
- Mean ± SE for both groups with units

Use this template:

```         
"[Group] leaves were significantly [heavier / lighter] than [group] leaves
(Welch's two-sample t-test: t(___) = ___, p = ___).
Mean ± SE: [side 1] = ___ ± ___ g, [side 2] = ___ ± ___ g."
```

Write your sentence here:

```         
Your results sentence:
```

> 💡 **Key idea:** Never write `p = 0.000`. Write `p < 0.001` instead. A *p*-value is never exactly zero — it is just too small to display at three decimal places.

------------------------------------------------------------------------

# Part 14 · Review and checkpoint

At this point you should be able to:

- [ ] State null and alternate hypotheses formally using μ notation
- [ ] Explain the difference between one-tailed and two-tailed tests
- [ ] Use histograms and QQ plots to visually assess normality
- [ ] Run `shapiro.test()` per group using `filter()` and `pull()`
- [ ] Run `leveneTest()` and explain why we use Welch's regardless
- [ ] Run `t.test(y ~ group, data, var.equal = FALSE, alternative = "two.sided")`
- [ ] Extract t, df, p-value, CI, and group means from the model object
- [ ] Compute the t-statistic by hand from the Welch's formula
- [ ] Make a formal reject / fail-to-reject decision at α = 0.05
- [ ] Write a complete results sentence in scientific format

✏️ **Your turn:** Run your entire script from top to bottom with **Ctrl/Cmd + Shift + Enter**. Does it run without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 15 · Going further

> This section is optional — work through it if you finish early or want to push deeper.

### Test a second variable: `height_cm`

**▶ Try this:**

``` r
# Run the same t-test pipeline for height_cm ---------

# 1. Stats recap
tree_df %>%
  group_by(side) %>%
  summarize(
    n        = sum(!is.na(height_cm)),
    mean_ht  = round(mean(height_cm, na.rm = TRUE), 2),
    sd_ht    = round(sd(height_cm,   na.rm = TRUE), 2),
    se_ht    = round(sd_ht / sqrt(n), 2)
  )
```

``` r
# 2. Shapiro-Wilk for height_cm
tree_df %>% filter(side == "sunny") %>% pull(height_cm) %>% shapiro.test()
tree_df %>% filter(side == "shady") %>% pull(height_cm) %>% shapiro.test()
```

``` r
# 3. Levene's test for height_cm
leveneTest(height_cm ~ side, data = tree_df)
```

``` r
# 4. Welch's t-test for height_cm
height_ttest_model <- t.test(
  height_cm ~ side,
  data        = tree_df,
  var.equal   = FALSE,
  alternative = "two.sided"
)
height_ttest_model
```

✏️ **Your turn:** Is leaf height also significantly different between sides? Fill in the results:

```         
t = _____   df = _____   p = _____
Decision:
One-sentence conclusion:
```

### Change the confidence level

By default `t.test()` reports a 95% CI (`conf.level = 0.95`). Try 99%:

**▶ Try this:**

``` r
# Run the weight t-test with 99% confidence interval --
t.test(
  weight_g ~ side,
  data       = tree_df,
  var.equal  = FALSE,
  alternative = "two.sided",
  conf.level  = 0.99        # 99% CI instead of 95%
)
```

✏️ **Your turn:** How did the 99% CI compare to the 95% CI? Why is the 99% CI wider?

```         
95% CI was: _____ to _____
99% CI was: _____ to _____
Why wider:
```

### What if the groups were not significantly different?

✏️ **Your turn:** Think about what would happen if both sides had leaves with weight_g around 5.5 ± 2.0 g. Would the t-test be significant? What would change in the output?

```         
Your prediction:
```

------------------------------------------------------------------------

# What your finished `figures/` folder should contain

```         
project/
├── data/
│   └── 2026_06_25_tree_experiment_raw_data.xlsx
├── figures/
│   ├── leaf_weight_boxplot.png            <- from Worksheet 03
│   ├── leaf_weight_mean_se.png            <- from Worksheet 03
│   └── leaf_weight_boxplot_ttest.png      <- from this worksheet
└── scripts/
    └── 04_leaf_ttest.R                    <- your script
```

------------------------------------------------------------------------

# Getting unstuck

1.  **Read the error message out loud.** R usually names the line and the problem.
2.  **Check the usual suspects:**
    - Loaded `library(car)`, `library(readxl)`, `library(tidyverse)`?
    - Spelling of column names? Check with `names(tree_df)`
    - Missing `)` or `%>%`?
3.  **`leveneTest` not found?** You need `library(car)` — not just `car::leveneTest`.
4.  **Shapiro-Wilk needs \> 3 values.** If you filtered to a tiny subset, you may get an error.
5.  **`t.test()` formula:** the grouping variable goes on the *right* of `~` and must have exactly **two levels**. Check with `unique(tree_df$side)`.
6.  **Cheat sheets** — <https://posit.co/resources/cheatsheets/>
7.  **Bring the exact error** (copy-paste it) to class, Canvas, or office hours.

> 💡 **Key idea:** The five-step framework (hypotheses → normality → variance → test → report) is the same for nearly every parametric test you will ever run. Master it here and it transfers directly to ANOVA and regression.

------------------------------------------------------------------------

*End of Worksheet 04. Next: Worksheet 05 — one-way ANOVA for comparing more than two groups.*