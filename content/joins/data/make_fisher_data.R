# =====================================================================
# make_fisher_data.R  —  CONSTRUCTED teaching dataset (not real records)
#
# A simulated fisher (Pekania pennanti) reintroduction-monitoring dataset,
# patterned on real programs (e.g. Washington Cascades 2015-2020, which
# translocated ~90 fishers from British Columbia). Numbers are invented;
# the STRUCTURE — a table of released individuals and a separate table of
# field capture/collar events that must be joined on an ID — mirrors how
# these data actually arrive. Use it to teach joins, not fisher biology.
# =====================================================================
set.seed(42)
library(tidyverse)

sites  <- c("Gifford Pinchot", "Mt Rainier", "Snoqualmie", "Okanogan")

individuals <- tibble(
  fisher_id     = sprintf("F%02d", 1:18),
  sex           = c("F","F","M","F","M","F","F","M","F","M","F","M","F","F","M","F","M","F"),
  age_class     = sample(c("juvenile","adult"), 18, replace = TRUE, prob = c(.35,.65)),
  source        = "British Columbia",
  site          = sample(sites, 18, replace = TRUE),   # RELEASE site (same name as captures$site on purpose)
  release_date  = as.Date("2018-01-15") + sample(0:900, 18)
) |> arrange(fisher_id)

# Capture / collar events. animal_id is lowercase (a key-format mismatch to
# clean). A few released fishers are never recaptured (F04/F11/F17 forced out,
# plus whatever the sampler misses). Three events are of unmarked animals
# (animal_id = "unk", no match in individuals).
recaptured <- setdiff(individuals$fisher_id, c("F04","F11","F17"))
n_events <- 45
events <- tibble(
  capture_event = sprintf("CE-%03d", 1:n_events),
  animal_id     = c(sample(tolower(recaptured), n_events - 3, replace = TRUE), rep("unk", 3)),
  capture_date  = as.Date("2018-03-01") + sample(0:1400, n_events),
  site          = sample(sites, n_events, replace = TRUE),  # CAPTURE site — a fisher may be caught away from where it was released
  mass_kg       = round(rnorm(n_events, mean = 3.2, sd = 1.1), 2),
  collar_id     = sprintf("C%03d", sample(100:400, n_events))
) |>
  mutate(mass_kg = pmax(mass_kg, 1.4)) |>
  arrange(capture_date)

write_csv(individuals, "content/joins/data/fisher_individuals.csv")
write_csv(events,      "content/joins/data/fisher_captures.csv")
cat("wrote", nrow(individuals), "individuals and", nrow(events), "capture events\n")
