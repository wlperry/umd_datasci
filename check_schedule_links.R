# =====================================================================
# check_schedule_links.R
#
# Verifies every lecture/activity/homework/assignment/common_code path
# in _schedule.yml actually exists on disk, BEFORE you render the site.
# Run this from the project root (same folder as _quarto.yml) any time
# you edit _schedule.yml.
#
#   Rscript check_schedule_links.R
#
# or from the Positron console:
#   source("check_schedule_links.R")
# =====================================================================

if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml")
library(yaml)

schedule <- yaml::read_yaml("_schedule.yml")

link_keys <- c("lecture", "activity", "homework", "assignment", "common_code")

missing <- character(0)
checked <- 0

for (wk in schedule$weeks) {
  for (mod in wk$modules) {
    for (key in link_keys) {
      path <- mod[[key]]
      if (!is.null(path)) {
        checked <- checked + 1
        if (!file.exists(path)) {
          missing <- c(missing, sprintf(
            "week %s, module %s (%s): %s",
            wk$week, mod$number, key, path
          ))
        }
      }
    }
  }
}

cat(sprintf("Checked %d links.\n", checked))

if (length(missing) == 0) {
  cat("All good — every path in _schedule.yml exists on disk.\n")
} else {
  cat(sprintf("\n%d MISSING file(s):\n\n", length(missing)))
  cat(paste0("  - ", missing, collapse = "\n"))
  cat("\n\nFix these paths in _schedule.yml (or rename the file on disk to match)\n")
  cat("before rendering the site — these are exactly what causes Quarto's\n")
  cat("'Unable to resolve link target' warnings.\n")
}
