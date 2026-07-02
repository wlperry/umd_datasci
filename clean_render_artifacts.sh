#!/usr/bin/env bash
# =====================================================================
# clean_render_artifacts.sh
#
# Deletes leftover render output (.docx, .html, .pptx, .typst, .md,
# .slides.html) sitting loose inside your CONTENT folders — these are
# byproducts of rendering individual .qmd files directly (Positron's
# per-file "Render" button writes output next to the source, ignoring
# `output-dir: docs`). Real output belongs only in docs/; content
# folders should contain just .qmd/.R source plus data/images/figures.
#
# Safe by construction: only scans the folders you list (default: the
# course content folders), never touches docs/, _freeze/, _extensions/,
# site_libs/, or ms_templates/.
#
# Usage:
#   ./clean_render_artifacts.sh            # dry run
#   ./clean_render_artifacts.sh --apply    # actually delete
#
# Pass different folders as extra args to scan something else instead:
#   ./clean_render_artifacts.sh --apply quizzes admin
# =====================================================================

set -euo pipefail

APPLY=false
DIRS=()

for arg in "$@"; do
  if [[ "$arg" == "--apply" ]]; then
    APPLY=true
  else
    DIRS+=("$arg")
  fi
done

if [[ ${#DIRS[@]} -eq 0 ]]; then
  DIRS=(lectures activities homeworks assignments common_code admin quizzes)
fi

# leftover render output extensions — never legitimate as a SOURCE file
ARTIFACT_REGEX='\.(docx|html|pptx|typst|md)$'
EXCLUDE_REGEX='(/_freeze/|/_extensions/|/docs/|/site_libs/|_cache/|_files/)'

USE_GIT=false
git rev-parse --is-inside-work-tree > /dev/null 2>&1 && USE_GIT=true

count=0

for dir in "${DIRS[@]}"; do
  [[ -d "$dir" ]] || { echo "skip: $dir (not found)"; continue; }

  while IFS= read -r -d '' filepath; do
    [[ "$filepath" =~ $EXCLUDE_REGEX ]] && continue
    [[ "$filepath" =~ $ARTIFACT_REGEX ]] || continue

    echo "$filepath"
    count=$((count + 1))

    if $APPLY; then
      if $USE_GIT; then
        git rm -q "$filepath" 2>/dev/null || rm "$filepath"
      else
        rm "$filepath"
      fi
    fi
  done < <(find "$dir" -type f -print0)
done

echo ""
if $APPLY; then
  echo "Deleted $count leftover render artifact(s)."
else
  echo "$count file(s) would be deleted. Re-run with --apply to actually do it."
fi
