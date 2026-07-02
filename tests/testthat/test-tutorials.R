# Harness for the graded tutorials (see build-spec.md, section H).
# For each built tutorial it pulls out every `*-solution` chunk and runs it
# against the lesson's data, asserting it executes without error.
# This is the cheap guard against a solution silently breaking when the
# tidyverse changes under it.

# Extract the code of every chunk whose label ends in "-solution".
extract_solution_code <- function(rmd) {
  lines <- readLines(rmd, warn = FALSE)
  starts <- grep("^```\\{r[^}]*-solution[^}]*\\}", lines)
  fences <- grep("^```\\s*$", lines)
  out <- list()
  for (s in starts) {
    e <- fences[fences > s][1]
    if (is.na(e)) next
    label <- sub("^```\\{r\\s*([^,}]+).*$", "\\1", lines[s])
    out[[trimws(label)]] <- paste(lines[(s + 1):(e - 1)], collapse = "\n")
  }
  out
}

# Pull a single chunk's code by exact label, or "" if there is no such chunk.
# Used to fetch an exercise's `-setup` chunk so its solution sees the same
# objects the live exercise was handed.
extract_chunk_by_label <- function(rmd_lines, label) {
  pat <- paste0("^```\\{r\\s+", label, "[,} ]")
  s <- grep(pat, rmd_lines)
  if (length(s) == 0L) return("")
  s <- s[1]
  fences <- grep("^```\\s*$", rmd_lines)
  e <- fences[fences > s][1]
  if (is.na(e)) return("")
  paste(rmd_lines[(s + 1):(e - 1)], collapse = "\n")
}

test_that("every built tutorial's solution chunks run without error", {
  skip_if_not_installed("dplyr")

  tut_root <- system.file("tutorials", package = "r4clinstats")
  skip_if(tut_root == "", "tutorials not installed")
  rmds <- list.files(tut_root, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  skip_if(length(rmds) == 0L, "no tutorials found")

  # Shared data and packages for evaluating the solutions.
  base_env <- new.env()
  ok <- tryCatch({
    utils::data("patients", package = "r4clinstats", envir = base_env)
    TRUE
  }, error = function(err) FALSE)
  skip_if(!ok, "datasets not built yet (run data-raw/patients.R)")
  tryCatch(utils::data("labs", package = "r4clinstats", envir = base_env),
           error = function(err) NULL)
  tryCatch(utils::data("linelist", package = "r4clinstats", envir = base_env),
           error = function(err) NULL)

  suppressPackageStartupMessages({
    require(dplyr, quietly = TRUE)
    if (requireNamespace("tidyr", quietly = TRUE)) require(tidyr, quietly = TRUE)
    if (requireNamespace("ggplot2", quietly = TRUE)) require(ggplot2, quietly = TRUE)
    if (requireNamespace("finalfit", quietly = TRUE)) require(finalfit, quietly = TRUE)
  })

  total <- 0L
  for (rmd in rmds) {
    rmd_lines <- readLines(rmd, warn = FALSE)

    # Run the tutorial's global `setup` chunk once into a per-tutorial env, so
    # its packages and any derived objects (joined or summarised tables, etc.)
    # are in scope for the solutions, exactly as they are for the live
    # exercises. A genuine setup error shows up as a failure here.
    tut_env <- new.env(parent = base_env)
    global_setup <- extract_chunk_by_label(rmd_lines, "setup")
    setup_err <- NULL
    if (nzchar(global_setup)) {
      setup_err <- tryCatch({
        suppressWarnings(suppressMessages(
          eval(parse(text = global_setup), envir = tut_env)
        ))
        NULL
      }, error = function(err) conditionMessage(err))
    }
    expect_null(setup_err, info = paste(basename(rmd), "/ setup"))
    if (!is.null(setup_err)) next

    sols <- extract_solution_code(rmd)
    for (label in names(sols)) {
      total <- total + 1L
      # If a matching `<label>-setup` chunk exists, run it first too, so the
      # solution sees any objects the live exercise was given to start from.
      base <- sub("-solution$", "", label)
      ex_setup <- extract_chunk_by_label(rmd_lines, paste0(base, "-setup"))
      code <- if (nzchar(ex_setup)) {
        paste(ex_setup, sols[[label]], sep = "\n")
      } else {
        sols[[label]]
      }
      e <- new.env(parent = tut_env)
      expect_error(
        eval(parse(text = code), envir = e),
        NA,
        info = paste(basename(rmd), "/", label)
      )
    }
  }
  expect_gt(total, 0L)
})

# The solution runner above never executes the `-check` graders, so a typo
# inside a grade_this() block would only surface when a learner submits an
# answer. Guard the structure instead: every grader must at least parse, and
# every graded exercise must keep the course promise of a Hint and a Solution.
test_that("every grader parses, with a hint and solution alongside it", {
  tut_root <- system.file("tutorials", package = "r4clinstats")
  skip_if(tut_root == "", "tutorials not installed")
  rmds <- list.files(tut_root, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  skip_if(length(rmds) == 0L, "no tutorials found")

  n_checks <- 0L
  for (rmd in rmds) {
    rmd_lines <- readLines(rmd, warn = FALSE)
    starts <- grep("^```\\{r[^}]*\\}", rmd_lines)
    labels <- trimws(sub("^```\\{r\\s*([^,}]+).*$", "\\1", rmd_lines[starts]))

    for (chk in labels[grepl("-check$", labels)]) {
      n_checks <- n_checks + 1L
      base <- sub("-check$", "", chk)
      where <- paste(basename(rmd), "/", base)

      expect_true(paste0(base, "-solution") %in% labels,
                  info = paste(where, "is graded but has no -solution chunk"))
      expect_true(any(startsWith(labels, paste0(base, "-hint"))),
                  info = paste(where, "is graded but has no -hint chunk"))
      expect_error(parse(text = extract_chunk_by_label(rmd_lines, chk)),
                   NA, info = paste(where, "-check does not parse"))
    }

    # And the reverse: a solution without a grader is an ungraded exercise
    # pretending to be graded.
    for (sol in labels[grepl("-solution$", labels)]) {
      expect_true(sub("-solution$", "-check", sol) %in% labels,
                  info = paste(basename(rmd), "/", sol, "has no matching -check chunk"))
    }
  }
  expect_gt(n_checks, 0L)
})
