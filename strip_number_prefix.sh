#!/usr/bin/env bash
# =====================================================================
# strip_number_prefix.sh
#
# Removes the leading "NN_" (or "N_") number from filenames inside your
# content folders, WITHOUT touching folder names.
#
#   lectures/lecture_03/03_lecture_powerpoint.qmd  ->  lectures/lecture_03/lecture_powerpoint.qmd
#   activities/lecture_05/05_class_activity.qmd    ->  activities/lecture_05/class_activity.qmd
#   homeworks/hw_07/07_homework.qmd                ->  homeworks/hw_07/homework.qmd
#
# The number stays on the FOLDER (lecture_03, hw_07, ...), which is what
# your site's ordering should key off going forward (via _schedule.yml).
#
# Usage:
#   ./strip_number_prefix.sh              # DRY RUN - just prints what it would do
#   ./strip_number_prefix.sh --apply      # actually renames (uses `git mv` if
#                                          # you're in a git repo, so history
#                                          # is preserved; falls back to `mv`)
#
# By default it scans: lectures activities homeworks assignments common_code
# Pass different folders as extra args to scan something else instead:
#   ./strip_number_prefix.sh --apply quizzes
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
  DIRS=(lectures activities homeworks assignments common_code)
fi

# Directories to skip entirely — generated/cache output, never hand-edited.
EXCLUDE_REGEX='(/_freeze/|/_extensions/|/docs/|/site_libs/|_cache/|_files/)'

# Only touch actual content/code files — never data files, images, xlsx, etc.
# (data filenames often start with a date like 2026_06_25_... which would
# otherwise get mangled).
CONTENT_EXT_REGEX='\.(qmd|Rmd|R|py|ipynb)$'

USE_GIT=false
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  USE_GIT=true
fi

count=0

for dir in "${DIRS[@]}"; do
  [[ -d "$dir" ]] || { echo "skip: $dir (not found)"; continue; }

  # find files (not dirs) whose basename starts with digits + underscore
  while IFS= read -r -d '' filepath; do
    [[ "$filepath" =~ $EXCLUDE_REGEX ]] && continue
    [[ "$filepath" =~ $CONTENT_EXT_REGEX ]] || continue

    dirpart=$(dirname "$filepath")
    base=$(basename "$filepath")

    # only strip a 1-2 digit prefix (lecture/module numbers), never longer
    # digit runs like dates (2026_06_25_...)
    if [[ "$base" =~ ^[0-9]{1,2}_(.+)$ ]]; then
      newbase="${BASH_REMATCH[1]}"
      newpath="$dirpart/$newbase"

      if [[ -e "$newpath" ]]; then
        echo "SKIP (target exists): $filepath -> $newpath"
        continue
      fi

      echo "$filepath  ->  $newpath"
      count=$((count + 1))

      if $APPLY; then
        if $USE_GIT; then
          git mv "$filepath" "$newpath"
        else
          mv "$filepath" "$newpath"
        fi
      fi
    fi
  done < <(find "$dir" -type f -print0)
done

echo ""
if $APPLY; then
  echo "Renamed $count file(s)."
else
  echo "$count file(s) would be renamed. Re-run with --apply to actually do it."
fi
