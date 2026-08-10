# Data

This directory contains or documents source data required by the project.

The historical unemployment series used to fit the SARIMA model is loaded programmatically through the `astsa` R package.

The project also retains monthly observed unemployment values for 1979 so the twelve-period forecast can be validated against observations outside the model-fitting period.

## Source File

```text
observed-unemployment-1979.csv
