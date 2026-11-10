# ==========================================================
# INSTRUCTOR ONLY - builds the data file for this module
#
# You do not need to run this. The CSV it writes is already
# in content/anova_one_factor_2/data/. It is here so the
# provenance of the file is on the record.
#
# Run from the module folder:
#   Rscript --vanilla scripts/00_build_module_data.R
# ==========================================================

library(tidyverse)

dir.create("data", showWarnings = FALSE)

# ---- Wellington tree weta --------------------------------
# 313 adult Hemideina crassidens from Te Pakeka / Maud
# Island, New Zealand, collected March-April 2016. Females
# plus three adult male morphs (eighth-, ninth- and
# tenth-instar), with 11 morphological measurements.
#
# Source : Zenodo, doi:10.5281/zenodo.22959939
#   https://zenodo.org/records/22959939
# Data creator : Clint D. Kelly, Universite du Quebec a
#   Montreal (ORCID 0000-0002-0693-7211). The Zenodo record
#   itself is author-anonymised for peer review; the creator
#   is named in the record's own README.md.
# Licence : CC BY 4.0 - redistribution is allowed WITH
#   attribution, which is why the citation appears in the
#   activity, both scripts, and here.
#
# ONE change from the archived file, which CC BY requires us
# to state: every numeric column is rounded to 4 decimal
# places. The archive stores floating-point artefacts like
# 2.5300000000000002, which are noise rather than precision
# and make the file ugly to read in class. Nothing else is
# touched - all 313 rows and all 14 columns are kept,
# including the 5 missing cells.
#
# TEACHING NOTES ON THIS FILE, so they are not lost:
#   - The three male morphs were assigned FROM head_length
#     (cutoffs 18.50579 and 24.15225), so head_length must
#     never be used as a response. That circularity is the
#     point of section 2 in the skeleton.
#   - Keep males only for any question about the morphs.
#     Females are much smaller and swamp the comparison.
#   - `ear` is an AREA in mm^2 while `pronotum` is a length
#     in mm, so relative ear size needs sqrt(ear)/pronotum.
#     The published analysis uses the same transformation.

weta_url <- "https://zenodo.org/records/22959939/files/trait_data.csv?download=1"

weta <- read_csv(weta_url, na = "", show_col_types = FALSE) %>%
  mutate(across(where(is.numeric), ~ round(.x, 4)))

stopifnot(nrow(weta) == 313, n_distinct(weta$ID) == 313)
stopifnot(setequal(unique(weta$morph), c("female", "eighth", "ninth", "tenth")))
write_csv(weta, "data/weta_traits.csv")

cat("wrote data/weta_traits.csv  ", nrow(weta), "rows\n")
