# Lock the synthetic datasets: shape, and the seed-dependent counts that the
# tutorials quote in their feedback. If a count here changes, a tutorial's
# wording is now wrong too.

get_data <- function(name) {
  e <- new.env()
  ok <- tryCatch({
    utils::data(list = name, package = "r4clinstats", envir = e)
    TRUE
  }, error = function(err) FALSE)
  if (!ok || !exists(name, envir = e, inherits = FALSE)) return(NULL)
  get(name, envir = e, inherits = FALSE)
}

test_that("patients has the locked shape and seed", {
  patients <- get_data("patients")
  skip_if(is.null(patients), "patients not built yet (run data-raw/patients.R)")

  expect_equal(nrow(patients), 100L)
  expect_named(patients, c("id", "age", "sex", "arm", "smoker", "bmi", "sbp"))
  expect_true(all(patients$age >= 40 & patients$age <= 88))
  expect_setequal(unique(patients$arm), c("Placebo", "Active"))

  # Seed-locked counts the M3 tutorial relies on.
  expect_equal(sum(patients$sex == "Female"), 43L)
  expect_equal(sum(patients$sex == "Male"), 57L)
})

test_that("labs is long and consistent with patients", {
  patients <- get_data("patients")
  labs <- get_data("labs")
  skip_if(is.null(labs), "labs not built yet (run data-raw/labs.R)")

  expect_equal(nrow(labs), 600L)            # 100 patients x 3 visits x 2 measures
  expect_named(labs, c("id", "visit", "weeks", "measure", "value"))
  expect_setequal(unique(labs$measure), c("sbp", "weight"))
  expect_setequal(unique(labs$visit), c(0L, 1L, 2L))
  if (!is.null(patients)) {
    expect_setequal(unique(labs$id), unique(patients$id))
  }
})

test_that("linelist has the locked messy shape and seed", {
  linelist <- get_data("linelist")
  skip_if(is.null(linelist), "linelist not built yet (run data-raw/linelist.R)")

  expect_equal(nrow(linelist), 50L)
  expect_named(linelist, c("id", "sex", "age", "smoker", "arm", "weight"))
  # Deliberately messy: age arrives as text, sex in more than two spellings.
  expect_type(linelist$age, "character")
  expect_gt(length(unique(linelist$sex)), 2L)

  # Seed-locked counts the M6 tutorial quotes in its feedback.
  expect_equal(sum(is.na(linelist$weight)), 5L)
  expect_equal(sum(is.na(suppressWarnings(as.numeric(linelist$age)))), 3L)
  cleaned_sex <- ifelse(tolower(linelist$sex) == "female", "Female", "Male")
  expect_equal(sum(cleaned_sex == "Female"), 21L)
})
