# Time Series Analysis and Seasonal Forecasting in R

## Author

Howard R. Silvey

## Project summary

This project combines theoretical stationarity analysis with a seasonal
forecast of monthly U.S. unemployment levels.

## Theoretical process

The process is `x_t = w_t^2 w_(t-1)^2 - 4`, where `w_t` is Gaussian white
noise with mean zero and standard deviation two.

- `E(w_t^2) = 4`
- `E(w_t^4) = 48`
- `E(x_t) = 12`
- `Var(x_t) = 2048`
- `Cov(x_t, x_(t-1)) = 512`
- `rho(1) = rho(-1) = 0.25`
- `rho(h) = 0` for `|h| > 1`

## Applied analysis

The model uses monthly unemployment observations from January 1948 through
December 1978 and fits `SARIMA(2,1,0)(0,1,1)[12]`.

## 1979 forecast

Unemployment stood at approximately 5.896 million persons in December 1978.
The model forecast:

- 6.950 million in January 1979
- 7.040 million in February
- A decline to 5.729 million in May
- A rebound to 6.842 million in June
- Stabilization near 6.025 million in December

The predicted pattern was a winter increase, spring decline, mid-year rebound,
and year-end stabilization around six million persons.

## Validation

Observed unemployment in 1979 followed the same broad seasonal pattern,
including a May low and June rebound. The model generally overpredicted the
first seven months. Mean absolute error was approximately 247,500 persons.
The August forecast was within roughly 4,000 persons, and the December
forecast of 6.025 million was within roughly 2,000 persons of the observed
6.027 million.

## Copyright

Copyright (c) 2026 Howard R. Silvey. All rights reserved.

Copyright (c) 2026 Howard R. Silvey. All rights reserved.
