# ==========================================================
# INSTRUCTOR ONLY - builds the data file for this module
#
# You do not need to run this. The CSV it writes is
# already in content/anova_one_factor/data/. It is here so
# the provenance of both files is on the record.
#
# Run from the module folder:
#   Rscript --vanilla scripts/00_build_module_data.R
# ==========================================================

library(tidyverse)

dir.create("data", showWarnings = FALSE)

# ---- 1. Possum - the IN-CLASS data -----------------------
# Mountain brushtail possums, 104 animals trapped at 7 sites
# in Victoria / New South Wales / Queensland, Australia.
#
# Source : OpenIntro (Lindenmayer et al. 1995, Aust J Zool 43:449-458)
#   https://www.openintro.org/data/csv/possum.csv
# Kaggle mirror (the one students are pointed at):
#   https://www.kaggle.com/datasets/abrambeyer/openintro-possum
#
# Shipped VERBATIM - no cleaning at all. The site column
# arrives as the integers 1-7 on purpose: turning those into
# named, ordered groups with factor() is part of the lesson.

possum <- read_csv("https://www.openintro.org/data/csv/possum.csv",
                   show_col_types = FALSE)

stopifnot(nrow(possum) == 104, n_distinct(possum$site) == 7)
write_csv(possum, "data/possum.csv")

# Site 1-7 in order, from the OpenIntro codebook:
#   1 Cambarville, 2 Bellbird (both Victoria),
#   3 Whian Whian, 4 Byrangery (both NSW),
#   5 Conondale, 6 Allyn River, 7 Bulburin (Qld / N NSW)


# The weta data moved. It is now the IN-CLASS data for the
# next module, and its provenance is documented there:
#   content/anova_one_factor_2/scripts/00_build_module_data.R


cat("wrote data/possum.csv       ", nrow(possum), "rows\n")
