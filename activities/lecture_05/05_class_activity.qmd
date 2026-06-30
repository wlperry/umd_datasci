---
title: "Worksheet 05 — Linear Regression"
subtitle: "Building a calibration curve to predict leaf area from paper tracing mass"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 5: Regression — Predicting Leaf Area

### Recap from Worksheet 04

- **Stated hypotheses** — H₀: μ_shady = μ_sunny (no difference in mean leaf weight); Hₐ: μ_shady ≠ μ_sunny
- **Checked normality** — histogram, QQ plot, Shapiro-Wilk on each group's `weight_g`
- **Checked variance** — Levene's test; used Welch's (`var.equal = FALSE`) regardless of result
- **Ran the t-test** — `t.test(weight_g ~ side, data = tree_df, var.equal = FALSE, alternative = "two.sided")`
- **Read output** — t-statistic, Welch-Satterthwaite df, *p*-value, 95% CI, group means
- **Result** — shady leaves were significantly **heavier** than sunny leaves (*p* \< 0.001)
- **But:** weight in grams tells us about *mass* — not directly about *leaf surface area*

### Today's Objectives

1.  Load and inspect the paper calibration data
2.  Make a scatter plot and visually assess linearity
3.  Fit a linear regression with `lm()` and read every line of `summary()`
4.  Extract slope, intercept, and R² from the model
5.  Check all four regression assumptions (linearity, equal variance, normality of residuals)
6.  Use the calibration equation to **predict leaf area** from a tracing mass
7.  Use `predict()` with confidence and prediction intervals
8.  Write a complete results paragraph following W&S Chapter 17 conventions

> # **How to use this worksheet**
>
> - Work through each part in order. Type the code into a new R script in Positron and run it line by line.
>   - Code blocks marked **▶ Run this** should be executed as written.
>
>   - Blocks marked **✏️ Your turn** ask you to write, modify, or interpret.
>
>   - The **Going further** section is optional.

------------------------------------------------------------------------

# Part 1 · Load libraries and data

### Libraries

**▶ Run this at the top of your script:**

``` r
# Load packages at the top — always ----------------------
library(readxl)      # reading Excel files
library(tidyverse)   # data manipulation + ggplot2
library(skimr)       # fast dataset overview
```

### The calibration dataset

The file `paper_area_weights.xlsx` contains 118 paper squares of **known area** (1–567 cm²) with their measured masses in grams. We will fit a regression to convert mass → area, then apply it to leaf tracings.

**▶ Run this:**

``` r
# Load the paper calibration data -----------------------
paper_df <- read_excel("data/paper_area_weights.xlsx")
```

✏️ **Your turn:** Run `dim(paper_df)`. How many rows and columns does the dataset have?

``` r
# Write your code here:
```

```         
Rows:
Columns:
Column names and their roles:
  area_cm2 →  (response / explanatory / circle one)
  mass_g   →  (response / explanatory / circle one)
```

------------------------------------------------------------------------

# Part 2 · Inspect the data

**▶ Run this:**

``` r
# Quick overview with skim --------------------------------
skim(paper_df)
```

``` r
# How many squares were measured at each area level? -----
paper_df %>%
  group_by(area_cm2) %>%
  summarize(
    n          = n(),
    mean_mass  = round(mean(mass_g), 5),
    min_mass   = round(min(mass_g),  5),
    max_mass   = round(max(mass_g),  5)
  )
```

✏️ **Your turn:** Fill in the table from the output above:

```         
area_cm2   mean mass (g)
--------   -------------
1          
4          
16         
64         
100        
400        
```

✏️ **Your turn:** Is there a clear pattern — as area increases, what happens to mass? Is this what you expected from your knowledge of paper?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 3 · First scatter plot

**▶ Run this:**

``` r
# Scatter plot — check the relationship visually ---------
scatter_09_plot <- paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point(alpha = 0.5, size = 2) +
  labs(
    title = "Paper Mass vs. Known Area",
    x     = "Mass (g)",
    y     = "Area (cm²)"
  ) +
  theme_minimal()

scatter_09_plot
```

✏️ **Your turn:** Describe the relationship. Is it linear? Is the variance (spread of points) roughly constant across the range of mass values?

```         
Shape of relationship (linear / curved):
Variance (constant / increases / decreases with X):
Any obvious outliers?  Y / N
```

✏️ **Your turn:** In this study, which variable is the explanatory (X) and which is the response (Y)? Why does that direction make sense for our goal of predicting leaf area?

```         
Explanatory (X):
Response (Y):
Reason for this direction:
```

> 💡 **Key idea:** In regression, *X* is what you measure (mass — easy with a balance), and *Y* is what you want to know (area — harder to measure on a complex leaf shape). We measure X to predict Y.

------------------------------------------------------------------------

# Part 4 · Fit the regression with `lm()`

**▶ Run this:**

``` r
# Fit the least-squares linear model --------------------
# lm(response ~ predictor, data = data_frame)
paper_lm_model <- lm(area_cm2 ~ mass_g, data = paper_df)
```

``` r
# Full summary — every number matters -------------------
summary(paper_lm_model)
```

✏️ **Your turn:** Copy the Coefficients table output here:

```         
Paste the Coefficients section of the summary() output:
```

------------------------------------------------------------------------

# Part 5 · Decode the `summary()` output line by line

✏️ **Your turn:** Match each piece of output to its meaning. Fill in the blanks:

```         
(Intercept) estimate = _____
  → This is "a" in Ŷ = a + bX. 
    It is the predicted area when mass = _____.
    Does this make physical sense? (a piece of paper with zero mass has zero area)  Y / N

mass_g estimate = _____
  → This is "b" (the slope).
    It means: for every additional 1 gram of paper, area increases by _____ cm².
    Biologically, 1 gram of this paper stock has _____ cm² of surface area.

Std. Error for mass_g = _____
  → The uncertainty in the slope estimate.

t value for mass_g = _____
  → slope / SE.  This tests H₀: β = _____.

Pr(>|t|) for mass_g = _____
  → The p-value for the slope test. Is it significant at α = 0.05?  Y / N

Multiple R-squared = _____
  → _____ % of the variation in area is explained by mass.

F-statistic = _____  on _____ and _____ df
  → Overall test of the model.  p = _____
```

> 📖 **Whitlock & Schluter §17.3 p. 551–553:** The slope is tested with a t-statistic: t = b / SE_b, with df = n − 2. If H₀: β = 0 is rejected, mass significantly predicts area.

------------------------------------------------------------------------

# Part 6 · Extract the calibration equation

**▶ Run this:**

``` r
# Pull intercept and slope from the model ---------------
a_intercept <- coef(paper_lm_model)[1]
b_slope     <- coef(paper_lm_model)[2]

cat("Intercept (a) =", round(a_intercept, 4), "cm²\n")
cat("Slope (b)     =", round(b_slope, 2), "cm²/g\n")
```

✏️ **Your turn:** Write the calibration equation for predicting area from mass:

```         
area_cm2 = _____ × mass_g + _____
```

✏️ **Your turn:** Use the equation by hand to predict the area of a paper tracing that weighs 0.120 g. Show your work:

```         
area = _____ × 0.120 + _____
     = _____  cm²
```

------------------------------------------------------------------------

# Part 7 · Extract and interpret R²

**▶ Run this:**

``` r
# Pull R-squared from the model summary -----------------
r2_val <- summary(paper_lm_model)$r.squared
cat("R² =", round(r2_val, 6), "\n")
```

✏️ **Your turn:** What does R² = 0.9999 mean in plain language for our calibration?

```         
Your answer:
```

✏️ **Your turn:** In ecology, you might see regression results with R² = 0.45. Is that a useful result? What does it mean?

```         
Your answer:
```

> 📖 **Whitlock & Schluter §17.4 p. 555:** *"R² measures the fraction of variation in Y that is explained by X."* A high R² indicates a tight fit; a low R² indicates high scatter around the line — but a low R² does not mean the relationship is not real or useful.

------------------------------------------------------------------------

# Part 8 · Plot the calibration curve

**▶ Run this:**

``` r
# Regression line with 95% confidence band --------------
calibration_plot <- paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point(alpha = 0.5, size = 1.8) +
  geom_smooth(method = "lm", se = TRUE,
              color = "steelblue", fill = "lightblue") +
  labs(
    title    = "Paper Calibration Curve",
    subtitle = paste0("area = ", round(b_slope, 2),
                      " × mass + ", round(a_intercept, 3),
                      "  |  R² = ", round(r2_val, 4)),
    x        = "Paper Mass (g)",
    y        = "Area (cm²)"
  ) +
  theme_minimal()

calibration_plot
```

✏️ **Your turn:** Where is the shaded confidence band *narrowest*? Where is it *widest*? Why does the width vary?

```         
Narrowest at:
Widest at:
Why it varies:
```

### Save the plot

**▶ Run this:**

``` r
ggsave("figures/paper_calibration_curve.png",
       plot   = calibration_plot,
       width  = 5, height = 5, units = "in", dpi = 300)
```

------------------------------------------------------------------------

# Part 9 · Check assumptions — residual plot

**▶ Run this:**

``` r
# Add fitted values and residuals to the data ----------
paper_resid_df <- paper_df %>%
  mutate(
    fitted    = fitted(paper_lm_model),
    residuals = residuals(paper_lm_model)
  )
```

``` r
# Residuals vs Fitted — checks linearity and equal variance
resid_09_plot <- paper_resid_df %>%
  ggplot(aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Residuals vs Fitted Values",
    x     = "Fitted Values (cm²)",
    y     = "Residuals (cm²)"
  ) +
  theme_minimal()

resid_09_plot
```

✏️ **Your turn:** Describe the residual plot. Do the points form a random cloud around zero, or is there a pattern?

```         
Pattern or random cloud?:
Any evidence of non-linearity (curved pattern)?  Y / N
Any evidence of unequal variance (funnel shape)?  Y / N
```

> ⚠️ **Watch out!** A funnel shape (residuals getting larger at higher fitted values) means variance is *not* constant — a violation of the equal variance assumption. A curved pattern means the relationship is not linear.
>
> 📖 **Whitlock & Schluter §17.5 p. 559 (Figure 17.5-4):** *"A residual plot should show a roughly symmetric cloud of points with no pattern."*

------------------------------------------------------------------------

# Part 10 · Check assumptions — QQ plot and Shapiro-Wilk

**▶ Run this:**

``` r
# QQ plot of residuals — checks normality assumption ---
qq_resid_09_plot <- paper_resid_df %>%
  ggplot(aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line(color = "red", linewidth = 0.8) +
  labs(
    title = "Normal QQ Plot of Residuals",
    x     = "Theoretical Quantiles",
    y     = "Sample Quantiles"
  ) +
  theme_minimal()

qq_resid_09_plot
```

``` r
# Shapiro-Wilk test on residuals — NOT on raw data -----
shapiro.test(residuals(paper_lm_model))
```

✏️ **Your turn:** Record the Shapiro-Wilk result:

```         
W = _____   p = _____
Decision (normal / not normal):
```

✏️ **Your turn:** An important distinction — in regression, normality is checked on the **residuals**, not on Y or X directly. Why does that matter?

```         
Your answer:
```

------------------------------------------------------------------------

# Part 11 · Predict leaf area from tracing mass

### Method 1 — Direct calculation

**▶ Run this:**

``` r
# Direct calculation using the calibration equation ----
mass_sunny <- 0.092   # g — example sunny leaf tracing
mass_shady <- 0.138   # g — example shady leaf tracing

area_sunny <- b_slope * mass_sunny + a_intercept
area_shady <- b_slope * mass_shady + a_intercept

cat("Sunny tracing:", mass_sunny, "g →",
    round(area_sunny, 2), "cm²\n")
cat("Shady tracing:", mass_shady, "g →",
    round(area_shady, 2), "cm²\n")
```

✏️ **Your turn:** Does the shady leaf have a larger predicted area? In Worksheet 04 we found shady leaves were significantly *heavier*. Does a larger predicted area match that finding? What does this tell you about the relationship between leaf weight and leaf area?

```         
Sunny predicted area:
Shady predicted area:
Larger side:
Does larger area match the heavier weight from Worksheet 04?  Y / N
What does this tell you about the relationship between weight and area in leaves?
```

### Method 2 — Using `predict()` with intervals

**▶ Run this:**

``` r
# predict() gives uncertainty around predictions ------
new_masses <- tibble(mass_g = c(0.092, 0.138))

# 95% confidence interval for the MEAN area
predict(paper_lm_model,
        newdata  = new_masses,
        interval = "confidence") %>%
  as_tibble() %>%
  mutate(mass_g = c(0.092, 0.138), .before = 1) %>%
  round(3)
```

``` r
# 95% prediction interval for a SINGLE observation
predict(paper_lm_model,
        newdata  = new_masses,
        interval = "prediction") %>%
  as_tibble() %>%
  mutate(mass_g = c(0.092, 0.138), .before = 1) %>%
  round(3)
```

✏️ **Your turn:** The prediction interval is wider than the confidence interval. In your own words, explain why — what additional source of uncertainty does a prediction interval capture?

```         
Your answer:
```

> 📖 **Whitlock & Schluter §17.2 p. 549:** *"Confidence bands measure the precision of the predicted mean Y for each value of X. Prediction intervals measure the precision of the predicted single Y-values for each X."*

------------------------------------------------------------------------

# Part 12 · Write a scientific results paragraph

✏️ **Your turn:** Write a complete results paragraph using the information below. Follow the format from Lecture 05.

**Information to include:** - What the regression tested - F-statistic, df₁, df₂, and p-value (from the F-statistic line in `summary()`) - R² - The calibration equation (slope and intercept) - 95% confidence interval for the slope (use `confint(paper_lm_model)`) - Brief mention of assumption checks

``` r
# Get the 95% CI for the slope -------------------------
confint(paper_lm_model)
```

```         
Write your results paragraph here:
```

------------------------------------------------------------------------

# Part 13 · Review and checkpoint

At this point you should be able to:

- [ ] Identify the response (Y) and explanatory (X) variables for a regression problem
- [ ] Make a scatter plot and assess linearity visually
- [ ] Fit a linear regression with `lm(Y ~ X, data)` and call `summary()`
- [ ] Extract slope, intercept, and R² from the model
- [ ] Interpret slope, intercept, t-value, p-value, and R² in biological terms
- [ ] Add fitted values and residuals to a data frame with `fitted()` and `residuals()`
- [ ] Check the residual vs fitted plot for linearity and equal variance
- [ ] Check the QQ plot and Shapiro-Wilk on **residuals** for normality
- [ ] Use `coef(model)` to write the prediction equation
- [ ] Use `predict(model, newdata, interval = "prediction")` for predictions with uncertainty
- [ ] Write a complete scientific results paragraph with F, df, p, R², and equation

✏️ **Your turn — before you move on:** Run your entire script with **Ctrl/Cmd + Shift + Enter**. Does it run from top to bottom without errors?

```         
Ran cleanly?  Y / N
If not, what error appeared:
```

------------------------------------------------------------------------

# Part 14 · Going further

> This section is optional — work through it if you finish early or want to push deeper.

### Explore the fit at each area group

**▶ Try this:**

``` r
# How well does the model fit within each area group? --
paper_df %>%
  mutate(
    predicted = fitted(paper_lm_model),
    residual  = residuals(paper_lm_model)
  ) %>%
  group_by(area_cm2) %>%
  summarize(
    n             = n(),
    mean_resid    = round(mean(residual), 4),
    max_abs_resid = round(max(abs(residual)), 4)
  )
```

✏️ **Your turn:** Are the residuals larger at bigger area values? What does that pattern (or lack of it) tell you about the equal-variance assumption?

```         
Your observation:
```

### Prediction for a real leaf tracing

Suppose you traced a leaf onto the same type of paper used in the calibration, cut it out, and weighed it. The tracing weighs **0.175 g**.

**▶ Try this:**

``` r
# Predict area for your leaf tracing -------------------
my_tracing <- tibble(mass_g = 0.175)

predict(paper_lm_model,
        newdata  = my_tracing,
        interval = "prediction") %>%
  round(2)
```

✏️ **Your turn:** What is the predicted leaf area? What is the 95% prediction interval? How confident are you in this prediction?

```         
Predicted area:
95% prediction interval:  _____ to _____ cm²
Confidence in prediction:
```

### Extrapolation warning

The calibration data ranges from 1 to 567 cm². Suppose a very large leaf tracing weighs 5.2 g.

✏️ **Your turn:** Would you trust a prediction for a tracing mass of 5.2 g? Why or why not? (Hint: what is the largest mass in the calibration data?)

```         
Max mass in calibration data:
Is 5.2 g within the calibration range?  Y / N
Should you predict at 5.2 g?  Y / N
Why:
```

> 📖 **Whitlock & Schluter §17.2 p. 550:** *"Extrapolation is the prediction of Y at values of X beyond the range of X-values in the data. Extrapolation is problematic because there is no way to ensure the relationship between X and Y continues to be linear."*

### Connect to Worksheet 04

In Worksheet 04 you ran a Welch's t-test comparing leaf **weight** (grams) between sunny and shady sides and found a significant difference (*p* \< 0.001). Now you have a calibration curve that converts tracing weight to **area** (cm²) — a more biologically meaningful measurement. You could use the regression equation as a `mutate()` step to add predicted area to a leaf data frame, then redo the t-test on *area* rather than weight.

**▶ Sketch the code (do not necessarily run it — you would need actual tracing masses):**

``` r
# How you WOULD apply the calibration to the leaf data
# (assuming trace_df has columns: side, tracing_mass_g)

# trace_df <- trace_df %>%
#   mutate(predicted_area_cm2 = b_slope * tracing_mass_g + a_intercept)
#
# t.test(predicted_area_cm2 ~ side, data = trace_df,
#        var.equal = FALSE, alternative = "two.sided")
```

✏️ **Your turn:** What is the advantage of working in units of **area** (cm²) rather than raw **weight** (g) when comparing sunny vs. shady leaves?

```         
Your answer:
```

------------------------------------------------------------------------

# What your `figures/` folder should contain after this worksheet

```         
figures/
├── paper_calibration_curve.png     ← from Part 8
```

------------------------------------------------------------------------

# Getting unstuck

1.  **`lm()` error:** the formula must be `lm(Y ~ X, data)` — response on the left, predictor on the right. Check column names with `names(paper_df)`.
2.  **`coef()` gives two values:** `coef(model)[1]` is the intercept, `coef(model)[2]` is the slope for the first predictor.
3.  **`residuals()` vs raw data:** always apply `shapiro.test()` and `ggplot(aes(sample = residuals))` to `residuals(model)`, not to the raw Y column.
4.  **`predict()` needs a tibble:** `newdata` must be a data frame or tibble with the exact same column name as the predictor (`mass_g`). A typo here is the most common error.
5.  **`geom_smooth(se = TRUE)` shows confidence band, not prediction interval.** For prediction intervals, use `predict()` manually.
6.  **Cheat sheets** — <https://posit.co/resources/cheatsheets/>

> 💡 **Key idea:** The five-step logic of regression (plot → fit → check assumptions → interpret → predict) is the same framework you'll use for multiple regression, ANOVA, and every other linear model in your career.

------------------------------------------------------------------------

*End of Worksheet 05. Next: Worksheet 06 — applying the calibration curve to measured leaf tracings and comparing sunny vs. shady leaf areas with a t-test.*