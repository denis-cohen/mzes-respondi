dat <- readRDS("dat/quant_vars.rds") %>%
  dplyr::select(-complete,-lfdn) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(num_div = sum(
    c(
      personal_parent,
      personal_1stgen,
      personal_handic,
      personal_lgbtq,
      personal_ethnic,
      personal_relig,
      personal_citiz,
      personal_lang
    ),
    na.rm = TRUE
  )) %>%
  dplyr::mutate(
    num_div_incl_nonbin = dplyr::if_else(personal_gender %in% c(3), num_div + 1L, num_div),
    num_div_incl_nonmale = dplyr::if_else(personal_gender %in% c(2, 3), num_div + 1L, num_div)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate_at(.vars = vars(starts_with("num_div")),
                   .funs = ~ifelse(. > 3, 3, .)) %>%
  dplyr::mutate_at(.vars = vars(starts_with("num_div")),
                   .funs = ~ factor(., levels = c(0:2, "3 or more"))) %>%
  dplyr::mutate_at(.vars = vars(starts_with("work_")),
                   .funs = ~ factor(
                     .,
                     levels = 1:11,
                     labels = c(
                       "Not at all satisfied",
                       1:4,
                       "Neither satisfied nor dissatisfied",
                       6:9,
                       "Highly satisfied"
                     )
                   )) %>%
  dplyr::mutate_at(
    .vars = vars(covid_resea,
                 covid_teach,
                 covid_admin),
    .funs = ~ factor(
      .,
      levels = 1:12,
      labels = c(
        "Much harder",
        1:4,
        "About the same",
        6:9,
        "Much easier",
        "Not applicable"
      )
    )
  ) %>%
  dplyr::mutate_at(.vars = vars(ends_with("_freq")),
                   .funs = ~ factor(
                     .,
                     levels = 1:4,
                     labels = c(
                       "Once; an isolated incident",
                       "Several times; unrelated isolated incidents",
                       "Repeatedly; recurring and related incidents",
                       "Prefer not to say"
                     )
                   )) %>%
  dplyr::mutate_at(
    .vars = vars(others_conseq_career,
                 others_conseq_offender),
    .funs = ~ factor(
      .,
      levels = 1:3,
      labels = c("0",
                 "1",
                 "Don't know")
    )
  ) %>%
  dplyr::mutate_at(
    .vars = vars(personal_occup),
    .funs = ~ factor(
      .,
      levels = 1:7,
      labels = c(
        "Student assistant",
        "Pre-doctoral researcher",
        "Post-doctoral researcher",
        "Professor",
        "Administration/infrastructure",
        "Other",
        "Prefer not to say"
      )
    )
  ) %>%
  dplyr::mutate_at(
    .vars = vars(personal_gender),
    .funs = ~ factor(
      .,
      levels = 1:4,
      labels = c("Female",
                 "Male",
                 "Non-binary or genderqueer",
                 "Prefer not to say")
    )
  ) %>%
  dplyr::mutate(personal_nonmale =
                  dplyr::if_else(personal_gender == "Male", 0L, 1L)) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    personal_ethrel = dplyr::case_when(
      personal_ethnic == 1 ~ 1L,
      personal_relig == 1 ~ 1L,
      personal_ethnic == 0 & personal_relig == 0 ~ 0L,
      TRUE ~ NA_integer_
    ),
    personal_citlan = dplyr::case_when(
      personal_citiz == 1 ~ 1L,
      personal_lang == 1 ~ 1L,
      personal_citiz == 0 & personal_lang == 0 ~ 0L,
      TRUE ~ NA_integer_
    ),
    personal_lgbtq_plus = dplyr::if_else(
      personal_gender %in% "Non-binary or genderqueer",
      1L,
      personal_lgbtq
    )
  ) %>%
  dplyr::ungroup()

binary_vars <- dat %>%
  dplyr::select(
    starts_with("self_") & !ends_with("_freq"),
    starts_with("covid_neg_"),
    starts_with("others_") & !ends_with("_freq") & !contains("conseq"),
    starts_with("personal_") & !ends_with("occup") & !ends_with("gender")
  ) %>%
  names()

dat <- dat %>%
  dplyr::mutate_at(
    .vars = vars(all_of(binary_vars)),
    .funs = ~ factor(
      .,
      levels = 0:1,
      labels = c("0",
                 "1")
    )
  )
