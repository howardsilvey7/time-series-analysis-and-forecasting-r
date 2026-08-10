# ============================================================
# Forecast Validation and Report Build
# Author: Howard R. Silvey
# ============================================================

cat("\n--------------------------------------------\n")
cat("Forecast validation and report build\n")
cat("--------------------------------------------\n\n")

forecast_file <- file.path(
  "outputs",
  "forecasts",
  "sarima-210-011-12-forecast-values.csv"
)

observed_file <- file.path(
  "data",
  "observed-unemployment-1979.csv"
)

validation_file <- file.path(
  "report",
  "forecast-validation-1979.csv"
)

report_source_file <- file.path(
  "report",
  "report-source.md"
)

report_pdf_file <- file.path(
  "report",
  "time-series-analysis.pdf"
)

if (!file.exists(forecast_file)) {
  stop(
    "Forecast values are missing. Run Script 02 before building the report."
  )
}

if (!file.exists(observed_file)) {
  stop(
    "Observed 1979 validation data are missing."
  )
}

if (!file.exists(report_source_file)) {
  stop(
    "The permanent report source file is missing."
  )
}

forecast_data <- read.csv(
  forecast_file,
  stringsAsFactors = FALSE
)

observed_data <- read.csv(
  observed_file,
  stringsAsFactors = FALSE
)

if (nrow(forecast_data) != nrow(observed_data)) {
  stop(
    "Forecast and observed validation datasets have different row counts."
  )
}

forecast_ten_thousands <- forecast_data$forecast
standard_error <- forecast_data$standard_error

forecast_persons <- round(
  forecast_ten_thousands * 10000
)

lower_95_ten_thousands <- (
  forecast_ten_thousands
  - 1.96 * standard_error
)

upper_95_ten_thousands <- (
  forecast_ten_thousands
  + 1.96 * standard_error
)

observed_ten_thousands <- (
  observed_data$observed_ten_thousands
)

observed_persons <- (
  observed_ten_thousands * 10000
)

error_ten_thousands <- (
  observed_ten_thousands
  - forecast_ten_thousands
)

validation <- data.frame(
  month =
    observed_data$month,
  forecast_ten_thousands =
    round(forecast_ten_thousands, 1),
  forecast_persons =
    forecast_persons,
  lower_95_ten_thousands =
    round(lower_95_ten_thousands, 1),
  upper_95_ten_thousands =
    round(upper_95_ten_thousands, 1),
  observed_ten_thousands =
    observed_ten_thousands,
  observed_persons =
    observed_persons,
  error_ten_thousands =
    round(error_ten_thousands, 1)
)

write.csv(
  validation,
  validation_file,
  row.names = FALSE
)

mae_persons <- mean(
  abs(
    validation$observed_persons
    - validation$forecast_persons
  )
)

rmse_persons <- sqrt(
  mean(
    (
      validation$observed_persons
      - validation$forecast_persons
    )^2
  )
)

cat(
  "Validation table written to:",
  validation_file,
  "\n"
)

cat(
  "Mean absolute error:",
  round(mae_persons),
  "persons\n"
)

cat(
  "Root mean squared error:",
  round(rmse_persons),
  "persons\n"
)

pdf(
  report_pdf_file,
  width = 8.5,
  height = 11
)

par(
  mar = c(1, 1, 1, 1)
)

plot.new()

text(
  0.5,
  0.95,
  "Time Series Analysis and Seasonal Forecasting in R",
  cex = 1.45,
  font = 2
)

text(
  0.5,
  0.91,
  "Howard R. Silvey",
  cex = 1.05
)

report_lines <- c(
  "",
  "Project Summary",
  "",
  "This project combines theoretical stationarity and autocorrelation",
  "analysis with seasonal forecasting of monthly unemployment.",
  "",
  "Theoretical Process",
  "",
  "x_t = w_t^2 w_(t-1)^2 - 4",
  "",
  "E(x_t) = 12",
  "Var(x_t) = 2048",
  "Cov(x_t, x_(t-1)) = 512",
  "rho(+/-1) = 0.25",
  "rho(h) = 0 for |h| > 1",
  "",
  "Applied Model",
  "",
  "SARIMA(2,1,0)(0,1,1)[12]",
  "",
  "Forecast Validation",
  "",
  paste(
    "Mean absolute error:",
    format(round(mae_persons), big.mark = ","),
    "persons"
  ),
  paste(
    "Root mean squared error:",
    format(round(rmse_persons), big.mark = ","),
    "persons"
  ),
  "",
  paste(
    "December 1979 forecast:",
    format(
      validation$forecast_persons[12],
      big.mark = ","
    ),
    "persons"
  ),
  paste(
    "December 1979 observed:",
    format(
      validation$observed_persons[12],
      big.mark = ","
    ),
    "persons"
  )
)

y <- 0.86

for (line in report_lines) {

  text(
    0.08,
    y,
    line,
    adj = c(0, 1),
    cex = 0.81,
    family = "mono"
  )

  y <- y - 0.031
}

plot.new()

text(
  0.5,
  0.95,
  "1979 Forecast Validation",
  cex = 1.35,
  font = 2
)

validation_display <- validation[
  ,
  c(
    "month",
    "forecast_ten_thousands",
    "observed_ten_thousands",
    "error_ten_thousands"
  )
]

table_lines <- capture.output(
  print(
    validation_display,
    row.names = FALSE
  )
)

y <- 0.89

for (line in table_lines) {

  text(
    0.06,
    y,
    line,
    adj = c(0, 1),
    cex = 0.72,
    family = "mono"
  )

  y <- y - 0.042
}

mtext(
  "Copyright (c) 2026 Howard R. Silvey. All Rights Reserved.",
  side = 1,
  line = -1.5,
  cex = 0.65
)

dev.off()

cat(
  "PDF report written to:",
  report_pdf_file,
  "\n"
)

cat("--------------------------------------------\n")
cat("Report build complete\n")
cat("--------------------------------------------\n")
