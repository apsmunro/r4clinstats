# The capstone report templates (inst/report-template/) must have working
# code: the completed one because it is the course's final promise, and the
# scaffold because a learner presses Render on it before filling anything in.
# Quarto itself is not on CI, so this runs every chunk's code in order, which
# is what a render does.

extract_qmd_chunk_code <- function(path) {
  lines <- readLines(path, warn = FALSE)
  starts <- grep("^```\\{r[^}]*\\}", lines)
  fences <- grep("^```\\s*$", lines)
  out <- character()
  for (s in starts) {
    e <- fences[fences > s][1]
    if (is.na(e)) next
    body <- lines[(s + 1):(e - 1)]
    body <- body[!grepl("^#\\|", body)]   # strip quarto chunk options
    out <- c(out, paste(body, collapse = "\n"))
  }
  out
}

# Inline `r ...` expressions in the prose must run too; a broken one kills a
# render just as surely as a broken chunk.
extract_qmd_inline_code <- function(path) {
  lines <- readLines(path, warn = FALSE)
  fence <- grepl("^```", lines)
  in_chunk <- cumsum(fence) %% 2 == 1
  prose <- lines[!in_chunk & !fence]
  m <- regmatches(prose, gregexpr("`r ([^`]+)`", prose))
  code <- unlist(m)
  sub("^`r (.+)`$", "\\1", code)
}

run_template_test <- function(file) {
  tpl <- system.file("report-template", file, package = "r4clinstats")
  skip_if(tpl == "", paste(file, "not installed"))
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("broom")
  skip_if_not_installed("survival")
  skip_if_not_installed("finalfit")
  skip_if_not_installed("knitr")

  env <- new.env(parent = globalenv())
  for (code in extract_qmd_chunk_code(tpl)) {
    expect_error(
      suppressWarnings(suppressMessages(eval(parse(text = code), envir = env))),
      NA,
      info = paste(file, "chunk starting:", substr(code, 1, 60))
    )
  }
  for (code in extract_qmd_inline_code(tpl)) {
    expect_error(
      eval(parse(text = code), envir = env),
      NA,
      info = paste(file, "inline:", code)
    )
  }
}

test_that("the completed report template runs end to end", {
  run_template_test("trial-report-completed.qmd")
})

test_that("the scaffold report template runs as shipped", {
  run_template_test("trial-report.qmd")
})
