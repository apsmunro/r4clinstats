# Internal helpers (not exported).

# Can we reach a URL? Returns TRUE/FALSE, never errors or hangs for long.
.can_reach <- function(url, timeout = 5L) {
  isTRUE(tryCatch({
    h <- curlGetHeaders(url, timeout = timeout)
    st <- attr(h, "status")
    is.numeric(st) && st > 0
  }, error = function(e) FALSE))
}

# Install packages, looking at R-universe (for gradethis) as well as CRAN.
.install_missing <- function(pkgs) {
  utils::install.packages(
    pkgs,
    repos = c("https://posit-dev.r-universe.dev",
              CRAN = "https://cloud.r-project.org")
  )
}
