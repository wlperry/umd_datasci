# ==========================================================
# Activity 19 - One-Factor ANOVA, start to finish
# Name:
# Date:
#
# Save as scripts/19_anova_one_factor.R
#
# ALL the code is written for you today. Run it chunk by
# chunk, read what comes out, then change things and see
# what breaks. That is the point of today.
#
# The THINK lines are to talk about, not to answer here.
#
# YOU DO NOT TURN THIS FILE IN.
# The homework is a separate file:
#   19_anova_one_factor_homework.R
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
# next chunk. With it, the cursor stops here and you keep
# your place.
#
# It does nothing and prints nothing. Leave it alone.
# ==========================================================

# Install these ONCE, from the Console, BEFORE class:
# install.packages("performance")
# install.packages("see")
# install.packages("emmeans")
# install.packages("multcomp")
# install.packages("effectsize")

# ---- Libraries -------------------------------------------
library(tidyverse)
library(car)          # Anova(), leveneTest()
library(performance)  # check_model(), check_normality()
library(emmeans)      # follow-up comparisons
library(multcomp)     # cld() - the compact letter display
library(effectsize)   # eta_squared()

invisible(NULL)


# ---- 1 Read the possums in --------------------------------
# 104 mountain brushtail possums (Trichosurus cunninghami),
# live-trapped at seven forest sites in Australia.
#
# Found on Kaggle: "OpenIntro Possum". Kaggle mirrored it
# from the OpenIntro textbook project, which took it from
# Lindenmayer et al. 1995, Australian Journal of Zoology.

possum_raw <- read_csv("data/possum.csv")

dim(possum_raw)
names(possum_raw)

# THINK: Kaggle is a MIRROR, not a source. Anyone can upload
# anything there. How far back could you trace YOUR final
# project data?

invisible(NULL)


# ---- 2 The site column is a trap -------------------------

possum_raw %>% count(site)

# Those are the integers 1-7. To R that is a QUANTITY - as
# if site 6 were "twice site 3". It is not. It is a NAME
# that happens to be written with a digit.
#
# Leave it alone and lm() fits a straight line through site
# number, which is nonsense. No error. No warning.

invisible(NULL)


# ---- 3 Fix it with factor() ------------------------------
# levels = the values AS THEY APPEAR in the data
# labels = what you want them CALLED
# Same length, same order. Get the order wrong and every
# result below is quietly mislabelled.
#
# The names come from the OpenIntro codebook.

possum_df <- possum_raw %>%
  filter(!is.na(total_l)) %>%
  mutate(site_name = factor(site,
                            levels = 1:7,
                            labels = c("Cambarville", "Bellbird",
                                       "Whian Whian", "Byrangery",
                                       "Conondale", "Allyn River",
                                       "Bulburin")))

possum_df %>% count(site_name)

levels(possum_df$site_name)

# THINK: 33 possums at Cambarville, 7 at Byrangery. Does
# unequal group size stop us doing ANOVA? (No.) Does it
# change how much we should trust the Byrangery mean? (Yes.)

invisible(NULL)


# ---- 4 LOOK at it before you test anything ---------------

ggplot(possum_df, aes(x = site_name, y = total_l)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.5)

# THINK: before any test - which site looks lowest? Highest?
# Do the boxes look about equally tall? Predict the answer
# NOW. Predicting is how you notice when output is wrong.

invisible(NULL)


# ---- 5 The group means -----------------------------------

possum_df %>%
  group_by(site_name) %>%
  summarise(n = n(),
            mean_total = round(mean(total_l), 1),
            sd_total   = round(sd(total_l), 2))

# THINK: the two VICTORIAN sites are the southernmost, and
# they sit at opposite extremes - Cambarville 89.7 cm,
# Bellbird 81.8 cm. So much for "it gets colder going south,
# so animals get bigger." What else could differ between two
# forests in the same state?

invisible(NULL)


# ---- 6 Fit the model -------------------------------------
# response ~ predictor. Exactly like regression. The only
# change is that the predictor is a factor with 7 levels.
#
# ANOVA *is* a linear model. Same function, same machinery.

total_model <- lm(total_l ~ site_name, data = possum_df)

invisible(NULL)


# ---- 7 Do NOT read summary() first -----------------------

summary(total_model)

# Six slopes, each comparing one site to CAMBARVILLE -
# because Cambarville is level 1, so it became the baseline.
#
# That answers "is each site different from Cambarville?",
# which is not the question. Nobody asked about Cambarville.
#
# THINK: change which site is level 1 and all six of those
# p-values change. Does the real answer depend on which site
# we happened to list first? Obviously not. So this is the
# wrong table.

invisible(NULL)


# ---- 8 The RIGHT table -----------------------------------

Anova(total_model, type = 2)

# F(6, 97) = 14.58, p = 8.45e-12
#
# One line. One p-value. One question answered: the seven
# site means are not all the same.
#
# Sum Sq 907.6  = variation explained by site
# Sum Sq 1006.2 = variation left over within sites
# Df 6   = 7 groups - 1
# Df 97  = 104 possums - 7 groups
# F      = the ratio, after dividing each Sum Sq by its Df
#
# With ONE factor, type 1, 2 and 3 give identical answers.
# We write type = 2 as a habit, because it starts mattering
# the moment you add a second factor.

invisible(NULL)


# ---- 9 How big is it? F does not say ---------------------

eta_squared(Anova(total_model, type = 2), partial = FALSE)

# eta-squared = 0.47. Which site a possum came from accounts
# for 47% of all variation in total length. The other 53% is
# possums being individuals.
#
# THINK: p answers "is it real?". eta-squared answers "is it
# big?". With a big enough sample a trivial difference gets
# a tiny p. Why must you report both?

invisible(NULL)


# ---- 10 Check the assumptions - AFTER fitting ------------
# You cannot check residuals before you have residuals.
# Fit first, then check.
#
# Five panels. Simulated data should sit on real data;
# the variance line should be flat, not a wedge; residuals
# should hug the diagonal.

check_model(total_model)

invisible(NULL)


# ---- 11 The formal tests ---------------------------------

# Equal variances across sites?
leveneTest(total_l ~ site_name, data = possum_df)

# Normal residuals?
shapiro.test(residuals(total_model))

# The same two checks, in English:
check_homogeneity(total_model)
check_normality(total_model)

# Levene p = 0.805 -> no evidence variances differ. PASS.
# Shapiro p = 0.588 -> no evidence of non-normality. PASS.
#
# THINK: for the MAIN test a small p was the interesting
# result. For ASSUMPTION tests it is backwards - a small p
# means your test is in trouble. Say it out loud:
# "Levene p = 0.805. Big. Variances are fine. Carry on."

invisible(NULL)


# ---- 12 F said "not all equal" - that is ALL it said -----
# At least one site differs from at least one other. Which
# ones? How many? In which direction? F does not say.
#
# Doing 21 comparisons as a FIRST move was wrong (21 tests
# at alpha = 0.05 on pure noise gives a 66% chance of a
# false positive). Doing them AFTER a significant F, with
# the p-values adjusted, is standard and defensible.

site_means <- emmeans(total_model, ~ site_name)
site_means

invisible(NULL)


# ---- 13 All 21 pairs, honestly adjusted ------------------

pairs(site_means, adjust = "tukey")

# Tukey widens every p-value to pay for running 21 tests.
# 10 of the 21 pairs come back significant.
#
# THINK: that is what the boxplot predicted - the ends
# separate, the middle does not. Did you call it in step 4?

invisible(NULL)


# ---- 14 The letters --------------------------------------
# Nobody wants 21 p-values in a results section. They want
# to know which groups cluster together.
#
# Share a letter -> not shown to differ.
# No letter in common -> differ.

cld(site_means, Letters = letters)

# Bellbird    a    - alone at the bottom, 81.8 cm
# Allyn River ab   - not distinguishable from either neighbour
# Byrangery   d    - alone at the top, 92.2 cm
#
# THINK: read R's own note at the bottom of that output.
# "We cannot show them to be different. But we also did not
# show them to be the same." Byrangery has n = 7. What would
# n = 70 have done to those letters?

invisible(NULL)


# ---- 15 Put the letters on the plot ----------------------

letters_df <- as.data.frame(cld(site_means, Letters = letters)) %>%
  mutate(group = trimws(.group))

ggplot(possum_df, aes(x = site_name, y = total_l)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.4) +
  geom_text(data = letters_df,
            aes(x = site_name, y = 97, label = group),
            size = 5)

invisible(NULL)


# ---- 16 Write it up --------------------------------------
# Total length differed significantly among the seven
# trapping sites (one-way ANOVA, F(6, 97) = 14.58,
# p < 0.001), and site accounted for 47% of the variation in
# length (eta-squared = 0.47). Residuals were normally
# distributed (Shapiro-Wilk p = 0.59) with homogeneous
# variances across sites (Levene's test p = 0.81).
# Tukey-adjusted comparisons separated Bellbird (mean
# 81.8 cm) from Byrangery (92.2 cm), with the remaining five
# sites forming an overlapping middle group.
#
# Every number has a job:
#   the test, F with BOTH df, p (as "< 0.001", never
#   "= 0.000"), the effect size, the assumption checks, and
#   the pattern with real means attached.

invisible(NULL)


# ---- 17 If there is time: break it on purpose ------------
# Run ANOVA on site as a NUMBER instead of a factor, the
# mistake from step 2, and compare the two tables.

broken_model <- lm(total_l ~ site, data = possum_df)

Anova(broken_model, type = 2)
Anova(total_model, type = 2)

# THINK: the broken one has Df = 1, not 6. It fit a single
# straight line through site ID and asked "does length go
# up as site number goes up?" - a question about the order
# someone typed the sites in. It still prints a p-value.
# Nothing warns you. This is why step 3 exists.

invisible(NULL)


# ==========================================================
# End of the in-class script.
#
# THE HOMEWORK IS A SEPARATE FILE:
#   19_anova_one_factor_homework.R
#
# New Zealand tree weta. Open it now and read the top.
# ==========================================================
