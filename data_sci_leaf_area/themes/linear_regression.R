# linear_regression() -------------------------------------------------
# Fit a simple linear regression and show everything we check:
#   1. the model output
#   2. a ggplot of the data with the fitted line
#   3. the four base R diagnostic plots
#   4. a Shapiro-Wilk test on the residuals
#
# Use it like lm():  linear_regression(y ~ x, data = my_df)
# Needs library(tidyverse) (or library(ggplot2)) loaded first.

linear_regression <- function(formula, data) {

  # 1. Fit the model and print the full output
  model <- lm(formula, data = data)
  print(summary(model))

  # 2. Plot the data with the regression line
  #    model$model is the data lm() actually used:
  #    column 1 is y, column 2 is x
  plot_data <- model$model
  y_label <- names(plot_data)[1]
  x_label <- names(plot_data)[2]
  names(plot_data) <- c("y", "x")

  regression_plot <- ggplot(plot_data, aes(x = x, y = y)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    labs(x = x_label, y = y_label)
  print(regression_plot)

  # 3. The four diagnostic plots, in a 2 x 2 grid
  par(mfrow = c(2, 2))
  plot(model)
  par(mfrow = c(1, 1))

  # 4. Are the residuals normal?
  print(shapiro.test(residuals(model)))

  # Hand back the model so it can be saved with <-
  invisible(model)
}
