# ==========================================================
# Activity 19 - HOMEWORK: the same possums, a different ruler
# Name:
# Date:
#
# Save as scripts/19_anova_one_factor_homework.R
#
# *** THIS IS THE FILE YOU TURN IN. ***
#
# In class we ran a one-factor ANOVA on possum TOTAL LENGTH
# across seven trapping sites. Here you run the same eight
# steps on TAIL LENGTH.
#
# Same 104 animals. Same seven sites. Same recipe. A
# different ruler.
#
# The real question is whether the PATTERN HOLDS. In class
# the letters ran from Bellbird at the bottom to Byrangery
# at the top. Do the sites with the longest BODIES also have
# the longest TAILS?
#
# HOW THIS WORKS
# 1. ALL the graded questions are in the ANSWERS block right
#    below. Answer them THERE, as # comments. Each code
#    section tells you which questions it unlocks.
# 2. Each code section gives you the total_l line from class,
#    commented out, right above a blank where your version
#    goes. Copy it, change the parts that are yours,
#    uncomment, run.
#
# It must run top to bottom (Ctrl/Cmd + Shift + Enter) with
# no errors before you hand it in - and when it does, the
# plots should draw.
#
# ----------------------------------------------------------
# THE FOUR MEASUREMENTS IN THE FILE
#   total_l   total length, cm  - what we used in class
#   tail_l    tail length, cm   - YOUR HOMEWORK
#   head_l    head length, mm
#   skull_w   skull width, mm   - the optional section at the end
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section H2 - answer BEFORE you run any test)
#       From the boxplot alone: which site looks like it has
#       the longest tails? The shortest? Do the boxes look
#       about equally tall? Predict whether the ANOVA will
#       come back significant.
# ANSWER:
#
#
# H-Q2. (section H3) Give n and the mean tail length for all
#       seven sites.
# ANSWER:
#
#
# H-Q3. (section H5) Report F, BOTH degrees of freedom, p,
#       and eta-squared. In one sentence, what does
#       eta-squared mean here?
# ANSWER:
#
#
# H-Q4. (section H6) Give the Levene p-value and the
#       Shapiro-Wilk p-value. Did each one PASS or FAIL -
#       and explain why a BIG p-value is the good outcome
#       for these two tests.
# ANSWER:
#
#
# H-Q5. (section H7) Write out the letters from cld(). Which
#       sites can you tell apart, and which can you not?
# ANSWER:
#
#
# H-Q6. (section H7) Put your tail-length letters next to
#       the total-length letters from class:
#
#         Bellbird a | Allyn River ab | Bulburin b |
#         Conondale bc | Whian Whian bcd | Cambarville cd |
#         Byrangery d
#
#       What is the SAME, and what MOVED? Is Bellbird still
#       at the bottom and Byrangery still at the top?
# ANSWER:
#
#
# H-Q7. (section H7) In class, 10 of the 21 pairs were
#       significant. How many are significant for tail
#       length? If it is fewer, does that mean tails vary
#       LESS between sites, or that we are worse at
#       detecting it? (Look at eta-squared before you
#       answer.)
# ANSWER:
#
#
# H-Q8. Three or four sentences, written as the results
#       paragraph of a report. Include the test, F with both
#       df, p, eta-squared, your two assumption checks, and
#       which sites differed - with means attached.
# ANSWER:
#
#
# H-Q9. (OPTIONAL section H8) Give the Levene and
#       Shapiro-Wilk p-values for skull_w. Which one FAILS?
# ANSWER:
#
#
# H-Q10. (OPTIONAL section H8) That failure does not mean
#        you delete the data or give up. In one or two
#        sentences: what does it mean about how much you
#        should trust the p-value from that model?
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


# ---- H1 Read it in and build the factor ------------------
# Identical to class, except we drop NA on tail_l instead of
# total_l. Nothing else changes - the sites are the sites.
#
# In class:
#   possum_df <- possum_raw %>%
#     filter(!is.na(total_l)) %>%
#     mutate(site_name = factor(site,
#                               levels = 1:7,
#                               labels = c("Cambarville", "Bellbird",
#                                          "Whian Whian", "Byrangery",
#                                          "Conondale", "Allyn River",
#                                          "Bulburin")))

# YOUR CODE:
# possum_raw <- read_csv("data/possum.csv")
#
# tail_df <- possum_raw %>%
#   filter(!is.na(tail_l)) %>%
#   mutate(site_name = factor(site,
#                             levels = 1:7,
#                             labels = c("Cambarville", "Bellbird",
#                                        "Whian Whian", "Byrangery",
#                                        "Conondale", "Allyn River",
#                                        "Bulburin")))
#
# tail_df %>% count(site_name)

invisible(NULL)


# ---- H2 LOOK at it first ---------------------------------
# -> then answer H-Q1 at the top, BEFORE you test anything.
#
# In class:
#   ggplot(possum_df, aes(x = site_name, y = total_l)) +
#     geom_boxplot(outlier.shape = NA) +
#     geom_jitter(width = 0.15, alpha = 0.5)

# YOUR CODE:

invisible(NULL)


# ---- H3 The group means ----------------------------------
# -> then answer H-Q2 at the top.
#
# In class:
#   possum_df %>%
#     group_by(site_name) %>%
#     summarise(n = n(),
#               mean_total = round(mean(total_l), 1),
#               sd_total   = round(sd(total_l), 2))

# YOUR CODE:

invisible(NULL)


# ---- H4 Fit the model ------------------------------------
# In class:
#   total_model <- lm(total_l ~ site_name, data = possum_df)

# YOUR CODE:
# tail_model <- lm(tail_l ~ site_name, data = tail_df)

invisible(NULL)


# ---- H5 The test, and how big it is ----------------------
# -> then answer H-Q3 at the top.
#
# In class:
#   Anova(total_model, type = 2)
#   eta_squared(Anova(total_model, type = 2), partial = FALSE)

# YOUR CODE:

invisible(NULL)


# ---- H6 Check the assumptions - AFTER fitting ------------
# -> then answer H-Q4 at the top.
#
# If check_model() errors about the plot being too small,
# that is your RStudio Plots pane, not your model. Drag the
# pane bigger, or ask for fewer panels:
#   check_model(tail_model, check = c("homogeneity", "qq"))
#
# In class:
#   check_model(total_model)
#   leveneTest(total_l ~ site_name, data = possum_df)
#   shapiro.test(residuals(total_model))

# YOUR CODE:

invisible(NULL)


# ---- H7 Which sites differ? ------------------------------
# -> then answer H-Q5, H-Q6 and H-Q7 at the top. H-Q8 is the
#    write-up - do it last.
#
# In class:
#   site_means <- emmeans(total_model, ~ site_name)
#   site_means
#   pairs(site_means, adjust = "tukey")
#   cld(site_means, Letters = letters)

# YOUR CODE:

invisible(NULL)


# ==========================================================
# OPTIONAL - what a FAILED assumption looks like
#
# Everything you have checked so far has passed. That makes
# it easy to treat the assumption check as a formality. It
# is not.
#
# Run the same recipe on skull_w. One of the two checks
# fails. Find out which.
# ==========================================================

# ---- H8 skull_w ------------------------------------------
# -> then answer H-Q9 and H-Q10 at the top.

# YOUR CODE:
# skull_df <- possum_raw %>%
#   filter(!is.na(skull_w)) %>%
#   mutate(site_name = factor(site,
#                             levels = 1:7,
#                             labels = c("Cambarville", "Bellbird",
#                                        "Whian Whian", "Byrangery",
#                                        "Conondale", "Allyn River",
#                                        "Bulburin")))
#
# skull_model <- lm(skull_w ~ site_name, data = skull_df)
#
# leveneTest(skull_w ~ site_name, data = skull_df)
# shapiro.test(residuals(skull_model))

invisible(NULL)

# A failed assumption is NOT a reason to delete data or give
# up. It is a reason to say so out loud, and to trust the
# exact p-value less. Real options, for later courses:
# transform the response, use a test that does not assume
# equal variances, or report the result with the caveat
# attached. What you must never do is notice and say
# nothing.


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and your
# plots must draw.
# ==========================================================
