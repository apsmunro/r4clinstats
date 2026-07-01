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

  suppressPackageStartupMessages({
    require(dplyr, quietly = TRUE)
    if (requireNamespace("tidyr", quietly = TRUE)) require(tidyr, quietly = TRUE)
  })

  total <- 0L
  for (rmd in rmds) {
    rmd_lines <- readLines(rmd, warn = FALSE)
    sols <- extract_solution_code(rmd)
    for (label in names(sols)) {
      total <- total + 1L
      # If a matching `<label>-setup` chunk exists, run it first so the
      # solution sees any objects the live exercise was given to start from.
      base <- sub("-solution$", "", label)
      setup_code <- extract_chunk_by_label(rmd_lines, paste0(base, "-setup"))
      code <- if (nzchar(setup_code)) {
        paste(setup_code, sols[[label]], sep = "\n")
      } else {
        sols[[label]]
      }
      e <- new.env(parent = base_env)
      expect_error(
        eval(parse(text = code), envir = e),
        NA,
        info = paste(basename(rmd), "/", label)
      )
    }
  }
  expect_gt(total, 0L)
})
