# Draft New Lectures — Not Yet Wired Into the Site

These four modules were drafted outside the live course build. Nothing in
`_schedule.yml`, `COURSE_MAP.md`, `content/`, `homeworks/`, or `quizzes/` has
been touched — these files live only here, for you to review first.

Each folder follows the same lecture / activity / homework pattern and the
same revealjs / docx / pptx front matter as the rest of the course, so any
one of them can be moved into `content/<topic>/` and added to `_schedule.yml`
with no rewriting — just drop it in, add a row, and re-run `course_map.R`.

## What's here

| Folder | Suggested slot | Contents |
|---|---|---|
| `00_file_system_orientation/` | Very first meeting, before Lecture 01 | Lecture only, as requested — no activity/homework |
| `01_data_cleaning/` | Right after Wrangling (module 03), before T-Tests | Lecture + activity + homework + a genuinely messy `messy_leaf_data.csv` |
| `02_ggplot_storytelling/` | After Advanced Plotting, before the Final Project intro | Lecture + activity + homework |
| `03_git_github/` | Right after Lecture 02 (Meeting R), ideally right after the file-system lecture | Lecture + activity + homework |

## Suggested order if you use all four

1. File System Orientation (00)
2. Lecture 01 — Introduction (existing)
3. Lecture 02 — Meeting R (existing)
4. Git & GitHub (03)
5. Lecture 03 — Wrangling (existing)
6. Data Cleaning (01)
7. Lecture 04 — T-Tests (existing) ... continuing as scheduled
8. ... Advanced Plotting (existing common_code)
9. ggplot Storytelling (02)
10. Lecture 08 — Final Project intro (existing)

## Notes on design choices

- **Data cleaning** reuses the course's sunny/shady leaf theme but with a
  new, deliberately messy CSV (inconsistent capitalization, disguised NA
  codes, a units-contaminated number, a duplicate row, an outlier typo) so
  students clean data they'll recognize before analyzing it in Wrangling.
- **ggplot storytelling** is deliberately light on new geoms — it's a design
  lecture, not a mechanics lecture, meant to sit alongside (not replace)
  the existing `03_ggplot` and `07_advanced_plotting` common-code modules.
- **Git & GitHub** uses GitHub Desktop, not the command line, given the
  target audience. The command line is mentioned only to confirm the Git
  install worked. Consider a later, optional lecture on the CLI once
  students are comfortable.
- **File system orientation** has no activity/homework per your request —
  it's meant as a short, no-code first-day primer.

## Before publishing

- All four still need the "recap last time / goals for today" header
  content adjusted once you decide their real position in `_schedule.yml`
  (the placeholder recaps above are my best guess at what precedes them).
- Spot-check the Git/GitHub screenshots-by-description against whatever
  GitHub Desktop version is current when you teach this — its UI changes
  periodically.
- Run each `.qmd` through Quarto once to confirm it renders cleanly in your
  environment before assigning it.
