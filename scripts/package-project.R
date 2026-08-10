# ============================================================
# Package Project as ZIP
# Time Series Analysis and Seasonal Forecasting in R
# Author: Howard R. Silvey
# ============================================================

project_name <- (
  "time-series-analysis-and-forecasting-r"
)

home_directory <- path.expand("~")

downloads_candidates <- unique(
  c(
    file.path(
      home_directory,
      "Downloads"
    ),
    file.path(
      Sys.getenv("USERPROFILE"),
      "Downloads"
    )
  )
)

downloads_candidates <- downloads_candidates[
  dir.exists(
    downloads_candidates
  )
]

if (length(downloads_candidates) == 0) {
  stop(
    "A Downloads directory could not be located."
  )
}

downloads_directory <- (
  downloads_candidates[1]
)

zip_path <- file.path(
  downloads_directory,
  paste0(
    project_name,
    ".zip"
  )
)

files <- list.files(
  ".",
  recursive = TRUE,
  all.files = TRUE,
  no.. = TRUE
)

files <- files[
  !grepl("^\\.git(/|$)", files)
  & !grepl("^\\.Rproj\\.user(/|$)", files)
  & !grepl("^Rplots\\.pdf$", files)
]

if (file.exists(zip_path)) {
  file.remove(zip_path)
}

utils::zip(
  zipfile = zip_path,
  files = files
)

message("")
message("Project ZIP created:")

message(
  normalizePath(
    zip_path,
    winslash = "/",
    mustWork = FALSE
  )
)
