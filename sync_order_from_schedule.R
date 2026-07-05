# =====================================================================
# sync_order_from_schedule.R   (pre-render hook)
#
# _schedule.yml is now the SINGLE SOURCE OF TRUTH for sequence + week.
# This script reads it and stamps `order:` (the module number) and
# `week:` into the frontmatter of every lecture / activity / homework
# .qmd it points to. To reorder the course, edit _schedule.yml only —
# folders are named by TOPIC and never need renumbering.
# =====================================================================

if (!requireNamespace("yaml", quietly = TRUE)) install.packages("yaml")
library(yaml)

update_fm <- function(lines, field, value) {
  dashes <- which(lines == "---")
  if (length(dashes) < 2) return(lines)
  fm_start <- dashes[1]; fm_end <- dashes[2]
  hit <- grep(paste0("^", field, ":"), lines[fm_start:fm_end])
  new_line <- paste0(field, ": ", value)
  if (length(hit) > 0) {
    lines[fm_start - 1 + hit[1]] <- new_line
  } else {
    lines <- append(lines, new_line, after = fm_start)
  }
  lines
}

sched <- yaml::read_yaml("_schedule.yml")
for (wk in sched$weeks) {
  for (mod in wk$modules) {
    ord <- as.integer(mod$number)
    for (key in c("lecture", "activity", "homework")) {
      p <- mod[[key]]
      if (!is.null(p) && file.exists(p)) {
        lines <- readLines(p, warn = FALSE)
        lines <- update_fm(lines, "week", wk$week)
        lines <- update_fm(lines, "order", ord)
        writeLines(lines, p)
        cat(sprintf("synced %s  ->  week=%s, order=%d\n", p, wk$week, ord))
      }
    }
  }
}
