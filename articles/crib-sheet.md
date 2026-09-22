# Crib sheet: every function in the course

Every function the course teaches, on one page, grouped by the job you
want done.

Keep this open in a second browser tab while you work. A lesson takes
over your R console while it runs, so you cannot look things up there,
but this page is always to hand. It is also worth printing.

## How to read an entry

Each line of code is written so it works on any data, not just the
course’s. The highlighted words are yours: replace each one with a name
from your own data, such as your table or one of its columns. Everything
else, including the brackets, commas and quote marks, is typed exactly
as shown. Where a line has nothing highlighted, type it as it stands.

Under each one, in grey, is an example from the lessons, and the last
column says which lesson taught it, so you can go back to the full
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

r4clinstats::start_report()        # start_report(), from r4clinstats
dplyr::filter(patients, age > 65)  # filter(), from dplyr
```

It is a command to run in the Console. It is not a web address, and
there is nothing to click.

## Getting your data in

[TABLE]

Read the file, never edit it. Then `glimpse()` the result and check the
row count and column types before going further.

## Looking at your data

Start here when you meet a new table.

[TABLE]

## Choosing rows and columns

[TABLE]

## Counting and summarising

[TABLE]

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

[TABLE]

## Reshaping and joining tables

[TABLE]

If a joined column comes back all `NA`, the key values did not match.
That is the quiet failure to watch for.

## Plotting

Every plot is three parts: the data, the `aes()` mapping, and a `geom_`
that draws it. The layers after the first are added with `+`.

[TABLE]

## Tables and tests

[TABLE]

`tidy()` returns up to ten columns, and the output panel hides the ones
that do not fit behind a small arrow at the top right, so the confidence
interval and p-value are often out of sight. Keep the ones you would
report:

``` r

t.test(change ~ arm, data = bp_change) |>
  tidy() |>
  select(estimate, conf.low, conf.high, p.value)
```

For a t-test, `estimate` is the first group’s mean minus the second’s,
with the groups in alphabetical order, so check which way round it is
before you report it. Lesson 11 explains every column.

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

[TABLE]

To draw the Kaplan-Meier curves, tidy the fit and step the line:

``` r

km <- survfit(Surv(time, status) ~ arm, data = trial)

tidy(km) |>
  ggplot(aes(x = time, y = estimate, colour = strata)) +
  geom_step()
```

## Reporting

[TABLE]

**Inline code** writes a number straight into a sentence, so your text
can never disagree with your data. In a Quarto document, wrap the
expression in backticks with an `r` at the front:

    The trial randomised `r nrow(patients)` patients.

That comes out in the finished document as “The trial randomised 100
patients.” (M14)

## Course housekeeping

[TABLE]

## Which lesson taught what

| Lesson | Tools |
|----|----|
| M2 Building blocks | `glimpse`, `head`, `class`, `table`, `factor` |
| M3 Wrangling I | `filter`, `select`, `arrange`, `desc`, `count`, the pipe |
| M4 Wrangling II | `mutate`, `group_by`, `summarise` |
| M5 Tidy data in practice | `pivot_wider`, `pivot_longer`, `left_join` |
| M6 Reading & cleaning | `read_csv`, `read_excel`, `if_else`, `tolower`, `as.numeric`, `is.na` |
| M7 Visualisation I | `ggplot`, `aes`, `geom_point`, `geom_boxplot`, `geom_bar`, `labs` |
| M8 Visualisation II | `geom_line`, `facet_wrap`, `theme_minimal`, `scale_colour_brewer` |
| M9 Summary tables | `summary_factorlist` |
| M10 Describing data | `summary`, `geom_histogram`, `mean`, `sd`, `median`, `IQR` |
| M11 Comparing groups | `t.test`, `chisq.test`, `tidy` |
| M12 Regression | `lm`, `glm`, `geom_smooth` |
| M13 Survival | `Surv`, `survfit`, `survdiff`, `coxph` |
| M14 Reproducible reports | `kable`, inline code, `start_report` |
