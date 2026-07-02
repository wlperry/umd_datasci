#!/usr/bin/env bash
# =====================================================================
# rename_homework_folders_ww_mm.sh
#
# Renames homeworks/hw_NN  ->  homeworks/WW_MM_homework
# (WW = week, MM = module number, matching lectures/activities and
# _schedule.yml). Only odd modules currently have a homework, matching
# your existing schedule.
#
# Run from the project root (same level as _quarto.yml).
#
# Usage:
#   ./rename_homework_folders_ww_mm.sh            # dry run
#   ./rename_homework_folders_ww_mm.sh --apply    # actually rename
# =====================================================================

set -euo pipefail

APPLY=false
[[ "${1:-}" == "--apply" ]] && APPLY=true

if [[ ! -d homeworks ]]; then
  echo "Run this from your project root — homeworks/ not found here."
  exit 1
fi

USE_GIT=false
git rev-parse --is-inside-work-tree > /dev/null 2>&1 && USE_GIT=true

MAPPINGS=(
  "hw_01:01_01_homework"
  "hw_03:02_03_homework"
  "hw_05:03_05_homework"
  "hw_07:04_07_homework"
  "hw_09:05_09_homework"
  "hw_11:06_11_homework"
  "hw_13:07_13_homework"
  "hw_15:08_15_homework"
  "hw_17:09_17_homework"
)

count=0
cd homeworks

for pair in "${MAPPINGS[@]}"; do
  old="${pair%%:*}"
  new="${pair##*:}"

  if [[ ! -d "$old" ]]; then
    echo "SKIP (not found): $old"
    continue
  fi
  if [[ -e "$new" ]]; then
    echo "SKIP (target exists): $old -> $new"
    continue
  fi

  echo "homeworks/$old  ->  homeworks/$new"
  count=$((count + 1))

  if $APPLY; then
    if $USE_GIT; then
      git mv "$old" "$new"
    else
      mv "$old" "$new"
    fi
  fi
done

echo ""
if $APPLY; then
  echo "Renamed $count folder(s)."
  echo "Next: update homeworks/index.qmd's listing 'contents:' glob to"
  echo "\"[0-9][0-9]_[0-9][0-9]_homework/*.qmd\" and update _schedule.yml paths."
else
  echo "$count folder(s) would be renamed. Re-run with --apply to actually do it."
fi
