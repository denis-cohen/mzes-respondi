## ---- Source data-processing scripts ----
source("r/quant-data.r")
source("r/process-quant-data.r")

## ---- Generate tables ----
## Tabulate and append
main_quantitative_vars <- dat %>%
  dplyr::select(starts_with("work_"),
                starts_with("covid_"),
                self_any,
                self_none,
                self_insult,
                self_threat,
                self_molest,
                self_discri,
                self_any_col,
                self_any_sup,
                self_any_oth,
                self_conseq_career,
                self_support) %>%
  names()
continuous_vars <- c("work_atmos",
                     "work_condi",
                     "covid_resea",
                     "covid_teach",
                     "covid_admin")
conditioning_vars <- dat %>%
  dplyr::select(starts_with("personal_"),
                starts_with("num_div"),
                self_any) %>%
  names()

bivariate_summary <- tidyr::tibble()
for (var in main_quantitative_vars) {
  for (group in conditioning_vars) {
    if (!(startsWith(var, "self") &
          startsWith(group, "self"))) {
      frequency_distribution <- dat %>%
        dplyr::rename(value = var,
                      subgroup = group) %>%
        dplyr::select(value, subgroup) %>%
        dplyr::group_by(subgroup, value, .drop = FALSE) %>%
        dplyr::tally() %>%
        dplyr::rename(freq = n) %>%
        dplyr::group_by(subgroup, .drop = FALSE) %>%
        dplyr::mutate(subgroup_size = sum(freq)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(var = var,
                      conditioning_var = group) %>%
        dplyr::select(var,
                      conditioning_var,
                      subgroup,
                      subgroup_size,
                      value,
                      freq)
      
      if (var %in% continuous_vars) {
        frequency_distribution <- frequency_distribution %>%
          dplyr::left_join(
            dat %>%
              dplyr::rename(value = var,
                            subgroup = group) %>%
              dplyr::select(value, subgroup) %>%
              dplyr::group_by(subgroup, .drop = FALSE) %>%
              dplyr::mutate(
                value_num = dplyr::if_else(
                  is.na(value) | value %in% c("Not applicable"),
                  NA_integer_,
                  as.integer(value) - 1L
                )
              ) %>%
              dplyr::summarize(
                mean = mean(value_num, na.rm = TRUE),
                std_dev = sd(value_num, na.rm = TRUE),
                median = median(value_num, na.rm = TRUE),
                perc25 = quantile(value_num, probs = .25, na.rm = TRUE),
                perc75 = quantile(value_num, probs = .75, na.rm = TRUE)
              ),
            by = "subgroup"
          )
      } else {
        frequency_distribution <- frequency_distribution %>%
          dplyr::group_by(subgroup, .drop = FALSE) %>%
          mutate(
            mean = freq / sum(freq),
            std_dev = NA_real_,
            median = NA_real_,
            perc25 = NA_real_,
            perc75 = NA_real_
          )
      }
      
      ## Enforce minimum subgroup size
      frequency_distribution <- frequency_distribution %>%
        dplyr::mutate_at(
          .vars = vars(freq, mean, std_dev, median, perc25, perc75),
          .funs = ~ ifelse(subgroup_size < 5, NA, .)
        )
      
      ## Append
      bivariate_summary <- dplyr::bind_rows(bivariate_summary,
                                            frequency_distribution)
    }
  }
}

## Collapse information for subgroups with N < 5
bivariate_summary <- bivariate_summary %>%
  dplyr::mutate(
    value = as.character(value),
    value = ifelse(subgroup_size < 5, "Subgroup too small", value)
  ) %>%
  distinct()

## Add question text
bivariate_summary <- bivariate_summary %>%
  dplyr::left_join(
    readr::read_csv("aux-dat-external/quantitative_names_questions.csv",
                    show_col_types = FALSE),
    by = c("var" = "name")
  )

bivariate_summary %>%
  readr::write_excel_csv("csv/bivariate/bivariate-summary.csv")
