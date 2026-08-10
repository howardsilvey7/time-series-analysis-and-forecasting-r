# ============================================================
# Project Directory Setup
# Time Series Analysis and Seasonal Forecasting in R
# Author: Howard R. Silvey
# ============================================================

cat("\n============================================\n")
cat("Project directory setup\n")
cat("============================================\n\n")

project_dirs <- c(
  "data",
  "scripts",
  "outputs",
  "outputs/acf-plots",
  "outputs/diagnostics",
  "outputs/figures",
  "outputs/forecasts",
  "report"
)

for (directory in project_dirs) {

  if (!dir.exists(directory)) {

    dir.create(
      directory,
      recursive = TRUE,
      showWarnings = FALSE
    )

    cat(
      "Created: ",
      directory,
      "\n",
      sep = ""
    )

  } else {

    cat(
      "Verified: ",
      directory,
      "\n",
      sep = ""
    )
  }
}

cat("\n--------------------------------------------\n")
cat("Required directory structure is ready\n")
cat("--------------------------------------------\n")
