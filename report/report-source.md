# Time Series Analysis and Seasonal Forecasting in R

## Author

**Howard R. Silvey**

## Project Summary

This project combines theoretical time-series analysis with applied seasonal forecasting of monthly unemployment data.

The first component studies a stochastic process whose mean, variance, covariance function, and autocorrelation structure can be derived mathematically. The second component applies those concepts to an observed economic time series, where the underlying temporal structure is unknown and must be diagnosed through visualization, differencing, autocorrelation analysis, stationarity testing, statistical modelling, residual assessment, forecasting, and validation.

The project is designed as a progression from theoretical foundations to applied forecasting practice.

The complete workflow includes:

* derivation of theoretical process moments;
* derivation of the theoretical autocorrelation function;
* simulation of a stationary stochastic process;
* comparison of theoretical and empirical behaviour;
* visualization of an observed unemployment series;
* ACF and PACF analysis;
* ordinary differencing;
* seasonal differencing;
* Augmented Dickey-Fuller stationarity testing;
* seasonal ARIMA modelling;
* residual diagnostics;
* twelve-period forecasting;
* numerical forecast export;
* out-of-sample validation against 1979 unemployment observations;
* reproducible generation of analytical figures, tables, and report outputs.

---

## 1. Theoretical Stationarity and Autocorrelation

The theoretical exercise studies the process:

```text
x_t = w_t^2 w_(t-1)^2 - 4
```

where `w_t` is Gaussian white noise satisfying:

```text
E(w_t) = 0
sd(w_t) = 2
Var(w_t) = 4
E(w_t^4) = 48
```

Because the Gaussian innovations are independent through time, the dependence structure of `x_t` is determined by whether observations share one of the squared white-noise terms.

### 1.1 Expected Value

The expected value is:

```text
E(x_t)
= E(w_t^2)E(w_(t-1)^2) - 4
= 4 × 4 - 4
= 12
```

Therefore:

```text
E(x_t) = 12
```

The process has a constant mean over time.

---

## 1.2 Variance

The variance is obtained from the fourth moments of the Gaussian innovations.

Because:

```text
E(w_t^4) = 3[Var(w_t)]^2 = 48
```

the process variance is:

```text
Var(x_t)
= E(w_t^4)E(w_(t-1)^4)
  - [E(w_t^2)E(w_(t-1)^2)]^2

= 48^2 - 16^2

= 2048
```

Therefore:

```text
Var(x_t) = 2048
```

The variance is constant through time.

---

## 1.3 Lag-One Covariance

Adjacent observations share the innovation term `w_(t-1)^2`.

The lag-one covariance is:

```text
Cov(x_t, x_(t-1))
= E(w_t^2)E(w_(t-1)^4)E(w_(t-2)^2) - 16^2

= 4 × 48 × 4 - 256

= 512
```

Therefore:

```text
Cov(x_t, x_(t-1)) = 512
```

This positive covariance arises because adjacent observations share one innovation.

---

## 1.4 Covariance Beyond Lag One

For observations separated by more than one lag, the corresponding process values share no innovations.

Therefore:

```text
Cov(x_t, x_(t-h)) = 0
```

for:

```text
|h| > 1
```

The process therefore has only short-range dependence.

---

## 1.5 Theoretical Autocorrelation Function

Autocorrelation standardizes covariance by the process variance.

At lag zero:

```text
rho(0) = 1
```

At lag one:

```text
rho(1)
= 512 / 2048
= 0.25
```

By symmetry:

```text
rho(-1) = 0.25
```

For all larger absolute lags:

```text
rho(h) = 0
```

for:

```text
|h| > 1
```

The complete theoretical structure is therefore:

```text
rho(0) = 1
rho(+/-1) = 0.25
rho(h) = 0 for |h| > 1
```

This compact ACF illustrates a process with dependence confined to a single lag.

---

## 1.6 Weak Stationarity

A weakly stationary process requires:

1. a constant expected value;
2. a constant finite variance;
3. covariance that depends only on lag rather than calendar time.

The process satisfies these conditions:

```text
E(x_t) = 12
Var(x_t) = 2048
```

and its covariance structure depends only on the separation between observations.

The process is therefore weakly stationary.

---

## 2. Simulation and Empirical Verification

The theoretical process is simulated using Gaussian white noise with standard deviation two.

A fixed random seed is used to support reproducibility.

The simulation compares the following empirical quantities with their theoretical counterparts:

* sample mean;
* sample variance;
* lag-one covariance;
* lag-one autocorrelation.

The corresponding generated file is:

```text
outputs/acf-plots/simulation-summary.csv
```

The theoretical and simulated autocorrelation structures are also exported as graphical outputs.

### Theoretical ACF

```text
outputs/acf-plots/theoretical-acf.png
```

### Simulated ACF

```text
outputs/acf-plots/simulated-process-acf.png
```

Because the simulation is finite, its empirical statistics do not exactly equal the population quantities.

This difference represents ordinary sampling variation.

As the number of simulated observations increases, the empirical values should generally approach their theoretical targets.

---

## 3. Interpretation of the Theoretical Exercise

The theoretical exercise illustrates several fundamental time-series concepts.

### 3.1 Dependence Can Exist Without Dependent Innovations

The white-noise innovations themselves are independent.

However, the constructed process is not independent across adjacent observations because neighbouring process values share one squared innovation term.

This demonstrates how serial dependence can arise through the structure of a process even when the underlying innovations are independent.

### 3.2 The Covariance Function Describes Memory

The covariance function identifies how dependence changes with lag.

In this process:

* lag zero contains total process variance;
* lag one contains positive dependence;
* all larger lags contain zero covariance.

The process therefore has a short and precisely defined memory structure.

### 3.3 The ACF Standardizes That Dependence

The autocorrelation function rescales covariance to a standardized range.

The resulting ACF provides a direct visual and numerical summary of the process memory:

```text
rho(+/-1) = 0.25
```

with no dependence beyond lag one.

### 3.4 Theoretical and Empirical ACFs Are Not Identical

A theoretical ACF describes the population process.

A sample ACF is an estimate derived from a finite realization.

The simulated ACF therefore contains sampling noise around the theoretical pattern.

This distinction becomes especially important in real applications, where only the empirical series is available and the true population ACF is unknown.

---

## 4. Transition to the Applied Unemployment Analysis

The theoretical exercise begins with a process whose temporal dependence is known exactly from its mathematical definition.

The unemployment series presents the opposite problem.

Its true dependence structure is unknown.

It must therefore be inferred from the observed data using:

* time-series plots;
* ACF diagnostics;
* PACF diagnostics;
* differencing;
* stationarity testing;
* model fitting;
* residual analysis;
* forecasting;
* out-of-sample validation.

This transition is the central link between the two project components.

---

## 5. Applied Unemployment Time-Series Analysis

The applied exercise uses the monthly unemployment time series supplied through the `astsa` R package.

The analysis proceeds through a structured sequence:

1. inspect the raw series;
2. analyze the original ACF and PACF;
3. apply first differencing;
4. inspect the differenced ACF and PACF;
5. apply seasonal differencing;
6. evaluate the transformed series;
7. perform stationarity testing;
8. fit the selected SARIMA model;
9. examine model diagnostics;
10. generate a twelve-period forecast;
11. compare forecasts with observed 1979 values.

---

## 6. Original-Series Inspection

The original unemployment series is visualized before modelling.

The generated figure is:

```text
outputs/forecasts/unemployment-series.png
```

The raw series is inspected for:

* persistent level changes;
* long-range dependence;
* trend-like movement;
* seasonal recurrence;
* changes in variation;
* unusual observations.

A slowly decaying ACF or strong low-frequency dependence provides evidence that the raw series may not be stationary.

---

## 7. ACF and PACF Diagnostics

The autocorrelation function and partial autocorrelation function provide complementary information.

### ACF

The ACF measures correlation between the series and its lagged values.

It is useful for identifying:

* persistence;
* seasonal recurrence;
* possible moving-average structure.

### PACF

The PACF measures the direct correlation at each lag after accounting for shorter lags.

It is useful for identifying candidate autoregressive structure.

The original-series diagnostic output is:

```text
outputs/acf-plots/01-original-series-acf-pacf.png
```

---

## 8. First Differencing

First differencing applies:

```text
(1 - B)x_t
```

where `B` is the backshift operator.

This transformation compares successive observations and is commonly used to remove persistent changes in level.

The first-differenced ACF/PACF output is:

```text
outputs/acf-plots/02-first-difference-acf-pacf.png
```

The transformed series is inspected to determine whether substantial dependence remains.

---

## 9. Seasonal Differencing

Because the unemployment series is monthly, the seasonal period is twelve.

Seasonal differencing applies:

```text
(1 - B^12)
```

Combining ordinary and seasonal differencing produces:

```text
(1 - B)(1 - B^12)x_t
```

The resulting ACF/PACF output is:

```text
outputs/acf-plots/03-first-and-seasonal-difference-acf-pacf.png
```

This transformation is intended to reduce both persistent level changes and recurring annual dependence.

---

## 10. Augmented Dickey-Fuller Testing

The project applies Augmented Dickey-Fuller tests to:

1. the original series;
2. the first-differenced series;
3. the first-and-seasonally-differenced series.

The complete output is written to:

```text
outputs/forecasts/augmented-dickey-fuller-tests.txt
```

The ADF test provides an additional statistical assessment of stationarity.

The warning:

```text
p-value smaller than printed p-value
```

may occur when the calculated p-value is below the smallest value displayed by the R function.

This is not an execution failure.

---

## 11. SARIMA Model

The principal fitted model is:

```text
SARIMA(2,1,0)(0,1,1)[12]
```

The specification contains:

### Non-Seasonal Component

```text
p = 2
d = 1
q = 0
```

This represents:

* two autoregressive terms;
* one ordinary difference;
* no non-seasonal moving-average term.

### Seasonal Component

```text
P = 0
D = 1
Q = 1
S = 12
```

This represents:

* no seasonal autoregressive term;
* one seasonal difference;
* one seasonal moving-average term;
* a twelve-month seasonal period.

The model therefore combines short-run autoregressive behaviour with seasonal differencing and seasonal moving-average structure.

---

## 12. Model Output

The complete model output is written to:

```text
outputs/forecasts/sarima-210-011-12-model-output.txt
```

This preserves the fitted model information separately from the console session.

---

## 13. Residual Diagnostics

Residual diagnostics are used to assess whether the fitted model has removed the systematic temporal dependence present in the original data.

The diagnostic output is generated as:

```text
outputs/diagnostics/sarima-210-011-12-diagnostics.png
```

An adequate forecasting model should leave residuals that behave approximately like white noise.

Residual diagnostics therefore provide an important check beyond model coefficient estimation alone.

---

## 14. Twelve-Period Forecast

The fitted SARIMA model generates twelve future unemployment forecasts.

The forecast includes:

* predicted unemployment values;
* forecast standard errors.

The graphical forecast is generated as:

```text
outputs/forecasts/sarima-210-011-12-twelve-period-forecast.png
```

The numerical forecasts are exported as:

```text
outputs/forecasts/sarima-210-011-12-forecast-values.csv
```

This separation between graphical and numerical output supports both interpretation and reproducibility.

---

## 15. 1979 Forecast Validation

The twelve generated forecasts are compared with preserved monthly unemployment observations for 1979.

The observed validation data are stored in:

```text
data/observed-unemployment-1979.csv
```

The generated comparison table is:

```text
report/forecast-validation-1979.csv
```

The validation table includes:

* forecast month;
* predicted unemployment;
* forecast standard error;
* approximate 95% forecast bounds;
* observed unemployment;
* forecast error.

The validation stage provides an out-of-sample assessment of the fitted model.

This is more informative than judging forecasting quality from historical model fit alone.

---

## 16. Forecast Accuracy

The report-building workflow calculates forecast-error summaries including:

* mean absolute error;
* root mean squared error.

Mean absolute error summarizes the typical absolute difference between predicted and observed unemployment.

Root mean squared error gives additional weight to larger forecast errors.

These measures provide complementary summaries of out-of-sample forecast performance.

---

## 17. Interpretation

The theoretical exercise illustrates a setting in which covariance and autocorrelation are known exactly from the mathematical definition of a process.

The applied exercise addresses a setting in which temporal structure must be inferred through visualization, differencing, ACF/PACF diagnostics, stationarity testing, model estimation, residual assessment, forecasting, and validation.

Together, the analyses demonstrate the progression from theoretical time-series foundations to applied seasonal forecasting.

The project also illustrates an important distinction between explanation and prediction.

A model may represent historical dependence reasonably well without necessarily producing accurate forecasts.

Forecast evaluation must therefore include observations that were not used to fit the model whenever an appropriate holdout period is available.

---

## 18. Theoretical Versus Applied Workflow

The two analyses can be summarized as follows.

### Theoretical Exercise

```text
Known mathematical process
        ↓
Derive mean and variance
        ↓
Derive covariance
        ↓
Derive theoretical ACF
        ↓
Simulate process
        ↓
Compare sample and theoretical behaviour
```

### Applied Exercise

```text
Observed economic series
        ↓
Visual inspection
        ↓
ACF / PACF diagnosis
        ↓
Ordinary differencing
        ↓
Seasonal differencing
        ↓
Stationarity testing
        ↓
SARIMA estimation
        ↓
Residual diagnostics
        ↓
Forecasting
        ↓
Out-of-sample validation
```

The theoretical exercise provides the conceptual foundation for the applied workflow.

---

## 19. Reproducibility

The complete analytical workflow is run from the repository root with:

```r
source("scripts/run-all.R")
```

The master workflow:

1. verifies or creates the required project directories;
2. checks required packages;
3. installs missing dependencies where necessary;
4. runs the theoretical exercise;
5. runs the applied unemployment analysis;
6. generates plots and numerical outputs;
7. performs forecast validation;
8. builds the final PDF report;
9. inventories generated artifacts.

The project uses relative paths and reproducible output generation rather than manually maintained analytical results.

---

## 20. Generated Analytical Artifacts

### ACF and PACF

```text
outputs/acf-plots/theoretical-acf.csv
outputs/acf-plots/theoretical-acf.png
outputs/acf-plots/simulation-summary.csv
outputs/acf-plots/simulated-process-acf.png
outputs/acf-plots/01-original-series-acf-pacf.png
outputs/acf-plots/02-first-difference-acf-pacf.png
outputs/acf-plots/03-first-and-seasonal-difference-acf-pacf.png
```

### Diagnostics

```text
outputs/diagnostics/sarima-210-011-12-diagnostics.png
```

### Forecasts

```text
outputs/forecasts/unemployment-series.png
outputs/forecasts/augmented-dickey-fuller-tests.txt
outputs/forecasts/sarima-210-011-12-model-output.txt
outputs/forecasts/sarima-210-011-12-twelve-period-forecast.png
outputs/forecasts/sarima-210-011-12-forecast-values.csv
```

### Report

```text
report/forecast-validation-1979.csv
report/time-series-analysis.pdf
```

---

## 21. Limitations

The fitted SARIMA model represents the dependence structure of this historical unemployment series.

Forecast performance should not be judged exclusively from model fit or residual diagnostics.

Out-of-sample validation is required to assess how well the fitted specification predicts observations not used during model estimation.

The selected SARIMA specification should therefore be interpreted as a structured forecasting model for this dataset rather than as a universal model of unemployment.

Additional limitations include:

* the model is univariate;
* external macroeconomic predictors are not incorporated;
* structural economic changes are not modelled explicitly;
* forecast uncertainty increases with the forecast horizon;
* historical seasonal relationships may not remain stable indefinitely;
* the selected model represents one defensible SARIMA specification rather than an exhaustive comparison of all possible forecasting models.

---

## 22. Possible Extensions

Potential extensions include:

* formal comparison with alternative SARIMA specifications;
* automatic ARIMA model selection;
* exponential-smoothing benchmarks;
* rolling-origin forecast evaluation;
* additional holdout periods;
* model-comparison tables;
* forecast interval calibration analysis;
* structural-break investigation;
* external macroeconomic regressors;
* modern state-space approaches.

These extensions are not required for the current project's objectives but provide natural directions for broader forecasting research.

---

## 23. Final Takeaway

This project demonstrates the connection between theoretical time-series reasoning and applied forecasting.

The first exercise shows how stationarity, covariance, and autocorrelation can be derived and verified when the data-generating process is known.

The second exercise shows how those same ideas are used when the process is unknown and must be estimated from observed economic data.

The resulting workflow progresses through:

```text
theory
→ simulation
→ diagnosis
→ transformation
→ model estimation
→ residual assessment
→ forecasting
→ validation
```

The project therefore combines mathematical understanding, statistical modelling, reproducible programming, and empirical forecast evaluation within one coherent time-series analysis.

---

## Copyright

Copyright (c) 2026 Howard R. Silvey. All Rights Reserved.
