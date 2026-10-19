# ==========================================================
# Activity 20: One-Way ANOVA II - assumptions, then
#              follow-up tests
# Name:
# Date:
#
# Save this file as scripts/20_anova_2.R
#
# PART A - in class. The code is written for you. Run it
#          chunk by chunk and answer the QA boxes.
# PART B - homework. Sets 2 and 3 again, on a DIFFERENT
#          measurement of your choosing. You write that
#          code, by copying the matching Part A chunk and
#          changing what needs changing. Answer the QB
#          boxes.
#
# Your ANSWERS, and your Part B code, are what gets graded.
#
# ----------------------------------------------------------
# About the invisible(NULL) lines
#
# Every chunk ends with
#
#     invisible(NULL)
#
# It is a BUMPER. When you press Ctrl/Cmd + Enter on the
# last real line of a chunk, the cursor jumps to the next
# line that has code on it. Without the bumper that is the
# next chunk, way down past the answer box. With it, the
# cursor stops right here and you keep your place.
#
# It does nothing and prints nothing. Leave it alone.
# ==========================================================

# Install these once, from the Console:
# install.packages("emmeans")
# install.packages("multcomp")

# Load libraries -------------------------------------------
library(tidyverse) # dplyr + ggplot2
library(palmerpenguins) # the penguins data
library(car) # leveneTest(), Anova()
library(emmeans) # pairwise follow-up tests

invisible(NULL)


# ##########################################################
# PART A - IN CLASS
# ##########################################################

# ---- A1: Same data, same model as last time --------------
# Every script starts from the raw data. Nothing here
# depends on objects left in last lecture's session.

penguins_df <- penguins %>%
  drop_na(body_mass_g, species)

mass_model <- lm(body_mass_g ~ species, data = penguins_df)

Anova(mass_model)

invisible(NULL)

# That is the F(2, 339) = 343.6, p < 0.001 we reported last
# time - WITHOUT checking whether we were allowed to.


# ##########################################################
# SET 2 - THE ASSUMPTIONS
#
# A one-way ANOVA assumes:
#   1. the observations are INDEPENDENT (a design question -
#      no R function can rescue it)
#   2. the RESIDUALS are normally distributed
#   3. the groups have EQUAL VARIANCE
# ##########################################################

# ---- A2: Normality is about the RESIDUALS ----------------
# A residual is one bird's miss: its mass minus its
# species' mean.
#
# ANOVA does NOT need the raw masses to be normal. Pooled
# across three species with different means they are not
# even supposed to be. It needs the MISSES to be normal.

head(residuals(mass_model), 4)

invisible(NULL)

# ---- A3: plot(model) - the same four panels --------------
# Predict first: with ~340 penguins, will the Normal Q-Q
# panel track the line tightly?

par(mfrow = c(2, 2))
plot(mass_model)
par(mfrow = c(1, 1))

invisible(NULL)

# Panel 1  Residuals vs Fitted   - THREE vertical stripes,
#                                  one per species. With a
#                                  categorical X there are
#                                  only three fitted
#                                  values. That is normal.
# Panel 2  Normal Q-Q            - the normality check
# Panel 3  Scale-Location        - are the stripe heights
#                                  equal? (assumption 3 by
#                                  eye)
# Panel 4  Residuals vs Leverage - is one point in charge?

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA1. Looking at panel 2, do the points track the dashed
#      line?  Y / mostly / N
#      Looking at panels 1 and 3, do the three stripes
#      look like they have the same height?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A4: Shapiro-Wilk, as the backup ---------------------
# H0: the residuals are normal. p > 0.05 means no evidence
# against normality.
#
# Note residuals(mass_model), NOT penguins_df$body_mass_g.
# Shapiro on the raw masses is a different, wrong test.

shapiro.test(residuals(mass_model))

invisible(NULL)

# Large-sample caution: at n = 342 Shapiro-Wilk flags tiny
# departures. Trust the plot; use the test as a second
# opinion.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA2. Shapiro-Wilk W = ____   p = ____
#      Does that agree with what you saw in panel 2?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A5: Equal variance, by eye first --------------------

penguins_df %>%
  group_by(species) %>%
  summarize(
    n = n(),
    mean = mean(body_mass_g),
    sd = sd(body_mass_g)
  )

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA3. Write the three sds down. How many times bigger is
#      the largest than the smallest?
#      Rule of thumb: equal n makes ANOVA forgiving about
#      unequal variance; unequal n does not. Which case
#      are we in?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A6: Levene's test -----------------------------------
# Predict first: given those sds, will Levene call the
# variances equal (p > 0.05) or unequal?
#
# H0: all groups have equal variance.

leveneTest(body_mass_g ~ species, data = penguins_df)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA4. Levene F = ____   p = ____
#      Equal variances?  Y / N
#      So is the classic ANOVA from A1 allowed?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# This is not a mistake in the activity. It is what this
# data set does. Real data does this constantly.

# ---- A7: Welch's ANOVA - when variances are unequal ------
# Same correction as Welch's t-test, which is already what
# t.test() does by default.

oneway.test(body_mass_g ~ species,
  data = penguins_df,
  var.equal = FALSE
)

invisible(NULL)

# The fractional denominator df is Welch's signature.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA5. Fill in both tests:
#      classic  Anova()      F = ____   p = ____
#      Welch    oneway.test  F = ____   p = ____
#      Which one do you REPORT, and why that one?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA6. Both agree here, so the violated assumption cost
#      us nothing. Is that a reason to skip the check
#      next time? Explain.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# SET 3 - THE FOLLOW-UP TESTS
#
# The F test said "at least one species differs". It cannot
# tell you WHICH, and on the boxplot two of the three
# species looked almost identical.
# ##########################################################

# ---- A8: Pairwise comparisons with emmeans ---------------
# Predict first: will all three species differ from each
# other, or will two be tied?
#
# emmeans does the three comparisons AND adjusts the
# p-values so the family-wise error rate stays at 0.05.
# The adjustment for all-pairs comparisons is Tukey's HSD.
#
# The p-values printed are ALREADY adjusted. Compare them
# with 0.05 directly - do not divide anything.

mass_emm <- emmeans(mass_model, pairwise ~ species)

mass_emm$contrasts

invisible(NULL)

# emmeans(model, pairwise ~ species) returns a LIST of two
# things. Here is the other half - the group means:

mass_emm$emmeans

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA7. Record each comparison.
#      Adelie  vs Chinstrap:  p = ____  different? Y / N
#      Adelie  vs Gentoo:     p = ____  different? Y / N
#      Chinstrap vs Gentoo:   p = ____  different? Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA8. The overall ANOVA p was below 0.001. Explain, in
#      your own words, how that is consistent with two of
#      the three species not differing at all.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A9: Compact letter display -------------------------
# Groups that SHARE a letter were NOT shown to be
# different. Different letters = significantly different.
# This is the notation you see over the bars in published
# figures.

multcomp::cld(mass_emm$emmeans, Letters = letters)

invisible(NULL)

# Read the NOTE that cld prints. "Not shown to be
# different" is not the same claim as "shown to be the
# same".

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA9. Adelie: ____  Chinstrap: ____  Gentoo: ____
#      Which species share a letter?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A10: The backup that matches Welch ------------------
# Tukey through emmeans uses the model's POOLED error - the
# thing Levene warned us about in A6. The unequal-variance
# version of the same comparisons:

pairwise.t.test(penguins_df$body_mass_g,
  penguins_df$species,
  pool.sd = FALSE
)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA10. Does this table tell the same story as A8's
#       letters?  Y / N
#       When the robust version agrees with the standard
#       one, what do you report?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A11: Plot the result --------------------------------

mass_emm_df <- as.data.frame(mass_emm$emmeans)

mass_emm_df

mass_emm_plot <- mass_emm_df %>%
  ggplot(aes(x = species, y = emmean)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), width = 0.15)

mass_emm_plot

invisible(NULL)

# Overlapping confidence intervals are a HINT, not a test.
# The p-value is the test; the plot is how a reader sees it.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA11. Which intervals overlap, and does that match the
#       pairwise p-values from QA7?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- A12: Report the whole thing -------------------------
# A complete write-up names:
#   - the assumption you checked and what you did about it
#   - the test, F, BOTH df, and p
#   - the follow-up, named as adjusted
#   - the means, so a reader can see the size of the effect
#   - the pair that did NOT differ. That is a finding, not
#     a failure.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QA12. Write the full results paragraph with YOUR
#       numbers. Use this as the skeleton:
#
#       "Body mass differed among the three penguin
#        species. Variances were unequal (Levene's test:
#        F(__, __) = ____, p = ____), so we report Welch's
#        ANOVA: F(__, __) = ____, p ____. Tukey-adjusted
#        comparisons showed that ______ was heavier than
#        both ______ (p ____) and ______ (p ____), while
#        ______ and ______ did not differ (p = ____)."
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# ##########################################################
# PART B - HOMEWORK - A DIFFERENT MEASUREMENT
#
# Mass is not the only thing that was measured on these
# birds. PICK ONE of these three columns and run Sets 2
# and 3 on it - the assumptions, then the follow-up tests:
#
#     flipper_length_mm
#     bill_length_mm
#     bill_depth_mm
#
# Write down which one you picked BEFORE you start.
#
# Use the SAME species as the grouping variable. You are
# changing the response (the Y), not the design.
#
# Nothing is filled in below. Copy the matching Part A
# chunk and change what needs changing - for most chunks
# that is one column name.
#
# Heads up: the three columns do NOT behave the same. One
# of them passes Levene's test cleanly, one of them has
# all three species in different groups, and one of them
# puts GENTOO at the BOTTOM instead of the top. Find out
# which one you have - do not assume it will look like the
# body mass result.
# ##########################################################

# ---- B1: Your data and your plot ------------------------
# TODO: build a data frame by dropping NA from species and
#       the column you picked. Call it penguins_hw.
# TODO: count(species) on it - is n the same as for mass?
# TODO: boxplot of your column by species.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB1. Column chosen: ____
#      n total = ____
#      Adelie = ____  Chinstrap = ____  Gentoo = ____
#      From the boxplot: which species looks highest, and
#      do any two look the same?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB2. H0 and Ha for YOUR test, in words. Remember the
#      response is no longer body mass.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B2: Fit it and read the table -----------------------
# TODO: lm(<your column> ~ species, data = penguins_hw),
#       call it hw_model.
# TODO: Anova(hw_model).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB3. F(__, __) = ____   p = ____
#      Reject H0?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B3: Set 2 - the assumptions -------------------------
# TODO: plot(hw_model) in a 2x2 grid, then put par back.
# TODO: shapiro.test() on the RESIDUALS of hw_model.
# TODO: group sds with group_by() + summarize().
# TODO: leveneTest().

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB4. Shapiro p = ____     residuals normal?  Y / N
#      Levene  p = ____     variances equal?   Y / N
#      Say what you SEE in the Q-Q panel too, not just
#      the p-value.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB5. Based on QB4, which test do you report - the
#      classic Anova() F, or the Welch oneway.test() F?
#      Say WHY, then run the one you chose and give its
#      F, df and p.
#
#      NOTE: your answer here may well be different from
#      the body mass answer in QA5. That is the point.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B4: Set 3 - the follow-up tests ---------------------
# TODO: emmeans(hw_model, pairwise ~ species) - keep both
#       $contrasts and $emmeans.
# TODO: multcomp::cld() for the letters.
# TODO: the means +/- CI plot.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB6. Pairwise p-values:
#      Adelie  vs Chinstrap:  p = ____
#      Adelie  vs Gentoo:     p = ____
#      Chinstrap vs Gentoo:   p = ____
#      Letters: Adelie ____  Chinstrap ____  Gentoo ____
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB7. Compare your letters with the body mass result in
#      A9 (Adelie a, Chinstrap a, Gentoo b).
#      Did the same species end up tied? Did the ORDER of
#      the species change?
#      A Gentoo is the heaviest bird of the three. Is it
#      also the biggest on YOUR measurement? If not, what
#      does that tell you about using one measurement as
#      a stand-in for overall body size?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# QB8. Write the full results paragraph for your column -
#      same shape as QA12, your numbers, your units.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- B5: Optional, no points -----------------------------
# Run one of the OTHER two columns as well and see whether
# the species line up the same way twice.

# ---- Before you hand in ----------------------------------
# Run the whole script top to bottom
# (Ctrl/Cmd + Shift + Enter) and make sure there are no
# errors.
