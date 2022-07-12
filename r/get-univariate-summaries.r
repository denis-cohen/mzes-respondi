## ---- Source data-processing scripts ----
source("r/quant-data.r")
source("r/process-quant-data.r")

## ---- Generate tables ----
## Tabulate and append
quantitative_vars <- names(dat)
continuous_vars <- c("work_atmos",
                     "work_condi",
                     "covid_resea",
                     "covid_teach",
                     "covid_admin")

univariate_summary <- tidyr::tibble()
for (var in quantitative_vars) {
  frequency_distribution <- dat %>%
    dplyr::select(!!as.name(var)) %>%
    table(useNA = "always") %>%
    dplyr::as_tibble() %>%
    dplyr::rename(., value = .,
                  freq = n) %>%
    dplyr::mutate(var = var) %>%
    dplyr::select(var, value, freq)
  
  if (var %in% continuous_vars) {
    frequency_distribution <- dplyr::bind_cols(
      frequency_distribution,
      dat %>%
        dplyr::select(any_of(var)) %>%
        dplyr::mutate(
          value_num = dplyr::if_else(
            is.na(!!as.name(var)) | !!as.name(var) %in% c("Not applicable"),
            NA_integer_,
            as.integer(!!as.name(var)) - 1L
          )
        )
      %>%
        dplyr::summarize(
          mean = mean(value_num, na.rm = TRUE),
          std_dev = sd(value_num, na.rm = TRUE),
          median = median(value_num, na.rm = TRUE),
          perc25 = quantile(value_num, probs = .25, na.rm = TRUE),
          perc75 = quantile(value_num, probs = .75, na.rm = TRUE)
        )
    )
  } else {
    frequency_distribution <- frequency_distribution %>%
      mutate(
        mean = freq / sum(freq),
        std_dev = NA_real_,
        median = NA_real_,
        perc25 = NA_real_,
        perc75 = NA_real_
      )
  }
  
  univariate_summary <- dplyr::bind_rows(univariate_summary,
                                         frequency_distribution)
}

## Export
univariate_summary %>%
  readr::write_excel_csv("csv/univariate/univariate-summary.csv")
