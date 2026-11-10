# ==========================================================
# Activity 22 - PCA II: loadings, scores, and the biplot
# Name:
# Date:
#
# Save as scripts/22_pca_2.R
#
# EVERY LINE OF CODE IS ALREADY WRITTEN. You do not have to
# write any of it. Run it one chunk at a time, top to
# bottom, and read the notes.
#
# After each chunk there is a block headed
#
#     WHAT YOU ARE LOOKING AT
#
# That block tells you how to read the output. That is the
# real content of today.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file:
#   22_pca_2_homework.R
#
# ----------------------------------------------------------
# STILL NO P-VALUES
#
# PCA is not a test. Today the whole job is INTERPRETATION:
# looking at numbers and deciding what they mean. There is
# no output that will tell you whether you got it right.
# ----------------------------------------------------------
# Install this ONCE, from the Console, BEFORE class:
# install.packages("ggrepel")
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(ggrepel)   # labels that do not sit on top of each other

invisible(NULL)


# ---- 1 Re-run last class's PCA ---------------------------
# Every script starts from the raw data. Nothing today
# depends on objects left over in last class's session.
#
# If a script only works because of something you ran
# yesterday, it is broken - you just cannot see it yet.

pokemon <- read_csv("data/pokemon_151.csv")

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed)

poke_pca <- prcomp(poke_stats, center = TRUE, scale. = TRUE)

summary(poke_pca)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# Exactly what we had last class, so we know we are starting
# from the same place:
#   PC1  39.6%
#   PC2  21.5%
#   together 61.1%
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 1 - reading the loadings
# ##########################################################

# ---- 2 The loadings table --------------------------------

round(poke_pca$rotation[, 1:3], 2)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# One row per original stat, one column per PC. A LOADING is
# how much that stat contributes to that axis.
#   big number  -> matters a lot to that axis
#   near zero   -> barely involved
#   the SIGN    -> which direction
#
# PC1 COLUMN - read down it:
#   sp_defense  0.54
#   sp_attack   0.45
#   attack      0.42
#   hp          0.38
#   speed       0.32
#   defense     0.28
#
# Every one POSITIVE, none of them tiny. To score high on
# PC1 you must be high on EVERYTHING.
#
# THE RULE FOR ALL-POSITIVE: an axis where every loading
# shares a sign is a "TOTAL" axis - overall size, overall
# strength, overall abundance. You will see this constantly.
# PC1 is very often a total, because the single biggest way
# things differ is usually just how much of them there is.
#
# PC2 COLUMN - read down it:
#   defense    +0.59   <- big positive
#   attack     +0.43   <- big positive
#   hp         +0.19
#   sp_defense -0.17
#   sp_attack  -0.33   <- big negative
#   speed      -0.54   <- big negative
#
# THE RULE FOR MIXED SIGNS: mixed signs mean a TRADE-OFF,
# not a total. PC2 is not measuring HOW MUCH. It is
# measuring WHICH KIND - being strong in one way INSTEAD of
# another.
#
#   high PC2 = defense + attack
#   low  PC2 = speed + sp_attack
#
# NAMING IT
# High PC2 = tough and hard-hitting but slow. Low PC2 =
# fast and special-attacking but fragile. Anyone who has
# played the game has names for these:
#
#   high PC2 -> a TANK
#   low  PC2 -> a GLASS CANNON
#
# PC2 is a "tank <-> glass cannon" axis, and it carries
# 21.5% of all the variation in six columns.
#
# BUT: YOU named it. The maths did not. prcomp() returned a
# column of numbers labelled PC2; it has no idea what a tank
# is. Naming an axis is interpretation and it is YOUR
# responsibility. It is also the most valuable thing you do
# in a PCA - and the easiest place to fool yourself.
# ---------------------------------------------------------

invisible(NULL)


# ---- 3 Prove the PC2 name from the data ------------------

poke_scores <- pokemon %>%
  mutate(PC1 = poke_pca$x[, 1],
         PC2 = poke_pca$x[, 2])

poke_scores %>%
  arrange(desc(PC2)) %>%
  select(name, defense, speed, PC2) %>%
  head(4)

poke_scores %>%
  arrange(PC2) %>%
  select(name, defense, speed, PC2) %>%
  head(4)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# TOP OF PC2: rhydon, golem, cloyster, rhyhorn.
#   defence 95 to 180, speed 25 to 70. Rocks.
#
# BOTTOM OF PC2: abra, kadabra, alakazam, jynx.
#   defence 15 to 45, speed 90 to 120.
#
# Alakazam is the fastest, most fragile special attacker in
# the game. Golem is a literal boulder. They sit at opposite
# ends of an axis built from nothing but six columns of
# numbers.
#
# THE TWO-STEP, EVERY TIME:
#   1. read the loadings  -> form a guess about the meaning
#   2. look at the extremes -> check the guess against
#                              things you already know
# Do them in that order. If step 2 disagrees with step 1,
# BELIEVE STEP 2.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 2 - finally, the picture
# ##########################################################

# ---- 4 The plot we have been working towards -------------

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.7)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# Every dot is ONE POKEMON. Neither axis is a thing anyone
# measured - both were invented by prcomp().
#
#   left <-> right  = weak <-> strong        (PC1, 39.6%)
#   bottom <-> top  = glass cannon <-> tank  (PC2, 21.5%)
#
# Two dots close together = two Pokemon with SIMILAR STAT
# PROFILES OVERALL. That is the question we could not answer
# with 15 pairwise scatterplots.
#
# This one flat picture holds 61% of six columns.
#
# THE ORIGIN IS AVERAGE. The scores were centred, so (0, 0)
# is the average Pokemon - not zero power. A dot at the far
# left is not "no stats", it is well BELOW AVERAGE.
#
# Scores are in standard deviations, which is why they run
# roughly -3.5 to +3.5.
# ---------------------------------------------------------

invisible(NULL)


# ---- 5 Colour by something you know ----------------------

ggplot(poke_scores, aes(x = PC1, y = PC2, color = is_legendary)) +
  geom_point(alpha = 0.7, size = 2)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# The four legendaries sit in a cluster at the FAR RIGHT -
# high PC1 - and slightly LOW on PC2. So the game's
# strongest Pokemon are not just powerful; they lean a
# little towards the fast, special-attacking side rather
# than the tank side.
#
# IMPORTANT: nothing in the PCA knew which Pokemon were
# legendary. The is_legendary column was never given to
# prcomp() - look back at section 1, poke_stats has six
# columns and that is not one of them. We only used it to
# COLOUR the finished result.
#
# THAT IS THE RIGHT WAY ROUND. Build the axes from the
# MEASUREMENTS only, then colour by the thing you care about
# and see whether it lines up. Put the grouping variable
# INTO the PCA and you have built the answer you wanted -
# the same circular trap as the weta's head_length.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 3 - label the interesting ones
# ##########################################################

# ---- 6 Pick the extremes ---------------------------------
# Labelling all 151 gives you a solid black rectangle. So
# label only the extremes - the ones furthest from the
# centre, which are the ones a reader will ask about.
#
# abs(PC1) is distance from centre, ignoring direction.
# quantile(abs(PC1), 0.97) is the value only 3% exceed.
# Together: "far from average on PC1, either way".

extremes <- poke_scores %>%
  filter(abs(PC1) > quantile(abs(PC1), 0.97) |
         abs(PC2) > quantile(abs(PC2), 0.97))

nrow(extremes)

extremes %>%
  select(name, PC1, PC2)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# A short list - the handful of Pokemon far from average on
# either axis. The | in the filter means OR, so a Pokemon
# qualifies by being extreme on EITHER axis, not both.
#
# Change 0.97 to 0.90 and you get more labels; change it to
# 0.99 and you get fewer. There is no correct value - it is
# a readability decision, and you should pick it by looking
# at the plot.
# ---------------------------------------------------------

invisible(NULL)


# ---- 7 Label just those ----------------------------------

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(color = "grey70") +
  geom_point(data = extremes, color = "firebrick") +
  geom_text_repel(data = extremes, aes(label = name), size = 3)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# Three layers, and the ORDER MATTERS - later layers draw on
# top of earlier ones:
#   1. all 151 points, grey, in the background
#   2. the extremes, on top, in red
#   3. names, only for the extremes
#
# geom_text_repel() is ggrepel's version of geom_text(). It
# nudges labels apart so they do not sit on top of each
# other, and draws a little line back to the dot.
#
# NOTE `data =` INSIDE A LAYER. Each geom_ can take its OWN
# data =. Give it one and that layer ignores the data in
# ggplot(). That is how you draw two different subsets on
# one plot - and it works for every geom, not just these.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 4 - the biplot
# ##########################################################

# ---- 8 Turn the loadings into arrows ---------------------
# Our plot shows WHERE POKEMON SIT. It does not show WHICH
# DIRECTION each original stat points. A biplot draws both:
#   points = the Pokemon (the scores)
#   arrows = the original stats (the loadings)
#
# R has a built-in biplot(poke_pca), but it is ugly and hard
# to control. Building it from the loadings means you know
# exactly what the arrows ARE.

arrows_df <- as_tibble(poke_pca$rotation[, 1:2], rownames = "stat") %>%
  mutate(PC1 = PC1 * 4,
         PC2 = PC2 * 4)

arrows_df

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# The same six loadings from section 2, in a data frame so
# ggplot can draw them, with every value multiplied by 4.
#
# WHY * 4: loadings run about -0.6 to +0.6. The scores run
# about -3.5 to +3.5. Draw the arrows at their true length
# and they vanish into a dot at the centre.
#
# Multiplying by 4 is PURELY COSMETIC. It changes the
# arrows' LENGTHS ON SCREEN, never their DIRECTIONS - and
# the directions are the part you interpret. Try 2, or 6,
# and see.
# ---------------------------------------------------------

invisible(NULL)


# ---- 9 The biplot ----------------------------------------

ggplot(poke_scores, aes(x = PC1, y = PC2)) +
  geom_point(color = "grey75", alpha = 0.7) +
  geom_segment(data = arrows_df,
               aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.2, "cm"))) +
  geom_text_repel(data = arrows_df, aes(label = stat),
                  fontface = "bold", size = 3.4)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# geom_segment() draws a line from (0,0) out to each
# loading. arrow() puts a head on it.
#
# READING THE ARROWS
#   - every arrow points RIGHT: all six stats increase with
#     PC1 - the all-positive loadings, now visible
#   - defense points UP-RIGHT, speed points DOWN-RIGHT:
#     nearly opposite vertically - that is the trade-off
#   - attack sits with defense; sp_attack and sp_defense
#     lean with speed
#   - defense has the LONGEST arrow, hp the SHORTEST - so hp
#     is the stat least involved in these two axes
#
# READ ANGLES, NOT POSITIONS
#   arrows close together -> correlated stats
#   arrows at right angles -> unrelated
#   arrows opposite        -> trade-off
#
# A TRAP WORTH NAMING
# Last class the correlation between speed and defense was
# -0.05 - essentially UNRELATED. But here their arrows point
# in nearly opposite directions, which LOOKS like a strong
# trade-off.
#
# Both are true. The biplot is a SHADOW. Two arrows can look
# opposed in the shadow while being unrelated in the full
# six dimensions.
#
# So ALWAYS say how much you are showing: "PC1 and PC2,
# which together explain 61.1% of the variance". Without
# that number a reader cannot tell whether your biplot is
# the whole story or three-fifths of it.
#
# Never show a biplot without its percentages.
# ---------------------------------------------------------

invisible(NULL)


# ==========================================================
# HOW TO WRITE UP A PCA
#
# There is no p-value, so the structure is different:
#
#   Six battle statistics for the 151 original Pokemon were
#   standardised and reduced by principal component
#   analysis. The first two components explained 61.1% of
#   the total variance (PC1 39.6%, PC2 21.5%). PC1 loaded
#   positively on all six statistics (0.28 to 0.54) and is
#   interpreted as overall power: the four legendary Pokemon
#   averaged PC1 = 3.00 against -0.08 for all others, and
#   Magikarp held the lowest score. PC2 contrasted defense
#   (+0.59) and attack (+0.43) against speed (-0.54) and
#   sp_attack (-0.33), separating durable, slow-moving
#   species such as Golem and Cloyster from fast, fragile
#   ones such as Alakazam.
#
# WHAT THAT PARAGRAPH DOES
#   - says what went in - six stats, 151 Pokemon
#   - says it was standardised (scale. = TRUE)
#   - gives variance explained, per axis AND cumulative
#   - NAMES each axis, and gives the loadings that justify
#     the name
#   - gives evidence from the data - real Pokemon at each end
#   - never says "significant", because nothing was tested
#
# THE TWO FAILURE MODES
#   too little: "We ran a PCA and PC1 explained 39.6%."
#               Explained of what? Meaning what?
#   too much:   "PC1 proves power is one-dimensional."
#               PCA proves nothing. It DESCRIBES.
#
# Describe, name, justify. Stop there.
# ==========================================================

# ==========================================================
# End of the in-class script.
#
# THE HOMEWORK IS A SEPARATE FILE:
#   22_pca_2_homework.R
#
# All 1,025 Pokemon, and you name PC2 yourself. Open it now.
# ==========================================================
