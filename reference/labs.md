# Synthetic longitudinal labs

Repeated measurements for the
[patients](https://apsmunro.github.io/r4clinstats/reference/patients.md)
cohort: systolic blood pressure and weight at three visits. Long format,
one row per patient \* visit \* measure. Built reproducibly
(`set.seed(2025)`) from
[patients](https://apsmunro.github.io/r4clinstats/reference/patients.md);
the generator is in `data-raw/labs.R`. SBP falls faster on the active
arm, so a trend is there to be found once the data is pivoted.

## Usage

``` r
labs
```

## Format

A data frame with 600 rows and 5 variables:

- id:

  Patient identifier, matching
  [patients](https://apsmunro.github.io/r4clinstats/reference/patients.md).

- visit:

  Visit number: 0, 1 or 2.

- weeks:

  Weeks since baseline: 0, 12 or 24.

- measure:

  "sbp" or "weight".

- value:

  Measured value.

## Source

Synthetic.
