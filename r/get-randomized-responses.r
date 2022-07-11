## ---- Source data-processing scripts ----
source("r/quant-data.r")
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

## Number of answered questions per respondents
proc_dat_qual %>%
  dplyr::group_by(lfdn, var) %>%
  dplyr::summarize(answered_any = 1L) %>%
  dplyr::ungroup() %>%
  dplyr::summarize(sum_answered_any = sum(answered_any)) %>%
  readr::write_csv("csv/open-text/num_answered_questions.csv")

## Randomization, arrangement, output
ordered_names <- unique(proc_dat_qual$var)
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
## Pre-anonymization (for reference)
proc_dat_qual %>%
  readr::write_excel_csv("csv/open-text/pre-anonymization.csv")

## Version for manual anonymization
if (file.exists("csv/open-text/post-anonymization.csv")) {
  stop(
    paste0(
      'The file csv/open-text/post-anonymization.csv ',
      'already exists. It will not be overwritten as potential ',
      ' manual edits would be lost. ',
      'If you want to replace the file, please overwrite it ',
      'manually with a copy of csv/open-text/pre-anonymization.csv.'
    )
  )
} else {
  proc_dat_qual %>%
    readr::write_excel_csv("csv/open-text/post-anonymization.csv")
}
