---
title: "03_Class_Activity"
author: "Bill Perry"
format:
  html: default
  docx: default
---

# In class activity 3:

# What did we do last time?

- Implement data pipeline best practices

- Apply controlled vocabulary and naming conventions

- Create effective visualizations

- Customize plots for publication quality

- Combine multiple plots into composite figures

  ``` r
  ggplot(name_df, aes(x_variable, y_variable, color = categorical_variable)) +
  #      dataframe, aesthetics(x and y variables, mapping of color or fill or shape) + 
    geom_point() +
  # this it the geometry you want and can add more layers like
    geom_line()
  ```

- What questions do you have and what is unclear

- What did not work so far when you started the homework?

# Objectives and goals for today