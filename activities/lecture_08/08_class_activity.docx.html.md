---
title: "Lecture 08 — Your Final Project Starts Now"
subtitle: "Finding real data, asking a real question, and building toward a real answer"
author: "Bill Perry"
date: today
format:
  revealjs:
    output-ext: "slides.html"
    theme: simple
    slide-number: true
    fig-format: png
    fig-width: 5
    fig-height: 3.8
    code-overflow: wrap
    highlight-style: github
  docx: default
  pptx: default
execute:
  echo: true
  warning: false
  message: false
---


::: {.cell}

:::


# Where We Left Off (Lecture 07)

- **`pivot_longer()`** — collapsed a 53-column wide file into tidy long data R can actually work with
- **`pivot_wider()`** — turned long data back into a human-readable summary table
- **Date wrangling** — ice seasons cross the new year; `if_else()` + `ymd()` fixed the calendar
- **`slice_max()`** — pulled the peak ice-cover day from each year
- **`lm()`** again — modeled whether annual maximum ice cover on Lake Superior is declining

::: callout-note
**✅ Transition**

Every dataset we've used so far — leaf morphology, Cisco fish, Duluth weather, Lake Superior ice — was handed to you.

**Today you start finding your own! That you will clean and analyze!**
:::

# Goals for Today

:::::: columns
:::: {.column width="60%"}
- Understand what makes a **good final project dataset** and question
- See a gallery of data sources — serious ecology/science **and** fun cryptid options
- Learn the **project milestone structure** — five deliverables spread over the next five weeks
- Understand what each milestone requires before you submit
- Leave today with at least **three dataset candidates** in mind

::: callout-tip
**🖐 Today's action**

Before you leave, write down one dataset you're seriously considering and the question you'd ask with it.
:::
::::

::: {.column width="40%"}
**No new R code today.**

This lecture is about *thinking like a data scientist* — asking a question first, then finding the data that can answer it.

📖 R4DS Ch. 1 — [The whole game](https://r4ds.hadley.nz/whole-game)

> *"The best dataset is the one you can't stop thinking about."*
:::
::::::

# What Is the Final Project?

::::: columns
::: {.column width="60%"}
Over the next five weeks you will work independently on a dataset of your choice. The final product is a **reproducible report** that includes:

- A clear **biological or scientific question**
- Data downloaded or imported **in R** (no Excel pre-processing)
- **Exploratory visualizations** — raw plots, summaries, distributions
- At least **one statistical analysis** appropriate to your question (regression, t-test, ANOVA, or similar)
- **Assumption checks** on your statistical model
- A short **written interpretation** of your results

This is exactly the workflow you've been building all semester — applied to something *you* care about.
:::

::: {.column width="40%"}
**What you are NOT required to do:**

- Find a perfect, spotless dataset (messy is fine — cleaning is a skill)
- Do something that no one has done before - no example data and code examples
- Use more than one analysis method

**What you ARE required to do:**

- Have a dataset with at least **50 rows** and at least **3 variables**
- Be able to state your hypothesis as H₀ and Hₐ before you analyze
- Submit every milestone on time — partial credit only if submitted
:::
:::::

# The Five Milestones

:::::: columns
::: {.column width="60%"}
| \# | What's due | When |
|----|----|----|
| **M1** | Dataset proposal — 1 paragraph + link | **DATES** |
| **M2** | Data in R — loaded, glimpsed, first raw plot | **DATES** |
| **M3** | Cleaned data + exploratory figures | **DATES** |
| **M4** | Statistical analysis + assumption checks | **DATES** |
| **M5** | Final Quarto report, knitted to HTML, presentations. | **Week Prior to finals** |

Each milestone builds directly on the last — M2 cannot happen if M1 isn't approved.
:::

:::: {.column width="40%"}
**Why milestones and not one big deadline?**

- Professional data projects always have checkpoints
- It forces you to start — the hardest part of any project
- Each piece is graded on its own, so a rough M2 doesn't sink your M5
- You get feedback from me before the next step, not after everything is done

::: callout-important
**M1 is due at the START of DATE\_\_\_\_\_\_\_\_\_\_\_\_\_.**
:::
::::
::::::

# Milestone 1 — What You Need to Submit

::::: columns
::: {.column width="60%"}
A **short paragraph** (5–8 sentences) containing:

1.  The **name and source URL** of your dataset
2.  How many **rows and columns** it has (look this up on the source website or download and `glimpse()`)
3.  The **key variables** you plan to use — what is your X? What is your Y?
4.  Your **biological or scientific question** in plain English
5.  Your **null and alternate hypotheses** (H₀ and Hₐ)
6.  Which **statistical approach** you think you'll use (regression, t-test, ANOVA, or other)
7.  Sketch of the take home graph

Submit as a Word file to Canvas.
:::

::: {.column width="40%"}
**Example M1 paragraph:**

> "I plan to use the BFRO Bigfoot sighting dataset (kaggle.com, \~5,000 rows), which records the date, state, season, and classification of each sighting. My key variables are season (X) and sighting count (Y). My question is: do Bigfoot sightings peak in summer compared to other seasons? H₀: sighting frequency does not differ by season. Hₐ: sighting frequency differs by season. I plan to use a one-way ANOVA or chi-square test on sighting counts grouped by season."

One paragraph. That's it. I'll respond with approved / revise before M2 is due.
:::
:::::

# What Makes a Good Project Dataset?

::::: columns
::: {.column width="60%"}
**It should have:**

- At least **50 rows** (more is better — 200–2,000 is ideal for beginners)
- At least one **numeric response variable** (the thing you want to explain)
- At least one **predictor** — either numeric (for regression) or categorical with 2+ levels (for t-test/ANOVA)
- A **question you can actually answer** with the methods we've covered
- A graph and analysis you can do

**Watch out for:**

- Datasets with only counts or percentages (hard to do regression or ANOVA on directly)
- Datasets where every row is a country or a year (too few observations)
- Datasets with hundreds of columns but only 20 rows (more variables than data)
:::

::: {.column width="40%"}
**Good question types for this course:**

| Question                               | Method             |
|----------------------------------------|--------------------|
| Does Y increase with X?                | Regression         |
| Does group A differ from group B on Y? | t-test             |
| Does Y differ across 3+ groups?        | ANOVA              |
| Does Y change over time?               | Regression on year |
| How does Y depend on both X and group? | ANCOVA (optional)  |

Any of these — applied to data you find interesting — is a valid project.
:::
:::::

# Data Sources: Ecology and Environmental Science

:::::: columns
::: {.column width="60%"}
**These are peer-reviewed and citable — great for biology-related questions:**

- 🌿 **GBIF** — Global Biodiversity Information Facility\
  Species occurrence records worldwide, 2+ billion observations\
  `gbif.org` — download by species, region, or date range
- 🌊 **EDI Repository** — Environmental Data Initiative\
  Long-term ecology datasets, many already tidy\
  `edirepository.org`
- 🌱 **NEON** — National Ecological Observatory Network\
  Standardized ecological data across 81 US sites\
  `data.neonscience.org`
- 📦 **Dryad** — data behind published papers\
  Every dataset comes with a real paper you can cite\
  `datadryad.org`
- 🔬 **Zenodo** — open research data from labs worldwide\
  `zenodo.org`
- Figshare - <https://figshare.com/>
:::

:::: {.column width="40%"}
**Good for regression or ANOVA questions like:**

- Does plant height differ between disturbed and undisturbed sites?
- Does bird species richness decrease with latitude?
- Has the first flowering date of a species shifted over time?
- Is fish abundance correlated with water temperature?

::: callout-tip
NEON and EDI data are especially good — they're already in tidy, well-documented CSV format and many come with R vignettes.
:::
::::
::::::

# Data Sources: Ecology and Environmental Science (cont.)

::::: columns
::: {.column width="60%"}
- 🧊 **NOAA-GLERL Great Lakes Ice**\
  Daily ice cover for all five lakes back to 1973\
  `glerl.noaa.gov/data/ice`\
  *Great Lakes Superior, Michigan, Huron, Erie, Ontario — each a different story*

- 🐟 **LTER Network** — Long Term Ecological Research\
  Fish, invertebrate, and plankton counts from dozens of sites\
  `lternet.edu/data or`- <https://lternet.edu/using-lter-data/>

- 🌡️ **Berkeley Earth**\
  Global land temperature anomalies by country and city\
  `berkeleyearth.org/data`

- 🐦 **eBird** — Cornell Lab of Ornithology\
  500M+ bird observation records globally\
  `ebird.org/science/use-ebird-data`
:::

::: {.column width="40%"}
**The Great Lakes ice option in particular:**

You already know how to load and pivot `sup.txt` — the exact same code works for `mic.txt`, `hur.txt`, `eri.txt`, and `ont.txt`.

Possible questions: - Does Lake Erie lose more ice per decade than Lake Superior? - Which lake shows the strongest trend in maximum ice cover? - Has the timing of peak ice changed since 1973?

This is a low-barrier entry since the hard code work is already done.
:::
:::::

# Data Sources: Fun and Engaging 👽🦶☕

:::::: columns
::: {.column width="60%"}
**These are popular with students and very workable statistically:**

- 👣 **Bigfoot / BFRO Sightings**\
  \~5,000 reports with date, state, season, classification (A/B/C), weather\
  `kaggle.com/datasets/mexwell/bigfoot-sightings`\
  *ANOVA on sightings by season; regression of count on year; t-test by class type*

- 👽 **UFO Sightings — NUFORC**\
  88,000+ reports with date, location, shape, duration\
  `kaggle.com/datasets/joebeachcapital/ufo-sightings`\
  *How has sighting frequency changed over time? Does duration differ by shape?*

- ☕ **Coffee Reviews**\
  Cupped coffee scores, country of origin, altitude, processing method\
  `kaggle.com` — search "coffee quality dataset"\
  *Does altitude predict quality score? Does processing method matter (ANOVA)?*

- 🎮 **Video Game Sales**\
  Sales figures by platform, genre, region, year — 16,000 titles\
  `kaggle.com` — search "video game sales"\
  *Does genre predict sales? Has the platform landscape shifted over time?*
:::

:::: {.column width="40%"}
**Why these work for this course:**

- Clean enough to load with `read_csv()` directly
- Have clear categorical and numeric variables
- Produce obvious testable hypotheses
- Students actually want to look at the results

::: callout-note
You don't have to study biology to do a biology data science course project. The methods are the same regardless of the data.
:::
::::
::::::

# Data Sources: General and Exploratory

::::: columns
::: {.column width="60%"}
- 🌍 **Our World in Data**\
  Country-level indicators: health, climate, economics, education\
  `ourworldindata.org/data` — all downloadable as CSV\
  *Global trends; great for regression of any indicator over time*

- 📊 **FiveThirtyEight**\
  Sports, politics, culture — all their story data is public\
  `github.com/fivethirtyeight/data`\
  *Dozens of clean CSVs; each has a published story as inspiration*

- 🏈 **Sports Reference**\
  Player and team stats for NFL, NBA, MLB, NHL\
  `sports-reference.com`\
  *Does salary predict performance? Regression all day.*

- 🚲 **Bike Sharing** (UCI ML Repository)\
  Hourly bike rental counts, weather, season — 17,000 rows\
  `archive.ics.uci.edu`\
  *Regression: does temperature predict rentals? ANOVA across seasons?*

- 🔬 **Figshare**\
  Research data across all fields — often from published papers\
  `figshare.com`
:::

::: {.column width="40%"}
**And the one your professor can't stop you from using:**

- 🏔️ **Kaggle** — the world's largest public dataset repository\
  `kaggle.com/datasets`\
  Free account required to download\
  Filter by: file type → CSV; size → small (under 10 MB to start)

**Google Dataset Search:**\
`datasetsearch.research.google.com`\
Search any topic and find datasets across dozens of repositories at once.
:::
:::::

# What Kind of Question Should You Ask?

::::: columns
::: {.column width="60%"}
A good project question has three parts:

1.  **A response variable (Y)** — something you can measure or count
2.  **A predictor (X)** — something that might explain Y
3.  **A direction** — does more X lead to more (or less) Y? Or does Y differ across groups?

**Examples of strong questions:**

- Do Bigfoot sightings in summer outnumber those in winter? *(ANOVA)*
- Has the number of UFO sightings increased since the 1990s? *(regression on year)*
- Does the altitude of a coffee farm predict its cupping score? *(regression)*
- Does Lake Erie show a stronger ice-loss trend than Lake Superior? *(compare two slopes)*
- Does bird species richness differ between NEON forest and grassland sites? *(t-test)*
:::

::: {.column width="40%"}
**Avoid questions like:**

- "What is interesting about this dataset?" — too vague for H₀/Hₐ
- "Which state has the most UFO sightings?" — descriptive, not inferential
- "Is climate change real?" — not answerable with one dataset

**A useful test:**

Can you write H₀ and Hₐ in one sentence each? If yes, you have a testable question. If not, keep narrowing.

📖 R4DS Ch. 1.1 — framing a data science question
:::
:::::

# The Workflow You Already Know

:::::: columns
::: {.column width="60%"}
Every milestone maps to something you've already done in this class:

| Milestone | Skill you already have |
|-----------------------|-------------------------------------------------|
| M1 — find dataset, state hypotheses | Lecture 01 — null vs. alternate hypotheses |
| M2 — load in R, `glimpse()`, first plot | Lecture 02/03 — `read_csv()`, `ggplot()` |
| M3 — clean + exploratory figures | Lecture 03/04 — `filter()`, `mutate()`, boxplots |
| M4 — statistical model + assumption checks | Lecture 05/06 — `lm()`, residual plots, `lm()` |
| M5 — Quarto report knitted to HTML | Every lecture — you've been doing this all semester - **MAYBE!!!!!!** |

**You are not learning new tools for the final project. You are applying tools you already have to data you chose.**
:::

:::: {.column width="40%"}
::: callout-important
**The biggest mistake in final projects:**

Waiting until Milestone 3 to actually open the data in R.

If you can't load the file and run `glimpse()` in the first week, you will not be able to finish. M2 is your early warning system — take it seriously.
:::
::::
::::::

# Choosing Wisely — A Practical Checklist

::::: columns
::: {.column width="60%"}
Before you write your M1 proposal, answer these five questions:

- [ ] Can I download this data as a CSV (or similar) **right now**?
- [ ] Does `dim()` return at least **50 rows and 3 columns**?
- [ ] Can I identify a **numeric Y variable** I want to explain?
- [ ] Can I identify at least one **X predictor** (numeric or categorical)?
- [ ] Can I write a **one-sentence hypothesis** using those variables?

If all five are yes — you have a viable dataset. Submit M1.

If any are no — keep looking, or come to office hours.
:::

::: {.column width="40%"}
**Practical tip — test your download now:**

``` r
# Try loading your candidate dataset this week ---
test_df <- read_csv("path/to/your/file.csv")

glimpse(test_df)
dim(test_df)
head(test_df)
```

If `read_csv()` throws an error, you want to know that **before** M1, not after.

If the file needs `read.table()` or special arguments (like our ice data did), that's fine — but discover it early.
:::
:::::

# Common Pitfalls and How to Avoid Them

:::::: columns
::: {.column width="60%"}
**"I can't find a dataset I like"** - Try Google Dataset Search first: `datasetsearch.research.google.com` - Search for a topic you're already interested in + the word "data" or "csv" - Come to office hours with a general topic — I can usually point you to a source in five minutes

**"My dataset is too messy to analyze"** - Messy is fine for this course — cleaning is the first two milestones - If you can `read_csv()` it and `glimpse()` it, you can work with it - You don't need every column — a well-chosen `select()` is enough

**"I can't figure out what question to ask"** - Start with the variables: what is numeric? What is categorical? - Ask: "what would I predict, before looking at the data?" - That prediction is your Hₐ; its opposite is H₀
:::

:::: {.column width="40%"}
**"My dataset only has two columns"** - You need at least one X and one Y — two columns *can* be enough for regression - But usually: look for a richer version of the same dataset on the same source

**"I already started analyzing before M1 was approved"** - Submit M1 anyway — describe what you've done so far - I'll either approve it or redirect you before you go further

::: callout-tip
**Office hours exist for this.** If you're stuck on finding or loading a dataset, come in. Don't wait until the M2 deadline.
:::
::::
::::::

# What a Strong Final Project Looks Like

::::: columns
::: {.column width="60%"}
**From past semesters, strong projects have:**

- A **clear narrative** — the report tells a story from question to answer
- **Figures that do the talking** — the key result is visible in a plot before the stats confirm it
- **Simple, correct statistics** — one well-interpreted `lm()` beats three confused ones
- **Honest interpretation** — "the trend was not significant (p = 0.12), which may reflect the small sample size" is a perfectly valid finding
- **Code that runs** — the Quarto file knits to HTML without errors, every time

**Things that do not make a strong project:** - Many analyses none of which are interpreted - A significant p-value with no plot showing the actual effect - Copied code from Stack Overflow that you can't explain
:::

::: {.column width="40%"}
**The question you will be graded on:**

> "Does this report tell me something real about this dataset, using tools from this class, in a way I could reproduce?"

That's it. Not complexity. Not novelty. **Clarity + reproducibility.**

📖 R4DS Ch. 28 — [Quarto formats: making a final report](https://r4ds.hadley.nz/quarto-formats)
:::
:::::

# Summary: What to Do This Week

:::::: columns
::: {.column width="60%"}
**By end of this week:**

1.  Visit at least **three** of the dataset sources shown today
2.  Download a candidate dataset and confirm `read_csv()` loads it
3.  Identify your Y variable, your X variable, and write one sentence of hypothesis
4.  Write your **Milestone 1 paragraph** (see the template on the next slide)
5.  Submit M1 to Canvas **before the start of Lecture 09**

**Resources:**

- Dataset source list (this slide deck, downloadable)
- Office hours — come with a topic or a link, leave with a plan
- Canvas discussion board — post a candidate dataset and get peer feedback
:::

:::: {.column width="40%"}
**Milestone 1 is due: start of Lecture 09**

It is short. It is low stakes. It is not optional.

The purpose is to make sure you have a working dataset **before** you write any analysis code. Every semester, students who skip or delay M1 struggle at M4 and M5.

::: callout-important
Two class periods from now. Write it this weekend.
:::
::::
::::::

# Milestone 1 Template

::::: columns
::: {.column width="60%"}
Copy this into a Word doc or text file and fill in the blanks:

> "I plan to use the **\[dataset name\]** dataset, available at **\[URL\]**. It contains approximately **\[n rows\]** observations and **\[n columns\]** variables. The key variables I plan to use are **\[X variable\]** as my predictor and **\[Y variable\]** as my response. My research question is: **\[your question in plain English\]**. My null hypothesis is that **\[H₀ in one sentence\]**, and my alternate hypothesis is that **\[Hₐ in one sentence\]**. I plan to use **\[regression / t-test / ANOVA / other\]** to test this. I have confirmed I can load this file into R using `read_csv()` \[or describe what function you used\]."
:::

::: {.column width="40%"}
**What happens after you submit:**

- I read all M1 proposals within 48 hours
- I reply with one of:
  - ✅ **Approved** — proceed to M2
  - 🔄 **Revise** — one specific thing to change, resubmit by \[date\]
  - ❌ **Not viable** — I'll suggest an alternative source

Most proposals get approved. The revision requests are almost always about the hypothesis being too vague.
:::
:::::