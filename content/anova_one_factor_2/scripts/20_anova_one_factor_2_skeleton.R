# ==========================================================
# Activity 20 - ANOVA II: weta, and correcting for size
# Name:
# Date:
#
# Save as scripts/20_anova_one_factor_2.R
#
# ALL the code is written for you today. Run it chunk by
# chunk, read what comes out, then change things and see
# what breaks.
#
# The THINK lines are to talk about, not to answer here.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file:
#   20_anova_one_factor_2_homework.R
#
# ----------------------------------------------------------
# THE ANIMALS
#
# Wellington tree weta, Hemideina crassidens - a large,
# flightless, nocturnal relative of crickets, found only in
# New Zealand. 313 adults collected at night on Te Pakeka /
# Maud Island, March-April 2016.
#
# Adult MALES come in three discrete forms, which stop
# growing at the 8th, 9th or 10th instar:
#
#   eighth - small head and jaws; sneaks into galleries
#   ninth  - intermediate
#   tenth  - huge head and mandibles; fights for harems
#
# ----------------------------------------------------------
# DATA SOURCE - cite your data, always
#
# trait_data.csv, Zenodo, doi:10.5281/zenodo.22959939
# Data creator: Clint D. Kelly, Universite du Quebec a
# Montreal. Licence CC BY 4.0 - reuse allowed WITH credit,
# which is what this block is.
#
# Our copy, data/weta_traits.csv, is that file with the
# numbers rounded to 4 decimal places. Nothing else changed.
#
# COLUMNS WE USE TODAY
#   morph       female / eighth / ninth / tenth
#   sex         f or m
#   pronotum    pronotum length, mm - the BODY SIZE measure
#   head_length head length, mm  <- do NOT test this, see 2
#   foretibia   foreleg tibia length, mm - the weapon leg
#   ear         tympanic membrane area, mm SQUARED
# ==========================================================

# ---- Libraries -------------------------------------------
# Nothing new today - same five as last class.
library(tidyverse)
library(car)          # Anova(), leveneTest()
library(performance)  # check_model()
library(emmeans)      # follow-up comparisons
library(multcomp)     # cld()
library(effectsize)   # eta_squared()

invisible(NULL)


# ---- 1 Read it in ----------------------------------------

weta_raw <- read_csv("data/weta_traits.csv")

dim(weta_raw)

weta_raw %>% count(morph)

# Four groups, not three - 118 of the 313 are FEMALE.

invisible(NULL)


# ---- 2 Two traps, before any test ------------------------
#
# TRAP 1: the females would swamp it.
# Females are much smaller than every male morph. Leave them
# in and the ANOVA comes back wildly significant, driven by
# SEX, and the three male morphs get buried. Our question is
# "do the three male morphs differ?" - so the data has to BE
# the three male morphs.
#
# filter() is not housekeeping. It is where you decide what
# your test is ABOUT.
#
# TRAP 2: head_length is CIRCULAR.
# The morphs were DEFINED using head length:
#   eighth = male, head_length < 18.51
#   ninth  = male, 18.51 to 24.15
#   tenth  = male, head_length > 24.15
#
# So "does head length differ among morphs?" is guaranteed.
# The answer was built into the labels. You would get an
# enormous F and learn nothing.
#
# Nothing in R will stop you. Anova() will hand you
# p < 2e-16 and a gold star. YOU have to catch this.

invisible(NULL)


# ---- 3 Males only, foreleg length ------------------------
# The groups are already WORDS, so factor() only needs
# levels - to fix the ORDER. Left alone R sorts
# alphabetically: eighth, ninth, tenth. That happens to be
# right. Do not rely on luck - say it.

weta_df <- weta_raw %>%
  filter(sex == "m", !is.na(foretibia)) %>%
  mutate(morph = factor(morph,
                        levels = c("eighth", "ninth", "tenth")))

weta_df %>% count(morph)

levels(weta_df$morph)

invisible(NULL)


# ---- 4 Look before you test ------------------------------

ggplot(weta_df, aes(x = morph, y = foretibia)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.5)

# THINK: predict the answer now. Significant? Will all three
# separate, or will two of them overlap?

invisible(NULL)


# ---- 5 The group means -----------------------------------

weta_df %>%
  group_by(morph) %>%
  summarise(n = n(),
            mean_foretibia = round(mean(foretibia), 2),
            mean_pronotum  = round(mean(pronotum), 2))

# THINK: look at the SECOND column. pronotum is the standard
# body-size measure for an insect, and it climbs too:
# 6.37 -> 6.93 -> 7.52 mm. Hold onto that. It is the whole
# lesson of section 9.

invisible(NULL)


# ---- 6 Fit, test, size -----------------------------------

fore_model <- lm(foretibia ~ morph, data = weta_df)

Anova(fore_model, type = 2)

eta_squared(Anova(fore_model, type = 2), partial = FALSE)

# F(2, 192) = 268.5, p < 2.2e-16, eta-squared = 0.74.

invisible(NULL)


# ---- 7 Check the assumptions -----------------------------
# If check_model() errors about the plot being too small,
# that is your Plots pane, not your model. Drag it bigger,
# or ask for fewer panels as below.

check_model(fore_model, check = c("homogeneity", "qq"))

leveneTest(foretibia ~ morph, data = weta_df)

shapiro.test(residuals(fore_model))

# Levene p = 0.233 PASS. Shapiro p = 0.542 PASS.
# Remember the inversion: for these two, a BIG p is good.

invisible(NULL)


# ---- 8 Which morphs differ? ------------------------------

cld(emmeans(fore_model, ~ morph), Letters = letters)

# a, b, c - all three separate. Morph explains 74% of the
# variation in foreleg length.
#
# THINK: cleanest result you will ever see. Which is exactly
# when you should get suspicious.

invisible(NULL)


# ##########################################################
# THE EARS
# ##########################################################

# ---- 9 Weta hear through their knees ---------------------
# A weta has no ears on its head. It hears through a
# tympanic membrane on the foreleg tibia - a drum on the
# knee. The `ear` column is that membrane's AREA in mm^2.
#
# A real behavioural question: the sneaks have to listen for
# the fighters. Do the three morphs differ in ear size?

ear_model <- lm(ear ~ morph, data = weta_df)

Anova(ear_model, type = 2)

eta_squared(Anova(ear_model, type = 2), partial = FALSE)

cld(emmeans(ear_model, ~ morph), Letters = letters)

# F(2, 192) = 122.2, p < 2.2e-16, eta-squared = 0.56.
# All three separate: a, b, c.
# Ear area climbs 2.50 -> 2.99 -> 3.42 mm^2.
#
# Assumptions pass. Write the paper: "the fighting morph has
# a 37% larger hearing organ."
#
# THINK: stop. Look back at section 5. The tenth-instar
# males have bigger ears. They also have bigger EVERYTHING.
# What did we actually just test?

invisible(NULL)


# ##########################################################
# THE CORRECTION
# ##########################################################

# ---- 10 Measure the ear relative to the animal -----------
# We asked: do the morphs differ in ear SIZE? Yes.
# We wanted:  do the morphs differ in HEARING?
# Those are not the same question, and Anova() cannot tell
# them apart.
#
# The fix is to divide ear size by body size - but there is
# a UNITS problem first.
#
#   ear      is an AREA,   in mm^2
#   pronotum is a LENGTH,  in mm
#
# Dividing an area by a length is meaningless. So first take
# the SQUARE ROOT of the area, which turns it back into a
# length, and THEN divide. Length over length = a ratio,
# with no units at all.

weta_rel <- weta_df %>%
  mutate(ear_rel = sqrt(ear) / pronotum)

weta_rel %>%
  group_by(morph) %>%
  summarise(n = n(),
            mean_ear     = round(mean(ear), 2),
            mean_ear_rel = round(mean(ear_rel), 4))

# Raw ear area:  2.50 -> 2.99 -> 3.42.  Climbing hard.
# Relative ear:  0.2485 -> 0.2490 -> 0.2459.  FLAT.
#
# THINK: predict it. What is F going to be?

invisible(NULL)


# ---- 11 Run it -------------------------------------------

ear_rel_model <- lm(ear_rel ~ morph, data = weta_rel)

leveneTest(ear_rel ~ morph, data = weta_rel)

shapiro.test(residuals(ear_rel_model))

Anova(ear_rel_model, type = 2)

eta_squared(Anova(ear_rel_model, type = 2), partial = FALSE)

cld(emmeans(ear_rel_model, ~ morph), Letters = letters)

# F(2, 192) = 0.80, p = 0.449, eta-squared = 0.008.
# All three share the letter a.
#
# Both assumptions pass - Levene p = 0.59, Shapiro p = 0.50 -
# so this is a TRUSTWORTHY null, not a broken model.
#
# Same ears. Same animals. Two defensible analyses.
# Opposite conclusions. p < 0.001 -> p = 0.449 on one
# mutate().
#
# THINK: both results are CORRECT. They answer different
# questions. Raw ear: "is the hearing organ physically
# bigger?" Yes. Relative ear: "has it been scaled up more
# than the rest of the animal?" No. Which would you report
# in a paper about hearing?

invisible(NULL)


# ##########################################################
# BRING THE FEMALES BACK
# ##########################################################

# ---- 12 A different question needs different data --------
# In section 3 we dropped the females because they would
# swamp a question about male morphs. Now we ask a question
# they belong in:
#
#   Across all four adult forms, is the FORELEG scaled up
#   differently?
#
# The foreleg is the WEAPON - a tenth-instar male fights
# with it. Both foretibia and pronotum are LENGTHS in mm, so
# no square root this time. Just divide.

weta_all <- weta_raw %>%
  filter(!is.na(foretibia)) %>%
  mutate(morph = factor(morph,
                        levels = c("female", "eighth", "ninth", "tenth")),
         fore_rel = foretibia / pronotum)

weta_all %>% count(morph)

fore_rel_model <- lm(fore_rel ~ morph, data = weta_all)

leveneTest(fore_rel ~ morph, data = weta_all)

shapiro.test(residuals(fore_rel_model))

Anova(fore_rel_model, type = 2)

cld(emmeans(fore_rel_model, ~ morph), Letters = letters)

# F(3, 309) = 266.3, p < 2.2e-16, eta-squared = 0.72.
# Letters: a | b | c | c
#
# Females, then eighth, then ninth - all separate. But NINTH
# AND TENTH SHARE c. 5 of the 6 pairs are significant, and
# that one is not. Relative foreleg length rises steeply,
# then PLATEAUS.
#
# THINK: this result SURVIVED the body-size correction,
# unlike the ears. The foreleg really has been built up more
# than the animal as a whole. But it stops. And n = 38 for
# the tenth morph - sharing a letter is a failure to detect
# a difference, not proof of sameness.

invisible(NULL)


# ---- 13 If there is time: do the circular one on purpose -
# Section 2 said never to test head_length, because the
# morphs were defined from it. Let us look at what that
# looks like, so you recognise it in the wild.

circular_model <- lm(head_length ~ morph, data = weta_df)

Anova(circular_model, type = 2)

eta_squared(Anova(circular_model, type = 2), partial = FALSE)

# THINK: F = 568 and eta-squared = 0.86 - morph "explains"
# 86% of head length. It is the biggest effect anywhere in
# this data set, and it is completely empty. We drew the
# group boundaries with this ruler.
#
# Nothing in the output looks wrong. That is the point.

invisible(NULL)


# ==========================================================
# End of the in-class script.
#
# THE HOMEWORK IS A SEPARATE FILE:
#   20_anova_one_factor_2_homework.R
#
# The hind leg - raw, then relative. Open it now.
# ==========================================================
