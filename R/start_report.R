#' Start your capstone trial report
#'
#' Copies the course's Quarto report template into your working directory and
#' opens it, ready to complete and render. This is the final exercise of the
#' course (Lesson 14): a real, reproducible analysis report built outside the
#' tutorial sandbox. The template renders as-is; you fill in one analysis
#' chunk at a time.
#'
#' @param path Where to put the report. Defaults to `trial-report.qmd` in the
#'   current working directory.
#' @param completed Logical. `FALSE` (the default) copies the template with
#'   TODO chunks for you to complete; `TRUE` copies the finished report, for
#'   comparing against when stuck.
#' @param overwrite Logical. Overwrite `path` if it already exists. Defaults
#'   to `FALSE` so you cannot lose work by accident.
#' @return Invisibly, the path to the new file.
#' @examples
#' \dontrun{
#' start_report()                  # the template, ready to complete
#' start_report(completed = TRUE)  # the finished version, to compare
#' }
#' @export
start_report <- function(path = "trial-report.qmd", completed = FALSE,
                         overwrite = FALSE) {
  src <- system.file(
    "report-template",
    if (isTRUE(completed)) "trial-report-completed.qmd" else "trial-report.qmd",
    package = "r4clinstats"
  )
  if (src == "")
    stop("The report template is missing; reinstall r4clinstats.", call. = FALSE)
  if (file.exists(path) && !isTRUE(overwrite))
    stop("'", path, "' already exists. Pick another path, or use ",
         "overwrite = TRUE if you mean to replace it.", call. = FALSE)

  file.copy(src, path, overwrite = isTRUE(overwrite))
  message("Created ", normalizePath(path),
          "\nOpen it in RStudio and press Render to build it. ",
          "It renders as-is;\nfill in one TODO chunk at a time and render again.")
  if (interactive()) {
    tryCatch(utils::file.edit(path), error = function(e) NULL)
  }
  invisible(path)
}
