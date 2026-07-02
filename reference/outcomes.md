# Synthetic trial outcomes

One year of follow-up for the
[patients](https://apsmunro.github.io/r4clinstats/reference/patients.md)
cohort, for the analysis lessons (M10-M13): treatment response, adverse
events, and a time-to-event pair censored at one year. Built
reproducibly (`set.seed(2026)`) from
[patients](https://apsmunro.github.io/r4clinstats/reference/patients.md);
the generator is in `data-raw/outcomes.R`. The signal is planted:
response is likelier on the active arm, and the active arm's event
hazard is lower. Like
[labs](https://apsmunro.github.io/r4clinstats/reference/labs.md), the
table carries no `arm` or `age` column on purpose, so the lessons join
back to
[patients](https://apsmunro.github.io/r4clinstats/reference/patients.md).

## Usage

``` r
outcomes
```

## Format

A data frame with 100 rows and 5 variables:

- id:

  Patient identifier, matching
  [patients](https://apsmunro.github.io/r4clinstats/reference/patients.md).

- response:

  Treatment response: "Y" or "N".

- adverse_event:

  Any adverse event: "Y" or "N".

- time:

  Days of event-free follow-up (1-365).

- status:

  1 if the event occurred at `time`, 0 if censored at one year.

## Source

Synthetic.
