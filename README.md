# Time Series Analysis and Seasonal Forecasting in R

A portfolio-ready R project covering:

- Weak stationarity, covariance functions, and autocorrelation
- Simulation of a nonlinear stationary process
- ACF and PACF diagnostics
- Ordinary and seasonal differencing
- Seasonal ARIMA modelling
- Twelve-period forecasting of unemployment data

## Repository structure

```text
time-series-analysis-and-forecasting-r/
├── README.md
├── requirements-or-packages.md
├── scripts/
│   ├── 01-stationarity-and-acf-exercises.R
│   └── 02-unemployment-sarima-analysis.R
├── data/
│   └── README.md
├── outputs/
│   ├── acf-plots/
│   └── forecasts/
└── report/
    ├── time-series-analysis.pdf
    └── report-source.md
```

## Stationary-process specification

The theoretical exercise uses:

```text
x_t = w_t^2 w_(t-1)^2 - 4
```

where `w_t` is Gaussian white noise with:

```text
E(w_t) = 0
sd(w_t) = 2
Var(w_t) = 4
E(w_t^4) = 48
```

This yields:

- `E(x_t) = 12`
- `Var(x_t) = 2048`
- `Cov(x_t, x_(t-1)) = 512`
- `rho(+/-1) = 0.25`
- `rho(h) = 0` for `|h| > 1`

## Running the project

Install the required R packages, then run:

```r
source("scripts/01-stationarity-and-acf-exercises.R")
source("scripts/02-unemployment-sarima-analysis.R")
```

Run both commands from the repository root so output paths resolve correctly.

## Main applied model

The unemployment script:

1. Loads the `unemp` time series from the `astsa` package.
2. Plots the original series.
3. Reviews the ACF/PACF of:
   - the original series,
   - the first difference,
   - the first and seasonal difference.
4. Fits:

```text
SARIMA(2,1,0)(0,1,1)[12]
```

5. Produces a twelve-period forecast.
6. Saves diagnostic and forecast output under `outputs/`.

## Reproducibility

The scripts:

- Check that required packages are installed.
- Use explicit output paths.
- Save figures to the repository.
- Keep theoretical exercises separate from applied forecasting.

## Portfolio description

**Time Series Analysis and Seasonal Forecasting in R**

Statistical analysis and forecasting of economic time-series data using
stationarity theory, covariance and autocorrelation analysis, differencing,
seasonal ARIMA modelling, diagnostics, and forecast generation.


## How the two scripts connect

The first script establishes the theoretical foundation for the applied
forecasting work:

- Weak stationarity
- Constant mean and variance
- Lag-based covariance
- Autocorrelation
- The difference between theoretical and sample ACFs

The unemployment script then applies these ideas to observed data. Because the
economic series does not arrive with a known covariance structure, it must be
diagnosed through plotting, ACF/PACF analysis, first differencing, seasonal
differencing, SARIMA fitting, and residual evaluation.

This progression moves from a mathematically defined stationary process to a
real seasonal forecasting problem.

## Forecast interpretation

The fitted `SARIMA(2,1,0)(0,1,1)[12]` model projects a winter increase,
spring decline, mid-year rebound, and year-end stabilization in 1979.
Its December forecast was approximately 6.025 million unemployed persons,
compared with an observed 6.027 million.

See `report/forecast-validation-1979.csv` and
`report/time-series-analysis.pdf`.

## Author

Howard R. Silvey

## Copyright

Copyright (c) 2026 Howard R. Silvey. All rights reserved.


## License

This repository is protected by copyright. Please see the **LICENSE** file for the complete terms governing viewing and use.
