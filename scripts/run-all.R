# ============================================================
# Complete Reproducible Workflow
# Time Series Analysis and Seasonal Forecasting in R
# Author: Howard R. Silvey
# ============================================================

cat("\n============================================\n")
cat("Time Series Analysis and Seasonal Forecasting in R\n")
cat("Complete reproducible workflow\n")
cat("============================================\n\n")

cat("--------------------------------------------\n")
cat("1. Project setup\n")
cat("--------------------------------------------\n\n")

source(
  "scripts/00-project-setup.R"
)

cat("\n--------------------------------------------\n")
cat("2. Dependency verification\n")
cat("--------------------------------------------\n\n")

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

  cat("Installing missing packages:\n")

  print(missing_packages)

  install.packages(
    missing_packages,
    repos = "https://cloud.r-project.org"
  )
}

cat("Required R packages are available.\n")

cat("\n--------------------------------------------\n")
cat("3. Stationarity and autocorrelation analysis\n")
cat("--------------------------------------------\n\n")

source(
  "scripts/01-stationarity-and-acf-exercises.R"
)

cat("\n--------------------------------------------\n")
cat("4. Unemployment SARIMA analysis\n")
cat("--------------------------------------------\n\n")

source(
  "scripts/02-unemployment-sarima-analysis.R"
)

cat("\n--------------------------------------------\n")
cat("5. Forecast validation and report\n")
cat("--------------------------------------------\n\n")

source(
  "scripts/03-build-report.R"
)

cat("\n--------------------------------------------\n")
cat("6. Generated analytical outputs\n")
cat("--------------------------------------------\n\n")

output_files <- list.files(
  "outputs",
  recursive = TRUE,
  full.names = TRUE
)

print(output_files)

cat("\n--------------------------------------------\n")
cat("7. Report files\n")
cat("--------------------------------------------\n\n")

report_files <- list.files(
  "report",
  recursive = TRUE,
  full.names = TRUE
)

print(report_files)

cat("\n============================================\n")
cat("Complete workflow finished successfully\n")
cat("============================================\n")
