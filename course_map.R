#!/usr/bin/env Rscript
# =====================================================================
# course_map.R
# Prints the current course schedule as a table and (re)writes
# COURSE_MAP.md. Reads _schedule.yml — the single source of truth — so
# the map is never hand-maintained: reorder in _schedule.yml, then run
#   Rscript course_map.R      (or  source("course_map.R")  in the console)
# =====================================================================

if (!requireNamespace("yaml", quietly = TRUE)) {
  install.packages("yaml")
}
library(yaml)

s <- yaml::read_yaml("_schedule.yml")
`%||%` <- function(x, y) if (is.null(x)) y else x

md <- c(
  "# Course Map — UMD Data Science Biology",
  "",
  sprintf(
    "*Generated from `_schedule.yml` on %s. Do not edit by hand — edit `_schedule.yml` and re-run `Rscript course_map.R`.*",
    format(Sys.Date())
  ),
  "",
  "| # | Week | Topic | Folder (`content/`) | L | A | E |",
  "|--:|:----:|-------|---------------------|:-:|:-:|:-:|"
)

has_extension <- function(activity_path) {
  if (is.null(activity_path) || !file.exists(activity_path)) {
    return(FALSE)
  }
  any(grepl("^#+\\s+Extension", readLines(activity_path, warn = FALSE)))
}

for (wk in s$weeks) {
  for (m in wk$modules) {
    folder <- if (!is.null(m$lecture)) sprintf("`%s`", basename(dirname(m$lecture))) else "—"
    topic <- m$topic %||% ""
    if (!nzchar(topic)) {
      topic <- "_(placeholder)_"
    }
    md <- c(
      md,
      sprintf(
        "| %s | %s | %s | %s | %s | %s | %s |",
        m$number,
        wk$week,
        topic,
        folder,
        if (!is.null(m$lecture)) "L" else "·",
        if (!is.null(m$activity)) "A" else "·",
        if (has_extension(m$activity)) "E" else "·"
      )
    )
  }
}

# Common-code reference library (separate from the weekly schedule)
if (!is.null(s$common_code) && length(s$common_code) > 0) {
  md <- c(
    md,
    "",
    "## Common Code (reference library — NOT the weekly schedule)",
    "",
    "| # | Topic | Path |",
    "|--:|-------|------|"
  )
  for (i in seq_along(s$common_code)) {
    cc <- s$common_code[[i]]
    md <- c(md, sprintf("| %02d | %s | `%s` |", i, cc$title, cc$path))
  }
}

md <- c(
  md,
  "",
  "**L** = lecture · **A** = activity · **E** = activity has an out-of-class Extension.  ",
  "Rows with _(placeholder)_ topics are open / flex / holiday slots.  ",
  "Parked topics (not on the schedule) live in `content/_parked/`."
)

writeLines(md, "COURSE_MAP.md")
cat(paste(md, collapse = "\n"), "\n\nWrote COURSE_MAP.md\n")
