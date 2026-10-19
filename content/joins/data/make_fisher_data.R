# =====================================================================
# make_fisher_data.R  —  CONSTRUCTED teaching dataset (not real records)
#
# A simulated fisher (Pekania pennanti) reintroduction-monitoring dataset,
# patterned on real programs (e.g. Washington Cascades 2015-2020, which
# translocated ~90 fishers from British Columbia). Numbers are invented;
# the STRUCTURE — a table of released individuals and a separate table of
# field capture/collar events that must be joined on an ID — mirrors how
# these data actually arrive. Use it to teach joins, not fisher biology.
#
# Two things the generator is careful about, because the activity reads
# them back out:
#   1. A capture event ALWAYS happens after that animal's release date,
#      so days_since_release is never negative.
#   2. mass_kg depends on sex (fishers are strongly dimorphic: males are
#      roughly twice the mass of females), so summarizing mass by sex
#      after the join gives a sensible answer.
# =====================================================================
set.seed(42)
library(tidyverse)

sites <- c("Gifford Pinchot", "Mt Rainier", "Snoqualmie", "Okanogan")

individuals <- tibble(
  fisher_id    = sprintf("F%02d", 1:18),
  sex          = c("F","F","M","F","M","F","F","M","F","M","F","M","F","F","M","F","M","F"),
  age_class    = sample(c("juvenile","adult"), 18, replace = TRUE, prob = c(.35,.65)),
  source       = "British Columbia",
  # RELEASE site — deliberately named `site`, same as captures$site
  site         = sample(sites, 18, replace = TRUE),
  release_date = as.Date("2018-01-15") + sample(0:900, 18)
) |>
  arrange(fisher_id)

# Capture / collar events. animal_id is lowercase (a key-format mismatch
# for students to clean). F04/F11/F17 are forced out so some released
# fishers are never recaptured; three events are unmarked animals
# (animal_id = "unk", no match in individuals).
recaptured <- setdiff(individuals$fisher_id, c("F04", "F11", "F17"))
n_events   <- 45
n_unk      <- 3

marked_ids <- sample(recaptured, n_events - n_unk, replace = TRUE)

# Each marked capture happens 10-1000 days AFTER that animal's release.
marked <- tibble(animal_id = marked_ids) |>
  left_join(individuals |> select(fisher_id, sex, release_date),
            by = c("animal_id" = "fisher_id")) |>
  mutate(capture_date = release_date + sample(10:1000, n(), replace = TRUE))

# Unmarked animals have no release date on record; give them field dates
# inside the same window the marked events span.
unmarked <- tibble(
  animal_id    = rep("unk", n_unk),
  sex          = NA_character_,
  release_date = as.Date(NA),
  capture_date = as.Date("2018-06-01") + sample(0:1200, n_unk)
)

events <- bind_rows(marked, unmarked) |>
  mutate(
    animal_id = tolower(animal_id),
    # Fishers are strongly sexually dimorphic: females ~2.3 kg,
    # males ~4.6 kg. Unmarked animals get a draw from the whole range.
    mass_kg = case_when(
      sex == "F" ~ rnorm(n(), 2.3, 0.30),
      sex == "M" ~ rnorm(n(), 4.6, 0.55),
      TRUE       ~ rnorm(n(), 3.4, 1.10)
    ),
    mass_kg = round(pmax(mass_kg, 1.4), 2),
    # CAPTURE site — a fisher may be caught away from where it was released
    site    = sample(sites, n(), replace = TRUE)
  ) |>
  arrange(capture_date) |>
  mutate(capture_event = sprintf("CE-%03d", seq_len(n())),
         collar_id     = sprintf("C%03d", sample(100:400, n()))) |>
  select(capture_event, animal_id, capture_date, site, mass_kg, collar_id)

write_csv(individuals, "content/joins/data/fisher_individuals.csv")
write_csv(events,      "content/joins/data/fisher_captures.csv")
cat("wrote", nrow(individuals), "individuals and", nrow(events), "capture events\n")
