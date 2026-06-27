# =============================================================================
# 11_anova.R
# UMD Biostatistics — Bill Perry
# Reference script: one-way ANOVA with the penguins dataset.
# Covers: descriptive stats, visualisation, assumption checks,
# lm() + Anova() fit, emmeans pairwise contrasts, compact letter display,
# effect size (eta-squared), and how to report results.
# =============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
library(tidyverse)
library(palmerpenguins)
library(skimr)
library(car)          # Anova() Type III, leveneTest()
library(emmeans)      # estimated marginal means + pairwise contrasts
library(multcompView) # compact letter display (a, b, c)
library(broom)        # tidy() — clean model output

source("themes/r_themes_for_3_sizes.R")


# ── Data ──────────────────────────────────────────────────────────────────────
# Drop the two rows with missing body_mass_g
penguins_anova <- penguins |>
  drop_na(body_mass_g, species)

penguins_anova |> count(species)


# ── 1. DESCRIPTIVE STATISTICS ─────────────────────────────────────────────────

# Quick skim by species
penguins_anova |> group_by(species) |> skim()

# Manual summary — use sum(!is.na()) for n
stats_df <- penguins_anova |>
  group_by(species) |>
  summarise(
    n      = sum(!is.na(body_mass_g)),
    mean   = round(mean(body_mass_g,   na.rm = TRUE), 1),
    median = round(median(body_mass_g, na.rm = TRUE), 1),
    sd     = round(sd(body_mass_g,     na.rm = TRUE), 1),
    se     = round(sd(body_mass_g,     na.rm = TRUE) /
                     sqrt(sum(!is.na(body_mass_g))), 1),
    .groups = "drop"
  )
stats_df


# ── 2. VISUALISE ──────────────────────────────────────────────────────────────

# Boxplot + raw points
penguins_anova |>
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.15, alpha = 0.35, size = 1.5) +
  labs(x = "Species", y = "Body mass (g)",
       title = "Penguin body mass by species") +
  theme_regular() +
  theme(legend.position = "none")

# Mean ± SE
penguins_anova |>
  ggplot(aes(x = species, y = body_mass_g, color = species)) +
  geom_jitter(width = 0.15, alpha = 0.3, size = 1.5) +
  stat_summary(fun.data = mean_se, geom = "pointrange",
               size = 0.9, linewidth = 1) +
  labs(x = "Species", y = "Body mass (g)",
       title = "Mean ± 1 SE body mass by species") +
  theme_regular() +
  theme(legend.position = "none")


# ── 3. FIT THE MODEL ─────────────────────────────────────────────────────────

# Fit as a linear model — lm() is the foundation for ANOVA in R
penguin_model <- lm(body_mass_g ~ species, data = penguins_anova)

# Overall ANOVA table — Type III sums of squares (use car::Anova, not base anova)
Anova(penguin_model, type = "III")

# Tidy version with broom
tidy(Anova(penguin_model, type = "III"))


# ── 4. CHECK ASSUMPTIONS ──────────────────────────────────────────────────────

# --- Extract residuals and fitted values for ggplot-based diagnostics ---
diag_df <- tibble(
  fitted    = fitted(penguin_model),
  residuals = residuals(penguin_model),
  std_resid = rstandard(penguin_model)
)

# Residuals vs Fitted — check for equal variance across groups
ggplot(diag_df, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "tomato") +
  geom_smooth(method = "loess", se = FALSE, color = "grey40", linewidth = 0.8) +
  labs(title = "Residuals vs Fitted",
       x = "Fitted values", y = "Residuals") +
  theme_regular()

# Q-Q plot — check normality of residuals
ggplot(diag_df, aes(sample = std_resid)) +
  stat_qq(alpha = 0.5, color = "steelblue") +
  stat_qq_line(color = "tomato") +
  labs(title = "Normal Q-Q plot of residuals",
       x = "Theoretical quantiles", y = "Standardised residuals") +
  theme_regular()

# Levene's test — equal variance
leveneTest(body_mass_g ~ species, data = penguins_anova)

# Shapiro-Wilk on residuals — normality
shapiro.test(residuals(penguin_model))


# ── 5. POST-HOC TESTS WITH emmeans ────────────────────────────────────────────

# Estimated marginal means (= group means in a balanced one-way ANOVA)
penguin_emm <- emmeans(penguin_model, ~ species)
penguin_emm

# All pairwise contrasts with Tukey adjustment
pairs(penguin_emm, adjust = "tukey")

# Tidy output
tidy(pairs(penguin_emm, adjust = "tukey"))

# Compact letter display (a, b, c) — quick scan for which groups differ
penguin_cld <- cld(penguin_emm, adjust = "tukey", Letters = letters,
                   sort = FALSE)
penguin_cld


# ── 6. EFFECT SIZE — ETA-SQUARED ─────────────────────────────────────────────

# Eta-squared (η²) = SS_between / SS_total
# > 0.01 small, > 0.06 medium, > 0.14 large
ss_between <- sum((fitted(penguin_model) - mean(penguins_anova$body_mass_g))^2)
ss_total   <- sum((penguins_anova$body_mass_g - mean(penguins_anova$body_mass_g))^2)
eta_sq     <- round(ss_between / ss_total, 3)
eta_sq


# ── 7. PUBLICATION PLOT WITH LETTERS ─────────────────────────────────────────

# Join CLD letters to the summary stats for annotation
cld_df <- as_tibble(penguin_cld) |>
  mutate(.group = str_trim(.group))   # remove padding spaces from letters

pub_plot <- penguins_anova |>
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.12, alpha = 0.3, size = 1.5) +
  geom_text(data = cld_df,
            aes(x = species, y = 6400, label = .group),
            size = 5, fontface = "bold", inherit.aes = FALSE) +
  labs(x = "Species", y = "Body mass (g)",
       title = "Penguin body mass by species",
       caption = paste0("One-way ANOVA; letters indicate Tukey HSD groups (α = 0.05); η² = ", eta_sq)) +
  theme_regular() +
  theme(legend.position = "none")

pub_plot

ggsave("figures/penguin_anova.pdf",
       plot = pub_plot, width = 6, height = 5, units = "in")

# =============================================================================
# END OF FILE
# =============================================================================
