## ---- Source data-processing scripts ----
source("r/qual-data.r")

## ---- Post-processing of text questions for manual deanonymization ----
# Desired output:
#   - All valid free-text responses
#   - Without any personal identifying information
#   - randomized within question groups to avoid sequencing and clustering

## Wide to long, split, drop empty cells
proc_dat_qual <- dat_qual %>%
  tidyr::pivot_longer(
    cols = !lfdn,
    names_to = c("var", "num"),
    names_pattern = "([A-Za-z_]+)(\\d+)",
    values_to = "response"
  ) %>%
  dplyr::filter(!is.na(response))

ordered_names <- unique(proc_dat_qual$var)
num_responses <- nrow(proc_dat_qual)

proc_dat_qual <- proc_dat_qual %>%
  dplyr::mutate(var = factor(
    var,
    levels = ordered_names,
    ordered = TRUE
  )) %>%
  dplyr::arrange(var, lfdn, num) %>%
  dplyr::select(-lfdn, -num) %>%
  dplyr::group_by(var) %>%
  dplyr::mutate(pos = sample(seq_len(n()), size = n(), replace = FALSE)) %>%
  dplyr::arrange(var, pos) %>%
  dplyr::select(-pos) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(response_num = row_number()) %>%
  dplyr::left_join(
    readr::read_csv("aux-dat-external/qualitative_names_questions.csv"),
    by = c("var" = "name")
  ) %>%
  dplyr::select(response_num,
                var,
                question,
                response) %>%
  dplyr::mutate(
    anonymized_by_respondi = NA,
    flagged_by_respondi = NA
  )

## ---- Export as CSV ----
proc_dat_qual %>%
  readr::write_csv("csv/open-text/pre-anonymization.csv")
proc_dat_qual %>%
  readr::write_csv("csv/open-text/post-anonymization.csv")
