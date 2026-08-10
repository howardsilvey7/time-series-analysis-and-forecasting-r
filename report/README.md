# Report

This directory contains the maintained analytical report source and the generated reporting artifacts for the **Time Series Analysis and Seasonal Forecasting in R** project.

The report brings together the project's theoretical stationarity and autocorrelation analysis, applied unemployment time-series modelling, SARIMA forecasting, and out-of-sample forecast validation.

## Directory Contents

```text
report/
├── README.md
├── report-source.md
├── forecast-validation-1979.csv
└── time-series-analysis.pdf
```

## `report-source.md`

**Permanent source file**

`report-source.md` contains the maintained written analysis underlying the project report.

It documents the complete analytical progression from theoretical time-series foundations to applied forecasting, including:

* project objectives and analytical scope;
* theoretical stationarity and autocorrelation analysis;
* derivation of the process mean, variance, covariance, and ACF;
* simulation and empirical verification;
* interpretation of theoretical versus sample behaviour;
* transition from theoretical analysis to observed economic data;
* unemployment time-series inspection;
* ACF and PACF diagnostics;
* ordinary differencing;
* seasonal differencing;
* Augmented Dickey-Fuller stationarity testing;
* SARIMA model specification and interpretation;
* residual diagnostics;
* twelve-period forecasting;
* 1979 out-of-sample forecast validation;
* forecast-accuracy interpretation;
* reproducibility;
* limitations;
* possible extensions;
* final analytical conclusions.

The maintained report source should remain under version control.

## `forecast-validation-1979.csv`

**Generated analytical output**

This file is produced by the report-building workflow and compares the model's twelve-period forecasts with preserved observed unemployment values for 1979.

The validation table contains the principal fields required to evaluate out-of-sample forecast performance, including:

* forecast month;
* forecast unemployment value;
* forecast value expressed in persons;
* lower approximate 95% forecast bound;
* upper approximate 95% forecast bound;
* observed unemployment value;
* observed value expressed in persons;
* forecast error.

The validation data are generated from:

```text
outputs/forecasts/sarima-210-011-12-forecast-values.csv
```

and:

```text
data/observed-unemployment-1979.csv
```

The resulting validation file is:

```text
report/forecast-validation-1979.csv
```

This file should be regenerated from the analytical workflow rather than manually edited.

## `time-series-analysis.pdf`

**Generated final report**

This file is the portable PDF reporting artifact generated from the project's analytical results.

It summarizes the major components of the project, including:

* theoretical time-series analysis;
* the principal theoretical results;
* the applied unemployment analysis;
* the fitted SARIMA model;
* twelve-period forecasting;
* 1979 forecast validation;
* forecast-error summaries.

The PDF is generated programmatically by the reporting workflow and should not be manually edited as the authoritative source.

The maintained written source remains:

```text
report/report-source.md
```

## Principal Model

The applied forecasting component uses:

```text
SARIMA(2,1,0)(0,1,1)[12]
```

The specification contains:

* two non-seasonal autoregressive terms;
* one ordinary difference;
* no non-seasonal moving-average terms;
* no seasonal autoregressive terms;
* one seasonal difference;
* one seasonal moving-average term;
* a seasonal period of twelve months.

## Relationship to Other Project Outputs

The report directory summarizes results produced elsewhere in the repository.

### Theoretical and ACF/PACF Outputs

```text
outputs/acf-plots/
```

This directory contains the theoretical ACF, simulation results, and ACF/PACF diagnostics used throughout the analysis.

### Model Diagnostics

```text
outputs/diagnostics/
```

This directory contains diagnostic output for the fitted SARIMA model.

### Forecast Outputs

```text
outputs/forecasts/
```

This directory contains the unemployment-series visualization, stationarity-test results, SARIMA model output, numerical forecasts, and forecast visualization.

### Validation Data

```text
data/observed-unemployment-1979.csv
```

This permanent data file contains the observed values used to evaluate the twelve-period forecast.

## Reproducibility

The report outputs are part of the repository's reproducible analytical pipeline.

From the repository root, the complete workflow can be executed with:

```r
source("scripts/run-all.R")
```

The workflow:

1. verifies the required project directory structure;
2. verifies required R dependencies;
3. executes the theoretical stationarity and autocorrelation analysis;
4. executes the unemployment SARIMA analysis;
5. generates analytical plots and numerical outputs;
6. generates the twelve-period forecast;
7. performs out-of-sample forecast validation;
8. generates the final report artifacts.

The reporting stage can also be run independently after the required analytical outputs have been generated:

```r
source("scripts/03-build-report.R")
```

## Source and Generated-File Policy

The report directory deliberately distinguishes between maintained source material and reproducible generated artifacts.

### Permanent Source

```text
README.md
report-source.md
```

These files are maintained directly and stored under version control.

### Generated Outputs

```text
forecast-validation-1979.csv
time-series-analysis.pdf
```

These files are generated from the repository's source code and analytical data.

They are retained in the repository so that reviewers can inspect the finished analytical results without first executing the R workflow.

However, they should remain reproducible from the permanent project source.

## Report Design Principle

The repository follows a source-to-output workflow:

```text
Permanent R source
        ↓
Theoretical and applied analysis
        ↓
Generated analytical outputs
        ↓
Forecast validation
        ↓
Report artifacts
```

This separation allows the repository to serve both purposes:

1. **technical reproducibility** — reviewers can inspect and rerun the complete analysis; and
2. **portfolio presentation** — reviewers can inspect the finished figures, forecasts, validation results, and report without having to execute the project first.

## Author

**Howard R. Silvey**

## Copyright

Copyright (c) 2026 Howard R. Silvey. All Rights Reserved.

See the repository-level `LICENSE` file for the terms governing use of this project.
