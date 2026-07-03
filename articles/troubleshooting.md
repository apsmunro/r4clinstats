# Troubleshooting: installing on a hospital or university computer

Managed computers, the kind most hospitals and universities issue, add
security layers that R sometimes trips over. Every problem on this page
has been hit by a real tester and has a known fix. Work down the page
until yours appears.

Whatever went wrong, the fastest first step is the same:

``` r

library(r4clinstats)
check_setup()
```

It checks your R version, your package library, and whether your network
can reach the package servers, then names what needs fixing and offers
to fix it.

## “package ‘gradethis’ is not available for this version of R”

The message is misleading. Your R version is fine. `gradethis` is simply
not on CRAN, the main package server, so the ordinary
`install.packages("gradethis")` cannot find it and R blames your version
instead of saying so.

Let the course install it for you:

``` r

library(r4clinstats)
check_setup(install = TRUE)
```

That looks in the right place (Posit’s R-universe server) and, if your
network blocks that server, falls back to installing from GitHub
automatically. To do it by hand instead, type this into the Console:

``` r

install.packages("gradethis",
                 repos = c("https://posit-dev.r-universe.dev", getOption("repos")))
```

## “The tutorial is missing required packages and cannot be rendered”

A lesson was opened before all the packages it needs were installed, and
usually the missing one is `gradethis` (see above). Run
`check_setup(install = TRUE)`, say yes to the prompts, then open the
lesson again.

## “Error: unexpected input” when pasting a command

If the error quotes a strange address such as `protect.checkpoint.com`
or `safelinks.protection.outlook.com`, the command was copied out of an
email. Many workplace email systems rewrite every web address in a
message for scanning, including addresses inside code, which breaks the
command. Copy commands from this website or from the [Get started
guide](https://apsmunro.github.io/r4clinstats/articles/getting-started.md),
or type them in by hand. Never copy R code out of an email.

## Nothing installs at all

Some networks only allow traffic through a proxy server, and R does not
always pick that up.
[`check_setup()`](https://apsmunro.github.io/r4clinstats/reference/check_setup.md)
reports this as failing to reach CRAN. Two things to try:

1.  In RStudio: **Tools ▸ Global Options ▸ Packages**, and confirm the
    primary repository is set to a CRAN mirror.
2.  Ask your IT team whether a proxy is required for internet access
    from applications. If it is, they can give you the address to put in
    the `http_proxy` and `https_proxy` environment variables.

If CRAN works and only `gradethis` fails, your network is likely
blocking the R-universe server; the automatic GitHub fallback described
above usually gets around it. Should every route fail, download the
Windows `gradethis` bundle in your ordinary web browser from
[posit-dev.r-universe.dev/gradethis](https://posit-dev.r-universe.dev/gradethis)
(the `.zip` under Downloads), then install the file directly:

``` r

install.packages("C:/path/to/the/downloaded/gradethis.zip",
                 repos = NULL, type = "win.binary")
```

## Installs fail partway, or packages vanish after a restart

On many managed machines your Documents folder lives inside OneDrive,
and R puts its package library there by default. OneDrive can lock files
while it syncs, which corrupts installs.
[`check_setup()`](https://apsmunro.github.io/r4clinstats/reference/check_setup.md)
spots this; the fix is one command:

``` r

library(r4clinstats)
use_local_library()
```

It creates a package library outside OneDrive and points R at it.
Restart R afterwards (**Session ▸ Restart R**), then reinstall the
course packages with `check_setup(install = TRUE)`.

## “No tutorials found for package ‘r4clinstats’”

Your R session is holding an older view of the package, typically right
after installing or updating it. Restart R (**Session ▸ Restart R**),
run [`library(r4clinstats)`](https://github.com/apsmunro/r4clinstats),
and try again.

## “there is no package called ‘reformulas’”

A dependency occasionally missed when `finalfit` installs. Install it
directly:

``` r

install.packages("reformulas")
```

## Still stuck?

Open an issue at the [project
page](https://github.com/apsmunro/r4clinstats/issues). Paste the exact
red text you saw, along with the output of
[`check_setup()`](https://apsmunro.github.io/r4clinstats/reference/check_setup.md),
and say whether you are on a work-managed computer. Those three things
are usually enough to diagnose it in one reply.
