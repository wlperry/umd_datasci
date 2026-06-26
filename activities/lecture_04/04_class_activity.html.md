---
title: "04_Class_Activity"
author: "Bill Perry"
format:
  html: default
  docx: default
---

# In class activity 4:

## What did we do last time in activity 3?

- Setting up a project and variable names and code names
- How to use the pipe command %\>%
- How to create descriptive statistics of a sample

``` r
p_df %>% 
  summarize(
    mean_length = mean(length_mm, na.rm = TRUE),
    sd_length = sd(length_mm, na.rm = TRUE),
    n_length = sum(!is.na(length_mm)))
```

- More graphs...

  ``` r
  ggplot(data = p_df, aes(x=length_mm, fill = wind)) +
    geom_histogram( binwidth = 2, 
  # sets the width in units of the bins - try different nubmers
     position = position_dodge2(width = 0.5))
  ```

- What questions do you have and what is unclear - what did not work so far when you started the homework?

# Introduction

In this active learning module, we'll explore real data from fish populations in Alaska. We'll focus on understanding:

- How to create and interpret frequency distributions
- How sample size affects our view of a population
- How distributions differ among lakes

We'll use the `tidyverse` package for data manipulation and visualization.