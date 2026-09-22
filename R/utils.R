# Internal helpers (not exported).

# Can we reach a URL? Returns TRUE/FALSE, never errors or hangs for long.
.can_reach <- function(url, timeout = 5L) {
  isTRUE(tryCatch({
    h <- curlGetHeaders(url, timeout = timeout)
    st <- attr(h, "status")
    is.numeric(st) && st > 0
  }, error = function(e) FALSE))
}

# The repository that serves gradethis. Posit has moved it between R-universe
# accounts before, so it is named once here rather than in every caller.
.gradethis_repo <- function() "https://rstudio.r-universe.dev"

# Is gradethis actually being served, or does the server merely answer?
# Returns "ok", "missing" (server up, package no longer on it) or
# "unreachable". The distinction matters: when gradethis moved off
# posit-dev.r-universe.dev, the old server kept answering, so a reachability
# test reported everything fine while installs failed. Source packages are
# checked because a pure-R package installs from source when no binary is
# built for the learner's R version.
.gradethis_status <- function(repo = .gradethis_repo(), timeout = 10L) {
  old <- options(timeout = timeout)
  on.exit(options(old), add = TRUE)
  db <- tryCatch(
    utils::available.packages(repos = repo, type = "source"),
    error = function(e) NULL, warning = function(w) NULL
  )
  if (is.null(db) || nrow(db) == 0L) return("unreachable")
  if ("gradethis" %in% rownames(db)) "ok" else "missing"
}

# Packages the tutorials need at run time. gradethis is not on CRAN, so
# installing these must go through .install_missing() and its extra repository;
# a plain install.packages("gradethis") fails with a misleading message about
# the R version.
.course_pkgs <- function() {
  c("learnr", "gradethis", "dplyr", "tidyr", "ggplot2", "readr",
    "here", "finalfit", "survival", "broom")
}

# Which of the course packages are not installed?
.missing_pkgs <- function(pkgs = .course_pkgs()) {
  pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
}

# Install missing course packages. Everything but gradethis comes from CRAN,
# and gradethis alone from the R-universe. Keeping the two apart matters: the
# R-universe also serves development builds of learnr and rmarkdown, and
# install.packages() takes the highest version it can see rather than the
# first repository listed, so naming both repositories at once quietly puts
# learners on unreleased builds of the engine their lessons run on.
#
# Institutional networks sometimes block R-universe while allowing CRAN and
# GitHub, so if gradethis is still missing afterwards we fall back to
# installing it from GitHub, and failing that print manual instructions.
.install_missing <- function(pkgs) {
  from_cran <- setdiff(pkgs, "gradethis")
  if (length(from_cran)) {
    try(utils::install.packages(
      from_cran,
      repos = c(CRAN = "https://cloud.r-project.org")
    ))
  }

  if ("gradethis" %in% pkgs) {
    try(utils::install.packages(
      "gradethis",
      repos = c(.gradethis_repo(), CRAN = "https://cloud.r-project.org")
    ))
  }

  if ("gradethis" %in% pkgs &&
      !requireNamespace("gradethis", quietly = TRUE)) {
    cat("\ngradethis did not install from R-universe (some networks block it).\n")
    cat("Trying GitHub instead...\n")
    .install_gradethis_from_github()
  }

  if ("gradethis" %in% pkgs &&
      !requireNamespace("gradethis", quietly = TRUE)) {
    cat("\ngradethis could not be installed automatically. To install it by hand:\n")
    cat("  1. In your web browser, open:\n")
    cat(sprintf("       %s/gradethis\n", .gradethis_repo()))
    cat("  2. Download the Windows binary (.zip) from the 'Downloads' section.\n")
    cat("  3. In R, run (with the path to the file you downloaded):\n")
    cat('       install.packages("C:/path/to/gradethis.zip", repos = NULL,\n')
    cat('                        type = "win.binary")\n')
    cat("If that fails too, ask your IT team to allow access to\n")
    cat(sprintf("%s, or contact the course author.\n",
                sub("^https://", "", .gradethis_repo())))
  }
}

# Fallback: install gradethis from its GitHub source. Pure R, so it builds
# without Rtools. Needs the remotes package, which is on CRAN.
.install_gradethis_from_github <- function() {
  if (!requireNamespace("remotes", quietly = TRUE)) {
    try(utils::install.packages("remotes",
                                repos = c(CRAN = "https://cloud.r-project.org")))
  }
  if (!requireNamespace("remotes", quietly = TRUE)) {
    cat("Could not install the 'remotes' package needed for the GitHub route.\n")
    return(invisible(FALSE))
  }
  try(remotes::install_github("rstudio/gradethis", upgrade = "never"))
  invisible(requireNamespace("gradethis", quietly = TRUE))
}
