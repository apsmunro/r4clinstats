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

#' Synthetic trial outcomes
#'
#' One year of follow-up for the [patients] cohort, for the analysis lessons
#' (M10-M13): treatment response, adverse events, and a time-to-event pair
#' censored at one year. Built reproducibly (`set.seed(2026)`) from [patients];
#' the generator is in `data-raw/outcomes.R`. The signal is planted: response
#' is likelier on the active arm, and the active arm's event hazard is lower.
#' Like [labs], the table carries no `arm` or `age` column on purpose, so the
#' lessons join back to [patients].
#'
#' @format A data frame with 100 rows and 5 variables:
#' \describe{
#'   \item{id}{Patient identifier, matching [patients].}
#'   \item{response}{Treatment response: "Y" or "N".}
#'   \item{adverse_event}{Any adverse event: "Y" or "N".}
#'   \item{time}{Days of event-free follow-up (1-365).}
#'   \item{status}{1 if the event occurred at `time`, 0 if censored at one year.}
#' }
#' @source Synthetic.
"outcomes"

#' Synthetic messy line list
#'
#' A small, deliberately untidy dataset for the cleaning lesson (M6): the same
#' problems you meet in real intake data. Synthetic and built reproducibly
#' (`set.seed(2027)`); the generator is in `data-raw/linelist.R`. Everything
#' except `weight` is stored as text, and the mess is intentional.
#'
#' @format A data frame with 50 rows and 6 variables:
#' \describe{
#'   \item{id}{Patient identifier, e.g. "L01".}
#'   \item{sex}{The same variable typed inconsistently ("Female", "female", "MALE", ...).}
#'   \item{age}{Age as text, including a few non-numeric entries that become NA.}
#'   \item{smoker}{Smoking status in lower case: "never", "former" or "current".}
#'   \item{arm}{Treatment arm: "Active" or "Placebo".}
#'   \item{weight}{Weight in kg, with some values missing (NA).}
#' }
#' @source Synthetic.
"linelist"
