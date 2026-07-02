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
