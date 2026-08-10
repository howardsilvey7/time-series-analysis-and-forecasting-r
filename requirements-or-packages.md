### `requirements-or-packages.md`

```markdown
# R Requirements and Packages

This project is implemented in R.

Python is not required.

## Recommended R Version

```text
R 4.3 or newer
Required Packages
astsa
install.packages("astsa")

Used for:

unemployment time-series data;
ACF/PACF analysis;
SARIMA modelling;
SARIMA forecasting.
forecast
install.packages("forecast")

Used for supporting time-series forecasting functionality.

tseries
install.packages("tseries")

Used for Augmented Dickey-Fuller stationarity testing.

Install All Required Packages
RStudio or Visual Studio Code R Console
install.packages(c("astsa", "forecast", "tseries"))
Git Bash or Ordinary Terminal
Rscript -e 'install.packages(c("astsa","forecast","tseries"), repos="https://cloud.r-project.org")'
Automatic Dependency Handling
source("scripts/run-all.R")
Windows R Installation

Typical location:

C:\Program Files\R\

Example:

C:\Program Files\R\R-4.3.0\bin\Rscript.exe

Git Bash equivalent:

/c/Program Files/R/R-4.3.0/bin/Rscript.exe
Notes
acf2(), sarima(), sarima.for(), and unemp are supplied through astsa.
Base R packages do not require separate installation.
See RUNNING.md for execution instructions.
