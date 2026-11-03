# t_test() -------------------------------------------------------------
# Run a two-group t-test and show everything we check:
#   1. the t-test output (Welch's test by default)
#   2. a ggplot boxplot of the two groups
#   3. a Shapiro-Wilk test for each group
#   4. Levene's test for equal variances
#
# Use it like t.test():  t_test(y ~ group, data = my_df)
# For the equal-variance version:  t_test(y ~ group, data = my_df, var.equal = TRUE)
# Needs library(tidyverse) (or library(ggplot2)) loaded first,
# and the car package installed (install.packages("car")).

t_test <- function(formula, data, var.equal = FALSE) {

  # 1. Run the t-test and print the output
  test_result <- t.test(formula, data = data, var.equal = var.equal)
  print(test_result)

  # 2. Plot the two groups
  #    model.frame() pulls out just the two columns in the formula:
  #    column 1 is y, column 2 is the group
  plot_data <- model.frame(formula, data = data)
  y_label <- names(plot_data)[1]
  x_label <- names(plot_data)[2]
  names(plot_data) <- c("y", "group")

  group_plot <- ggplot(plot_data, aes(x = group, y = y)) +
    geom_boxplot(outlier.shape = NA) +
    geom_jitter(width = 0.1, alpha = 0.5) +
    labs(x = x_label, y = y_label)
  print(group_plot)

  # 3. Is each group normal?
  group_names <- unique(plot_data$group)

  print(group_names[1])
  print(shapiro.test(plot_data$y[plot_data$group == group_names[1]]))

  print(group_names[2])
  print(shapiro.test(plot_data$y[plot_data$group == group_names[2]]))

  # 4. Do the two groups have similar spread? (Levene's test)
  #    Welch's test doesn't need this, but it shows whether the spreads differ
  print(car::leveneTest(formula, data = data))

  # Hand back the test so it can be saved with <-
  invisible(test_result)
}
