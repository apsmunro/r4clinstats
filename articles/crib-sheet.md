# Crib sheet: every function in the course

Every function the course teaches, on one page, grouped by the job you
want done.

Keep this open in a second browser tab while you work. A lesson takes
over your R console while it runs, so you cannot look things up there,
but this page is always to hand. It is also worth printing.

Each entry says which lesson introduced it, so you can go back to the
explanation whenever a one-line reminder is not enough.

## Two symbols worth knowing

These two turn up everywhere and neither is guessable.

**The pipe, `|>`, means “and then.”** It carries the result of one step
into the next, so a pipeline reads top to bottom like a recipe:

``` r

patients |>
  filter(age > 70) |>
  select(id, age, arm)
```

*Take patients, and then keep the older ones, and then show these three
columns.*

**The tilde, `~`, means “by”, or “explained by.”** What you are
measuring goes on the left, what splits or explains it goes on the
right:

``` r

change ~ arm          # change, by arm
facet_wrap(~ arm)     # one panel, by arm
```

A third piece of punctuation is worth knowing even though it is not a
symbol you type often. **`package::function()`**, with two colons, means
“this function, out of this package”:

``` r

r4clinstats::start_report()      # start_report(), from r4clinstats
remotes::install_github("...")   # install_github(), from remotes
```

It is a command to run in the Console. It is not a web address, and
there is nothing to click.

## Looking at your data

Start here when you meet a new table.

| Code | What it does | Lesson |
|----|----|----|
| `glimpse(patients)` | Every column, its type, and the first few values. The best first look. | M2 |
| `head(patients)` | The first six rows. | M2 |
| `summary(patients$age)` | Min, max, quartiles, median and mean of a number. | M10 |
| `class(patients$sex)` | What type a column is: `chr`, `dbl`, `fct`, `lgl`. | M2 |
| `table(patients$smoker)` | Counts of each category, base R’s version of `count()`. | M2 |
| `nrow(patients)` | How many rows. | M14 |

## Choosing rows and columns

| Code | What it does | Lesson |
|----|----|----|
| `filter(patients, arm == "Active")` | Keep the rows matching a condition. Note the double `==`. | M3 |
| `filter(patients, age > 70, sex == "Female")` | Several conditions at once, separated by commas, all must hold. | M6 |
| `select(patients, id, age, arm)` | Keep only these columns, in this order. | M3 |
| `arrange(patients, age)` | Sort, smallest first. | M3 |
| `arrange(patients, desc(age))` | Sort, largest first. `desc()` flips it. | M3 |

## Counting and summarising

| Code | What it does | Lesson |
|----|----|----|
| `count(patients, smoker)` | How many rows in each group. The count column is called `n`. | M3 |
| `summarise(patients, mean_age = mean(age))` | Collapse a column to one number. The name on the left of `=` becomes the column name. | M4 |
| `mean(age)`, `median(age)`, `sd(age)`, `IQR(age)` | The summary numbers themselves. Use mean and SD for a symmetric shape, median and IQR when it is lopsided. | M4, M10 |

The two you will reach for most are a sorted tally, and a summary per
group:

``` r

patients |>                        # tally, most common first
  count(smoker) |>
  arrange(desc(n))

patients |>                        # one row per group
  group_by(arm) |>
  summarise(mean_age = mean(age))
```

## Making and changing columns

| Code | What it does | Lesson |
|----|----|----|
| `mutate(patients, high_bp = sbp > 140)` | Add a column built from the others. A comparison gives `TRUE`/`FALSE`. | M4 |
| `mutate(linelist, sex = if_else(tolower(sex) == "female", "Female", "Male"))` | `if_else()` picks between two values per row; [`tolower()`](https://rdrr.io/r/base/chartr.html) flattens case. The standard recoding pair. | M6 |
| `mutate(linelist, age = as.numeric(age))` | Convert text to numbers. Anything that was never a number becomes `NA`, with a warning. | M6 |
| `is.na(weight)` | `TRUE` where a value is missing. `!is.na(weight)` is “has a value”. | M6 |
| `factor(x, levels = c("Never", "Former", "Current"))` | Fix the order of categories, instead of R’s alphabetical default. This is what tidies your tables and plot axes. | M2 |
| `factor(x, levels = c(...), ordered = TRUE)` | The same, plus permission to compare levels with `<` and `>`. Only needed for a real scale, like tumour stage. | M2 |

## Reshaping and joining tables

| Code | What it does | Lesson |
|----|----|----|
| `pivot_wider(names_from = visit, values_from = value)` | Long to wide: one column per visit. `names_from` supplies the new headings, `values_from` fills the cells. | M5 |
| `pivot_longer(cols = c(v0, v1, v2), names_to = "visit", values_to = "value")` | Wide back to long, the reverse move. | M5 |
| `left_join(labs, patients, by = "id")` | Bring columns from a second table across, matching on a shared column. Keeps every row of the left table. | M5 |
| `left_join(labs, select(patients, id, arm), by = "id")` | Narrow the right table first when you only want a column or two. | M5 |

If a joined column comes back all `NA`, the key values did not match.
That is the quiet failure to watch for.

## Plotting

Every plot is three parts: the data, the `aes()` mapping, and a `geom_`
that draws it.

| Code | What it does | Lesson |
|----|----|----|
| `ggplot(patients, aes(x = bmi, y = sbp)) + geom_point()` | Scatter plot: how two numbers relate. | M7 |
| `aes(x = bmi, y = sbp, colour = arm)` | Map a third variable to colour. Inside `aes()` means “from the data”, and ggplot adds the legend. | M7 |
| `geom_point(colour = "steelblue")` | A fixed colour, outside `aes()`, carrying no information. | M7 |
| `geom_boxplot()` | One box per group: median line, middle half in the box. | M7 |
| `geom_bar()` | Counts rows per category. No `y` needed, it counts for you. | M7 |
| `geom_histogram(binwidth = 5)` | The shape of one number. Aim for about ten bars, then adjust. | M10 |
| `geom_line()` with `aes(group = id)` | Joins each patient’s readings into their own line. | M8 |
| `geom_line(linewidth = 1)` | Thicker lines, which survive being shrunk into a paper. Set outside `aes()`, because it is a fixed choice rather than something read from the data. | M8 |
| `geom_step()` | Draws a staircase rather than a sloped line, which is the correct shape for a survival curve. | M13 |
| `geom_smooth(method = "lm")` | Adds a fitted straight line through the points. | M12 |
| `facet_wrap(~ arm)` | One panel per group, all on the same scale. Use when a single panel is too crowded. | M8 |
| `labs(x = "Weeks", y = "Systolic BP", colour = "Treatment arm")` | Readable axis and legend titles. | M7, M8 |
| `theme_minimal()` | A cleaner look for a paper. | M8 |
| `scale_colour_brewer(palette = "Dark2")` | Colours a reader with red-green colour blindness can still tell apart. Worth it from three groups up. Use `scale_fill_brewer()` for bars and boxes. | M8 |
| `scale_colour_viridis_d()` | The same idea for an ordered variable; `scale_colour_viridis_c()` for a continuous one. | M8 |

## Tables and tests

| Code | What it does | Lesson |
|----|----|----|
| `summary_factorlist("arm", c("age", "sex", "bmi"))` | The whole of Table 1 in one line. First argument is the dependent (the columns), then the variables to describe. From the `finalfit` package. | M9 |
| `summary_factorlist("sex", c("age", "bmi"), p = TRUE)` | Adds a p-value per variable. One test per variable, not per level. Leave it off a randomised baseline table. | M9 |
| `t.test(change ~ arm, data = bp_change)` | Compares a mean between two groups. | M11 |
| `chisq.test(table(patients$smoker, patients$arm))` | Tests whether two categories are associated. | M11 |
| `tidy(result)` | Turns any test or model into a tidy data frame, with columns like `estimate` and `p.value`. From the `broom` package. | M11 |

`tidy()` returns up to ten columns, and the output panel hides the ones
that do not fit behind a small arrow at the top right, so the confidence
interval and p-value are often out of sight. Keep the ones you would
report:

``` r

t.test(change ~ arm, data = bp_change) |>
  tidy() |>
  select(estimate, conf.low, conf.high, p.value)
```

### Reading `e-17` and the like

R writes very small numbers in **scientific notation**. `e-17` means
“shift the decimal point 17 places left”, and the exponent does all the
work:

| R shows    | Means                 | Report as  |
|------------|-----------------------|------------|
| `6.78e-17` | 0.0000000000000000678 | p \< 0.001 |
| `1.98e-03` | 0.00198               | p = 0.002  |
| `4.20e-02` | 0.042                 | p = 0.042  |

`1.98e-03` is 0.002, **not** 1.98. A p-value can never exceed 1, so if
yours looks bigger, you have missed the exponent. (M12)

## Models

All of them share the same formula shape: outcome, tilde, predictors.
Add a predictor with `+`.

| Code | What it does | Lesson |
|----|----|----|
| `lm(change ~ arm, data = bp_change)` | Linear regression, for a numeric outcome. | M12 |
| `lm(change ~ baseline + arm, data = bp_change)` | The same, adjusted for baseline. Adding predictors is what regression is for. | M12 |
| `glm(response ~ arm, data = trial, family = binomial)` | Logistic regression, for a yes/no outcome. | M12 |
| `tidy(model, exponentiate = TRUE, conf.int = TRUE)` | Odds ratios (or hazard ratios) with confidence intervals. Both are switches, and both are off by default. | M12 |
| `Surv(time, status)` | Packages follow-up time and censoring into one outcome. | M13 |
| `survfit(Surv(time, status) ~ arm, data = trial)` | Kaplan-Meier estimate, one curve per group. | M13 |
| `survdiff(Surv(time, status) ~ arm, data = trial)` | The log-rank test: do the curves differ? | M13 |
| `coxph(Surv(time, status) ~ arm, data = trial)` | Cox model, for the hazard ratio. | M13 |

To draw the Kaplan-Meier curves, tidy the fit and step the line:

``` r

km <- survfit(Surv(time, status) ~ arm, data = trial)

tidy(km) |>
  ggplot(aes(x = time, y = estimate, colour = strata)) +
  geom_step()
```

## Reporting

| Code | What it does | Lesson |
|----|----|----|
| `kable(my_table)` | Typesets a data frame as a proper table in a rendered document. Pipe a table into it as the last step. | M14 |
| [`start_report()`](https://apsmunro.github.io/r4clinstats/reference/start_report.md) | Puts the report template in your working directory and opens it. | M14 |

**Inline code** writes a number straight into a sentence, so your text
can never disagree with your data. In a Quarto document, wrap the
expression in backticks with an `r` at the front:

    The trial randomised `r nrow(patients)` patients.

That comes out in the finished document as “The trial randomised 100
patients.” (M14)

## Course housekeeping

| Code | What it does |
|----|----|
| [`learn()`](https://apsmunro.github.io/r4clinstats/reference/learn.md) | List the lessons. |
| `learn("m4")` | Open a lesson. |
| [`check_setup()`](https://apsmunro.github.io/r4clinstats/reference/check_setup.md) | Check your machine and install anything missing. |
| [`use_local_library()`](https://apsmunro.github.io/r4clinstats/reference/use_local_library.md) | Move your package library out of OneDrive, if installs keep failing. |

## Which lesson taught what

| Lesson | Tools |
|----|----|
| M2 Building blocks | `glimpse`, `head`, `class`, `table`, `factor` |
| M3 Wrangling I | `filter`, `select`, `arrange`, `desc`, `count`, the pipe |
| M4 Wrangling II | `mutate`, `group_by`, `summarise` |
| M5 Tidy data in practice | `pivot_wider`, `pivot_longer`, `left_join` |
| M6 Reading & cleaning | `if_else`, `tolower`, `as.numeric`, `is.na` |
| M7 Visualisation I | `ggplot`, `aes`, `geom_point`, `geom_boxplot`, `geom_bar`, `labs` |
| M8 Visualisation II | `geom_line`, `facet_wrap`, `theme_minimal` |
| M9 Summary tables | `summary_factorlist` |
| M10 Describing data | `summary`, `geom_histogram`, `mean`, `sd`, `median`, `IQR` |
| M11 Comparing groups | `t.test`, `chisq.test`, `tidy` |
| M12 Regression | `lm`, `glm`, `geom_smooth` |
| M13 Survival | `Surv`, `survfit`, `survdiff`, `coxph` |
| M14 Reproducible reports | `kable`, inline code, `start_report` |
