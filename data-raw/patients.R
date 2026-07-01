## Generates data/patients.rda
## Run from the package root:  source("data-raw/patients.R")

set.seed(2024)
n <- 100
age <- round(rnorm(n, 63, 11))
age[age < 40] <- 40
age[age > 88] <- 88

patients <- data.frame(
  id     = sprintf("P%03d", 1:n),
  age    = age,
  sex    = sample(c("Female", "Male"), n, TRUE, prob = c(0.48, 0.52)),
  arm    = sample(c("Placebo", "Active"), n, TRUE),
  smoker = sample(c("Never", "Former", "Current"), n, TRUE, prob = c(0.5, 0.3, 0.2)),
  bmi    = round(rnorm(n, 28, 4.5), 1),
  sbp    = round(rnorm(n, 138, 16)),
  stringsAsFactors = FALSE
)

usethis::use_data(patients, overwrite = TRUE)
