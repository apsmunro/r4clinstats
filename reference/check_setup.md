# Check your R setup for r4clinstats

Diagnoses the things that commonly stop a learner getting started on a
managed Windows machine, and optionally fixes them: an out-of-date R, a
package library living inside a synced OneDrive folder, no route to the
package repositories, and missing packages. It prints a short report.

## Usage

``` r
check_setup(install = interactive())
```

## Arguments

- install:

  Logical. Offer to install any missing packages. Defaults to
  [`interactive()`](https://rdrr.io/r/base/interactive.html); set
  `FALSE` to report only.

## Value

Invisibly `TRUE` if everything needed is present, otherwise `FALSE`.

## Examples

``` r
if (FALSE) { # \dontrun{
check_setup()
check_setup(install = TRUE)
} # }
```
