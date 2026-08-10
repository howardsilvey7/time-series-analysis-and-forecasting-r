# Time Series Analysis and Seasonal Forecasting in R

A reproducible R project progressing from theoretical time-series concepts to applied seasonal forecasting of economic data.

The project demonstrates:

- weak stationarity;
- expected value, variance, covariance, and autocorrelation;
- simulation of a nonlinear stationary process;
- theoretical versus sample autocorrelation;
- ACF and PACF diagnostics;
- first and seasonal differencing;
- Augmented Dickey-Fuller stationarity testing;
- seasonal ARIMA modelling;
- residual diagnostics;
- twelve-period unemployment forecasting;
- out-of-sample forecast validation;
- reproducible generation of figures, tables, diagnostics, forecasts, and reports.

## Author

**Howard R. Silvey**

## Repository Structure

```text
time-series-analysis-and-forecasting-r/
│
├── README.md
├── RUNNING.md
├── requirements-or-packages.md
├── LICENSE
├── .gitignore
├── time-series-analysis-and-forecasting-r.Rproj
│
├── data/
│   ├── README.md
│   └── observed-unemployment-1979.csv
│
├── scripts/
│   ├── README.md
│   ├── 00-project-setup.R
│   ├── 01-stationarity-and-acf-exercises.R
│   ├── 02-unemployment-sarima-analysis.R
│   ├── 03-build-report.R
│   ├── run-all.R
│   └── package-project.R
│
├── outputs/
│   ├── acf-plots/
│   │   ├── README.md
│   │   ├── theoretical-acf.csv
│   │   ├── theoretical-acf.png
│   │   ├── simulation-summary.csv
│   │   ├── simulated-process-acf.png
│   │   ├── 01-original-series-acf-pacf.png
│   │   ├── 02-first-difference-acf-pacf.png
│   │   └── 03-first-and-seasonal-difference-acf-pacf.png
│   │
│   ├── diagnostics/
│   │   ├── README.md
│   │   └── sarima-210-011-12-diagnostics.png
│   │
│   ├── figures/
│   │   └── README.md
│   │
│   └── forecasts/
│       ├── README.md
│       ├── unemployment-series.png
│       ├── augmented-dickey-fuller-tests.txt
│       ├── sarima-210-011-12-model-output.txt
│       ├── sarima-210-011-12-twelve-period-forecast.png
│       └── sarima-210-011-12-forecast-values.csv
│
└── report/
    ├── README.md
    ├── report-source.md
    ├── forecast-validation-1979.csv
    └── time-series-analysis.pdf
