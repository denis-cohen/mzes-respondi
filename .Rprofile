## ---- respondi: Set name of xlsx and sheet ----
respondi_xlsx_name <- "data_project_21384_2022_04_21.xlsx"
respondi_sheet_name <- "Export 1.1"

## ---- Install renv if uninstalled ----
if (!("renv" %in% installed.packages())) {
  install.packages("renv")
}

## ---- Start up ----
.First <- function() {
  ## ---- Generate folders ----
  dir.create(paste0(getwd(), "/r"), showWarnings = F)
  dir.create(paste0(getwd(), "/rmd"), showWarnings = F)
  dir.create(paste0(getwd(), "/pdf"), showWarnings = F)
  dir.create(paste0(getwd(), "/dat"), showWarnings = F)
  dir.create(paste0(getwd(), "/csv"), showWarnings = F)
  dir.create(paste0(getwd(), "/csv/univariate"), showWarnings = F)
  dir.create(paste0(getwd(), "/csv/bivariate"), showWarnings = F)
  
  ## ---- Initialize/activate renv ----
  if (!("renv" %in% list.files())) {
    renv::init()
  } else {
    source("renv/activate.R")
  }

  ## ---- Run setup script ----
  source("r/setup.r")
  
  ## ---- Print welcome message ----
  cat("\nWelcome to your R-Project:", basename(getwd()), "\n")
}

## ---- Shutdown ---
.Last <- function() {
  renv::snapshot()
}
