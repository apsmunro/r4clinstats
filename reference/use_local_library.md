# Move your R package library out of a synced folder

Creates a local package library and points R at it by writing
`R_LIBS_USER` to your `~/.Renviron`. Use this when
[`check_setup()`](https://apsmunro.github.io/r4clinstats/reference/check_setup.md)
reports that your library sits inside OneDrive. Restart R afterwards for
it to take effect.

## Usage

``` r
use_local_library(
  path = file.path(Sys.getenv("LOCALAPPDATA", unset = path.expand("~")), "R", "library")
)
```

## Arguments

- path:

  Directory for the local library. Defaults to a folder under
  `%LOCALAPPDATA%` (or your home directory if that is unset).

## Value

Invisibly, the library path.
