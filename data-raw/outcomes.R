## Generates data/outcomes.rda  (run data-raw/patients.R first)
## Run from the package root:  source("data-raw/outcomes.R")
##
## Trial outcomes for the patients cohort, for the analysis modules (M10-M13):
## treatment response, adverse events, and a time-to-event pair (time, status)
## censored at one year. The clinical signal is planted: response is likelier
## on the active arm and in younger patients, and the event hazard is lower on
## the active arm, so the tests and models in Part 3 find something real.
## Like labs, the table deliberately carries no arm or age column: joining
## back to patients is part of the lessons.

library(dplyr)

if (!file.exists("data/patients.rda")) {
  stop("Run data-raw/patients.R first to create data/patients.rda.")
}
load("data/patients.rda")  # brings in `patients`

set.seed(2026)
outcomes <- patients |>
  select(id, age, arm) |>
  mutate(
    p_resp        = plogis(-0.4 + 1.2 * (arm == "Active") - 0.02 * (age - 63)),
    response      = if_else(runif(n()) < p_resp, "Y", "N"),
    adverse_event = if_else(runif(n()) < 0.15, "Y", "N"),
    # Exponential event times, slowed on the active arm; at least 1 day.
    # The effect sizes here were tuned so the planted signals survive the
    # seed: with the sketch values (0.9, 1.4x) the drawn sample showed no
    # survival benefit and a borderline response difference.
    time          = pmax(round(rexp(n(), 1 / 420) * if_else(arm == "Active", 3, 1)), 1),
    status        = if_else(time >= 365, 0L, 1L),   # 0 = censored at one year
    time          = as.integer(pmin(time, 365))
  ) |>
  select(id, response, adverse_event, time, status)

usethis::use_data(outcomes, overwrite = TRUE)
