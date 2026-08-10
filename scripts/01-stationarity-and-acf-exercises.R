# ============================================================
# Time Series Stationarity and ACF Exercises
# Author: Howard R. Silvey
# ============================================================
#
# Purpose:
#   1. Derive the mean, covariance function, and ACF for
#        x_t = w_t^2 * w_{t-1}^2 - 4
#   2. Simulate the process under Gaussian white noise.
#   3. Compare sample statistics and the sample ACF with
#      their theoretical counterparts.
#
# Model:
#   w_t is Gaussian white noise with:
#     E(w_t) = 0
#     sd(w_t) = 2
#     Var(w_t) = 4
#     E(w_t^4) = 3 * Var(w_t)^2 = 48
#
# Theoretical results:
#
#   E(x_t)
#     = E(w_t^2)E(w_{t-1}^2) - 4
#     = 4 * 4 - 4
#     = 12
#
#   Var(x_t)
#     = E(w_t^4)E(w_{t-1}^4)
#       - [E(w_t^2)E(w_{t-1}^2)]^2
#     = 48^2 - 16^2
#     = 2048
#
#   Cov(x_t, x_{t-1})
#     = E(w_t^2)E(w_{t-1}^4)E(w_{t-2}^2) - 16^2
#     = 4 * 48 * 4 - 256
#     = 512
#
#   Cov(x_t, x_{t-h}) = 0 for |h| > 1.
#
# Therefore:
#   rho(0) = 1
#   rho(+/-1) = 512 / 2048 = 1/4
#   rho(h) = 0 for |h| > 1

output_dir <- file.path(
  "outputs",
  "acf-plots"
)

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

innovation_sd <- 2
innovation_variance <- innovation_sd^2

second_moment <- innovation_variance
fourth_moment <- 3 * innovation_variance^2

process_mean <- second_moment^2 - 4

process_variance <- (
  fourth_moment^2
  - second_moment^4
)

lag_one_covariance <- (
  second_moment
  * fourth_moment
  * second_moment
  - second_moment^4
)

lag_one_acf <- (
  lag_one_covariance
  / process_variance
)

cat("\n\n--------------------------------------------\n")
cat("Theoretical results for Gaussian white noise\n")
cat("--------------------------------------------\n")

cat("E(x_t):", process_mean, "\n")
cat("Var(x_t):", process_variance, "\n")
cat("Cov(x_t, x_{t-1}):", lag_one_covariance, "\n")
cat("rho(1) = rho(-1):", lag_one_acf, "\n")
cat("rho(h) for |h| > 1: 0\n\n")

lags <- -10:10

theoretical_acf <- ifelse(
  lags == 0,
  1,
  ifelse(
    abs(lags) == 1,
    lag_one_acf,
    0
  )
)

theoretical_table <- data.frame(
  lag = lags,
  acf = theoretical_acf
)

write.csv(
  theoretical_table,
  file.path(
    output_dir,
    "theoretical-acf.csv"
  ),
  row.names = FALSE
)

png(
  filename = file.path(
    output_dir,
    "theoretical-acf.png"
  ),
  width = 1400,
  height = 900,
  res = 150
)

plot(
  theoretical_table$lag,
  theoretical_table$acf,
  type = "h",
  lwd = 4,
  xlab = "Lag",
  ylab = "Autocorrelation",
  main = "Theoretical ACF of x[t]",
  ylim = c(-0.1, 1.05)
)

abline(h = 0)

points(
  theoretical_table$lag,
  theoretical_table$acf,
  pch = 16
)

dev.off()

set.seed(2026)

n <- 10000

w <- rnorm(
  n = n + 1,
  mean = 0,
  sd = innovation_sd
)

x <- (
  w[2:(n + 1)]^2
  * w[1:n]^2
  - 4
)

sample_lag_one_covariance <- cov(
  x[-1],
  x[-length(x)]
)

sample_lag_one_acf <- cor(
  x[-1],
  x[-length(x)]
)

simulation_summary <- data.frame(
  statistic = c(
    "sample_mean",
    "sample_variance",
    "sample_lag_1_covariance",
    "sample_lag_1_acf"
  ),
  estimate = c(
    mean(x),
    var(x),
    sample_lag_one_covariance,
    sample_lag_one_acf
  ),
  theoretical = c(
    process_mean,
    process_variance,
    lag_one_covariance,
    lag_one_acf
  )
)

write.csv(
  simulation_summary,
  file.path(
    output_dir,
    "simulation-summary.csv"
  ),
  row.names = FALSE
)

cat("--------------------------------------------\n")
cat("Simulation results versus theory\n")
cat("--------------------------------------------\n")

print(simulation_summary)

png(
  filename = file.path(
    output_dir,
    "simulated-process-acf.png"
  ),
  width = 1400,
  height = 900,
  res = 150
)

acf(
  x,
  lag.max = 20,
  main = "Sample ACF of Simulated x[t]"
)

dev.off()

# ------------------------------------------------------------
# Interpretation and bridge to applied SARIMA analysis
# ------------------------------------------------------------
#
# Weak stationarity
#
# The process has constant mean and variance over time, and its covariance
# depends only on lag rather than calendar time.
#
# Dependence across time
#
# Although the innovations w_t are independent, x_t and x_{t-1} share the
# term w_{t-1}^2. This creates non-zero dependence at lag one. Observations
# separated by more than one lag do not share innovations and therefore have
# zero covariance.
#
# Covariance function
#
# The covariance function describes linear dependence between observations
# separated by each lag. For this process, dependence is concentrated at
# lag one.
#
# Autocorrelation function
#
# Standardizing covariance by the process variance gives:
#
#   rho(0) = 1
#   rho(+/-1) = 0.25
#   rho(h) = 0 for |h| > 1
#
# Theoretical versus sample behaviour
#
# A finite simulated sample does not reproduce theoretical quantities exactly
# because of sampling variation. With a sufficiently large sample, the sample
# mean, variance, covariance, and ACF should approach their theoretical values.
#
# Bridge to Script 02
#
# Script 02 applies the same concepts to observed unemployment data.
#
# Unlike the theoretical process, the covariance structure of the unemployment
# series is unknown. It must be inferred using:
#
# - visualization;
# - ACF;
# - PACF;
# - first differencing;
# - seasonal differencing;
# - stationarity testing;
# - SARIMA fitting;
# - residual diagnostics;
# - forecast validation.
#
# Key concepts carried into Script 02
#
# Mean and variance:
#   describe the level and dispersion of a process.
#
# Covariance:
#   measures dependence between observations at different lags.
#
# ACF:
#   summarizes correlation by lag and helps identify persistence, seasonality,
#   and moving-average structure.
#
# PACF:
#   isolates direct lag relationships after controlling for shorter lags and
#   helps identify autoregressive structure.
#
# Differencing:
#   transforms a non-stationary series toward stationarity.
#
# Seasonal differencing:
#   removes recurring dependence separated by a fixed seasonal period.
#
# SARIMA:
#   combines autoregressive, differencing, moving-average, and seasonal
#   components in one forecasting model.
#
# Residual diagnostics:
#   assess whether systematic dependence remains after model fitting.
#
# Forecast validation:
#   compares model-generated future values with observed holdout values.
#
# Final takeaway
#
# Stationarity and lag dependence should be understood before forecasting.
# Script 02 extends these concepts from a process with known mathematical
# structure to a real economic series whose structure must be diagnosed and
# estimated.
#
# ------------------------------------------------------------
# End of Script 01
# ------------------------------------------------------------
