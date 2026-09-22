# r4clinstats 0.3.3

- `learn()` with no argument now lists the lessons and returns to the `>`
  prompt, without the numbered pick-list. That list numbered from 1 while the
  modules start at m0, so a learner who typed 10 for "m10 Describing data" was
  taken to m9, Summary tables. Its `Selection:` prompt also rejected R code,
  and a tester typed `learn("m10")` into it twice before trying a number.
  `learn("m10")` is now the one way to open a lesson, everywhere.
- Comparing groups explains the ten columns `tidy()` returns for a t-test,
  and how to read the sign of `estimate`: it is the first group minus the
  second, in alphabetical order, so renaming the arms can flip it.
- Regression explains `se = FALSE`, and what the grey band it hides actually
  shows: a confidence interval for the line, not the spread of patients.
- The crib sheet is written so it works on any data. Each entry is a
  template with the parts you replace highlighted, and an example from the
  lessons beneath it, so it is clear which words are yours and which are R's.
  That matters most for quote marks, which `summary_factorlist()` needs round
  column names and `filter()` does not.

# r4clinstats 0.3.2

- The install no longer names the rstudio R-universe alongside CRAN. That
  universe also serves development builds of `learnr` and `rmarkdown`, and
  `install.packages()` takes the highest version it can see rather than the
  first repository listed, so the one-command install in 0.3.1 quietly put
  learners on an unreleased `learnr`: the engine every lesson runs on. The
  course now installs from CRAN and its own R-universe, and `check_setup()`
  fetches `gradethis` on its own afterwards. `.install_missing()` keeps the
  two apart for the same reason.
- `install-check` tests the two-step guide as written and fails if a
  development build of `learnr` or `rmarkdown` reaches a learner's library.
  This was found by running that job against a genuinely clean machine, which
  is the only place it was visible.

# r4clinstats 0.3.1

- `gradethis` moved from Posit's `posit-dev` R-universe to `rstudio`. The old
  server still answers, so installs failed with R's misleading "package
  'gradethis' is not available for this version of R" rather than anything
  pointing at the real cause. Every reference now names the new server:
  `check_setup()`, the automatic installer, `DESCRIPTION` and the guides.
- `check_setup()` now asks whether `gradethis` is actually in the repository
  rather than whether the server answers. Through the whole outage above the
  old check reported `[OK ]`, because the server it tested stayed up after the
  package left it. A moved package is now named as such, with somewhere to
  report it.
- The course installs from <https://apsmunro.r-universe.dev> instead of
  `remotes::install_github()`. GitHub allows 60 anonymous API requests an hour
  per network address, which a hospital or university shares across everyone
  behind it, so a group installing together hit HTTP 403. R-universe has no
  such limit and serves a Windows binary. Troubleshooting gained an entry for
  the 403, with a tarball fallback for networks that block R-universe.
- Dropped the `Remotes:` field, which made every install resolve a second
  GitHub repository. CI now names the R-universe in `extra-repositories`
  instead: that field, not `Additional_repositories`, is what the dependency
  solver reads, and removing `Remotes:` without it broke both workflows.
- A weekly `install-check` job installs the course from R-universe on Windows
  exactly as a learner would, then runs `check_setup()`. The next time this
  path breaks, CI notices rather than a clinician.

# r4clinstats 0.3.0

- M14, Reproducible reports: the capstone, and the course is complete. The
  learner rebuilds the whole trial analysis as six graded exercises (no
  blanks, for the first time in the course), then leaves the sandbox:
  `start_report()` copies a Quarto report template with matching TODO chunks
  into their working directory, and the lesson ends with a real rendered
  document. The scaffold renders as shipped, so the render-early habit works
  from minute zero; `start_report(completed = TRUE)` is the escape hatch.
- The closing bookend: M14 returns to the four core books introduced in M0,
  and adds a five-step guide to starting a real project with your own data.
- Both report templates are tested chunk by chunk (and inline expression by
  inline expression) in CI.

# r4clinstats 0.2.1

- `learn()` groups the menu by course part, matching the website.
- Every graded exercise with a targeted catch now declares its common wrong
  answer in the tutorial source, and the test harness verifies the catch
  fires with the intended feedback. This found and fixed a real hole: M4's
  quoted-threshold mistake (`bmi >= "30"`) used to pass by coincidence; the
  grader now catches it and explains why text comparison is a trap.
- CI also runs on Windows, where the course's learners actually are.

# r4clinstats 0.2.0

- Part 3, the analysis modules: M10 Describing data, M11 Comparing groups,
  M12 Regression, and M13 Survival analysis.
- The `outcomes` dataset: one year of follow-up for the patients cohort, with
  response, adverse events, and a censored time-to-event pair. Effect sizes
  were tuned so the planted signals survive the seed (response OR 2.66,
  hazard ratio 0.47, both clear of 1).
- The analysis arc is deliberate: baseline balance (no test needed), then the
  change-score t-test (p = 0.039), then the baseline-adjusted model that
  sharpens it (p = 0.002) — regression to the mean and ANCOVA taught with the
  course's own trial.
- `check_setup()` now also checks `survival` and `broom`.

# r4clinstats 0.1.0

- Four new modules: M6 Reading & cleaning data, M7 Visualisation I,
  M8 Visualisation II, and M9 Summary tables, with the synthetic `linelist`
  dataset for the cleaning lesson.
- M9 now teaches when a baseline table should carry p-values and when it
  should not: a randomised trial's Table 1 describes the arms without testing
  them (CONSORT), so the `p = TRUE` exercises compare non-randomised groups.
- Plot exercises accept aesthetics mapped inside the geom as well as in
  `ggplot()`, and the faceting exercises check the faceting variable rather
  than only that faceting happened (`facet_grid()` is accepted too).
- M3 trimmed so it no longer repeats M1's tidy-data material, and retitled
  Wrangling I to match the menu.
- The test harness now feeds every canonical solution through its own
  gradethis grader and asserts a pass, and checks that every graded exercise
  has a hint and a solution.
- Monthly scheduled CI run, so a breaking tidyverse release surfaces on a
  schedule rather than in a learner's session.

# r4clinstats 0.0.0.9000

- The MVP: modules M0-M5, the `patients` and `labs` datasets, `learn()`,
  `check_setup()`, `use_local_library()`, the pkgdown portal with the webR
  taster, and the solution-running test harness.
