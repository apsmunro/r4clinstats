# Browse and launch the r4clinstats lessons

Lists the course modules and opens one as an interactive tutorial in
your browser. With no argument it lists the modules and returns you to
the prompt; pass a module id (for example `"m3"` or `3`) to open that
one.

## Usage

``` r
learn(module = NULL)
```

## Arguments

- module:

  Optional module id, such as `"m3"`. If `NULL`, the modules are listed.

## Value

Invisibly `NULL`. Called for the side effect of launching a tutorial.

## Details

There is deliberately no numbered pick-list.
[`utils::menu()`](https://rdrr.io/r/utils/menu.html) numbers from 1, so
its numbers could never match module ids that start at m0, and a learner
typing 10 for "m10" would open m9. One way in, `learn("m10")`, avoids
both that and the separate `Selection:` mode, which rejects R code.

## Examples

``` r
if (FALSE) { # \dontrun{
learn()        # list the modules
learn("m3")    # open Wrangling I
} # }
```
