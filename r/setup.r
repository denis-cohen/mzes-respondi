if (!("pacman" %in% installed.packages()))
  install.packages("pacman")

pacman::p_load(
  dplyr,
  rmarkdown,
  readxl,
  here,
  ggplot2,
  viridisLite,
  tidyr,
  readr
)
