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
# across seven trapping sites. Here you run the same recipe
# on EAR LENGTH (ear_l, in mm).
#
# Same 104 animals. Same seven sites. Same recipe. A
# different ruler.
#
# In class the sites formed a ladder: Bellbird at the
# bottom, Byrangery at the top, everything else overlapping
# in the middle. The question here is whether ears tell the
# SAME story as total length - or a different one.
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
# WHERE THE DATA CAME FROM
#   Lindenmayer, Viggers, Cunningham & Donnelly (1995).
#   Australian Journal of Zoology 43: 449-458.
#   https://doi.org/10.1071/ZO9950449
#   Data: the `possum` data set in the R package DAAG.
#   https://cran.r-project.org/package=DAAG
# ==========================================================


# ==========================================================
# ANSWERS - every graded question, in one place
# ==========================================================

# H-Q1. (section H2 - answer BEFORE you run any test)
#       From the boxplot alone: do the seven sites look like
#       a ladder, the way total length did - or do they fall
#       into GROUPS? Which sites sit together? Is there any
#       single point that looks out of place?
# ANSWER:
#
#
# H-Q2. (section H3) Give n and the mean ear length for all
#       seven sites.
# ANSWER:
#
#
# H-Q3. (section H5) Report F, BOTH degrees of freedom, p,
#       and eta-squared. In class eta-squared for total
#       length was 0.47. In one sentence, what does YOUR
#       eta-squared say about how much site matters for ears
#       compared with total length?
# ANSWER:
#
#
# H-Q4. (section H6) Give the Levene p-value and the
#       Shapiro-Wilk p-value. Which one PASSES and which one
#       FAILS? Remember which direction is the good one.
# ANSWER:
#
#
# H-Q5. (section H7) Which animal is the odd one out? Give
#       its animal number, its site, and its ear length, and
#       say how it compares with the other possums at that
#       site.
# ANSWER:
#
#
# H-Q6. (section H7) You ran the model again WITHOUT that
#       animal. What happened to the Shapiro-Wilk p-value?
#       What happened to F and to eta-squared? Did the
#       CONCLUSION change?
# ANSWER:
#
#
# H-Q7. (section H7) We do not get to delete an animal just
#       because it is inconvenient. So why was it still
#       worth running the model both ways? What would you
#       have had to say if the answer HAD changed?
# ANSWER:
#
#
# H-Q8. (section H8 - use ALL 104 animals) Write out the
#       letters from multcomp::cld(). Which sites share a
#       letter with each other, and which sites share
#       nothing with anybody else?
# ANSWER:
#
#
# H-Q9. (section H8) Look at the two sites that stand apart.
#       Find them in the table of sites and states in the
#       activity. What do they have in common that the other
#       five do not?
# ANSWER:
#
#
# H-Q10. Here are the class results for TOTAL length:
#
#          Bellbird a | Allyn River ab | Bulburin b |
#          Conondale bc | Whian Whian bcd | Cambarville cd |
#          Byrangery d
#
#        For total length, Cambarville and Bellbird were at
#        OPPOSITE ends. For ear length, where are they? So
#        do these two sites differ from the rest in overall
#        SIZE, or in SHAPE? Explain in two or three
#        sentences.
# ANSWER:
#
#
# H-Q11. Three or four sentences, written as the results
#        paragraph of a report. Include the test, F with
#        both df, p, eta-squared, your two assumption checks
#        (including the one that failed and what you did
#        about it), and which sites differed - with means
#        attached.
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
library(effectsize)   # eta_squared()

# NOT loaded on purpose: multcomp. Use multcomp::cld().

invisible(NULL)


# ---- H1 Read it in, name the sites, make the factor ------
# Identical to class, except we drop NA on ear_l instead of
# total_l. Nothing else changes - the sites are the sites.
#
# This one is written for you. Uncomment it and run it.
# (Select the lines, then Ctrl/Cmd + Shift + C.)

# possum_raw <- read_csv("data/possum.csv")
#
# ear_df <- possum_raw %>%
#   filter(!is.na(ear_l)) %>%
#   mutate(site_name = case_when(
#     site == 1 ~ "Cambarville",
#     site == 2 ~ "Bellbird",
#     site == 3 ~ "Whian Whian",
#     site == 4 ~ "Byrangery",
#     site == 5 ~ "Conondale",
#     site == 6 ~ "Allyn River",
#     site == 7 ~ "Bulburin")) %>%
#   mutate(site_name = as.factor(site_name)) %>%
#   mutate(site_name = fct_relevel(site_name,
#                                  "Bulburin", "Conondale",
#                                  "Whian Whian", "Byrangery",
#                                  "Allyn River", "Cambarville",
#                                  "Bellbird"))
#
# ear_df %>% count(site_name)

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
# ear_model <- lm(ear_l ~ site_name, data = ear_df)

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
#   check_model(ear_model, check = c("homogeneity", "qq"))
#
# In class:
#   check_model(total_model)
#   leveneTest(total_l ~ site_name, data = possum_df)
#   shapiro.test(residuals(total_model))

# YOUR CODE:

invisible(NULL)


# ---- H7 One of those checks failed. Find out why. --------
# -> then answer H-Q5, H-Q6 and H-Q7 at the top.
#
# In class both checks passed. Here one does not. That is
# NOT a reason to delete data or give up. It is a reason to
# LOOK.
#
# Step 1. Sort the possums by ear length and look at the
# smallest few. Compare the top row with the mean for its
# own site from H3.

# YOUR CODE:
# ear_df %>%
#   arrange(ear_l) %>%
#   head(5)

# Step 2. Build a second data set WITHOUT that one animal,
# fit the same model to it, and run the same checks. Put
# the animal's number where the blank is.

# YOUR CODE:
# ear_check_df <- ear_df %>%
#   filter(animal != ____)
#
# ear_check_model <- lm(ear_l ~ site_name, data = ear_check_df)
#
# shapiro.test(residuals(ear_check_model))
# Anova(ear_check_model, type = 2)
# eta_squared(Anova(ear_check_model, type = 2), partial = FALSE)
# multcomp::cld(emmeans(ear_check_model, ~ site_name), Letters = letters)

# We are NOT throwing the animal away. It is a real possum
# that somebody trapped and measured. We ran the model both
# ways to find out whether ONE animal is deciding the
# answer. If the conclusion is the same with it and without
# it, you can report the full data set and say so.

invisible(NULL)


# ---- H8 Which sites differ? ------------------------------
# -> then answer H-Q8, H-Q9 and H-Q10 at the top. H-Q11 is
#    the write-up - do it last.
#
# Go back to ALL 104 animals - ear_model, not
# ear_check_model.
#
# In class:
#   site_means <- emmeans(total_model, ~ site_name)
#   site_means
#   pairs(site_means, adjust = "tukey")
#   multcomp::cld(site_means, Letters = letters)

# YOUR CODE:

invisible(NULL)


# ==========================================================
# WHEN YOU ARE DONE - and not before
#
# The people who collected these possums asked the same
# question you just did. What they found changed how these
# animals are classified:
#
#   Lindenmayer, Dubach & Viggers (2002). Geographic
#   dimorphism in the mountain brushtail possum (Trichosurus
#   caninus): the case for a new species. Australian Journal
#   of Zoology 50: 369-393.
#   https://doi.org/10.1071/ZO01047
#
# Read the abstract. Then read your answer to H-Q10 again.
# ==========================================================


# ==========================================================
# Before you hand in: Session > Restart R, then run the
# whole file top to bottom. It must run clean, and your
# plots must draw.
# ==========================================================
