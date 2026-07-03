# Internal helpers (not exported).

# Can we reach a URL? Returns TRUE/FALSE, never errors or hangs for long.
.can_reach <- function(url, timeout = 5L) {
  isTRUE(tryCatch({
    h <- curlGetHeaders(url, timeout = timeout)
    st <- attr(h, "status")
    is.numeric(st) && st > 0
  }, error = function(e) FALSE))
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

# Install packages, looking at R-universe (for gradethis) as well as CRAN.
# Institutional networks sometimes block R-universe while allowing CRAN and
# GitHub, so if gradethis is still missing afterwards we fall back to
# installing it from GitHub, and failing that print manual instructions.
.install_missing <- function(pkgs) {
  try(utils::install.packages(
    pkgs,
    repos = c("https://posit-dev.r-universe.dev",
              CRAN = "https://cloud.r-project.org")
  ))

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
    cat("       https://posit-dev.r-universe.dev/gradethis\n")
    cat("  2. Download the Windows binary (.zip) from the 'Downloads' section.\n")
    cat("  3. In R, run (with the path to the file you downloaded):\n")
    cat('       install.packages("C:/path/to/gradethis.zip", repos = NULL,\n')
    cat('                        type = "win.binary")\n')
    cat("If that fails too, ask your IT team to allow access to\n")
    cat("posit-dev.r-universe.dev, or contact the course author.\n")
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
