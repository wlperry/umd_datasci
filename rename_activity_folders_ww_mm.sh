#!/usr/bin/env bash
# =====================================================================
# rename_activity_folders_ww_mm.sh
#
# Renames activities/NN_activity  ->  activities/WW_MM_activity
# (WW = week, MM = module number, matching lectures and _schedule.yml)
#
# Run from the project root (same level as _quarto.yml).
#
# Usage:
#   ./rename_activity_folders_ww_mm.sh            # dry run
#   ./rename_activity_folders_ww_mm.sh --apply    # actually rename
# =====================================================================

set -euo pipefail

APPLY=false
[[ "${1:-}" == "--apply" ]] && APPLY=true

if [[ ! -d activities ]]; then
  echo "Run this from your project root — activities/ not found here."
  exit 1
fi

USE_GIT=false
git rev-parse --is-inside-work-tree > /dev/null 2>&1 && USE_GIT=true

MAPPINGS=(
  "01_activity:01_01_activity"
  "02_activity:01_02_activity"
  "03_activity:02_03_activity"
  "04_activity:02_04_activity"
  "05_activity:03_05_activity"
  "06_activity:03_06_activity"
  "07_activity:04_07_activity"
  "08_activity:04_08_activity"
  "09_activity:05_09_activity"
  "10_activity:05_10_activity"
  "11_activity:06_11_activity"
  "12_activity:06_12_activity"
  "13_activity:07_13_activity"
  "14_activity:07_14_activity"
  "15_activity:08_15_activity"
  "16_activity:08_16_activity"
  "17_activity:09_17_activity"
  "18_activity:09_18_activity"
  "19_activity:10_19_activity"
)

count=0
cd activities

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

  echo "activities/$old  ->  activities/$new"
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
  echo "Next: update activities/index.qmd's listing 'contents:' glob to"
  echo "\"[0-9][0-9]_[0-9][0-9]_activity/*.qmd\" and update _schedule.yml paths."
else
  echo "$count folder(s) would be renamed. Re-run with --apply to actually do it."
fi
