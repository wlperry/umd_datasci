# =============================================================================
# 10_correlation_regression.R
# UMD Biostatistics — Bill Perry
# Reference script: correlation and simple linear regression with penguins.
# Part 1: Pearson correlation — flipper length vs body mass
# Part 2: Simple linear regression — flipper length predicts body mass
# Includes: assumption checks, broom output, predictions, and reporting.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)
library(skimr)
library(broom)      # tidy() — clean model output

source("themes/r_themes_for_3_sizes.R")

# ── Data — complete cases only ────────────────────────────────────────────────
pg <- penguins |>
  drop_na(flipper_length_mm, body_mass_g, species)

glimpse(pg)


# ==============================================================================
# PART 1 · CORRELATION
# ==============================================================================

# ── 1. Explore the relationship ───────────────────────────────────────────────

ggplot(pg, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(alpha = 0.5, color = "steelblue", size = 2) +
  geom_smooth(method = "loess", se = FALSE,
              color = "tomato", linetype = "dashed", linewidth = 0.8) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)",
       title = "Does the relationship look linear?") +
  theme_regular()

# ── 2. Check normality of both variables ──────────────────────────────────────

# Q-Q plots for each variable
ggplot(pg, aes(sample = flipper_length_mm)) +
  stat_qq(color = "steelblue", alpha = 0.6) +
  stat_qq_line(color = "tomato") +
  labs(title = "Q-Q: Flipper length",
       x = "Theoretical quantiles", y = "Sample quantiles") +
  theme_regular()

ggplot(pg, aes(sample = body_mass_g)) +
  stat_qq(color = "steelblue", alpha = 0.6) +
  stat_qq_line(color = "tomato") +
  labs(title = "Q-Q: Body mass",
       x = "Theoretical quantiles", y = "Sample quantiles") +
  theme_regular()

# Shapiro-Wilk — only valid for n < 5000
shapiro.test(pg$flipper_length_mm)
shapiro.test(pg$body_mass_g)

# ── 3. Pearson correlation ────────────────────────────────────────────────────

cor_result <- cor.test(pg$flipper_length_mm, pg$body_mass_g,
                       method = "pearson")
cor_result

# Tidy output
tidy(cor_result)

# Extract key values
r_val  <- round(cor_result$estimate, 3)
r2_val <- round(cor_result$estimate^2, 3)
p_val  <- round(cor_result$p.value, 4)

r_val; r2_val; p_val

# ── 4. Spearman (non-parametric alternative) ──────────────────────────────────

cor.test(pg$flipper_length_mm, pg$body_mass_g, method = "spearman")

# ── 5. Correlation by species (grouped) ──────────────────────────────────────

pg |>
  group_by(species) |>
  summarise(
    n = sum(!is.na(flipper_length_mm) & !is.na(body_mass_g)),
    r = round(cor(flipper_length_mm, body_mass_g, use = "complete.obs"), 3),
    .groups = "drop"
  )

# ── 6. Publication correlation plot ──────────────────────────────────────────

cor_plot <- ggplot(pg, aes(x = flipper_length_mm, y = body_mass_g,
                            color = species)) +
  geom_point(alpha = 0.6, size = 2) +
  stat_ellipse(linewidth = 0.8, alpha = 0.7) +
  annotate("text", x = 175, y = 6000,
           label = paste0("r = ", r_val, "\np = ", p_val),
           hjust = 0, size = 3.5, color = "grey30") +
  labs(x = "Flipper length (mm)", y = "Body mass (g)",
       color = "Species",
       title = "Flipper length vs body mass — Palmer penguins") +
  theme_regular()

cor_plot

ggsave("figures/penguin_correlation.pdf",
       plot = cor_plot, width = 6, height = 5, units = "in")


# ==============================================================================
# PART 2 · SIMPLE LINEAR REGRESSION
# ==============================================================================

# ── 1. Fit the model ─────────────────────────────────────────────────────────

reg_model <- lm(body_mass_g ~ flipper_length_mm, data = pg)

# Full summary
summary(reg_model)

# Tidy coefficients table
tidy(reg_model, conf.int = TRUE)

# Model-level statistics (R², F, df, p)
glance(reg_model)

# ── 2. Extract key values ─────────────────────────────────────────────────────

intercept <- round(coef(reg_model)[1], 1)
slope     <- round(coef(reg_model)[2], 1)
r2        <- round(summary(reg_model)$r.squared, 3)
f_stat    <- round(summary(reg_model)$fstatistic[1], 1)
df1       <- summary(reg_model)$fstatistic[2]
df2       <- summary(reg_model)$fstatistic[3]
p_model   <- round(pf(f_stat, df1, df2, lower.tail = FALSE), 4)

cat("Equation: body_mass_g =", intercept, "+", slope, "× flipper_length_mm\n")
cat("R² =", r2, "  F =", f_stat, "  p =", p_model, "\n")

# ── 3. Assumption diagnostics in ggplot ──────────────────────────────────────

diag_df <- tibble(
  fitted    = fitted(reg_model),
  residuals = residuals(reg_model),
  std_resid = rstandard(reg_model),
  cooks_d   = cooks.distance(reg_model)
)

# Residuals vs Fitted — equal variance
ggplot(diag_df, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "tomato") +
  geom_smooth(method = "loess", se = FALSE, color = "grey40", linewidth = 0.8) +
  labs(title = "Residuals vs Fitted",
       x = "Fitted values (g)", y = "Residuals") +
  theme_regular()

# Q-Q of residuals — normality
ggplot(diag_df, aes(sample = std_resid)) +
  stat_qq(alpha = 0.5, color = "steelblue") +
  stat_qq_line(color = "tomato") +
  labs(title = "Normal Q-Q of residuals",
       x = "Theoretical quantiles", y = "Standardised residuals") +
  theme_regular()

# Cook's distance — influential points
ggplot(diag_df, aes(x = seq_along(cooks_d), y = cooks_d)) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  geom_hline(yintercept = 4 / nrow(pg), linetype = "dashed", color = "tomato") +
  labs(title = "Cook's distance",
       x = "Observation", y = "Cook's D",
       caption = "Dashed line = 4/n threshold") +
  theme_regular()

# Formal tests
shapiro.test(residuals(reg_model))   # normality of residuals

# ── 4. Predictions ────────────────────────────────────────────────────────────

# Predict body mass at specific flipper lengths
new_data <- tibble(flipper_length_mm = c(180, 200, 210, 220))

# Confidence interval — uncertainty in the MEAN response
predict(reg_model, new_data, interval = "confidence") |> round(1)

# Prediction interval — uncertainty for a SINGLE new observation
predict(reg_model, new_data, interval = "prediction") |> round(1)

# ── 5. Publication regression plot ───────────────────────────────────────────

eq_label <- paste0("y = ", intercept, " + ", slope, "x\n",
                   "R² = ", r2)

reg_plot <- ggplot(pg, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", color = "grey20",
              fill = "grey70", alpha = 0.2, linewidth = 1) +
  annotate("text", x = 172, y = 6000,
           label = eq_label, hjust = 0, size = 3.5, color = "grey20") +
  labs(x = "Flipper length (mm)", y = "Body mass (g)",
       color = "Species",
       title = "Body mass predicted by flipper length") +
  theme_regular()

reg_plot

ggsave("figures/penguin_regression.pdf",
       plot = reg_plot, width = 6, height = 5, units = "in")

# =============================================================================
# END OF FILE
# =============================================================================
