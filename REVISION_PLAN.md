# Course Revision Plan — Data Science Biology 2026

*Working document. Created 2026-08-27. Edit `_schedule.yml` + content per this
plan; check items off in §0 as you finish them so a fresh session can resume.*

> ## Done so far (branch `course-revision`)
>
> - **`fdff36e`** — `_schedule.yml` rewritten to the instructor's real **15-week**
>   Fall 2026 plan (from `schedule/2026_datascience_organization.xlsx`): flex-day
>   + holiday slots, final-project pitch (wk10) / poster (wk15) days, Joins →
>   wk11, Mapping → wk12, ANOVA I/II → wk8. Homework tree **deleted**; sidebar
>   link removed; `course_map.R` H→E column. Unscheduled topics (GLM, ANCOVA,
>   PCA I/II, multivariate, logistic, standalone Factors, tbd_20–30) **parked**
>   in `content/_parked/` (excluded from render).
> - **`6ae190e`** — Factors folded into **One-Way ANOVA I** (lecture: `fct_reorder`
>   + `fct_relevel` slides; activity: new Parts 3 & 6, renumbered 1–8).
> - **`8828aff`** — **Extension** sections added to `one_way_anova_2` and
>   `t_tests_2` activities (the two-part topics carry the extension on Part II).
>
> ### Also done (later commits)
> - **All 16 activity Extensions** written (§5.3 checklist all green).
> - **`syllabus.qmd` + `admin/syllabus.qmd` + `overview.qmd` (both copies)** —
>   grading table now "In-class activities + Extensions 40%" (Homework folded
>   in); new section describes the extension + 4-point rubric.
> - **Joins reworked to fishers** — `content/joins/data/fisher_individuals.csv`
>   + `fisher_captures.csv` (simulated, generator `make_fisher_data.R`).
>   Lecture (19/19 chunks) + activity fully rewritten. Key-clean is now
>   `str_to_upper()` (`f07`→`F07`); the accidental-join trap is a shared `site`
>   column. Joins no longer feeds mapping. Mapping stays Bigfoot.
> - **New slots wired**: `content/final_project_pitch/` (wk10, both days) and
>   `content/final_project_poster/` (wk15) activities created; module 13 =
>   final-project intro lecture, module 14 "Finding Data" = the existing
>   "Find Your Own Data" activity.
> - `~$*` Excel temp files gitignored.
>
> ### Still open
> - **Worksheet NN cross-references** — many activities/lectures still say
>   "Worksheet 12", "Recap from Worksheet 14", etc. from the old numbering.
>   Cosmetic; a global pass to drop the numbers (or renumber) is a clean-up job.
> - **`check_schedule_links.R` / `index.qmd` / `sync_order_from_schedule.R`**
>   still list a `homework` key — harmless (no module uses it), tidy later.
> - `content/joins/data/bfro_*.csv` — orphaned (old Bigfoot join data); safe to
>   delete once the fisher rework is reviewed.
> - **`content/_parked/`** — GLM, ANCOVA, PCA I/II, multivariate, logistic,
>   tbd_20–30: `git mv` back into `content/` + add to `_schedule.yml` when a
>   flex week gets a topic. Add an Extension to each when its activity is built.
> - `common_code/15_factors` — has a one-line pointer to ANOVA I now; full
>   intro rewrite optional.

This plan captures a restructuring the instructor decided on after doing the
same thing on the Ecostats site:

1. **No separate homework.** Fold a short, out‑of‑class **Extension** (~30–40 min)
   onto the end of each **activity**. The extension must genuinely *extend* the
   in‑class work and force a small change to what was taught — productive
   struggle, not repetition.
2. **Retire the standalone "Factors" module.** Shorten factors hard and fold the
   ANOVA‑relevant pieces into **One‑Way ANOVA I** (week 7), where ordered
   factors and the reference level actually matter. The full `forcats`
   reference stays in **Common Code 15**.
3. **Reflow weeks 9–10.** Joins becomes the first (2‑day) topic of week 9;
   Bigfoot/GBIF mapping becomes a 2‑day topic in week 10; the second slot of
   each of those weeks is left blank (flex/work day).
4. **Update `_schedule.yml`** (single source of truth) and let
   `sync_order_from_schedule.R` re‑stamp `order:`/`week:`.

---

## 0. Progress tracker

Update these as you go. `[x]` = done, `[~]` = in progress, `[ ]` = not started.

### Part A — Schedule  ✅ done (`fdff36e`)
- [x] A1. `_schedule.yml` → full 15-week Fall 2026 version (from the Excel)
- [x] A2. Tail: weeks 11–15 are flex/holiday/new slots — no renumber needed
- [x] A3. `COURSE_MAP.md` regenerated (`course_map.R`: H column → E)
- [x] A4. `index.qmd` schedule chunk executes cleanly
- [ ] A5. Update `syllabus.qmd` + `admin/syllabus.qmd` grading model (Homework 20% → activities/extensions)

### Part B — Factors → ANOVA I  ✅ done (`6ae190e`)
- [x] B1. `fct_reorder` / `fct_relevel` slides in `one_way_anova_lecture.qmd`
- [x] B2. New Parts 3 & 6 in `one_way_anova_activity.qmd`; renumbered 1–8
- [x] B3. Recap / goals / getting-unstuck wording updated
- [x] B4. `one_way_anova_2` — Extension added; no factor-order dependency to fix
- [x] B5. Factors module removed from `_schedule.yml`
- [ ] B6. Trim `common_code/15_factors/factors.qmd` intro to read as a reference
- [x] B7. `content/factors/` parked in `content/_parked/factors/`
- [x] B8. Render-checked (lecture 23/23 chunks; activity clean)

### Part C — Homework → Extension  ✅ all scheduled modules done
- [x] C-01 introduction — first solo R session: plot + handwritten boxplot prediction + your-own-leaf
- [x] C-02 meeting_r — your-own-mean size cutoff + handwritten predict/interpret
- [x] C-03 ggplot_1 — your own colour + combo mean±SE + facet; handwritten
- [x] C-04 ggplot_2 — your own variable pair + zoom window (xlim vs coord_cartesian); handwritten
- [x] C-05 wrangling — three `case_when()` categories, your cutoffs; handwritten
- [x] C-06 summary_stats — IQR / range / coefficient of variation; handwritten
- [x] C-07 quarto — cross-refs (`@tbl-`/`@fig-`) + a self-authored callout + `echo:false` prediction (no inline code)
- [—] C-09 t_tests (I) — no extension (two-part topic; extension is on II)
- [x] C-10 t_tests_2 (II) — one-tailed test on a chosen variable + handwritten E2/E3
- [x] C-11 regression — calibrate a paper object you cut yourself; handwritten
- [x] C-12 weather — your-own-city GSOD warming rate vs Duluth; predict-first
- [—] C-13 one_way_anova (I) — no extension (two-part; extension is on II)
- [x] C-14 one_way_anova_2 (II) — one-sex-subset ANOVA + handwritten E2/E3
- [x] C-15 final_project — "Going further" → Extension (backup dataset + handwritten question pressure-test)
- [x] C-16 pivoting — run the ice workflow on a different Great Lake; predict-first
- [x] C-17 joins — completeness check; ONLY the handwritten "most surprising thing" is graded
- [x] C-19 mapping — map a species you pick via `rgbif`/GBIF; predict-first + bias explain
- [ ] C-21 ancova / C-23 pca_2 — parked; add an Extension when the module is authored

### Standard Extension shape used
`# Extension — out of class (~30–40 min)` inserted before `# Getting unstuck`
(kept any existing "Going further" playground where it added value). Each has
**E1** (do-it, ~3–4 pts), **E2** (predict-then-check, ✍️ handwritten, 3 pts),
**E3** (explain-with-your-own-numbers, ✍️ handwritten, 2–3 pts), with the
half-credit-if-typed callout. `_metadata`/format unchanged.

---

## 1. Decisions (confirmed) & rationale

| Decision | Detail |
|---|---|
| Homework → Extension | Each `content/<topic>/<topic>_activity.qmd` gets a final section **`# Extension — out of class (~30–40 min)`** placed *after* "Review and checkpoint" and *before* "Getting unstuck". No `homeworks/` file in the schedule. |
| Extension design | Must (a) build on exactly what the activity did, (b) require changing one thing that was taught (new response variable, a subset only that student picks, a boundary case, a broken assumption), (c) keep a **handwritten predict‑then‑check + explain‑with‑your‑own‑numbers** step where the topic supports it. Budget 30–40 min. |
| Factors | Standalone module retired. ANOVA I gains ~5 slides / ~3 activity parts covering: *species is a factor*, *level order = plot order*, *alphabetical is the default*, `fct_reorder()` to order the boxplot by the response, `fct_relevel()` to set the ANOVA reference. Everything else (`fct_recode`, `fct_collapse`, `fct_lump`, the `as.numeric()` trap, `fct_reorder2`) lives only in **Common Code 15**. |
| Weeks 9–10 | Wk9: **M17 Joins (2‑day)**, M18 blank. Wk10: **M19 Mapping (2‑day)**, M20 blank. |
| Numbering | `_schedule.yml` `number:` fields are the sequence. Removing Factors and adding a blank slot shifts everything from GLM onward by +1. Folders are named by topic and never renumbered (`sync_order_from_schedule.R` handles `order:`/`week:`). |

## 2. Open questions — confirm before executing the affected part

1. **Tail cascade (weeks 11–18).** After wk10, the current order is GLM → ancova
   → pca → pca_2 → multivariate → logistic(Review) → tbd_20…30. Removing Factors
   (−1) and adding one blank slot (+1) roughly cancels, but the 2‑day Joins/2‑day
   Mapping each consume a slot that used to hold a distinct topic. **Which topics
   move where in weeks 11+?** Recommend: don't touch weeks 11+ until the
   instructor confirms; Parts B and C don't depend on it.
2. **Blank second slots.** Render as a true placeholder row (`topic: ""`, no
   files) or as a **flex/work day** pointing at `content/catchup/`? A work‑day
   framing is more useful to students. (`sync_order_from_schedule.R` stamps
   `order:` per module — reusing `catchup_lecture.qmd` in two slots means the
   last one wins the stamp; acceptable, or make a `content/flex_day/` stub.)
3. **`final_project` (M15).** It has a real deliverable (`final_project_homework`).
   Keep that as a genuine project assignment rather than converting it to a
   30–40 min extension? (Recommend: keep.)
4. **`homeworks/` folder + nav.** Once no module references a homework: delete the
   `homeworks/` tree, or keep it as an archive outside the schedule? The sidebar
   "Homeworks" link and `homeworks/index.qmd` listing get removed either way
   (see §5.4).
5. **T‑Tests I / ANOVA I** currently have **no** homework (see `COURSE_MAP.md`).
   Do they get a new extension, or stay activity‑only? (Recommend: add a light
   extension so every class day has out‑of‑class work.)
6. **Grading.** Homework was point‑weighted (e.g. "2 pts"). How are extensions
   graded — same rubric, completion, or folded into participation? Affects the
   wording of each Extension section.

---

## 3. Part A — Schedule restructure

### 3.1 Proposed `_schedule.yml` — weeks 7–10

Replace the current weeks 7–10 blocks with:

```yaml
  - week: 7
    title: ""
    modules:
      - number: "13"
        topic: "One-Way ANOVA I — Setting Up the Test (with Factors for ordering & reference)"
        lecture: content/one_way_anova/one_way_anova_lecture.qmd
        activity: content/one_way_anova/one_way_anova_activity.qmd
        # no homework: — extension lives at the end of the activity

      - number: "14"
        topic: "One-Way ANOVA II — Running & Reporting the Test"
        lecture: content/one_way_anova_2/one_way_anova_2_lecture.qmd
        activity: content/one_way_anova_2/one_way_anova_2_activity.qmd

  - week: 8
    title: ""
    modules:
      - number: "15"
        topic: "Intro to the Final Project"
        lecture: content/final_project/final_project_lecture.qmd
        activity: content/final_project/final_project_activity.qmd
        homework: homeworks/final_project_homework/final_project_homework.qmd   # keep — real project deliverable

      - number: "16"
        topic: "Lake Superior Ice"
        lecture: content/pivoting/pivoting_lecture.qmd
        activity: content/pivoting/pivoting_activity.qmd

  - week: 9
    title: ""
    modules:
      - number: "17"
        topic: "Joins — Combining Tables (2-day topic)"
        lecture: content/joins/joins_lecture.qmd
        activity: content/joins/joins_activity.qmd

      - number: "18"
        topic: ""            # blank — flex / joins work day (see open question 2)
        # lecture: content/flex_day/flex_day_lecture.qmd   # optional

  - week: 10
    title: ""
    modules:
      - number: "19"
        topic: "Mapping — Bigfoot & GBIF (2-day topic)"
        lecture: content/mapping/mapping_lecture.qmd
        activity: content/mapping/mapping_activity.qmd

      - number: "20"
        topic: ""            # blank — flex / mapping work day
```

**Removed:** the old `number: "17" topic: "Factors"` module (folder stays on disk
for now, see §4.4).

### 3.2 Tail (weeks 11+)

Everything currently numbered 20+ shifts down by one slot. **Do not execute until
open question 1 is resolved.** When ready: bump each `number:` in weeks 11–18,
add one `tbd_*` module at the end to keep 36 modules (or accept 35), then
`Rscript course_map.R`.

### 3.3 Files touched in Part A

- `_schedule.yml` (only hand‑edited file)
- `COURSE_MAP.md` (regenerated: `Rscript course_map.R`)
- Frontmatter `order:`/`week:` in the affected `.qmd`s (auto via
  `sync_order_from_schedule.R` on next render)
- `content/joins/joins_activity.qmd`, `content/mapping/mapping_activity.qmd`
  titles/recaps may say "Worksheet 17/18/19" — update the day references
- Check `check_schedule_links.R` still passes

---

## 4. Part B — Fold "Factors" into One-Way ANOVA I

### 4.1 What moves / retires / stays

| Factors content | Destination |
|---|---|
| "What a factor is", levels have an order, alphabetical is the default | **ANOVA I lecture**, new short chunk (2–3 slides) |
| `fct_infreq()` (bar order by frequency) | Common Code 15 only |
| `fct_reorder()` — order a boxplot by another variable | **ANOVA I lecture + activity** (order the mass‑by‑species boxplot by median mass) |
| `fct_rev()` | brief mention in ANOVA I; full in CC15 |
| `fct_recode()`, `fct_collapse()`, `fct_lump_n()` | Common Code 15 only |
| `as.numeric()` trap | Common Code 15 only (keep the "Getting unstuck" bullet) |
| `fct_relevel()` — set the model reference level | **ANOVA I lecture + activity** (set Gentoo as reference, show coefficients change but F/p don't) |
| `fct_drop()` — drop ghost levels after `filter()` | **ANOVA I activity**, in the Extension (subsetting drops a group) |
| `fct_reorder2()` (legend order for line plots) | Common Code 15 only |

### 4.2 `content/one_way_anova/one_way_anova_lecture.qmd` — edits

Current structure: *Chunk 1 of 2* (why ANOVA, F‑stat, meet the data, explore
boxplot) → *Chunk 2 of 2* (fit, assumptions).

1. **Retitle** the deck's chunks to **"Chunk 1 of 3 / 2 of 3 / 3 of 3"** OR weave
   factors into the existing two (leaner — preferred). Weaving plan below.
2. In **"Explore First — Boxplot by Species"** (≈ line 220): add 2 slides right
   after the first boxplot —
   - *"Your boxplot is in alphabetical order"* — `class(penguins_df$species)`,
     `levels(...)`; species is a **factor**, ggplot uses the level order.
   - *"Order the boxplot by what you're testing"* —
     `mutate(species = fct_reorder(species, body_mass_g, .fun = median))` then
     replot. One line, big readability win. Note `forcats` ships with
     `library(tidyverse)`.
3. In **"Fit the Model"** (≈ line 268): add 1 slide after the `lm()` call —
   *"Which group is the baseline?"* — `coef(mass_model)` shows `(Intercept)` =
   Adelie (alphabetically first level). `fct_relevel(species, "Gentoo")` then
   refit: coefficients change, **the overall F and p do not**. This is the
   factors idea that matters for ANOVA.
4. Add 1 closing slide to **"What We Learned Today"**: "the rest of the `forcats`
   family (`fct_recode`, `fct_collapse`, `fct_lump`, …) is in **Common Code 15**;
   pull it up when a categorical column needs cleaning."
5. Fix **"Where we left off"** (≈ line 42) — it currently says Lectures 09–11 and
   does not mention factors; no change needed, but confirm it doesn't forward‑ref
   a Factors lecture.

Target size: ~360 → ~430 lines. Keep the Predict·Type·Run framing and the
`🛑 Pause — Do Activity Parts …` markers (renumber the part ranges).

### 4.3 `content/one_way_anova/one_way_anova_activity.qmd` — edits

Current: Parts 1–6 + Review + Getting unstuck (241 lines).

1. **Part 2 (boxplot)** — after the existing plot, add a **"✏️ Your turn"**:
   reorder with `fct_reorder(species, body_mass_g, .fun = median)`, replot, note
   the new order. (~5 min.)
2. **New Part between 4 and 5** — *"Set the reference group"*:
   `coef(mass_model)` → identify baseline; `fct_relevel(species, "Gentoo")` →
   refit → compare `coef()`; confirm `anova()`/overall F unchanged.
   **✏️ Your turn:** what does `(Intercept)` mean before vs after? (~8 min.)
3. Renumber later parts; update the `🧩 Chunk … after lecture Chunk …` markers.
4. Add the factor bullets to **"Getting unstuck"**: `could not find function
   "fct_reorder"` → `library(tidyverse)`; blank gap on an axis → ghost level →
   `fct_drop()`.
5. The Extension for this module (Part C‑13) is the sex‑subset ANOVA currently in
   `homeworks/one_way_anova_homework/one_way_anova_homework.qmd` — that file is
   already the right shape; trim its Tasks 6–8 to ~35 min and drop Tasks 1–5
   (redundant with the activity).

### 4.4 Retire the standalone Factors module

1. Remove the `number: "17" topic: "Factors"` block from `_schedule.yml`.
2. `content/factors/` — **archive, don't delete yet.** Move to
   `draft_new_lectures/_archive/factors/` (out of the render — `_*` dirs are
   skipped) so the prose is available to harvest for CC15 and for the ANOVA I
   inserts. Delete after B is verified.
3. `homeworks/factors_homework/` — delete (its idea, "reorder a factor in your
   own data", becomes a one‑line ✏️ in the ANOVA I activity Extension).
4. `common_code/15_factors/factors.qmd` — keep the full reference. Trim its
   opening paragraph so it reads as a reference ("You met `fct_reorder()` and
   `fct_relevel()` in ANOVA I; here is the rest of the family"), not a lesson.
5. Grep for stale links: `grep -rn "factors_lecture\|factors_activity\|Worksheet 16\|content/factors" --include="*.qmd" .`

### 4.5 Acceptance checks for Part B

- ANOVA I lecture renders to `revealjs` + `pptx` + `docx` with no error.
- ANOVA I activity renders `html` + `docx`.
- `fct_reorder` / `fct_relevel` examples run against `palmerpenguins`.
- No schedule row references `content/factors/`.
- `COURSE_MAP.md` regenerated; row 17 is now Joins.

---

## 5. Part C — Homework → end-of-activity Extension

### 5.1 Standard Extension template

Append to every `*_activity.qmd`, after "Review and checkpoint", before "Getting
unstuck":

```markdown
------------------------------------------------------------------------

# Extension — out of class (~30–40 min)

*Turn this in with your worksheet. It builds directly on what you just did and
asks you to change one thing.*

## E1 · Push it further — <one student-specific change> (X pts)

<Same analysis as the activity, but on: a different response variable / a subset
only you pick / a boundary case / a deliberately broken assumption. State the
choice before you start.>

## E2 · Predict, then check ✍️ by hand (X pts)

**Before running E1**, on paper: predict how the result changes vs. the in-class
version and *why* (mechanism, not just direction). Photograph the page. Then run
E1 and add your actual numbers underneath, in your own hand.

## E3 · Explain it ✍️ by hand, using YOUR numbers (X pts)

Using your real output from E1 (not the class example): state H0/Ha for your
version, interpret the result in plain language, and explain why it differs from
(or matches) the in-class result given what you changed.
```

Adjust E2/E3 out where a topic has no inferential result (ggplot, wrangling,
quarto) — there, E2 becomes "predict the plot/output" and E3 becomes "explain
what each step does and what breaks if you reorder it".

### 5.2 Conversion recipe (per module)

1. Open `homeworks/<topic>_homework/<file>.qmd`. Its **"Push it further" / Task 6+
   / "Predict, then check" / "Explain it, by hand"** sections are already the
   extension — most homeworks in this repo follow that shape.
2. Copy those sections into the activity using the §5.1 template. **Drop** the
   homework's Tasks 1–5 (they duplicate the activity).
3. Trim to a 30–40 min budget: one push‑further scenario, one prediction, one
   explanation. Cut any second dataset‑loading detour.
4. Move any data files the extension needs from `homeworks/<topic>_homework/data/`
   into `content/<topic>/data/` and fix paths.
5. Delete `homeworks/<topic>_homework/` (or move to an archive per open Q4).
6. Remove the `homework:` line from that module in `_schedule.yml`.
7. Render the activity (`html` + `docx`); run every code block.

### 5.3 Week-by-week checklist

Do them in schedule order so a fresh session always knows where it is. Each row =
one commit.

| # | Module | Activity file | Homework source | Extension seed (already in the homework) |
|--:|---|---|---|---|
| 01 | introduction | `content/introduction/introduction_activity.qmd` | `homeworks/introduction_homework/sunny_shady_leaves_homework.qmd` | check file for "Push it further" |
| 02 | meeting_r | `content/meeting_r/meeting_r_activity.qmd` | `homeworks/meeting_r_homework/…` | — |
| 03 | ggplot_1 | `content/ggplot_1/ggplot_1_activity.qmd` | `homeworks/ggplot_1_homework/…` | predict‑the‑plot variant |
| 04 | ggplot_2 | `content/ggplot_2/ggplot_2_activity.qmd` | `homeworks/ggplot_2_homework/…` | — |
| 05 | wrangling | `content/wrangling/wrangling_activity.qmd` | `homeworks/wrangling_homework/wrangling_homework.qmd` | "Push It Further" + "Predict, Then Check" + "Explain It" — already perfect shape |
| 06 | summary_stats | `content/summary_stats/summary_stats_activity.qmd` | `homeworks/summary_stats_homework/…` | — |
| 07 | quarto | `content/quarto/quarto_activity.qmd` | `homeworks/quarto_homework/quarto_report_homework.qmd` | "print & reference" report task |
| 09 | t_tests (I) | `content/t_tests/t_tests_activity.qmd` | *(none today)* | write a light one (open Q5) |
| 10 | t_tests_2 (II) | `content/t_tests_2/t_tests_2_activity.qmd` | `homeworks/t_tests_homework/cisco_ttest_homework.qmd` | cisco subset t‑test |
| 11 | regression | `content/regression/regression_activity.qmd` | `homeworks/regression_homework/regression_homework.qmd` | Tasks 6–8: calibrate an object only you have + extrapolation, handwritten |
| 12 | weather | `content/weather/weather_activity.qmd` | `homeworks/weather_homework/weather_climate_homework.qmd` | your‑own‑city climate |
| 13 | one_way_anova (I) | `content/one_way_anova/one_way_anova_activity.qmd` | `homeworks/one_way_anova_homework/one_way_anova_homework.qmd` | **sex‑subset ANOVA, Tasks 6–8** — do with Part B |
| 14 | one_way_anova_2 (II) | `content/one_way_anova_2/one_way_anova_2_activity.qmd` | *(none — homework was on M14 in schedule; confirm)* | post‑hoc on a subset |
| 15 | final_project | — | `homeworks/final_project_homework/…` | **KEEP as project deliverable** (open Q3) |
| 16 | pivoting | `content/pivoting/pivoting_activity.qmd` | `homeworks/pivoting_homework/pivoting_homework.qmd` | another long‑format dataset |
| 17 | joins | `content/joins/joins_activity.qmd` | `homeworks/joins_homework/joins_homework.qmd` | Task 4 "how complete is it?" + wrong‑join diagnosis |
| 19 | mapping | `content/mapping/mapping_activity.qmd` | `homeworks/mapping_homework/gbif_mapping_homework.qmd` | "Map your own species" via `rgbif` — already a self‑contained ~40 min task; trim Part 5 interpret + Stretch |
| 21 | ancova | `content/ancova/ancova_activity.qmd` | `homeworks/ancova_homework/homework_15_tbd.qmd` | placeholder — build when module is built |
| 23 | pca_2 | `content/pca_2/pca_2_activity.qmd` | `homeworks/pca_2_homework/homework_17_tbd.qmd` | placeholder |

Modules with neither activity nor homework yet (GLM, pca, multivariate, logistic,
tbd_*) get an Extension when their activity is authored.

### 5.4 Site plumbing after homeworks are gone

- `_quarto.yml` sidebar: remove the **"Homeworks"** entry
  (`- href: homeworks/index.qmd`). Keep "Activities".
- Delete `homeworks/index.qmd` and `homeworks/_metadata.yml` (or repoint if an
  archive is kept).
- `course_map.R` / `COURSE_MAP.md`: the **H** column becomes vestigial — either
  drop it or repurpose it to mark "activity has an Extension" (recommended: keep
  the column, relabel "**E**").
- `check_schedule_links.R`: drop the homework‑path check.
- Search for stale links: `grep -rn "homeworks/" --include="*.qmd" --include="*.yml" . | grep -v _archive`
- The `activities.qmd` listing already exists and is unchanged.

---

## 6. Part D — Rendering & verification

After any batch:

```bash
Rscript course_map.R                 # regenerate COURSE_MAP.md
Rscript check_schedule_links.R        # all paths resolve
quarto render index.qmd              # homepage builds from _schedule.yml
quarto render content/one_way_anova/ # the module you changed
```

Known environment note: full‑project `quarto render` currently also needs the
`_quarto.yml` `render:` exclusion for `web_ecostats_website_2026/` to be present
(added 2026‑08‑27). `{verbatim}` example blocks require `engine: knitr` in a file
that has no other `{r}` chunk.

---

## 7. Resume instructions for a fresh session

1. Read this file top to bottom. Check §0 for where things stand.
2. Parts B and C‑13 are coupled — do them in one pass.
3. Part C is independent per module and safe to do one at a time; each module =
   one commit, checklist row in §0/§5.3.
4. Part A weeks 7–10 can go in early; **Part A tail (weeks 11+) is blocked on
   open question 1** — do not renumber weeks 11+ without instructor sign‑off.
5. Don't delete `content/factors/` or `homeworks/` trees until the dependent
   part is rendered and verified; archive under a `_`‑prefixed dir first.
6. `_schedule.yml` is the only file you hand‑edit for sequence; everything else
   (`order:`, `week:`, `COURSE_MAP.md`) is generated.
