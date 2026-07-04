# =====================================================================
#  regression_analysis_script.R
#  THE "SCRIPT WAY" of doing our regression analysis.
#
#  A plain .R script is a list of commands. It is excellent for RUNNING
#  an analysis: put your cursor on a line and press Ctrl/Cmd + Enter, or
#  run the whole file with Ctrl/Cmd + Shift + Enter (source).
#
#  What a script does NOT do: it will not turn itself into a report. The
#  numbers print to the Console and the plots pop up in the Plots pane —
#  to hand this in you would COPY each number into Word and EXPORT each
#  figure by hand. Compare this file with its twin, which produces a
#  finished Word document automatically:
#      regression_analysis_report.qmd
# =====================================================================

# ---- HOW TO USE THIS SCRIPT ACTIVELY --------------------------------
# Before you run each section, PREDICT what it will print, then run it and
# compare. Type sections yourself rather than pasting. The PREDICT notes
# below mark good places to pause.

# ---- 1. Load libraries (always at the top) --------------------------
library(readxl) # read Excel files
library(tidyverse) # wrangling + ggplot2
library(skimr) # fast dataset overview


# ---- 2. Load the paper calibration data -----------------------------
paper_df <- read_excel("data/paper_area_weights.xlsx")


# ---- 3. Inspect the data --------------------------------------------
dim(paper_df) # rows, columns
glimpse(paper_df) # column names, types, first values
skim(paper_df) # full summary


# ---- 4. Scatter plot: check the relationship visually ---------------
scatter_reg_plot <- paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point(alpha = 0.5, size = 2) +
  labs(
    title = "Paper Mass vs. Known Area",
    x = "Mass (g)",
    y = "Area (cm²)"
  ) +
  theme_minimal()

scatter_reg_plot # prints to the Plots pane


# ---- 5. Fit the least-squares regression line -----------------------
# lm(response ~ predictor, data = data_frame)
paper_lm_model <- lm(area_cm2 ~ mass_g, data = paper_df)

# 🔮 PREDICT: will the slope be positive? Roughly how many cm² per gram?
summary(paper_lm_model) # prints the full model summary to the Console


# ---- 6. Extract the calibration equation and R2 ---------------------
# 🔮 PREDICT: for uniform paper, what R² do you expect — near 0, 0.5, or 1?
a_intercept <- coef(paper_lm_model)[1] # intercept (a)
b_slope <- coef(paper_lm_model)[2] # slope (b)
r2_val <- summary(paper_lm_model)$r.squared # R-squared

cat("Intercept (a) =", round(a_intercept, 4), "cm²\n")
cat("Slope (b)     =", round(b_slope, 2), "cm²/g\n")
cat("R²            =", round(r2_val, 6), "\n")


# ---- 7. Plot the calibration curve with 95% CI band -----------------
calibration_plot <- paper_df %>%
  ggplot(aes(x = mass_g, y = area_cm2)) +
  geom_point(alpha = 0.5, size = 1.8) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    color = "steelblue",
    fill = "lightblue"
  ) +
  labs(
    title = "Paper Calibration Curve",
    subtitle = paste0(
      "area = ",
      round(b_slope, 2),
      " × mass + ",
      round(a_intercept, 3),
      "  |  R² = ",
      round(r2_val, 4)
    ),
    x = "Paper Mass (g)",
    y = "Area (cm²)"
  ) +
  theme_minimal()

calibration_plot

# Save the figure by hand (the script cannot embed it in a report)
ggsave(
  "figures/paper_calibration_curve.png",
  plot = calibration_plot,
  width = 5,
  height = 5,
  units = "in",
  dpi = 300
)


# ---- 8. Check assumptions -------------------------------------------
# Add fitted values and residuals to the data frame
paper_resid_df <- paper_df %>%
  mutate(
    fitted = fitted(paper_lm_model),
    residuals = residuals(paper_lm_model)
  )

# Residuals vs Fitted — linearity + equal variance
resid_reg_plot <- paper_resid_df %>%
  ggplot(aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Fitted Values (cm²)", y = "Residuals (cm²)") +
  theme_minimal()

resid_reg_plot

# Normality of residuals — QQ plot + Shapiro-Wilk
qq_reg_plot <- paper_resid_df %>%
  ggplot(aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line(color = "red", linewidth = 0.8) +
  labs(
    title = "Normal QQ Plot of Residuals",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal()

qq_reg_plot

shapiro.test(residuals(paper_lm_model)) # H0: residuals are normal


# ---- 9. Predict leaf area from a tracing mass -----------------------
# 🔮 PREDICT: which tracing (sunny 0.092 g or shady 0.138 g) gives the larger area?
mass_sunny <- 0.092 # g — example sunny leaf tracing
mass_shady <- 0.138 # g — example shady leaf tracing

area_sunny <- b_slope * mass_sunny + a_intercept
area_shady <- b_slope * mass_shady + a_intercept

cat("Sunny tracing:", mass_sunny, "g →", round(area_sunny, 2), "cm²\n")
cat("Shady tracing:", mass_shady, "g →", round(area_shady, 2), "cm²\n")

# predict() with a prediction interval (uncertainty for a single leaf)
new_masses <- tibble(mass_g = c(mass_sunny, mass_shady))
predict(paper_lm_model, newdata = new_masses, interval = "prediction")


# ---- 10. Reporting values -------------------------------------------
# In a script these just print. You would retype them into your report.
confint(paper_lm_model) # 95% CI for slope + intercept
f_stat <- summary(paper_lm_model)$fstatistic # F, df1, df2
f_stat

# =====================================================================
#  Done. Everything printed to the Console / Plots pane.
#  To SHARE these results you would now copy numbers into a document and
#  drag in the saved PNG. The .qmd version does all of that for you.
# =====================================================================
