# ==============================================================================
# SUMMARY STATS HELPER FOR DATASCIENCE CLASS
# Source this file to load summary_stats()
#
# summary_stats(data, variable) returns one row (or one row per group, if
# data is already grouped with group_by()) with n, mean, variance, sd, se,
# and a 95% confidence interval for the mean.
#
# It is exactly the summarize() you write by hand, packaged up once.
# Needs dplyr (tidyverse) already loaded.
# ==============================================================================

summary_stats <- function(data, variable) {
  data %>%
    summarize(
      n        = sum(!is.na({{ variable }})),
      mean     = mean({{ variable }}, na.rm = TRUE),
      variance = var({{ variable }}, na.rm = TRUE),
      sd       = sd({{ variable }}, na.rm = TRUE),
      se       = sd / sqrt(n),
      ci_lower = mean - qt(0.975, df = n - 1) * se,
      ci_upper = mean + qt(0.975, df = n - 1) * se,
      .groups  = "drop"
    )
}
