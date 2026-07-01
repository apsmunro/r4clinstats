# Synthetic clinical-trial patients

A made-up cohort of 100 trial patients, one row each. Built reproducibly
(`set.seed(2024)`) and containing no real patient data. The generator is
in `data-raw/patients.R`. Columns are stored as character (not factor)
on purpose, so the early lessons read naturally and M2 can teach
factors.

## Usage

``` r
patients
```

## Format

A data frame with 100 rows and 7 variables:

- id:

  Patient identifier, e.g. "P001".

- age:

  Age in years (40-88).

- sex:

  "Female" or "Male".

- arm:

  Treatment arm: "Placebo" or "Active".

- smoker:

  Smoking status: "Never", "Former" or "Current".

- bmi:

  Body-mass index.

- sbp:

  Systolic blood pressure (mmHg).

## Source

Synthetic.
