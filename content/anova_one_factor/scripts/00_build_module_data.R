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

# ---- 1. Possum - the IN-CLASS and HOMEWORK data ----------
# Mountain brushtail possums, 104 animals trapped at 7 sites
# in Victoria / New South Wales / Queensland, Australia.
#
# Paper  : Lindenmayer, Viggers, Cunningham & Donnelly (1995)
#   Morphological variation among populations of the
#   mountain brushtail possum, Trichosurus caninus Ogilby.
#   Australian Journal of Zoology 43: 449-458.
#   https://doi.org/10.1071/ZO9950449
# Data   : the `possum` data frame in the R package DAAG
#   (Maindonald & Braun), which carries all nine body
#   measurements from that study.
#   https://cran.r-project.org/package=DAAG
#   https://vincentarelbundock.github.io/Rdatasets/doc/DAAG/possum.html
#
# This REPLACED the 8-column OpenIntro / Kaggle copy on
# 2026-11-17. That copy has the same 104 animals in the same
# order but leaves out foot, ear, eye, chest and belly - and
# ear length is the homework.
#
# Changes from the DAAG file, all cosmetic:
#   - columns renamed to short snake_case names (below)
#   - the trap-ID row names are dropped
# No value is altered. The site column still arrives as the
# integers 1-7 on purpose: naming them with case_when() and
# making them a factor is part of the lesson.

possum <- read_csv("https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/possum.csv",
                   show_col_types = FALSE) %>%
  transmute(animal  = case,
            site,
            pop     = Pop,
            sex,
            age,
            head_l  = hdlngth,    # head length, mm
            skull_w = skullw,     # skull width, mm
            total_l = totlngth,   # total length, cm
            tail_l  = taill,      # tail length, cm
            foot_l  = footlgth,   # foot length, mm
            ear_l   = earconch,   # ear conch length, mm
            eye,                  # eye, mm
            chest,                # chest girth, cm
            belly)                # belly girth, cm

stopifnot(nrow(possum) == 104, n_distinct(possum$site) == 7)
write_csv(possum, "data/possum.csv")

# Site 1-7, from the DAAG documentation (`possumsites`),
# with latitude:
#   1 Cambarville 37.6 S, 2 Bellbird 37.6 S (Victoria)
#   3 Whian Whian 28.6 S, 4 Byrangery 28.6 S (NSW)
#   5 Conondale 26.4 S (Queensland)
#   6 Allyn River 32.1 S (NSW)
#   7 Bulburin 24.6 S (Queensland)
#
# TEACHING NOTE: animal 41 (Bellbird, female) has an ear of
# 40.3 mm where the rest of Bellbird is 49-56 mm, and is
# also the one animal with no foot length. It makes
# Shapiro-Wilk fail on ear_l (p < 0.001). Without it
# Shapiro p = 0.56 and the conclusion is unchanged. That is
# the point of homework section H7.

# The weta data moved. It is now the IN-CLASS data for the
# next module, and its provenance is documented there:
#   content/anova_one_factor_2/scripts/00_build_module_data.R


cat("wrote data/possum.csv       ", nrow(possum), "rows\n")
