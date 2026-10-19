# ==========================================================
# Activity 19: One-Way ANOVA I - start to finish
# Name:
# Date:
#
# Save this file as scripts/19_anova_1.R
#
# ALL the code is written for you. Run it chunk by chunk
# and watch what comes out.
#
# You answer the questions in the boxes marked # # # # # #
# after "ANSWER:", with every line starting with #
#
# Your ANSWERS are what gets graded.
#
# ----------------------------------------------------------
# About the invisible(NULL) lines
#
# Every chunk below ends with
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
# install.packages("palmerpenguins")
# install.packages("car")

# Load libraries -------------------------------------------
library(tidyverse) # dplyr + ggplot2 + forcats
library(palmerpenguins) # the penguins data
library(car) # Anova()

invisible(NULL)


# ---- 1: The question -------------------------------------
# Do the three penguin species differ in body mass?
#
#   Y = body_mass_g   (numeric response)
#   X = species       (categorical predictor, 3 levels)
#
# That is a ONE-WAY ANOVA: one numeric response across the
# levels of one categorical predictor.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q1. Why is this an ANOVA and not a t-test? One sentence.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q2. If you ran t-tests on all three PAIRS of species
#     instead, what would be wrong with that?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 2: Load the data ------------------------------------
# WARNING: R 4.5 has its own penguins data set, where the
# mass column is called body_mass, NOT body_mass_g. If you
# forget library(palmerpenguins) you will get
#
#   Error in `drop_na()`: Column `body_mass_g` doesn't exist
#
# and not a missing-object error. The fix is the library()
# call at the top.

penguins_df <- penguins %>%
  drop_na(body_mass_g, species)

penguins_df %>% count(species)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q3. Write down the sample size of each species.
#     Adelie = ____  Chinstrap = ____  Gentoo = ____
#     Are the groups BALANCED (equal n)?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 3: Plot it before you test it -----------------------
# Predict first: which species is heaviest? Do you think
# all three differ, or only one?

penguins_df %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot() +
  geom_jitter(width = 0.15)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q4. Describe what you SEE.
#     Heaviest species:
#     Lightest species:
#     Do any two species look almost the same?
#     Do the boxes look like they have the same SPREAD?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 4: species is a factor, and factors have an order ---
# A factor is a categorical column with a fixed, ORDERED
# set of levels. ggplot and lm both use that order.

class(penguins_df$species)

levels(penguins_df$species)

invisible(NULL)

# The stored order is ALPHABETICAL - that is just R's
# default, not a decision anyone made about penguins.
#
# fct_reorder() puts the groups in order of the thing you
# are testing. It has to go INSIDE mutate().

penguins_df %>%
  mutate(species = fct_reorder(species, body_mass_g, .fun = median)) %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot()

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q5. What order were the levels stored in, and what order
#     are they in after fct_reorder()? Here they come out
#     the same - why is it still worth doing?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 5: State the hypotheses -----------------------------
# Do this BEFORE you fit anything.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q6. Write the hypotheses.
#     H0 in words:
#     Ha in words:
#     H0 in symbols:
#     alpha =
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 6: Fit the model ------------------------------------
# Exactly the same lm() call as the regression lecture.
# The only difference is that X is categorical.

mass_model <- lm(body_mass_g ~ species, data = penguins_df)

invisible(NULL)

# Fitting the model and READING A TABLE from it are two
# separate steps. First look at what lm() did with the
# factor:

coef(mass_model)

invisible(NULL)

# (Intercept) is the mean of the FIRST level - Adelie.
# The other two numbers are DIFFERENCES from Adelie.
# That is called TREATMENT coding, and it is R's default.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q7. From coef(), what is the mean mass of an Adelie?
#     How much heavier is a Gentoo than an Adelie?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 7: Change the baseline with fct_relevel() -----------
# Predict first: if Gentoo becomes the first level, does
# the overall F / p change, or only the coefficients?

penguins_relevel <- penguins_df %>%
  mutate(species = fct_relevel(species, "Gentoo"))

mass_model_gentoo <- lm(body_mass_g ~ species, data = penguins_relevel)

coef(mass_model_gentoo)

invisible(NULL)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q8. What does (Intercept) mean in each of the two
#     models? Did the overall ANOVA question change?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 8: Read the ANOVA table -----------------------------
# Predict first: is p nearer 0.5, 0.05, or far below 0.001?

# 8a. The classic table
mass_aov <- aov(body_mass_g ~ species, data = penguins_df)

summary(mass_aov)

invisible(NULL)

# 8b. Base R anova() on the lm - this is TYPE I, which is
#     SEQUENTIAL and therefore order-dependent. With one
#     predictor there is no order to depend on.
anova(mass_model)

invisible(NULL)

# 8c. car::Anova() - TYPE II, which is the default and is
#     order-independent. This is the one to make a habit of.
#     Lowercase anova() and capital Anova() are DIFFERENT
#     functions from DIFFERENT packages. If you see
#       could not find function "Anova"
#     you forgot library(car).
Anova(mass_model)

invisible(NULL)

# Anova(mass_model, type = 2) is the same thing, spelled out.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q9. From the table: F = ____  df = ____ , ____
#     p = ____    Reject H0 at alpha = 0.05?  Y / N
#     Do all three tables above agree on F?   Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 9: Type III, and the contrasts option it needs ------
# Type III sums of squares are only meaningful when the
# factor is coded against the GRAND MEAN (contr.sum), not
# against a baseline group (contr.treatment).
#
# Ask for type = 3 on a treatment-coded model and car will
# still print a table. It just is not the test you think.

# 9a. What is R using right now?
getOption("contrasts")

invisible(NULL)

# That is R's default: treatment coding for unordered
# factors, polynomial for ordered ones.

# 9b. Type III on the TREATMENT-coded model (not right)
Anova(mass_model, type = 3)

invisible(NULL)

# 9c. The four-line pattern. SET - REFIT - TEST - SET BACK.
#
#     Step 2 is not optional. A model remembers the coding
#     it was FITTED with, so changing the option and
#     reusing the old model does nothing at all.

options(contrasts = c("contr.sum", "contr.poly"))

mass_model_sum <- lm(body_mass_g ~ species, data = penguins_df)

Anova(mass_model_sum, type = 3)

options(contrasts = c("contr.treatment", "contr.poly"))

invisible(NULL)

# 9d. Prove to yourself that the switch back worked, and
#     that each model carries its own coding.
getOption("contrasts")

mass_model$contrasts

mass_model_sum$contrasts

invisible(NULL)

# WHY SET IT BACK: options() is global and sticky. It stays
# changed for the rest of your R session and silently
# affects every model you fit afterwards.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q10. Compare the two type = 3 tables, 9b and 9c.
#      Which ROW changed, and which row stayed the same?
#      Given that, why does the contrast coding matter at
#      all here? (Hint: it does not, YET - what changes
#      when you have two factors and an interaction?)
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- 10: Report it ---------------------------------------
# For this course, report Anova(model) - Type II - unless
# you have a specific reason not to.

Anova(mass_model)

invisible(NULL)

# Template:
#   "Body mass differed significantly among the three
#    penguin species (one-way ANOVA: F(__, __) = ____,
#    p ____)."
#
# Never write p = 0.000. Write p < 0.001.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q11. Write the results sentence with YOUR numbers in it.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Q12. That sentence does not say WHICH species differ,
#      and it does not say whether the model was allowed
#      to give us that p-value. Which of those two gaps
#      worries you more, and why?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ##########################################################
# HOMEWORK - A DIFFERENT MEASUREMENT
#
# Mass is not the only thing that was measured on these
# birds. PICK ONE of these three columns and run the basic
# ANOVA on it, start to finish, exactly as you did above:
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
# Nothing is filled in below. Copy the matching chunk from
# above and change what needs changing - for most chunks
# that is one column name.
#
# Keep the column you pick. You will run the ASSUMPTIONS
# and the FOLLOW-UP TESTS on the same column for the
# Activity 20 homework, so you end up with one complete
# analysis of one measurement.
# ##########################################################

# ---- H1: Read it and plot it -----------------------------
# TODO: build penguins_hw by dropping NA from species and
#       the column you picked.
# TODO: count(species). Is n the same as it was for mass?
# TODO: boxplot of your column by species, with the points
#       jittered over it.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q1. Column chosen: ____
#       Units of that column: ____
#       n total = ____
#       Adelie = ____  Chinstrap = ____  Gentoo = ____
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q2. From the boxplot: which species looks highest,
#       which looks lowest, and do any two look the same?
#       Do the boxes look like they have the same spread?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H2: Order the groups --------------------------------
# TODO: fct_reorder() the species by the MEDIAN of your
#       column, inside mutate(), then plot it again.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q3. Did the order of the species change from the
#       alphabetical order this time? Write the new order.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H3: Hypotheses --------------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q4. H0 and Ha for YOUR test, in words and in symbols.
#       Remember the response is no longer body mass.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H4: Fit it, and look at the coefficients ------------
# TODO: lm(<your column> ~ species, data = penguins_hw),
#       call it hw_model.
# TODO: coef(hw_model).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q5. What is the mean of your column for Adelie?
#       How much higher or lower is Gentoo than Adelie,
#       and in what units?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H5: Read the table ----------------------------------
# TODO: Anova(hw_model).

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q6. F(__, __) = ____   p = ____
#       Reject H0 at alpha = 0.05?  Y / N
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H6: Type III on your model --------------------------
# TODO: the four-line pattern from section 9 - set the
#       contrasts to contr.sum, REFIT, Anova(type = 3),
#       then set the contrasts back.

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q7. Is the F for species the same as in H-Q6?  Y / N
#       Which row of the table is different?
#       What is the LAST line of this section, and why
#       does it have to be there?
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- H7: Report it ---------------------------------------

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q8. Write the results sentence for your column, with
#       your numbers and your units.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# H-Q9. You still cannot say WHICH species differ, and
#       you have not checked a single assumption. List the
#       two checks you would want to run before you would
#       believe your own sentence in H-Q8.
# ANSWER:
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# ---- Before you hand in ----------------------------------
# Run the whole script top to bottom
# (Ctrl/Cmd + Shift + Enter) and make sure there are no
# errors. Check that the LAST thing it does is set the
# contrasts option back to the default.
#
# NEXT TIME: Lecture 20 - the assumptions (one of them
# fails on the body mass data) and the follow-up tests
# that tell you which species actually differ.
