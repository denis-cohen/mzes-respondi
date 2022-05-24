## ---- Source data-processing scripts ----
source("r/data.r")

## ---- Generate tables ----
dat <- readRDS("dat/quant_vars.rds")
personal_vars <- names(dat)
personal_vars <- personal_vars[startsWith(personal_vars, "personal_")]

for (var in personal_vars) {
  dat %>%
    dplyr::select(!!as.name(var)) %>%
    table(useNA = "always") %>%
    dplyr::as_tibble() %>%
    dplyr::rename(., value = .) %>%
    write.csv(.,
              row.names = FALSE,
              file = paste0("csv/univariate/", var, ".csv"))
}
