# Time Series Stationarity and ACF Exercises
# Author: Howard R. Silvey
#
# Purpose:
#   1. Derive the mean, covariance function, and ACF for
#        x_t = w_t^2 * w_{t-1}^2 - 4
#   2. Simulate the process under Gaussian white noise.
#   3. Compare the sample ACF with the theoretical ACF.
#
# Model:
#   w_t is Gaussian white noise with:
#     E(w_t) = 0
#     sd(w_t) = 2
#     Var(w_t) = 4
#     E(w_t^4) = 3 * Var(w_t)^2 = 48
#
# Theoretical results:
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
#   Therefore:
#     rho(0) = 1
#     rho(+/-1) = 512/2048 = 1/4
#     rho(h) = 0 for |h| > 1

output_dir <- file.path("outputs", "acf-plots")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

innovation_sd <- 2
innovation_variance <- innovation_sd^2
second_moment <- innovation_variance
fourth_moment <- 3 * innovation_variance^2

process_mean <- second_moment^2 - 4
process_variance <- fourth_moment^2 - second_moment^4
lag_one_covariance <- (
  second_moment * fourth_moment * second_moment
  - second_moment^4
)
lag_one_acf <- lag_one_covariance / process_variance

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
  ifelse(abs(lags) == 1, lag_one_acf, 0)
)

theoretical_table <- data.frame(
  lag = lags,
  acf = theoretical_acf
)

write.csv(
  theoretical_table,
  file.path(output_dir, "theoretical-acf.csv"),
  row.names = FALSE
)

png(
  filename = file.path(output_dir, "theoretical-acf.png"),
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
points(theoretical_table$lag, theoretical_table$acf, pch = 16)
dev.off()

set.seed(2026)

n <- 10000
w <- rnorm(n = n + 1, mean = 0, sd = innovation_sd)
x <- w[2:(n + 1)]^2 * w[1:n]^2 - 4

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
    cov(x[-1], x[-length(x)]),
    cor(x[-1], x[-length(x)])
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
  file.path(output_dir, "simulation-summary.csv"),
  row.names = FALSE
)

png(
  filename = file.path(output_dir, "simulated-process-acf.png"),
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

print(simulation_summary)


# ---------------------------------------------------------------------------
# Interpretation and bridge to the applied SARIMA analysis
# ---------------------------------------------------------------------------
#
# What this exercise demonstrates
#
# 1. Weak stationarity
#    The process has a constant mean and variance over time, and its covariance
#    depends only on lag rather than calendar time. This is the central
#    structural condition used by many classical time-series methods.
#
# 2. Dependence across time
#    Although the innovations w_t are independent, x_t and x_{t-1} share the
#    term w_{t-1}^2. That shared innovation creates non-zero dependence at lag
#    one. Once observations are separated by more than one lag, they no longer
#    share innovations and their covariance is zero.
#
# 3. Covariance function
#    The covariance function measures the magnitude and direction of linear
#    dependence between observations separated by each lag. Here, dependence
#    is concentrated entirely at lag one.
#
# 4. Autocorrelation function
#    The ACF standardizes covariance by the process variance. The theoretical
#    ACF therefore has:
#
#      rho(0) = 1
#      rho(+/-1) = 0.25
#      rho(h) = 0 for |h| > 1
#
#    This compact pattern is a theoretical example of how an ACF reveals the
#    memory structure of a time series.
#
# 5. Theoretical versus sample behaviour
#    The simulated ACF will not exactly equal the theoretical ACF because a
#    finite sample contains sampling variation. As the simulation size grows,
#    the sample mean, variance, covariance, and ACF should move closer to their
#    theoretical values.
#
# How this prepares the reader for the unemployment analysis
#
# The next script applies the same ideas to observed economic data:
#
# - The unemployment series is first plotted to identify trend, seasonality,
#   changing level, and possible instability.
# - The ACF and PACF are inspected to identify persistence and candidate
#   autoregressive or moving-average behaviour.
# - First differencing removes persistent changes in level.
# - Seasonal differencing at lag 12 removes recurring annual patterns.
# - A SARIMA model then represents the remaining short-run and seasonal
#   dependence.
#
# In the theoretical exercise, the covariance structure is known exactly from
# the process definition. In the unemployment exercise, the dependence
# structure is unknown and must be inferred from the observed series using
# plots, differencing, ACF/PACF diagnostics, model fitting, and residual checks.
#
# Key tools carried into Script 02
#
# - Mean and variance: describe the level and dispersion of a process.
# - Covariance: measures dependence between observations at different lags.
# - ACF: summarizes correlation by lag and helps identify persistence,
#   seasonality, and moving-average structure.
# - PACF: isolates direct correlation at each lag after controlling for shorter
#   lags and helps identify autoregressive structure.
# - Differencing: transforms a non-stationary series toward stationarity.
# - Seasonal differencing: removes recurring patterns separated by a fixed
#   seasonal period.
# - SARIMA: combines autoregressive, differencing, moving-average, and seasonal
#   terms in one forecasting model.
# - Residual diagnostics: test whether the fitted model has removed systematic
#   dependence, leaving approximately white-noise errors.
#
# Final takeaway
#
# This exercise shows why stationarity and lag dependence must be understood
# before forecasting. Script 02 extends those concepts from a process with a
# known mathematical structure to a real economic series whose structure must
# be diagnosed and estimated.
