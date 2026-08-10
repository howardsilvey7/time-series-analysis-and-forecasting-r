# Analysis Scripts

This directory contains the permanent R source code for project setup, theoretical time-series analysis, applied SARIMA modelling and forecasting, report generation, complete reproducible execution, and optional project packaging.

## `00-project-setup.R`

Creates or verifies the project directory structure.

```r
source("scripts/00-project-setup.R")
```

## `01-stationarity-and-acf-exercises.R`

Performs the theoretical stationarity and autocorrelation analysis.

## `02-unemployment-sarima-analysis.R`

Performs the applied unemployment time-series analysis.

Principal model:

```text
SARIMA(2,1,0)(0,1,1)[12]
```

## `03-build-report.R`

Performs forecast validation and generates the report outputs.

## `run-all.R`

Runs the complete reproducible workflow.

```r
source("scripts/run-all.R")
```

## `package-project.R`

Creates an optional ZIP archive of the project in the user's Downloads directory.

```r
source("scripts/package-project.R")
```
