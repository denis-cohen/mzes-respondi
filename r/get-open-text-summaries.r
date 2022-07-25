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
  dplyr::group_by(var) %>%
  dplyr::summarize(num_respondents = length(unique(lfdn)),
                   num_responses = n()) %>%
  dplyr::ungroup() %>%
  readr::write_csv("csv/open-text/open-text-summaries.csv")
