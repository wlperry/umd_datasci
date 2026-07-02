# =====================================================================
# sync_order_from_folder_names.R
#
# Wire this into _quarto.yml as a pre-render hook (see bottom of this
# file for the snippet) so it runs automatically before every render.
#
# Reads folder names like:
#   lectures/01_02_lecture/          -> week 01, lecture/module 02
#   lectures/02_03_wrangling_stats/  -> week 02, lecture/module 03
# and writes those two numbers into `week:` and `order:` in that
# folder's .qmd frontmatter automatically. Move a lecture to a
# different week? Rename the folder's leading numbers — that's it,
# the .qmd frontmatter updates itself on the next render.
#
# Folder naming rule: the folder must start with  WW_MM_  (two 2-digit
# numbers separated by underscores) — anything after that is up to you
# (lecture, a topic slug, whatever). Folders that don't match this
# pattern are left alone.
#
# Scans: lectures/, activities/, homeworks/  (edit TARGET_DIRS below to
# add/remove folders this applies to).
# =====================================================================

TARGET_DIRS <- c("lectures", "activities", "homeworks")

FOLDER_PATTERN <- "^([0-9]{2})_([0-9]{2})_"

update_frontmatter_field <- function(lines, field, value) {
  # frontmatter is bounded by the first two lines that are exactly "---"
  dashes <- which(lines == "---")
  if (length(dashes) < 2) return(lines)  # no frontmatter block, leave alone
  fm_start <- dashes[1]
  fm_end <- dashes[2]

  field_pattern <- paste0("^", field, ":")
  field_line <- grep(field_pattern, lines[fm_start:fm_end])

  new_line <- paste0(field, ": ", value)

  if (length(field_line) > 0) {
    # field exists — update its value in place
    idx <- fm_start - 1 + field_line[1]
    lines[idx] <- new_line
  } else {
    # field missing — insert it right after the opening "---"
    lines <- append(lines, new_line, after = fm_start)
  }
  lines
}

sync_one_qmd <- function(path, week, order) {
  lines <- readLines(path, warn = FALSE)
  lines <- update_frontmatter_field(lines, "week", week)
  lines <- update_frontmatter_field(lines, "order", order)
  writeLines(lines, path)
}

for (dir in TARGET_DIRS) {
  if (!dir.exists(dir)) next

  subfolders <- list.dirs(dir, recursive = FALSE, full.names = TRUE)

  for (folder in subfolders) {
    base <- basename(folder)
    m <- regmatches(base, regexec(FOLDER_PATTERN, base))[[1]]
    if (length(m) == 0) next  # doesn't match WW_MM_ pattern, skip

    week  <- as.integer(m[2])
    order <- as.integer(m[3])

    qmds <- list.files(folder, pattern = "\\.qmd$", full.names = TRUE)
    qmds <- qmds[basename(qmds) != "index.qmd"]

    for (qmd in qmds) {
      sync_one_qmd(qmd, week, order)
      cat(sprintf("synced %s  ->  week=%d, order=%d\n", qmd, week, order))
    }
  }
}

# =====================================================================
# Add this to _quarto.yml so it runs automatically before every render:
#
# project:
#   type: website
#   output-dir: docs
#   pre-render: sync_order_from_folder_names.R
# =====================================================================
