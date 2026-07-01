# Try R in your browser

You can run real R right now, with nothing to install.
[webR](https://docs.r-wasm.org/webr/latest/) is a full version of R that
runs inside your web browser. It takes a few seconds to load the first
time, then you have a working R console.

[Open R in your browser ↗](https://webr.r-wasm.org/latest/)

## Something to try

Once the console has loaded (you will see a `>` prompt), paste this in
and press Enter. It works out the average age of six patients, then
counts how many are 65 or over:

``` r

ages <- c(54, 61, 47, 73, 39, 68)
mean(ages)          # average age
sum(ages >= 65)     # how many are 65 or over
```

Change the numbers and run it again. Nothing you type there can do any
harm, and nothing is saved.

## From taster to course

That console is plain R, handy for a first taste and quick sums. The
course goes further: its lessons walk you through real clinical data
step by step, with exercises that check your answers and nudge you when
you are close.

When you are ready for that, the [Get
started](https://apsmunro.github.io/r4clinstats/articles/getting-started.md)
guide has you running the first lesson in about fifteen minutes.
