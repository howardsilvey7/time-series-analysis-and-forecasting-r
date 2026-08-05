# Unemployment Time Series Analysis and Seasonal Forecasting
# Author: Howard R. Silvey
#
# Purpose:
#   Analyze the unemployment time series supplied by the astsa package using
#   visual diagnostics, ordinary and seasonal differencing, and a
#   SARIMA(2,1,0)(0,1,1)[12] model.

required_packages <- c("astsa", "forecast")

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    paste(
      "Install the following packages before running this script:",
      paste(missing_packages, collapse = ", ")
    )
  )
}

output_acf_dir <- file.path("outputs", "acf-plots")
output_forecast_dir <- file.path("outputs", "forecasts")

dir.create(output_acf_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(output_forecast_dir, recursive = TRUE, showWarnings = FALSE)

data("unemp", package = "astsa")

if (!exists("unemp")) {
  stop("The 'unemp' time series could not be loaded from the astsa package.")
}

png(
  filename = file.path(output_forecast_dir, "unemployment-series.png"),
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

save_acf2_plot <- function(series, filename, title) {
  png(
    filename = file.path(output_acf_dir, filename),
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

seasonally_differenced <- diff(first_difference, lag = 12)

save_acf2_plot(
  seasonally_differenced,
  "03-first-and-seasonal-difference-acf-pacf.png",
  "ACF and PACF: First and Seasonal Difference"
)

model_output_file <- file.path(
  output_forecast_dir,
  "sarima-210-011-12-model-output.txt"
)

sink(model_output_file)
cat("Model: SARIMA(2,1,0)(0,1,1)[12]\n\n")

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

png(
  filename = file.path(
    output_forecast_dir,
    "sarima-210-011-12-twelve-period-forecast.png"
  ),
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
    horizon = seq_along(forecast_result$pred),
    forecast = as.numeric(forecast_result$pred),
    standard_error = if (!is.null(forecast_result$se)) {
      as.numeric(forecast_result$se)
    } else {
      NA_real_
    }
  )

  write.csv(
    forecast_table,
    file.path(
      output_forecast_dir,
      "sarima-210-011-12-forecast-values.csv"
    ),
    row.names = FALSE
  )
}

if (requireNamespace("tseries", quietly = TRUE)) {
  adf_output_file <- file.path(
    output_forecast_dir,
    "augmented-dickey-fuller-tests.txt"
  )

  sink(adf_output_file)
  cat("Augmented Dickey-Fuller tests\n")
  cat("=============================\n\n")

  cat("Original series\n")
  print(tseries::adf.test(unemp))

  cat("\nFirst difference\n")
  print(tseries::adf.test(first_difference))

  cat("\nFirst and seasonal difference\n")
  print(tseries::adf.test(seasonally_differenced))
  sink()
}

cat("Analysis complete.\n")
cat("ACF outputs:", output_acf_dir, "\n")
cat("Forecast outputs:", output_forecast_dir, "\n")
