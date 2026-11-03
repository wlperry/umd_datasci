# paired_t_test() ------------------------------------------------------
# Run a paired t-test and show everything we check:
#   1. the paired t-test output
#   2. a plot of each pair, before vs after, joined by a line
#   3. a histogram of the differences
#   4. a Q-Q plot of the differences
#   5. a Shapiro-Wilk test on the differences
#
# The data need to be in two columns, one row per individual,
# with the pairs lined up on the same row.
#
# Use it like this:  paired_t_test(my_df$before, my_df$after)
# Differences are first minus second, the same as t.test().
# Needs library(tidyverse) (or library(ggplot2)) loaded first.

paired_t_test <- function(first, second) {

  # 1. Run the paired t-test and print the output
  test_result <- t.test(first, second, paired = TRUE)
  print(test_result)

  # 2. Plot each pair joined by a line
  #    Stack the two columns into one long data frame:
  #    id says which individual, measurement says first or second
  n <- length(first)
  pair_data <- data.frame(
    id = c(1:n, 1:n),
    measurement = c(rep("first", n), rep("second", n)),
    value = c(first, second)
  )

  pair_plot <- ggplot(pair_data, aes(x = measurement, y = value, group = id)) +
    geom_line(alpha = 0.5) +
    geom_point()
  print(pair_plot)

  # 3. Histogram of the differences
  #    The paired t-test is really a one-sample t-test on these
  difference_data <- data.frame(difference = first - second)

  difference_plot <- ggplot(difference_data, aes(x = difference)) +
    geom_histogram(bins = 10) +
    geom_vline(xintercept = 0, linetype = "dashed")
  print(difference_plot)

  # 4. Q-Q plot of the differences
  qqnorm(difference_data$difference)
  qqline(difference_data$difference)

  # 5. Are the differences normal?
  print(shapiro.test(difference_data$difference))

  # Hand back the test so it can be saved with <-
  invisible(test_result)
}
