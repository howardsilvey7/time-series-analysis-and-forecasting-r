# ============================================================
# Unemployment Time Series Analysis and Seasonal Forecasting
# Author: Howard R. Silvey
# ============================================================
#
# Purpose:
#   1. Inspect the unemployment time series.
#   2. Analyze ACF and PACF behaviour.
#   3. Apply ordinary and seasonal differencing.
#   4. Evaluate stationarity.
#   5. Fit SARIMA(2,1,0)(0,1,1)[12].
#   6. Produce model diagnostics.
#   7. Generate a twelve-period forecast.
#   8. Export reproducible numerical and graphical outputs.

required_packages <- c(
  "astsa",
  "forecast",
  "tseries"
)

missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]

if (length(missing_packages) > 0) {
  stop(
    paste(
      "Install the following packages before running this script:",
      paste(missing_packages, collapse = ", ")
    )
  )
}

output_acf_dir <- file.path(
  "outputs",
  "acf-plots"
)

output_forecast_dir <- file.path(
  "outputs",
  "forecasts"
)

output_diagnostics_dir <- file.path(
  "outputs",
  "diagnostics"
)

output_figures_dir <- file.path(
  "outputs",
  "figures"
)

for (directory in c(
  output_acf_dir,
  output_forecast_dir,
  output_diagnostics_dir,
  output_figures_dir
)) {
  dir.create(
    directory,
    recursive = TRUE,
    showWarnings = FALSE
  )
}

data(
  "unemp",
  package = "astsa"
)

if (!exists("unemp")) {
  stop(
    "The 'unemp' time series could not be loaded from the astsa package."
  )
}

cat("\n\n--------------------------------------------\n")
cat("Unemployment time-series analysis\n")
cat("--------------------------------------------\n")

cat("Observations:", length(unemp), "\n")
cat("Frequency:", frequency(unemp), "\n")
cat("Start:", paste(start(unemp), collapse = ", "), "\n")
cat("End:", paste(end(unemp), collapse = ", "), "\n\n")

png(
  filename = file.path(
    output_forecast_dir,
    "unemployment-series.png"
  ),
  width = 1400,
  height = 900,
  res = 150
)

plot(
  unemp,
  main = "Unemployment Time Series",
  ylab = "Unemployment",
  xlab = "Time"
)

dev.off()

save_acf2_plot <- function(
  series,
  filename,
  title
) {

  png(
    filename = file.path(
      output_acf_dir,
      filename
    ),
    width = 1400,
    height = 1000,
    res = 150
  )

  astsa::acf2(
    series,
    main = title
  )

  dev.off()
}

cat("--------------------------------------------\n")
cat("Original-series diagnostics\n")
cat("--------------------------------------------\n")

save_acf2_plot(
  unemp,
  "01-original-series-acf-pacf.png",
  "ACF and PACF: Original Unemployment Series"
)

first_difference <- diff(unemp)

save_acf2_plot(
  first_difference,
  "02-first-difference-acf-pacf.png",
  "ACF and PACF: First-Differenced Unemployment Series"
)

seasonally_differenced <- diff(
  first_difference,
  lag = 12
)

save_acf2_plot(
  seasonally_differenced,
  "03-first-and-seasonal-difference-acf-pacf.png",
  "ACF and PACF: First and Seasonal Difference"
)

cat("\n--------------------------------------------\n")
cat("Augmented Dickey-Fuller stationarity tests\n")
cat("--------------------------------------------\n")

adf_output_file <- file.path(
  output_forecast_dir,
  "augmented-dickey-fuller-tests.txt"
)

adf_results <- list(
  original =
    tseries::adf.test(unemp),
  first_difference =
    tseries::adf.test(first_difference),
  first_and_seasonal_difference =
    tseries::adf.test(seasonally_differenced)
)

sink(adf_output_file)

cat("Augmented Dickey-Fuller tests\n")
cat("=============================\n\n")

cat("Original series\n")
cat("---------------\n")
print(adf_results$original)

cat("\nFirst difference\n")
cat("----------------\n")
print(adf_results$first_difference)

cat("\nFirst and seasonal difference\n")
cat("-----------------------------\n")
print(adf_results$first_and_seasonal_difference)

sink()

cat(
  "ADF results written to:",
  adf_output_file,
  "\n"
)

cat("\n--------------------------------------------\n")
cat("SARIMA model fitting\n")
cat("--------------------------------------------\n")

model_output_file <- file.path(
  output_forecast_dir,
  "sarima-210-011-12-model-output.txt"
)

diagnostic_plot_file <- file.path(
  output_diagnostics_dir,
  "sarima-210-011-12-diagnostics.png"
)

png(
  filename = diagnostic_plot_file,
  width = 1600,
  height = 1200,
  res = 150
)

sink(model_output_file)

cat("Model: SARIMA(2,1,0)(0,1,1)[12]\n")
cat("==================================\n\n")

model_fit <- astsa::sarima(
  unemp,
  p = 2,
  d = 1,
  q = 0,
  P = 0,
  D = 1,
  Q = 1,
  S = 12,
  details = TRUE
)

print(model_fit)

sink()
dev.off()

cat(
  "Model output written to:",
  model_output_file,
  "\n"
)

cat(
  "Diagnostic plot written to:",
  diagnostic_plot_file,
  "\n"
)

cat("\n--------------------------------------------\n")
cat("Twelve-period unemployment forecast\n")
cat("--------------------------------------------\n")

forecast_plot_file <- file.path(
  output_forecast_dir,
  "sarima-210-011-12-twelve-period-forecast.png"
)

png(
  filename = forecast_plot_file,
  width = 1400,
  height = 900,
  res = 150
)

forecast_result <- astsa::sarima.for(
  unemp,
  n.ahead = 12,
  p = 2,
  d = 1,
  q = 0,
  P = 0,
  D = 1,
  Q = 1,
  S = 12
)

dev.off()

if (!is.null(forecast_result$pred)) {

  forecast_table <- data.frame(
    horizon = seq_along(
      forecast_result$pred
    ),
    forecast = as.numeric(
      forecast_result$pred
    ),
    standard_error = if (
      !is.null(forecast_result$se)
    ) {
      as.numeric(
        forecast_result$se
      )
    } else {
      NA_real_
    }
  )

  forecast_values_file <- file.path(
    output_forecast_dir,
    "sarima-210-011-12-forecast-values.csv"
  )

  write.csv(
    forecast_table,
    forecast_values_file,
    row.names = FALSE
  )

  cat(
    "Forecast values written to:",
    forecast_values_file,
    "\n"
  )

  cat("\nForecast table\n")
  cat("--------------\n")

  print(forecast_table)
}

# ------------------------------------------------------------
# Interpretation
# ------------------------------------------------------------
#
# Original series
#
# The raw unemployment series is inspected for persistence, changing level,
# trend-like behaviour, and seasonal structure.
#
# First differencing
#
# First differencing applies:
#
#   (1 - B)x_t
#
# to reduce persistent changes in level.
#
# Seasonal differencing
#
# Monthly seasonality is addressed through:
#
#   (1 - B^12)
#
# Combining the transformations gives:
#
#   (1 - B)(1 - B^12)x_t
#
# ACF and PACF
#
# The ACF summarizes correlation between observations and their lagged values.
# The PACF isolates direct relationships at individual lags after accounting
# for shorter-lag dependence.
#
# Augmented Dickey-Fuller testing
#
# ADF tests provide additional evidence about stationarity before and after
# differencing.
#
# SARIMA model
#
# The fitted specification is:
#
#   SARIMA(2,1,0)(0,1,1)[12]
#
# It contains:
#
# - two non-seasonal autoregressive terms;
# - one ordinary difference;
# - no non-seasonal moving-average terms;
# - no seasonal autoregressive terms;
# - one seasonal difference;
# - one seasonal moving-average term;
# - a seasonal period of twelve months.
#
# Residual diagnostics
#
# Diagnostic plots assess whether substantial systematic temporal dependence
# remains after fitting the model.
#
# Forecasting
#
# The fitted model produces twelve future unemployment estimates and associated
# forecast standard errors.
#
# Connection to Script 01
#
# Script 01 begins with a process whose covariance and autocorrelation structure
# can be derived exactly.
#
# Script 02 addresses an observed economic series whose structure must instead
# be inferred through visualization, ACF/PACF diagnostics, differencing,
# stationarity testing, model fitting, residual analysis, and forecast
# validation.
#
# Final takeaway
#
# The analysis demonstrates how stationarity, autocorrelation, and lag
# structure translate from theoretical concepts into a practical seasonal
# forecasting workflow.

cat("\n--------------------------------------------\n")
cat("Analysis complete\n")
cat("--------------------------------------------\n")

cat("ACF/PACF outputs:", output_acf_dir, "\n")
cat("Forecast outputs:", output_forecast_dir, "\n")
cat("Diagnostics directory:", output_diagnostics_dir, "\n")
cat("General figures directory:", output_figures_dir, "\n")
cat("Model: SARIMA(2,1,0)(0,1,1)[12]\n")
cat("Forecast horizon: 12 periods\n")

cat("--------------------------------------------\n")
cat("End of Script 02\n")
cat("--------------------------------------------\n")
