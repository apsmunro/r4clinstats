#' Check your R setup for r4clinstats
#'
#' Diagnoses the things that commonly stop a learner getting started on a
#' managed Windows machine, and optionally fixes them: an out-of-date R, a
#' package library living inside a synced OneDrive folder, no route to the
#' package repositories, and missing packages. It prints a short report.
#'
#' @param install Logical. Offer to install any missing packages. Defaults to
#'   [interactive()]; set `FALSE` to report only.
#' @return Invisibly `TRUE` if everything needed is present, otherwise `FALSE`.
#' @examples
#' \dontrun{
#' check_setup()
#' check_setup(install = TRUE)
#' }
#' @export
check_setup <- function(install = interactive()) {
  cat("r4clinstats setup check\n")
  cat("=======================\n\n")

  ## 1. R version -----------------------------------------------------------
  ver_ok <- getRversion() >= "4.2.0"
  if (ver_ok) {
    cat(sprintf("[OK ]  R %s (>= 4.2.0)\n", getRversion()))
  } else {
    cat(sprintf("[FIX]  R %s is older than 4.2.0; the course uses the native pipe |>.\n",
                getRversion()))
    cat("       Update from https://cran.r-project.org, then restart RStudio.\n")
  }

  ## 2. Library path inside OneDrive ----------------------------------------
  lib <- .libPaths()[1]
  lib_ok <- !grepl("onedrive", lib, ignore.case = TRUE)
  if (lib_ok) {
    cat(sprintf("[OK ]  Library not inside OneDrive\n       %s\n", lib))
  } else {
    cat(sprintf("[FIX]  Library is inside a synced folder:\n       %s\n", lib))
    cat("       OneDrive can lock files mid-install. Fix with use_local_library().\n")
  }

  ## 3. Connectivity --------------------------------------------------------
  cran_ok <- .can_reach("https://cran.r-project.org")
  cat(sprintf("[%s]  Reach CRAN\n", if (cran_ok) "OK " else "FIX"))

  # Not "can we reach the server" but "is gradethis actually on it". The two
  # came apart once already, and the reachable-but-empty case looked fine.
  gt <- .gradethis_status()
  runiv_ok <- identical(gt, "ok")
  cat(sprintf("[%s]  gradethis available from R-universe\n",
              if (runiv_ok) "OK " else "FIX"))
  if (identical(gt, "missing")) {
    cat(sprintf("       %s answers but no longer lists gradethis.\n",
                .gradethis_repo()))
    cat("       It has most likely moved again, which the course cannot fix\n")
    cat("       by itself. Please report it at\n")
    cat("       https://github.com/apsmunro/r4clinstats/issues\n")
  } else if (identical(gt, "unreachable")) {
    cat(sprintf("       Cannot reach %s.\n", .gradethis_repo()))
  }
  if (!cran_ok || identical(gt, "unreachable")) {
    cat("       Behind a proxy? Set it in RStudio > Tools > Global Options > Packages,\n")
    cat("       or via the http_proxy / https_proxy environment variables.\n")
  }

  ## 4. Packages ------------------------------------------------------------
  missing <- .missing_pkgs()

  if (length(missing) == 0L) {
    cat("[OK ]  All required packages installed.\n")
    pkgs_ok <- TRUE
  } else {
    cat(sprintf("[FIX]  Missing packages: %s\n", paste(missing, collapse = ", ")))
    if (isTRUE(install)) {
      cat("       Installing now...\n")
      .install_missing(missing)
      missing <- .missing_pkgs(missing)
      if (length(missing)) cat(sprintf("       Still missing: %s\n", paste(missing, collapse = ", ")))
    } else {
      cat("       Install them with: r4clinstats::check_setup(install = TRUE)\n")
    }
    pkgs_ok <- length(missing) == 0L
  }

  ok <- ver_ok && lib_ok && cran_ok && runiv_ok && pkgs_ok
  cat("\n")
  if (ok) {
    cat("All set. Start with:  r4clinstats::learn()\n")
  } else {
    cat("Some items need attention (see [FIX] above), then run check_setup() again.\n")
  }
  invisible(ok)
}

#' Move your R package library out of a synced folder
#'
#' Creates a local package library and points R at it by writing `R_LIBS_USER`
#' to your `~/.Renviron`. Use this when [check_setup()] reports that your
#' library sits inside OneDrive. Restart R afterwards for it to take effect.
#'
#' @param path Directory for the local library. Defaults to a folder under
#'   `%LOCALAPPDATA%` (or your home directory if that is unset).
#' @return Invisibly, the library path.
#' @export
use_local_library <- function(
    path = file.path(Sys.getenv("LOCALAPPDATA", unset = path.expand("~")), "R", "library")) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  renviron <- path.expand("~/.Renviron")
  existing <- if (file.exists(renviron)) readLines(renviron, warn = FALSE) else character()
  existing <- existing[!grepl("^\\s*R_LIBS_USER\\s*=", existing)]
  writeLines(c(existing, sprintf('R_LIBS_USER="%s"', path)), renviron)
  message("Set R_LIBS_USER to:\n  ", path, "\nin ", renviron, ".\nRestart R for it to take effect.")
  invisible(path)
}
