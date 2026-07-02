# linelist: a small, DELIBERATELY MESSY clinical dataset for the cleaning module (M6).
# Synthetic, so there is no licence question. It embodies the disasters witnessed
# read-only in M1 and M3, now something the learner tidies with scaffolding:
#   - sex          : the same category typed inconsistently (case variants)
#   - age          : arrived as TEXT, with a few non-numeric entries
#   - weight       : has missing values (NA)
#   - smoker       : lower-case, tidy enough to turn into an ordered factor (Practice)
# See also data-raw/patients.R and data-raw/labs.R.

library(dplyr)

set.seed(2027)
n <- 50

# The same variable, entered every which way. Case only, so tolower() unifies it.
sex <- sample(
  c("Female", "female", "FEMALE", "Male", "male", "MALE"),
  n, replace = TRUE, prob = c(0.24, 0.12, 0.06, 0.30, 0.20, 0.08)
)

# Age typed into a text box: mostly numbers-as-text, a few that aren't numbers at all.
age_num <- round(rnorm(n, 62, 12))
age_num[age_num < 30] <- 30
age_num[age_num > 90] <- 90
age <- as.character(age_num)
age[sample(n, 3)] <- c("unknown", "", "n/a")   # become NA when coerced to numeric

smoker <- sample(c("never", "former", "current"), n, replace = TRUE,
                 prob = c(0.5, 0.3, 0.2))
arm <- sample(c("Active", "Placebo"), n, replace = TRUE)

weight <- round(rnorm(n, 78, 14), 1)
weight[sample(n, 5)] <- NA                       # missing values to handle

linelist <- tibble::tibble(
  id     = sprintf("L%02d", seq_len(n)),
  sex    = sex,
  age    = age,
  smoker = smoker,
  arm    = arm,
  weight = weight
)

usethis::use_data(linelist, overwrite = TRUE)
