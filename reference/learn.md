# Browse and launch the r4clinstats lessons

Lists the course modules and opens one as an interactive tutorial in
your browser. With no argument it shows the menu; pass a module id (for
example `"m3"` or `3`) to go straight there.

## Usage

``` r
learn(module = NULL)
```

## Arguments

- module:

  Optional module id, such as `"m3"`. If `NULL`, the modules are listed
  and (in an interactive session) you are offered a menu.

## Value

Invisibly `NULL`. Called for the side effect of launching a tutorial.

## Examples

``` r
if (FALSE) { # \dontrun{
learn()        # list the modules
learn("m3")    # open Wrangling I
} # }
```
