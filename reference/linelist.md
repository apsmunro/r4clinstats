# Synthetic messy line list

A small, deliberately untidy dataset for the cleaning lesson (M6): the
same problems you meet in real intake data. Synthetic and built
reproducibly (`set.seed(2027)`); the generator is in
`data-raw/linelist.R`. Everything except `weight` is stored as text, and
the mess is intentional.

## Usage

``` r
linelist
```

## Format

A data frame with 50 rows and 6 variables:

- id:

  Patient identifier, e.g. "L01".

- sex:

  The same variable typed inconsistently ("Female", "female", "MALE",
  ...).

- age:

  Age as text, including a few non-numeric entries that become NA.

- smoker:

  Smoking status in lower case: "never", "former" or "current".

- arm:

  Treatment arm: "Active" or "Placebo".

- weight:

  Weight in kg, with some values missing (NA).

## Source

Synthetic.
