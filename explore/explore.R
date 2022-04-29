devtools::load_all()
library(tidyverse)
library(here)
library(janitor)

sample_data <- data_test_path("8356614998_ACTIVITY.fit")
output_dir <- here("explore")

imported <- sample_data |>
  load_fit(output_dir) |>
  fit2datacsv() |>
  read_csv() |>
  remove_empty("cols") |>
  clean_names()


imported |>
  select(
    record_timestamp_s,
    record_heart_rate_bpm,
    record_temperature_c,
    record_developer_0_sensor_heading_rad,
    matches("acceleration_[xyz]_hd_mgn$")
  ) |>
  mutate(
    record_timestamp_s =.data[["record_timestamp_s"]] |>
      lubridate::as_datetime(origin = "1989-12-31T00:00:00UTC")
  ) |>
  glimpse()


