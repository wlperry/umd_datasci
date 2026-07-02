---
title: "Worksheet 02 — Meeting R"
subtitle: "From the console to your first plot with the tree leaf data"
author: "Bill Perry"
date: today
format:
  html: default
  docx: default
---

# In-class Activity 2: Meeting R

### Recap from Activity 1

- Collected leaf samples from **sunny and shady sides** of trees
- Identified the independent variable (side of tree) and dependent variables (leaf mass, dimensions)
- Measured and recorded leaf weight, width, and height in a spreadsheet
- Agreed on column names, units, and metadata conventions
- **Finding:** shady leaves appeared larger — today we start exploring this in R

### Today's Objectives

1.  Get R and Positron installed and oriented
2.  Organize a project folder the right way — `data/`, `scripts/`, `figures/`
3.  Use R as a calculator and store values with `<-`
4.  Write and run a script with `#` comments
5.  Call functions, build vectors, understand data types
6.  Load our leaf data from Excel with `read_excel()` and from CSV with `read_csv()`
7.  Inspect a data frame with `head()`, `glimpse()`, and `dim()`
8.  Use the pipe `%>%` to chain steps
9.  Make and save a first `ggplot` figure

> # **How to use this worksheet**
>
> Work through each section at your own pace. Type the code into your script file in Positron and run it line by line. Code blocks marked **▶ Run this** are the ones you should execute. Blocks marked **✏️ Your turn** ask you to write or modify something. The **Going further** section is optional — work through it if you finish early.

------------------------------------------------------------------------

# Part 1 · Set up R and Positron

### Download and install — in this order

1.  **R** (the engine) — <https://cran.r-project.org/>
    - Choose your operating system, run the installer, accept all defaults
2.  **Positron** (the editor) — <https://positron.posit.co/download.html>
    - Install **after** R — Positron needs to find R already on your machine
    - Open Positron and verify it finds R (check the bottom status bar)

> ⚠️ **Watch out!** Install R *first*, then Positron. If you installed them in the wrong order, reinstall R and then restart Positron.

### Orient yourself in Positron

Four panes you will use constantly:

| Pane                    | Where       | What it does                       |
|-------------------------|-------------|------------------------------------|
| **Editor**              | Top-left    | Your scripts live here             |
| **Console / Terminal**  | Bottom      | Where code runs and results appear |
| **Variables / Session** | Right       | Every object you have stored       |
| **Plots**               | Right (tab) | Your figures appear here           |

✏️ **Your turn:** Click the **Console** tab. Type `1 + 1` and press Enter. What did R return?

```         
Your answer: 
```

------------------------------------------------------------------------

# Part 2 · Build your project folder

### Why a project folder?

In R we keep everything for one project together in one folder. Every file path is then *relative* to that folder — no more `C:/Users/myname/Desktop/random_stuff/final_FINAL2.xlsx` nightmares.

### Create the folder structure

On your computer, make a new folder called `tree_project`. Inside it, create these three sub-folders:

```         
tree_project/
├── data/        ← your Excel and CSV files go here
├── scripts/     ← your .R code goes here
└── figures/     ← plots you save go here
```

> 💡 **Coming from Excel?** In Excel you tend to keep one giant workbook. In R we keep raw data untouched and write *new* processed files — so you can always trace your steps and never overwrite your original numbers.

### Open the folder as your workspace in Positron

In Positron: **File → Open Folder…** and pick your `tree_project` folder.

You should see `tree_project` appear in the Explorer panel on the left.

✏️ **Your turn:** What is the full path to your `tree_project` folder on your computer?

```         
Your answer: 
```

### Copy the data file

Copy `2026_06_25_tree_experiment_raw_data.xlsx` into `tree_project/data/`.

> ⚠️ **Important:** Leave this copy alone — it is your raw data. We will read it but never overwrite it.

### Create your first script

- In Positron:
  - **File → New File → R File**.
  - Save it immediately with **Ctrl/Cmd + S**, name it `02_tree_analysis.R`,
  - and save it inside `tree_project/scripts/`.

> 💡 **Key idea:** Console = scratch paper. Script = the lab notebook you keep.

✏️ **Your turn:** What is your script named?

```         
Your answer: 
```

------------------------------------------------------------------------

# Part 3 · How R works

### R as a calculator

Type each line below into your **Console** (not the script yet) and press Enter after each one.

**▶ Run this in the Console:**

``` r
3 + 5
12 / 7
2 ^ 10
sqrt(144)
```

> ⚠️ **Watch out!** If you see a `+` at the *start* of a console line instead of the `>` prompt, R is waiting for you to finish a command. Press **Esc** to cancel and start over.

✏️ **Your turn:** What does `2 ^ 10` return? What does the `^` operator do?

```         
Your answer: 
```

------------------------------------------------------------------------

### Storing values with `<-`

To keep a value, give it a **name** using the assignment operator `<-`.

Shortcut: **Alt + −** (Windows) or **Option + −** (Mac) types `<-` for you.

**▶ Run this in the Console:**

``` r
x <- 7          # store 7 under the name x
x               # type the name to see it
x * 2           # use it in math
```

Look at the **Variables** pane on the right — `x` should appear there.

✏️ **Your turn:** Store the number `42` under the name `my_number`, then multiply `my_number` by `x`. What is the result?

``` r
# Write your code here:
```

```         
Your answer: 
```

------------------------------------------------------------------------

### Naming things well

Good names make code readable months later:

- Be explicit but not too long: `leaf_mass` not `x2`
- Cannot start with a number — `x2` ✅, `2x` ❌
- R is **case-sensitive** — `weight_g` ≠ `Weight_g`
- Use **`lower_snake_case`** — words separated by underscores, all lowercase

✏️ **Your turn:** Which of these names are valid in R? Write Y or N next to each.

```         
leaf_mass       — 
3rd_leaf        — 
Width_cm        — 
my.leaf.data    — 
side            — 
```

------------------------------------------------------------------------

### Comments with `#`

Anything to the right of `#` is **ignored by R** — it is a note for humans. Shortcut to toggle: **Ctrl/Cmd + Shift + C**.

**▶ Run this in your Script:**

``` r
# weights of four leaves, in grams
leaf_mass <- c(4, 3, 5, 7)

mean(leaf_mass)   # average leaf mass
```

> 💡 **Key idea:** If a line confused you while writing it, write a comment explaining *why* you did it.

------------------------------------------------------------------------

### Functions and arguments

A **function** is a mini-program you call by name. You feed it **arguments** (inputs) inside `( )`.

**▶ Run this in the Console:**

``` r
sqrt(10)                         # one argument
round(3.14159)                   # default: 0 decimal places → 3
round(3.14159, 2)                # two decimal places → 3.14
round(x = 3.14159, digits = 2)  # same, with named arguments
```

To get help on any function:

``` r
?round          # open the help page
args(round)     # list what arguments it takes
```

✏️ **Your turn:** Use `round()` to round `pi` (R knows `pi` by name — just type it) to 4 decimal places.

``` r
# Write your code here:
```

```         
Your answer: 
```

------------------------------------------------------------------------

### Vectors — a row of values

A **vector** is a series of values built with `c()` — the *combine* function. A spreadsheet column is really just a vector.

**▶ Run this in your Script:**

``` r
weight_g <- c(4, 3, 5, 7)          # numeric vector
side     <- c("sunny", "shady")    # character vector — needs quotes

length(weight_g)    # how many values?
class(weight_g)     # what type is it?
str(weight_g)       # structure overview
```

> ⚠️ **Watch out!** Quotes matter: `"sunny"` is text. Without quotes, R searches for an *object* named `sunny` and throws an error when it cannot find one.

✏️ **Your turn:** Make a character vector called `my_colors` with three color names of your choice. Check its `length()` and `class()`.

``` r
# Write your code here:
```

------------------------------------------------------------------------

### Data types inside vectors

Every vector holds **one type**:

| Type        | Example          | Notes                   |
|-------------|------------------|-------------------------|
| `numeric`   | `4`, `3.5`       | All numbers by default  |
| `character` | `"sunny"`        | Any text, always quoted |
| `logical`   | `TRUE` / `FALSE` | Must be all-caps        |

Mix types and R silently converts everything to the most flexible type — numbers become text, TRUE becomes 1. This can cause surprising bugs.

------------------------------------------------------------------------

# Part 4 · Packages and libraries

### What is a package?

Base R is powerful but lean. **Packages** add new functions — like apps for your phone.

**Install once** — run this in the Console (not in your script):

``` r
install.packages("tidyverse")
install.packages("readxl")
```

**Load every session** — put this at the **top of every script you write**:

``` r
library(tidyverse)   # data wrangling + ggplot2 for plotting
library(readxl)      # reading Excel files
```

> ⚠️ **Watch out!** If R says *"could not find function `read_excel`"*, you forgot `library(readxl)`. You must reload libraries every time you restart R.

**▶ Run this at the very top of your Script:**

``` r
# ── Packages ────────────────────────────────────────────────
library(tidyverse)
library(readxl)
```

✏️ **Your turn:** What message does R print after `library(tidyverse)`? Write the first line here:

```         
Your answer: 
```

------------------------------------------------------------------------

# Part 5 · Load the tree data

### Two functions — two file types

**▶ Run this in your Script:**

``` r
# ── Load data ────────────────────────────────────────────────

# Excel files (.xlsx) — needs library(readxl)
tree_df <- read_excel("data/2026_06_25_tree_experiment_raw_data.xlsx")

tree_df    # print to the console
```

> 💡 **Coming from Excel?** `read_excel()` is the bridge from your spreadsheet into R. Your sheet's first row becomes the **column names** in R.

The path `"data/..."` is *relative* to your project folder. It works on anyone's computer — not just yours.

### Also: read CSV files with `read_csv()`

Many public datasets (NOAA climate data, iNaturalist, eBird) come as `.csv` files. The tidyverse provides `read_csv()` for these:

``` r
# CSV files (.csv) — comes with tidyverse, no extra install
# noaa_df <- read_csv("data/noaa_global_yearly_temps.csv")
```

> 💡 **Key difference:** `read_excel()` needs `library(readxl)`. `read_csv()` comes with `library(tidyverse)` — no extra install needed.

------------------------------------------------------------------------

### Meet the data frame

A **data frame** is R's word for a spreadsheet-style table. Each column is a vector of one type; the rows line up.

Our `tree_df` has five columns:

| Column      | Type      | What it holds              |
|-------------|-----------|----------------------------|
| `index`     | numeric   | leaf number (1–20)         |
| `side`      | character | `"sunny"` or `"shady"`     |
| `weight_g`  | numeric   | leaf weight in grams       |
| `width_cm`  | numeric   | leaf width in centimetres  |
| `height_cm` | numeric   | leaf height in centimetres |

Pull a single column with `$`:

``` r
tree_df$weight_g     # just the weight column, as a vector
```

------------------------------------------------------------------------

# Part 6 · Inspect a new dataset

**Always eyeball a new dataset before doing any analysis.**

**▶ Run each of these in your Script:**

``` r
head(tree_df)       # first 6 rows

# glimpse() is the tidyverse way — one line per column
glimpse(tree_df)    # column names, types, first values

# Base R equivalents (give similar info)
dim(tree_df)        # (rows, columns)
names(tree_df)      # column names
str(tree_df)        # type of every column
summary(tree_df)    # min / mean / max per column
```

> 💡 **Prefer `glimpse()` over `str()`** — it is the tidyverse-friendly version and is easier to read.

✏️ **Your turn:** Answer these questions from the output above.

```         
How many rows does tree_df have?          
How many columns?                         
What type does R report for `side`?       
What is the mean weight_g?                
What is the maximum height_cm?            
```

> ⚠️ **Watch out!** If a number column shows as `<chr>` in `glimpse()`, a stray letter or comma snuck into your spreadsheet. Check your raw data file.

------------------------------------------------------------------------

# Part 7 · The pipe `%>%` — read it as "then"

The pipe sends a result straight into the next function. Read `%>%` as the word **"then"**.

**▶ Run this in your Script:**

``` r
# Simple examples — read each %>% as "then"
tree_df %>% nrow()          # take tree_df, THEN count rows
tree_df %>% names()         # take tree_df, THEN list column names
tree_df %>% summary()       # take tree_df, THEN summarize everything

# Chain multiple steps
tree_df %>%
  head(3)                   # take tree_df, THEN show first 3 rows
```

> 💡 **Two pipes — same idea:** `%>%` — from tidyverse (we use this one throughout the course) The native pipe (a vertical bar then greater-than sign) — built into R 4.1+; you will see it in code online They behave identically for everything in this course.

✏️ **Your turn:** Using the pipe, write code to show only the last 3 rows of `tree_df`. Hint: look at `tail()`.

``` r
# Write your code here:
```

In Lecture 03 we will use `%>%` with `group_by()` and `summarize()` to compute statistics by group — this is where the pipe really pays off.

------------------------------------------------------------------------

# Part 8 · Your first plot

### ggplot builds pictures in layers

Every ggplot is built in three pieces, joined with `+`:

1.  `ggplot(data, aes(...))` — which data frame, which columns map to x and y
2.  `geom_*()` — the shape to draw (points, boxes, bars, …)
3.  `labs()` — axis labels and title

**▶ Run this in your Script — the simplest possible plot:**

``` r
ggplot(tree_df, aes(x = side, y = weight_g)) +
  geom_point()
```

> ⚠️ **Watch out!** The `+` must sit at the **end** of a line, never the start. A `+` at the start causes an error.

------------------------------------------------------------------------

### Improve it one layer at a time

**▶ Run this in your Script:**

``` r
ggplot(tree_df, aes(x = side, y = weight_g)) +
  geom_boxplot() +
  geom_jitter(width = 0.15, alpha = 0.6, color = "tomato") +
  labs(x     = "Side of tree",
       y     = "Leaf weight (g)",
       title = "Sunny vs. shady leaves")
```

✏️ **Your turn:** Make the same plot but for `height_cm` instead of `weight_g`. Copy the code above and change the relevant parts.

``` r
# Write your modified code here:
```

What pattern do you see — do sunny or shady leaves tend to be taller?

```         
Your answer: 
```

------------------------------------------------------------------------

### Save your plot as a PNG

Store the plot in an object, then save it to your `figures/` folder.

**▶ Run this in your Script:**

``` r
# Save the weight plot — always use PNG, always use dpi = 300
weight_plot <- ggplot(tree_df, aes(x = side, y = weight_g)) +
  geom_boxplot() +
  geom_jitter(width = 0.15, alpha = 0.6, color = "tomato") +
  labs(x     = "Side of tree",
       y     = "Leaf weight (g)",
       title = "Sunny vs. shady leaves")

ggsave("figures/leaf_weight.png",
       plot   = weight_plot,
       width  = 6,
       height = 6,
       units  = "in",
       dpi    = 300)
```

Check your `figures/` folder — the PNG should be there.

> ⚠️ **Watch out!** `ggsave()` wants the **filename first**, then `plot =`. Mixing that order is the classic first-save mistake.

> 💡 **Always use `dpi = 300`** — that is publication quality (300 dots per inch). The default (72 dpi) looks blurry in reports and on posters.

------------------------------------------------------------------------

# Part 9 · Review and checkpoint

At this point you can:

- [ ] Set up R and Positron and orient yourself in the four panes
- [ ] Build a project folder with `data/`, `scripts/`, `figures/`
- [ ] Use R as a calculator and store values with `<-`
- [ ] Write a script with `#` comments, save it, and re-run it
- [ ] Call functions with arguments and use `?` for help
- [ ] Build numeric and character vectors with `c()`
- [ ] Install and load packages with `install.packages()` and `library()`
- [ ] Load an Excel file with `read_excel()` and understand how `read_csv()` differs
- [ ] Inspect a data frame with `glimpse()`, `head()`, `dim()`
- [ ] Use the pipe `%>%` to chain steps together
- [ ] Build a `ggplot` boxplot and save it as a PNG with `dpi = 300`

✏️ **Your turn — before you move on:** Run the full script from top to bottom by pressing **Ctrl/Cmd + Shift + Enter** (runs the whole file). Does it complete without errors?

```         
Did it run cleanly? Y / N
If not, what error did you see?
```

------------------------------------------------------------------------

# Part 10 · Going further — more plotting

> This section is optional — work through it if you finish early or want to explore. There are no wrong answers here; the goal is to see what ggplot can do.

### Scatter plots — two numeric variables

**▶ Try this:**

``` r
ggplot(tree_df, aes(x = width_cm, y = height_cm, color = side)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(x     = "Leaf width (cm)",
       y     = "Leaf height (cm)",
       color = "Side of tree",
       title = "Leaf dimensions by side of tree")
```

✏️ **Your turn:** Does width predict height? Do the two groups cluster separately or overlap?

```         
Your observation: 
```

------------------------------------------------------------------------

### Add a trend line

**▶ Try this:**

``` r
ggplot(tree_df, aes(x = width_cm, y = height_cm, color = side)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(x     = "Leaf width (cm)",
       y     = "Leaf height (cm)",
       color = "Side of tree",
       title = "Leaf dimensions with regression lines")
```

✏️ **Your turn:** Do the slopes look similar or different for sunny vs. shady leaves? What might that mean biologically?

```         
Your observation: 
```

------------------------------------------------------------------------

### Violin plots

**▶ Try this:**

``` r
ggplot(tree_df, aes(x = side, y = weight_g, fill = side)) +
  geom_violin(alpha = 0.5) +
  geom_jitter(width = 0.1, size = 2) +
  labs(x     = "Side of tree",
       y     = "Leaf weight (g)",
       title = "Violin plot of leaf weight") +
  theme(legend.position = "none")
```

✏️ **Your turn:** What does the width of the violin show you that a boxplot does not?

```         
Your observation: 
```

------------------------------------------------------------------------

### Facets — small multiples

Facets split one plot into panels, one per group.

**▶ Try this:**

``` r
ggplot(tree_df, aes(x = weight_g)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  facet_wrap(~side, ncol = 1) +
  labs(x     = "Leaf weight (g)",
       y     = "Count",
       title = "Distribution of leaf weight by side")
```

✏️ **Your turn:** Do the histograms look roughly symmetric, or skewed? Are the shapes similar between sunny and shady?

```         
Your observation: 
```

------------------------------------------------------------------------

### Themes — change the look

ggplot comes with built-in themes. Try swapping by adding one to any plot above:

``` r
+ theme_bw()          # clean, white background
+ theme_minimal()     # very minimal, no border
+ theme_classic()     # classic axis lines, no grid
+ theme_dark()        # dark background
```

✏️ **Your turn:** Which theme do you prefer for this kind of biological comparison data? Why?

```         
Your answer: 
```

------------------------------------------------------------------------

### Save a scatter plot as PNG

**▶ Try this:**

``` r
scatter_plot <- ggplot(tree_df, aes(x = width_cm, y = height_cm, color = side)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(x = "Leaf width (cm)", y = "Leaf height (cm)", color = "Side") +
  theme_bw()

ggsave("figures/leaf_dimensions_scatter.png",
       plot   = scatter_plot,
       width  = 7,
       height = 5,
       units  = "in",
       dpi    = 300)
```

✏️ **Your turn:** Why do we save as `.png` rather than `.pdf` for most class submissions?

```         
Your answer: 
```

------------------------------------------------------------------------

# What your finished project folder looks like

After working through this worksheet your `tree_project/` folder should contain:

```         
tree_project/
├── data/
│   └── 2026_06_25_tree_experiment_raw_data.xlsx   <- never touch this
├── scripts/
│   └── 02_tree_analysis.R                          <- your complete script
└── figures/
    ├── leaf_weight.png                             <- Part 8
    └── leaf_dimensions_scatter.png                 <- Going further
```

This is the project structure we will use **for every analysis** in this course:

| Folder     | Contents        | Rule                           |
|------------|-----------------|--------------------------------|
| `data/`    | All data files  | Read only — never overwrite    |
| `scripts/` | `.R` code files | One script per topic           |
| `figures/` | Saved plots     | Always PNG, always `dpi = 300` |

------------------------------------------------------------------------

# Getting unstuck

When code breaks — and it will, that is normal — try these in order:

1.  **Read the error message out loud.** R usually names the line and the problem.
2.  **Check the usual suspects:** Did you load `library(tidyverse)` and `library(readxl)`? Spelling? Missing `)` or `+` at the *start* of a line?
3.  **`?function_name`** opens the built-in help page.
4.  **Tidyverse cheat sheets** — <https://posit.co/resources/cheatsheets/>
5.  **Bring the exact error** (copy-paste it) to class or office hours.

> 💡 **Key idea:** Every working data scientist googles error messages daily. Getting stuck is not failing — it is the job.

------------------------------------------------------------------------

*End of Worksheet 02. Next: Worksheet 03 will cover the core tidyverse wrangling verbs — `filter()`, `select()`, `mutate()`, `arrange()` — and then descriptive statistics on our leaf data.*