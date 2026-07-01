## Generates data/labs.rda  (run data-raw/patients.R first)
## Run from the package root:  source("data-raw/labs.R")

library(dplyr)

if (!file.exists("data/patients.rda")) {
  stop("Run data-raw/patients.R first to create data/patients.rda.")
}
load("data/patients.rda")  # brings in `patients`

set.seed(2025)
visits <- tibble::tibble(visit = c(0L, 1L, 2L), weeks = c(0L, 12L, 24L))

labs <- patients |>
  select(id, arm) |>
  tidyr::crossing(visits) |>
  tidyr::crossing(measure = c("sbp", "weight")) |>
  mutate(
    base  = if_else(measure == "sbp", 138, 85),
    drift = case_when(
      measure == "sbp"    & arm == "Active"  ~ -3.0 * visit,
      measure == "sbp"    & arm == "Placebo" ~ -0.5 * visit,
      measure == "weight" & arm == "Active"  ~ -1.0 * visit,
      measure == "weight" & arm == "Placebo" ~ -0.2 * visit
    ),
    noise = rnorm(n(), 0, if_else(measure == "sbp", 8, 3)),
    value = round(base + drift + noise, 1)
  ) |>
  select(id, visit, weeks, measure, value) |>
  arrange(id, visit, measure)

usethis::use_data(labs, overwrite = TRUE)
