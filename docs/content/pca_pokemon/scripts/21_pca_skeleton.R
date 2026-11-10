# ==========================================================
# Activity 21 - PCA I: many measurements, few axes
# Name:
# Date:
#
# Save as scripts/21_pca.R
#
# EVERY LINE OF CODE IS ALREADY WRITTEN. You do not have to
# write any of it. Run it one chunk at a time, top to
# bottom, and read the notes.
#
# After each chunk there is a block headed
#
#     WHAT YOU ARE LOOKING AT
#
# That block tells you how to read the output you just
# produced. That is the real content of today. The code is
# only four or five actual commands - the skill is knowing
# what the output means.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file:
#   21_pca_homework.R
#
# ----------------------------------------------------------
# TODAY HAS NO P-VALUES
#
# PCA is not a test. There is no null hypothesis, no
# p-value, and nothing to reject. Nothing passes or fails.
#
# So do not ask "is it significant?" today. Ask "can I
# explain what this axis means?"
# ----------------------------------------------------------
# No new packages. prcomp() is built into R.
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)

invisible(NULL)


# ##########################################################
# CHUNK 1 - the problem with six columns
# ##########################################################

# ---- 1 Read it in ----------------------------------------

pokemon <- read_csv("data/pokemon_151.csv")

dim(pokemon)

pokemon %>%
  select(name, hp, attack, defense, sp_attack, sp_defense, speed) %>%
  head(4)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# 151 rows - the original Pokemon - and 15 columns. Six of
# those columns are the battle stats, and those six are the
# only ones PCA will see:
#
#   hp          hit points
#   attack      physical attack
#   defense     physical defence
#   sp_attack   special attack
#   sp_defense  special defence
#   speed       speed
#
# Treat them exactly like six measurements taken off an
# animal - length, mass, wingspan and so on. The method is
# identical. Pokemon are just easier to check.
# ---------------------------------------------------------

invisible(NULL)


# ---- 2 Pull the six stats into their own table -----------

poke_stats <- pokemon %>%
  select(hp, attack, defense, sp_attack, sp_defense, speed)

dim(poke_stats)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# 151 rows, 6 columns. Numbers only - no names, no types.
# PCA cannot handle text, so the names have to come out.
#
# IMPORTANT: the rows stay in the SAME ORDER as `pokemon`.
# That is what lets us glue the results back onto the names
# in section 8. Never sort one and not the other.
#
# WHY SIX COLUMNS ARE A PROBLEM
# One measurement you can draw as a histogram. Two as a
# scatterplot. Three as an awkward 3-D plot nobody can read.
# Six - there is no six-dimensional plot, and there never
# will be.
#
# You could draw all the pairs instead, but six columns make
# 15 separate scatterplots, and "which Pokemon are similar
# to each other?" is a question about all six numbers AT
# ONCE. Looking at two at a time cannot answer it.
# ---------------------------------------------------------

invisible(NULL)


# ---- 3 Do the stats move together? -----------------------

poke_stats %>%
  cor() %>%
  round(2)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# A correlation matrix. Every column against every column.
# Values run from -1 to +1:
#
#    +1  perfectly together
#     0  no relationship
#    -1  perfectly opposite
#
# The diagonal is all 1.00 - each column against itself.
# Ignore the diagonal.
#
# The interesting ones here:
#   sp_attack & sp_defense    0.53   move together
#   hp        & sp_defense    0.49   move together
#   attack    & defense       0.48   move together
#   speed     & defense      -0.05   nothing at all
#
# So the six columns are NOT six independent facts. They
# overlap - knowing one tells you something about others.
#
# THIS IS WHAT MAKES PCA WORK. Correlation is redundancy,
# and PCA's whole job is to squeeze the redundancy out. If
# all six columns were completely unrelated, PCA would have
# nothing to do: six axes in, six equally useless axes out.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 2 - what PCA does, and scaling
# ##########################################################

# ---------------------------------------------------------
# THE SHADOW ANALOGY - read this before running anything
#
# Hold your hand in front of a lamp and look at the shadow.
# Your hand is 3-D; the shadow is 2-D. You lost a dimension,
# but you can still tell it is a hand.
#
# Now rotate your hand. Some angles give a shadow you
# recognise instantly. Others give a shapeless blob. Same
# hand, same wall - different amount of information kept.
#
# That is PCA. Your data is a cloud of 151 points in 6-D
# space. PCA finds the angle that casts the most informative
# shadow - the one where the points stay as spread out as
# possible - and then tells you what that shadow is made of.
#
# SAID WITHOUT THE ANALOGY
# PCA builds new measurements by blending the old ones:
#
#   PC1 = a1*hp + a2*attack + a3*defense + ...
#
# It chooses the weights so that PC1 captures as much of the
# spread between Pokemon as any single blend can. Then PC2
# captures as much of what is LEFT OVER as possible, at
# right angles to PC1. Then PC3, and so on.
#
# Six columns in, six PCs out - but in ORDER OF USEFULNESS.
#
# TWO WORDS YOU NEED
#   LOADING - how much an original stat contributes to a PC.
#             What the axis is MADE OF.
#   SCORE   - where one Pokemon sits along that PC.
#             Its new measurement.
# ---------------------------------------------------------

invisible(NULL)


# ---- 4 Why you must scale first --------------------------

poke_stats %>%
  summarise(across(everything(), ~ round(sd(.x), 1)))

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# The standard deviation of each stat - how spread out each
# column is in its own raw points. They are not equal. hp
# varies more than defense does.
#
# PCA chases SPREAD. Hand it unscaled columns and it will
# decide the most important thing in your data is whichever
# column happens to use the biggest numbers.
#
# A WORKED DISASTER
# Imagine measuring animals in grams and kilometres. Body
# mass in grams runs into the thousands; home range in km
# might be 0.4. Unscaled, PC1 would be ENTIRELY mass, and
# would tell you nothing except which unit you typed in.
#
# THE FIX
#   scale. = TRUE
# converts every column to standard deviations from its own
# mean first. Afterwards every column has mean 0 and sd 1,
# so all six compete fairly and the units cancel out.
#
# MIND THE FULL STOP: the argument is `scale.` with a dot,
# because `scale` was already an R function. Leave the dot
# off and you get an error.
#
# Almost always use scale. = TRUE.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 3 - run it and read it
# ##########################################################

# ---- 5 The entire analysis, in one line ------------------

poke_pca <- prcomp(poke_stats, center = TRUE, scale. = TRUE)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# Nothing printed - that is correct. prcomp() stores the
# result in poke_pca.
#
#   center = TRUE   subtract each column's mean
#   scale.  = TRUE  divide by each column's sd
#
# That is the whole analysis. Everything from here on is
# READING the result, which is the part that takes
# judgement.
# ---------------------------------------------------------

invisible(NULL)


# ---- 6 Variance explained --------------------------------

summary(poke_pca)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# Three rows. Ignore the first one (Standard deviation).
#
# PROPORTION OF VARIANCE - how much of the total spread each
# PC captures:
#   PC1  39.6%
#   PC2  21.5%
#   PC3  16.5%
#   ...
#
# CUMULATIVE PROPORTION - the running total:
#   PC1 alone        39.6%
#   PC1 + PC2        61.1%
#   all six          100%, always
#
# THE HEADLINE: two invented axes carry 61% of everything in
# six columns. So a flat scatterplot of PC1 against PC2 -
# which we draw next class - shows about three-fifths of the
# whole dataset.
#
# WHAT "VARIANCE EXPLAINED" MEANS IN PLAIN WORDS
# Variance here just means "how spread out things are".
# Total variance = every way these 151 Pokemon differ from
# each other across all six stats.
#
# PC1 captures 39.6% of that. Meaning: throw away all six
# stats, keep ONLY each Pokemon's PC1 score, and you still
# have about 40% of the information about how they differ.
# One number instead of six, for 40% of the picture.
#
# IT IS NOT 39.6% OF THE POKEMON, and it is not 39.6%
# accuracy. It is 39.6% of the total VARIATION - of the
# differences between them.
# ---------------------------------------------------------

invisible(NULL)


# ---- 7 The scree plot ------------------------------------

var_df <- tibble(
  PC      = paste0("PC", 1:6),
  percent = round(100 * poke_pca$sdev^2 / sum(poke_pca$sdev^2), 1)
)

var_df

ggplot(var_df, aes(x = PC, y = percent)) +
  geom_col() +
  geom_text(aes(label = percent), vjust = -0.4)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# WHERE var_df CAME FROM
# poke_pca$sdev is each PC's standard deviation. Squaring it
# gives variance; dividing by the total makes it a share;
# times 100 is a percent. Same numbers summary() printed,
# but now in a data frame - which is what lets us plot them.
#
# THE PLOT is a SCREE PLOT: variance explained per axis, in
# order. ("Scree" is the loose rubble at the foot of a
# cliff - the shape the bars make.)
#
# You are looking for the ELBOW: where the bars stop
# dropping steeply and flatten into rubble. Here PC1 and PC2
# stand up; from PC3 on they settle down and get similar. So
# the honest answer is KEEP TWO, and know you are holding
# 61%.
#
# THERE IS NO RULE for where the elbow is. People argue
# about it constantly. Rough guides:
#   - keep PCs until the cumulative total passes ~70-80%
#   - keep the ones BEFORE the flat part
#   - keep the ones you can INTERPRET
# The last one is the most useful.
# ---------------------------------------------------------

invisible(NULL)


# ##########################################################
# CHUNK 4 - does PC1 mean anything?
# ##########################################################

# ---- 8 A quick look at what PC1 is made of ---------------

round(poke_pca$rotation[, 1:2], 2)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# The LOADINGS - how much each original stat contributes to
# each PC. One row per stat, one column per PC.
#
# LOOK AT THE PC1 COLUMN: every single number is POSITIVE
# (0.28 to 0.54). So a Pokemon scores high on PC1 by being
# high on all six stats at once.
#
# PC1 IS AN "OVERALL POWER" AXIS.
#
# Now glance at PC2: it has MINUS SIGNS in it. A big
# positive and a big negative on the same axis means PC2 is
# a TRADE-OFF, not a total. defense is +0.59 and speed is
# -0.54. Which trade-off? That is next class.
# ---------------------------------------------------------

invisible(NULL)


# ---- 9 Glue the scores back onto the names ---------------

poke_scores <- pokemon %>%
  mutate(PC1 = poke_pca$x[, 1],
         PC2 = poke_pca$x[, 2])

poke_scores %>%
  select(name, hp, attack, speed, PC1, PC2) %>%
  head(3)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# poke_pca$x holds the SCORES - one row per Pokemon, one
# column per PC, in the SAME ROW ORDER as the data we put
# in. That is why mutate() can glue them straight on.
#
# Every Pokemon now has two new made-up measurements, PC1
# and PC2, sitting next to its real ones.
#
# Scores are in STANDARD DEVIATIONS, so 0 is average and
# they run roughly -3 to +3. A negative score is not bad -
# it just means "below average on this axis".
# ---------------------------------------------------------

invisible(NULL)


# ---- 10 The ends of PC1 - the only check that matters ----

poke_scores %>%
  arrange(desc(PC1)) %>%
  select(name, is_legendary, PC1) %>%
  head(6)

poke_scores %>%
  arrange(PC1) %>%
  select(name, PC1) %>%
  head(6)

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# TOP OF PC1: mewtwo, dragonite, mew, articuno, zapdos,
# moltres - every legendary in the game, plus the two
# strongest non-legendaries.
#
# BOTTOM OF PC1: magikarp, caterpie, weedle, metapod,
# kakuna, zubat.
#
# Nobody told PCA which Pokemon were strong. There is no
# "power" column in the file. It was handed six columns of
# numbers and it sorted them by overall strength on its own.
#
# THAT IS THE WHOLE VALIDATION, and it is the check you run
# on EVERY PCA, on any data. You cannot test whether an axis
# is "real" - there is no p-value for that. But you CAN look
# at what sits at each end and ask whether it lines up with
# something you already know.
#
# If it does, the axis is measuring something. If it does
# not, be very careful about what you claim.
# ---------------------------------------------------------

invisible(NULL)


# ---- 11 Put a number on it -------------------------------

poke_scores %>%
  group_by(is_legendary) %>%
  summarise(n = n(),
            mean_PC1 = round(mean(PC1), 2))

# ---------------------------------------------------------
# WHAT YOU ARE LOOKING AT
#
# The four legendaries average PC1 = 3.00. Everyone else
# averages -0.08.
#
# Scores are in standard deviations, so the legendaries sit
# about THREE STANDARD DEVIATIONS above the crowd - on an
# axis that was built without ever being told they existed.
#
# Note n = 4. Four Pokemon is not much to hang a claim on.
# The homework repeats this with 71 legendaries.
# ---------------------------------------------------------

invisible(NULL)


# ==========================================================
# WHERE WE GOT TO, AND WHAT IS MISSING
#
# We have:
#   - two axes holding 61% of six columns
#   - PC1 identified as "overall power", checked against
#     Magikarp and Mewtwo
#
# We do NOT have:
#   - any idea what PC2 means
#   - a PICTURE - we have not plotted a single Pokemon yet
#   - any way to see the original six stats ON that picture
#
# All three are next class.
#
# THE HOMEWORK IS A SEPARATE FILE:
#   21_pca_homework.R
#
# All 1,025 Pokemon instead of 151. Open it now.
# ==========================================================
