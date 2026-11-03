# load libraries
library(tidyverse)
install.packages("patchwork")
library(patchwork)
leaf_df <- read_csv("data/2026_09_03_data_sci_leaf_area.csv")
glimpse(leaf_df)

# ---- Positions: define once, reuse on every layer -------
jitter_pos <- position_jitter(width = 0.15, seed = 42) # raw points: spread them out
dodge_pos <- position_dodge(width = 0.2) # grouped means / lines: shift side by side

leaf_df %>%
  ggplot(aes(x = shade, y = mass_g, fill = shade)) +

  geom_violin(alpha = 0.6) +
  geom_point(position = jitter_pos, alpha = 0.6) +
  labs(
    title = "Leaf Mass by Shade",
    x = "Shade",
    y = "Leaf Mass (g)",
    fill = "Shade"
  ) +
  theme_classic() +
  scale_fill_manual(
    values = c(
      "sunny" = "darkorchid3",
      "shady" = "thistle3"
    ),
    labels = c(
      "shady" = "Shady",
      "sunny" = "Sunny"
    )
  )


violin_plot <- leaf_df %>%
  ggplot(aes(x = shade, y = thickness_mm, fill = shade)) +

  geom_violin(alpha = 0.6) +
  geom_point(position = jitter_pos, alpha = 0.6) +
  labs(
    title = "Leaf Mass by Shade",
    x = "Shade",
    y = "Leaf Mass (g)",
    fill = "Shade"
  ) +
  theme_classic() +
  scale_fill_manual(
    values = c(
      "sunny" = "darkorchid3",
      "shady" = "thistle3"
    ),
    labels = c(
      "shady" = "Shady",
      "sunny" = "Sunny"
    )
  )

facet_plot <- leaf_df %>%
  ggplot(aes(x = thickness_mm, fill = shade)) +
  geom_histogram(binwidth = 0.1) +
  scale_fill_manual(
    values = c(
      "sunny" = "darkorchid3",
      "shady" = "thistle3"
    ),
    labels = c(
      "shady" = "Shady",
      "sunny" = "Sunny"
    )
  ) +
  facet_grid(shade ~ .)
facet_plot

# this is standard error ------
mean_se_plot <- leaf_df %>% # this take the dataframe and passes to ggplot
  ggplot(aes(x = shade, y = thickness_mm, color = shade)) + # this
  # geom_point(position = jitter_pos) +
  stat_summary(fun = mean, geom = "point", color = "black", size = 4) +
  stat_summary(
    fun.data = mean_se,
    geom = "errorbar",
    color = "black",
    width = 0.1,
    linewidth = 1
  ) +
  theme_regular()

mean_se_plot


ggsave(
  mean_se_plot,
  file = "figures/mean_se.pdf",
  width = 9,
  height = 9,
  units = "in"
)

mean_se_plot +
  violin_plot +
  plot_layout(ncol = 2) +
  plot_annotation(tag_levels = "A", tag_suffix = ")")
