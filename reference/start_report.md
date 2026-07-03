# Start your capstone trial report

Copies the course's Quarto report template into your working directory
and opens it, ready to complete and render. This is the final exercise
of the course (Lesson 14): a real, reproducible analysis report built
outside the tutorial sandbox. The template renders as-is; you fill in
one analysis chunk at a time.

## Usage

``` r
start_report(path = "trial-report.qmd", completed = FALSE, overwrite = FALSE)
```

## Arguments

- path:

  Where to put the report. Defaults to `trial-report.qmd` in the current
  working directory.

- completed:

  Logical. `FALSE` (the default) copies the template with TODO chunks
  for you to complete; `TRUE` copies the finished report, for comparing
  against when stuck.

- overwrite:

  Logical. Overwrite `path` if it already exists. Defaults to `FALSE` so
  you cannot lose work by accident.

## Value

Invisibly, the path to the new file.

## Examples

``` r
if (FALSE) { # \dontrun{
start_report()                  # the template, ready to complete
start_report(completed = TRUE)  # the finished version, to compare
} # }
```
