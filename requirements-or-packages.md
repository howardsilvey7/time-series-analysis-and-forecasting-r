
### `requirements-or-packages.md`

```markdown
# R Requirements and Packages

This project is implemented in R.

Python is not required.

## Recommended R Version

```text
R 4.3 or newer

The scripts may also work on earlier supported R 4.x releases.

## Required packages

### astsa

Used for:

- `unemp`
- `acf2()`
- `sarima()`
- `sarima.for()`

Install with:

```r
install.packages("astsa")
```

### forecast

Used for additional forecast objects, plotting, and optional diagnostics.

Install with:

```r
install.packages("forecast")
```

## Optional packages

### tseries

Useful for additional stationarity tests such as the augmented Dickey-Fuller
test.

```r
install.packages("tseries")
```

### ggplot2

Useful for customized visualizations, though the supplied scripts use base R
and package-native plotting to minimize dependencies.

```r
install.packages("ggplot2")
```

## One-command installation

```r
required_packages <- c("astsa", "forecast")

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}
```

## Reproducibility recommendation

After confirming the project works, consider using `renv`:

```r
install.packages("renv")
renv::init()
renv::snapshot()
```

This creates a lockfile containing the exact package versions used.

## Notes

- `acf2()`, `sarima()`, `sarima.for()`, and `unemp` are supplied by `astsa`.
- Do not list base R packages such as `stats`, `graphics`, or `utils` as
  external requirements.
- The unemployment data source should be documented more precisely before
  formal publication if the original course material identifies its source.
