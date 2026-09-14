# =============================================================================
# 09_ttest.R
# UMD Biostatistics — Bill Perry
# Reference script: two-sample t-test workflow with slimy sculpin data.
# Covers descriptive stats, assumption checks, t-test, Welch's t-test,
# and how to report and plot results.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(skimr)
library(car)       # leveneTest()
library(broom)     # tidy() — clean model output

source("themes/r_themes_for_3_sizes.R")


# ── Load data ─────────────────────────────────────────────────────────────────
sculpin_df <- read_csv("data/t_test_sculpin_s07_ne14.csv")

glimpse(sculpin_df)
sculpin_df |> count(lake)


# ── 1. DESCRIPTIVE STATISTICS ─────────────────────────────────────────────────

# Quick skim grouped by lake
sculpin_df |> group_by(lake) |> skim()

# Manual summary — use sum(!is.na()) for correct n
stats_df <- sculpin_df |>
  group_by(lake) |>
  summarise(
    n      = sum(!is.na(length_mm)),
    mean   = round(mean(length_mm,   na.rm = TRUE), 2),
    median = round(median(length_mm, na.rm = TRUE), 2),
    sd     = round(sd(length_mm,     na.rm = TRUE), 2),
    se     = round(sd(length_mm,     na.rm = TRUE) /
                     sqrt(sum(!is.na(length_mm))),   2),
    .groups = "drop"
  )
stats_df


# ── 2. VISUALISE BEFORE TESTING ───────────────────────────────────────────────

# Boxplot + raw points
sculpin_df |>
  ggplot(aes(x = lake, y = length_mm, fill = lake)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.4, size = 1.5) +
  labs(x = "Lake", y = "Total length (mm)",
       title = "Slimy sculpin total length by lake") +
  theme_regular() +
  theme(legend.position = "none")

# Mean ± SE
sculpin_df |>
  ggplot(aes(x = lake, y = length_mm, color = lake)) +
  geom_jitter(width = 0.15, alpha = 0.3, size = 1.5) +
  stat_summary(fun.data = mean_se, geom = "pointrange",
               size = 0.9, linewidth = 1) +
  labs(x = "Lake", y = "Total length (mm)",
       title = "Mean ± 1 SE total length by lake") +
  theme_regular() +
  theme(legend.position = "none")


# ── 3. CHECK ASSUMPTIONS ──────────────────────────────────────────────────────

# --- Normality: Q-Q plots ---
sculpin_df |>
  ggplot(aes(sample = length_mm, color = lake)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~ lake) +
  labs(title = "Q-Q plots by lake",
       x = "Theoretical quantiles", y = "Sample quantiles") +
  theme_regular() +
  theme(legend.position = "none")

# --- Normality: Shapiro-Wilk test, one line per group ---
sculpin_df |>
  group_by(lake) |>
  group_modify(~ broom::tidy(shapiro.test(.x$length_mm)))

# --- Equal variances: Levene's test ---
leveneTest(length_mm ~ lake, data = sculpin_df)


# ── 4. RUN THE T-TEST ─────────────────────────────────────────────────────────

# Standard two-sample t-test (assumes equal variances)
t_equal <- t.test(length_mm ~ lake, data = sculpin_df, var.equal = TRUE)
t_equal

# Welch's t-test (does NOT assume equal variances — the safer default)
t_welch <- t.test(length_mm ~ lake, data = sculpin_df, var.equal = FALSE)
t_welch

# Tidy output with broom — one row, easy to work with
tidy(t_welch)


# ── 5. EXTRACT VALUES FOR REPORTING ──────────────────────────────────────────

# Pull t, df, and p-value out of the test object
t_val  <- round(t_welch$statistic, 2)
df_val <- round(t_welch$parameter, 1)
p_val  <- round(t_welch$p.value,   4)

t_val; df_val; p_val

# Or use broom for a clean tibble
result <- tidy(t_welch)
result$statistic   # t
result$parameter   # df
result$p.value     # p


# ── 6. FINAL PUBLICATION PLOT ─────────────────────────────────────────────────

# Compute summary for annotation
final_stats <- sculpin_df |>
  group_by(lake) |>
  summarise(
    n    = sum(!is.na(length_mm)),
    mean = mean(length_mm, na.rm = TRUE),
    se   = sd(length_mm,   na.rm = TRUE) / sqrt(sum(!is.na(length_mm))),
    .groups = "drop"
  )

# Plot with n labels
final_plot <- sculpin_df |>
  ggplot(aes(x = lake, y = length_mm, fill = lake)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.12, alpha = 0.35, size = 1.5) +
  geom_text(data = final_stats,
            aes(label = paste0("n = ", n), y = 20),
            size = 3.5, color = "grey30") +
  labs(x    = "Lake",
       y    = "Total length (mm)",
       title = "Slimy sculpin total length by lake",
       caption = paste0("Welch's t-test: t(", df_val, ") = ", t_val,
                        ", p = ", p_val)) +
  theme_regular() +
  theme(legend.position = "none")

final_plot

ggsave("figures/sculpin_ttest.pdf",
       plot   = final_plot,
       width  = 5, height = 5, units = "in")

# =============================================================================
# END OF FILE
# =============================================================================
