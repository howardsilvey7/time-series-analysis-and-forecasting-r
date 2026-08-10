# Analysis Scripts

00-project-setup.R
Creates or verifies the project directory structure.

```r
source("scripts/00-project-setup.R")

01-stationarity-and-acf-exercises.R
Performs the theoretical stationarity and autocorrelation analysis.

02-unemployment-sarima-analysis.R
Performs the applied unemployment time-series analysis.

Principal model:
SARIMA(2,1,0)(0,1,1)[12]

03-build-report.R
Performs forecast validation and generates the report outputs.

run-all.R
Runs the complete workflow.
```r
source("scripts/run-all.R")

package-project.R
Creates an optional ZIP archive in the user's Downloads directory.
source("scripts/package-project.R")
