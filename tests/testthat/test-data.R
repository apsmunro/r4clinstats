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

test_that("outcomes has the locked shape and seed", {
  outcomes <- get_data("outcomes")
  patients <- get_data("patients")
  skip_if(is.null(outcomes), "outcomes not built yet (run data-raw/outcomes.R)")

  expect_equal(nrow(outcomes), 100L)
  expect_named(outcomes, c("id", "response", "adverse_event", "time", "status"))
  expect_setequal(unique(outcomes$response), c("Y", "N"))
  expect_setequal(unique(outcomes$status), c(0L, 1L))
  expect_true(all(outcomes$time >= 1 & outcomes$time <= 365))
  expect_true(all(outcomes$time[outcomes$status == 0] == 365L))

  # Seed-locked counts the M10-M13 tutorials quote in their text and feedback.
  expect_equal(sum(outcomes$response == "Y"), 62L)
  expect_equal(sum(outcomes$adverse_event == "Y"), 25L)
  expect_equal(sum(outcomes$status), 42L)
  expect_equal(median(outcomes$time), 365)
  if (!is.null(patients)) {
    joined <- merge(outcomes, patients[, c("id", "arm")], by = "id")
    expect_equal(sum(joined$response == "Y" & joined$arm == "Active"), 36L)
    expect_equal(sum(joined$response == "Y" & joined$arm == "Placebo"), 26L)
    expect_equal(sum(joined$status == 1L & joined$arm == "Active"), 15L)
    expect_equal(sum(joined$status == 1L & joined$arm == "Placebo"), 27L)
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

# bp_change as the M11 and M12 setup chunks build it, in base R so these tests
# need nothing beyond broom.
bp_change_base <- function(patients, labs) {
  sbp <- labs[labs$measure == "sbp", ]
  v0 <- sbp[sbp$visit == 0L, c("id", "value")]
  v2 <- sbp[sbp$visit == 2L, c("id", "value")]
  bp <- merge(merge(v0, v2, by = "id", suffixes = c("_0", "_2")),
              patients[, c("id", "arm")], by = "id")
  data.frame(arm = bp$arm, baseline = bp$value_0,
             change = bp$value_2 - bp$value_0)
}

test_that("the M11 t-test gives the numbers its column key quotes", {
  patients <- get_data("patients")
  labs <- get_data("labs")
  skip_if(is.null(patients) || is.null(labs), "patients or labs not built yet")
  skip_if_not_installed("broom")

  res <- broom::tidy(stats::t.test(change ~ arm, data = bp_change_base(patients, labs)))
  expect_equal(round(res$estimate, 2), -4.84)
  expect_equal(round(res$estimate1, 2), -4.97)   # Active, first alphabetically
  expect_equal(round(res$estimate2, 2), -0.13)   # Placebo
  expect_equal(round(c(res$conf.low, res$conf.high), 2), c(-9.43, -0.25))
  expect_equal(round(res$statistic, 2), -2.09, ignore_attr = TRUE)
  expect_equal(round(res$parameter, 1), 97.9, ignore_attr = TRUE)
  expect_equal(round(res$p.value, 3), 0.039)
})

test_that("most M12 points sit outside the confidence band, as the lesson says", {
  patients <- get_data("patients")
  labs <- get_data("labs")
  skip_if(is.null(patients) || is.null(labs), "patients or labs not built yet")

  bp <- bp_change_base(patients, labs)
  band <- stats::predict(stats::lm(change ~ baseline, data = bp),
                         interval = "confidence")
  inside <- mean(bp$change >= band[, "lwr"] & bp$change <= band[, "upr"])
  expect_true(inside > 0.2 && inside < 0.3)   # "about three-quarters" outside
})
