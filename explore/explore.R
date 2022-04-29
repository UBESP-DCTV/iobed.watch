devtools::load_all()
library(tidyverse)
library(here)

sample_data <- data_test_path("8356614998_ACTIVITY.fit")
output_dir <- here("explore")

fit_data_csv_path <- sample_data |>
  load_fit(output_dir) |>
  fit2datacsv()


date_today <- lubridate::today() |>
  stringr::str_replace_all("\\W+", "")
id_pat <- "001"
record_code <-  paste0(date_today, id_pat)

tidy_fit <- fit_data_csv_path |>
  parse_fit_data(dir_path = output_dir, prefix_name = record_code)
tidy_fit
