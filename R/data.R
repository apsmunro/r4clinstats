#' Synthetic clinical-trial patients
#'
#' A made-up cohort of 100 trial patients, one row each. Built reproducibly
#' (`set.seed(2024)`) and containing no real patient data. The generator is in
#' `data-raw/patients.R`. Columns are stored as character (not factor) on
#' purpose, so the early lessons read naturally and M2 can teach factors.
#'
#' @format A data frame with 100 rows and 7 variables:
#' \describe{
#'   \item{id}{Patient identifier, e.g. "P001".}
#'   \item{age}{Age in years (40-88).}
#'   \item{sex}{"Female" or "Male".}
#'   \item{arm}{Treatment arm: "Placebo" or "Active".}
#'   \item{smoker}{Smoking status: "Never", "Former" or "Current".}
#'   \item{bmi}{Body-mass index.}
#'   \item{sbp}{Systolic blood pressure (mmHg).}
#' }
#' @source Synthetic.
"patients"

#' Synthetic longitudinal labs
#'
#' Repeated measurements for the [patients] cohort: systolic blood pressure and
#' weight at three visits. Long format, one row per patient * visit * measure.
#' Built reproducibly (`set.seed(2025)`) from [patients]; the generator is in
#' `data-raw/labs.R`. SBP falls faster on the active arm, so a trend is there to
#' be found once the data is pivoted.
#'
#' @format A data frame with 600 rows and 5 variables:
#' \describe{
#'   \item{id}{Patient identifier, matching [patients].}
#'   \item{visit}{Visit number: 0, 1 or 2.}
#'   \item{weeks}{Weeks since baseline: 0, 12 or 24.}
#'   \item{measure}{"sbp" or "weight".}
#'   \item{value}{Measured value.}
#' }
#' @source Synthetic.
"labs"
