#!/usr/bin/env bash
# =====================================================================
# rename_lecture_folders_ww_mm.sh
#
# Renames lectures/lecture_NN  ->  lectures/WW_MM_<slug>
# (WW = week, MM = module/lecture number, per your _schedule.yml mapping)
#
# Once renamed, sync_order_from_folder_names.R will read week/order
# straight off these folder names on every render — no more hand-editing
# `order:`/`week:` in frontmatter.
#
# Run from the project root (same level as _quarto.yml).
#
# Usage:
#   ./rename_lecture_folders_ww_mm.sh            # dry run
#   ./rename_lecture_folders_ww_mm.sh --apply    # actually rename
# =====================================================================

set -euo pipefail

APPLY=false
[[ "${1:-}" == "--apply" ]] && APPLY=true

if [[ ! -d lectures ]]; then
  echo "Run this from your project root — lectures/ not found here."
  exit 1
fi

USE_GIT=false
git rev-parse --is-inside-work-tree > /dev/null 2>&1 && USE_GIT=true

# old_folder:new_folder pairs, derived from _schedule.yml's week/module map.
# Lectures 01-07 keep their descriptive slug; 08-30 haven't been renamed to
# a descriptive name yet, so they get a generic "lecture" slug for now —
# edit the slug (text after the second number) any time, it doesn't matter
# to the sync script, only the leading WW_MM_ numbers do.
MAPPINGS=(
  "lecture_01:01_01_introduction"
  "lecture_02:01_02_intor_r_positron_projects"
  "lecture_03:02_03_wrangling_summary_stats_stats"
  "lecture_04:02_04_t_tests_and_hypotheses"
  "lecture_05:03_05_regressions"
  "lecture_06:03_06_weather_data_r_download_summarize"
  "lecture_07:04_07_lake_superior_ice"
  "lecture_08:04_08_lecture"
  "lecture_09:05_09_lecture"
  "lecture_10:05_10_lecture"
  "lecture_11:06_11_lecture"
  "lecture_12:06_12_lecture"
  "lecture_13:07_13_lecture"
  "lecture_14:07_14_lecture"
  "lecture_15:08_15_lecture"
  "lecture_16:08_16_lecture"
  "lecture_17:09_17_lecture"
  "lecture_18:09_18_lecture"
  "lecture_19:10_19_lecture"
  "lecture_20:10_20_lecture"
  "lecture_21:11_21_lecture"
  "lecture_22:11_22_lecture"
  "lecture_23:12_23_lecture"
  "lecture_24:12_24_lecture"
  "lecture_25:13_25_lecture"
  "lecture_26:13_26_lecture"
  "lecture_27:14_27_lecture"
  "lecture_28:14_28_lecture"
  "lecture_29:15_29_lecture"
  "lecture_30:15_30_lecture"
)

count=0
cd lectures

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

  echo "lectures/$old  ->  lectures/$new"
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
  echo "Next: add sync_order_from_folder_names.R as a pre-render hook in"
  echo "_quarto.yml, and update the lecture paths in _schedule.yml to match."
else
  echo "$count folder(s) would be renamed. Re-run with --apply to actually do it."
fi
