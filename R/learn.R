#' Browse and launch the r4clinstats lessons
#'
#' Lists the course modules and opens one as an interactive tutorial in your
#' browser. With no argument it shows the menu; pass a module id (for example
#' `"m3"` or `3`) to go straight there.
#'
#' @param module Optional module id, such as `"m3"`. If `NULL`, the modules are
#'   listed and (in an interactive session) you are offered a menu.
#' @return Invisibly `NULL`. Called for the side effect of launching a tutorial.
#' @examples
#' \dontrun{
#' learn()        # list the modules
#' learn("m3")    # open Wrangling I
#' }
#' @export
learn <- function(module = NULL) {
  mods <- .modules()

  if (is.null(module)) {
    cat("r4clinstats - course modules\n\n")
    for (i in seq_len(nrow(mods))) {
      tag <- if (mods$available[i]) "" else "(coming soon)"
      cat(sprintf("  %-3s  %-26s %s\n", mods$id[i], mods$title[i], tag))
    }
    cat('\nOpen one with, for example, learn("m3").\n')
    if (interactive()) {
      avail <- mods[mods$available, , drop = FALSE]
      pick <- utils::menu(avail$title, title = "\nLaunch which module?")
      if (pick > 0) return(invisible(.launch(avail$id[pick], mods)))
    }
    return(invisible(NULL))
  }

  invisible(.launch(module, mods))
}

# Internal: the module table. `available` marks which tutorials are built.
.modules <- function() {
  data.frame(
    id = paste0("m", 0:9),
    title = c(
      "Why R for clinical data",
      "Tidy data as design",
      "The building blocks of R",
      "Wrangling I",
      "Wrangling II",
      "Tidy data in practice",
      "Reading & cleaning data",
      "Visualisation I",
      "Visualisation II",
      "Summary tables"
    ),
    dir = c(
      "m0-why-r", "m1-tidy-data-design", "m2-building-blocks",
      "m3-wrangling-i", "m4-wrangling-ii", "m5-tidy-data-practice",
      "m6-reading-cleaning", "m7-visualisation-i",
      "m8-visualisation-ii", "m9-summary-tables"
    ),
    available = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
    stringsAsFactors = FALSE
  )
}

# Internal: validate a module id and run its tutorial.
.launch <- function(module, mods = .modules()) {
  module <- tolower(trimws(as.character(module)))
  if (!grepl("^m", module)) module <- paste0("m", module)

  row <- mods[mods$id == module, , drop = FALSE]
  if (nrow(row) == 0L)
    stop("Unknown module '", module, "'. Run learn() to see the list.", call. = FALSE)
  if (!row$available)
    stop("Module '", module, "' is not built yet.", call. = FALSE)
  if (!requireNamespace("learnr", quietly = TRUE))
    stop("Package 'learnr' is needed. Run check_setup(install = TRUE).", call. = FALSE)

  learnr::run_tutorial(row$dir, package = "r4clinstats")
}
