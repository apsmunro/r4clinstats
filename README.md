# r4clinstats

Learn R for clinical statistics, interactively. A swirl-style, learn-by-doing
course for clinicians and clinical researchers: type real code against
real-feeling synthetic clinical data and get immediate, kind feedback. Lessons
are [`learnr`](https://rstudio.github.io/learnr/) tutorials graded by
[`gradethis`](https://pkgs.rstudio.com/gradethis/).

Modules 0–13 are built and runnable (M0–M5 are the MVP).

## What's here so far

- **Module 0 — Why R for clinical data** (narrative: scripts, reproducibility, your first line of R).
- **Module 1 — Tidy data as design** (narrative: tidy shape, wide vs long, design before collection).
- **Module 2 — The building blocks of R** (objects, value types, factors, logical vectors).
- **Module 3 — Wrangling I** (`filter`, `count`, `arrange`, `select`, the pipe `|>`), adapted from the prototype.
- **Module 4 — Wrangling II** (`mutate`, `group_by` + `summarise`).
- **Module 5 — Tidy data in practice** (`pivot_wider`/`pivot_longer`, `left_join`).
- **Module 6 — Reading & cleaning data** (`read_csv`/`here`, recoding, fixing types, missing values).
- **Module 7 — Visualisation I** (the ggplot2 grammar of graphics: scatter, box and bar plots).
- **Module 8 — Visualisation II** (trends over time, faceting, tidying a figure for a paper).
- **Module 9 — Summary tables** (the "Table 1" every clinical paper opens with, via `finalfit`).
- **Module 10 — Describing data** (histograms, mean/SD vs median/IQR, choosing between them).
- **Module 11 — Comparing groups** (t-test, chi-squared, tidy results with `broom`).
- **Module 12 — Regression** (`lm`, baseline adjustment, logistic `glm`, odds ratios).
- **Module 13 — Survival analysis** (censoring, Kaplan-Meier, log-rank, Cox hazard ratios).
- Each interactive module closes with a **Practice** section: open exercises (no blanks) with hints, solutions and grading.
- Datasets **`patients`**, **`labs`**, **`outcomes`** and **`linelist`** (synthetic, reproducible).
- **`learn()`**, **`check_setup()`**, **`use_local_library()`**.
- A test harness in `tests/` that runs every tutorial solution and locks the datasets.

Still to come: a closing module on reproducible reports with Quarto.

## Build it from source (developer)

From the package root, in R:

```r
source("data-raw/patients.R")   # writes data/patients.rda
source("data-raw/labs.R")       # writes data/labs.rda  (run after patients.R)
source("data-raw/outcomes.R")   # writes data/outcomes.rda  (run after patients.R)
source("data-raw/linelist.R")   # writes data/linelist.rda
devtools::document()            # regenerate NAMESPACE and man/ from the roxygen comments
devtools::install()             # install the package locally
devtools::test()                # run the harness
```

`gradethis` is **not on CRAN**. It installs from Posit's R-universe; `check_setup()` handles this, or install it directly:

```r
install.packages("gradethis",
                 repos = c("https://posit-dev.r-universe.dev", getOption("repos")))
```

## The portal (this website)

The landing page, install guide and browser taster are a [`pkgdown`](https://pkgdown.r-lib.org/)
site. Build it locally to preview:

```r
install.packages("pkgdown")
pkgdown::build_site()
```

On every push to `master`, `.github/workflows/pkgdown.yaml` rebuilds the site and publishes it to
GitHub Pages at <https://apsmunro.github.io/r4clinstats/>. Enable Pages once in the repository
settings, serving from the `gh-pages` branch.

## Get started (learner)

```r
library(r4clinstats)
check_setup()     # check your machine and install anything missing
learn()           # list the lessons
learn("m0")       # start at the beginning
```

## Licence

MIT. The bundled datasets are synthetic and contain no real patient data.
