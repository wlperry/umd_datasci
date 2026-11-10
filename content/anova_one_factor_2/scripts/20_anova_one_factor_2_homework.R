# ==========================================================
# Activity 20 - HOMEWORK: the hind leg, raw and relative
# Name:
# Date:
#
# Save as scripts/20_anova_one_factor_2_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class we did the foreleg - the WEAPON - and then the
# ears, where a huge result vanished once we divided by body
# size.
#
# Here you do the HIND leg: hindtibia, the jumping leg. Same
# two analyses, raw then relative.
#
# IT WILL NOT COME OUT LIKE THE EARS. The ears went from
# p < 0.001 all the way to p = 0.449 - to nothing. The hind
# leg does something in between. Your job is to DESCRIBE
# what it does, not to match the answer we got in class.
#
# HOW THIS WORKS
# 1. ALL the graded questions are in the ANSWERS block right
#    below. Answer them THERE, as # comments.
# 2. Each code section gives you the class line, commented
#    out, right above a blank where your version goes.
#
# It must run top to bottom (Ctrl/Cmd + Shift + Enter) with
# no errors before you hand it in.
#
# ----------------------------------------------------------
# DATA SOURCE - cite your data, always
#
# trait_data.csv, Zenodo, doi:10.5281/zenodo.22959939
# Data creator: Clint D. Kelly, Universite du Quebec a
# Montreal. Licence CC BY 4.0 - reuse allowed WITH credit.
#
# COLUMNS YOU NEED
#   morph      female / eighth / ninth / tenth
#   sex        f or m
#   pronotum   pronotum length, mm - the BODY SIZE measure
#   hindtibia  hind leg tibia length, mm - YOUR TRAIT
#   eye        eye length, mm - the optional section
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section H1) Why do we filter to sex == "m" again?
#       Answer in terms of the QUESTION being asked, not in
#       terms of the code.
# ANSWER:
#
#
# H-Q2. (section H2) Give n and the mean hindtibia for each
#       of the three morphs, and the mean pronotum alongside
#       it. Does body size climb across the morphs?
# ANSWER:
#
#
# H-Q3. (section H4) RAW hindtibia: report F, BOTH degrees
#       of freedom, p, and eta-squared. Give the Levene and
#       Shapiro p-values and say PASS or FAIL for each.
# ANSWER:
#
#
# H-Q4. (section H4) Write out the letters from cld() for
#       raw hindtibia. Which morphs separate?
# ANSWER:
#
#
# H-Q5. (section H5) Why do we NOT need sqrt() this time,
#       when we did need it for the ears? Answer in terms of
#       UNITS.
# ANSWER:
#
#
# H-Q6. (section H6) RELATIVE hindtibia: report F, both df,
#       p, and eta-squared, plus both assumption p-values
#       and PASS/FAIL.
# ANSWER:
#
#
# H-Q7. (section H6) Write out the letters for relative
#       hindtibia. Compare them to your H-Q4 letters. What
#       changed?
# ANSWER:
#
#
# H-Q8. Compare your eta-squared values from H-Q3 and H-Q6.
#       How much of the raw effect was really about body
#       size? Is the leftover difference still worth
#       reporting?
# ANSWER:
#
#
# H-Q9. In class the ear result went all the way to nothing
#       (p = 0.449, all three sharing one letter). Your hind
#       leg result does NOT. In two or three sentences: what
#       is the biological difference between a trait that
#       disappears completely after correction and one that
#       only shrinks?
# ANSWER:
#
#
# H-Q10. Three or four sentences as a results paragraph,
#        reporting BOTH analyses - raw and relative - with
#        F, both df, p, eta-squared, your assumption checks,
#        and the letters. Remember: never write "no
#        difference", write "no detectable difference".
# ANSWER:
#
#
# H-Q11. (OPTIONAL section H7) For `eye`, give the Shapiro
#        p-value for the RAW model and for the RELATIVE
#        model. Which one fails?
# ANSWER:
#
#
# H-Q12. (OPTIONAL section H7) The relative eye model is
#        both the more meaningful question AND the
#        better-behaved model. Is that a coincidence? Give
#        one reason dividing by body size might also tidy up
#        the residuals.
# ANSWER:
#
#
#

# ==========================================================
# CODE
# ==========================================================

# ---- Libraries -------------------------------------------
library(tidyverse)
library(car)          # Anova(), leveneTest()
library(performance)  # check_model()
library(emmeans)      # follow-up comparisons
library(multcomp)     # cld()
library(effectsize)   # eta_squared()

invisible(NULL)


# ---- H1 Read it in, males only, factor the morph ---------
# -> then answer H-Q1 at the top.
#
# In class:
#   weta_df <- weta_raw %>%
#     filter(sex == "m", !is.na(foretibia)) %>%
#     mutate(morph = factor(morph,
#                           levels = c("eighth", "ninth", "tenth")))

# YOUR CODE:
# weta_raw <- read_csv("data/weta_traits.csv")
#
# hind_df <- weta_raw %>%
#   filter(sex == "m", !is.na(hindtibia)) %>%
#   mutate(morph = factor(morph,
#                         levels = c("eighth", "ninth", "tenth")))
#
# hind_df %>% count(morph)

invisible(NULL)


# ---- H2 Look at it, and get the means --------------------
# -> then answer H-Q2 at the top.
#
# Put mean pronotum next to mean hindtibia, the way we did
# in class. You will need it for H-Q8.
#
# In class:
#   ggplot(weta_df, aes(x = morph, y = foretibia)) +
#     geom_boxplot(outlier.shape = NA) +
#     geom_jitter(width = 0.15, alpha = 0.5)
#
#   weta_df %>%
#     group_by(morph) %>%
#     summarise(n = n(),
#               mean_foretibia = round(mean(foretibia), 2),
#               mean_pronotum  = round(mean(pronotum), 2))

# YOUR CODE:

invisible(NULL)


# ---- H3 Fit the raw model --------------------------------
# In class:
#   fore_model <- lm(foretibia ~ morph, data = weta_df)

# YOUR CODE:
# hind_model <- lm(hindtibia ~ morph, data = hind_df)

invisible(NULL)


# ---- H4 Raw: test, size, assumptions, letters ------------
# -> then answer H-Q3 and H-Q4 at the top.
#
# In class:
#   Anova(fore_model, type = 2)
#   eta_squared(Anova(fore_model, type = 2), partial = FALSE)
#   leveneTest(foretibia ~ morph, data = weta_df)
#   shapiro.test(residuals(fore_model))
#   cld(emmeans(fore_model, ~ morph), Letters = letters)

# YOUR CODE:

invisible(NULL)


# ---- H5 Build the relative trait -------------------------
# -> then answer H-Q5 at the top.
#
# For the EARS we had to write sqrt(ear) / pronotum, because
# ear was an AREA in mm^2 and pronotum is a LENGTH in mm.
#
# hindtibia is a LENGTH, in mm. So think about whether you
# need the square root here before you write the line.
#
# In class (the four-group foreleg version):
#   weta_all <- weta_raw %>%
#     mutate(fore_rel = foretibia / pronotum)

# YOUR CODE:
# hind_rel_df <- hind_df %>%
#   mutate(hind_rel = hindtibia / pronotum)
#
# hind_rel_df %>%
#   group_by(morph) %>%
#   summarise(n = n(),
#             mean_hindtibia = round(mean(hindtibia), 2),
#             mean_hind_rel  = round(mean(hind_rel), 4))

invisible(NULL)


# ---- H6 Relative: the whole recipe again -----------------
# -> then answer H-Q6, H-Q7 and H-Q8 at the top. H-Q9 and
#    H-Q10 are the write-up - do those last.
#
# Fit it, check both assumptions, test it, get eta-squared,
# and get the letters. Same five calls as H4.

# YOUR CODE:

invisible(NULL)


# ==========================================================
# OPTIONAL - when the right question is also the better
#            behaved model
#
# Run the same pair of analyses on `eye` - raw eye length,
# then eye / pronotum. One of the two models fails its
# normality check and the other does not.
# ==========================================================

# ---- H7 eye, raw and relative ----------------------------
# -> then answer H-Q11 and H-Q12 at the top.

# YOUR CODE:
# eye_df <- weta_raw %>%
#   filter(sex == "m", !is.na(eye)) %>%
#   mutate(morph   = factor(morph,
#                           levels = c("eighth", "ninth", "tenth")),
#          eye_rel = eye / pronotum)
#
# eye_raw_model <- lm(eye ~ morph, data = eye_df)
# eye_rel_model <- lm(eye_rel ~ morph, data = eye_df)
#
# shapiro.test(residuals(eye_raw_model))
# shapiro.test(residuals(eye_rel_model))
#
# Anova(eye_rel_model, type = 2)
# cld(emmeans(eye_rel_model, ~ morph), Letters = letters)

invisible(NULL)


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and your
# plots must draw.
# ==========================================================
