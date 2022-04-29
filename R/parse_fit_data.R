#' Parse FIT data
#'
#' Read and transform a data FIT file from csv file format to a tidy
#' tibble with columns and content processed for the utility of
#' IO.BED project.
#'
#' @param fit_data_csv_path (chr) file path the the `<name>_data.csv`
#'   file as output from the function [fit2datacsv]
#'
#' @return a [tibble][tibble::tibble-package] with the imported data FIT
#'   file.
#' @export
#'
#' @examples
#' \dontrun{
#' sample_data <- data_test_path("8356614998_ACTIVITY.fit")
#' output_dir <- withr::local_tempdir()
#'
#' fit_data_csv_path <- sample_data |>
#'   load_fit(output_dir) |>
#'   fit2datacsv()
#'
#' parse_fit_data(fit_data_csv_path)
#' }
#'
parse_fit_data <- function(fit_data_csv_path) {
  raw_data_text <- readr::read_lines(fit_data_csv_path) |>
    stringr::str_remove_all(",$")  # last column is always empty

  raw_data <-  I(raw_data_text[-2]) |> # first row doesn't have hd data
    readr::read_csv(show_col_types = FALSE) |>
    janitor::clean_names()

  useful_data <- raw_data |>
    dplyr::select(
      record_timestamp_s,
      record_heart_rate_bpm,
      record_temperature_c,
      record_developer_0_sensor_heading_rad,
      dplyr::matches("acceleration_[xyz]_hd_mgn$")
    ) |>
    dplyr::rename(
      timestamp = record_timestamp_s,
      hr = record_heart_rate_bpm,
      temp_c = record_temperature_c,
      heading_rad = record_developer_0_sensor_heading_rad,
      acc_x_hd = record_developer_0_sensor_acceleration_x_hd_mgn,
      acc_y_hd = record_developer_0_sensor_acceleration_y_hd_mgn,
      acc_z_hd = record_developer_0_sensor_acceleration_z_hd_mgn
    ) |>
    dplyr::mutate(
      timestamp =.data[["timestamp"]] |>
        lubridate::as_datetime(origin = "1989-12-31T00:00:00UTC")
    )



  hd_suffix <- as.character(seq(0, 0.96, by = 0.04)) |>
    stringr::str_remove("^0\\.") |>
    stringr::str_pad(2, side = "right", pad = "0")

  useful_data |>
    tidyr::separate(
      acc_x_hd,
      paste0("acc_x_hd-", hd_suffix),
      convert = TRUE,
      sep = "\\|"
    ) |>
    tidyr::separate(
      acc_y_hd,
      paste0("acc_y_hd-", hd_suffix),
      convert = TRUE,
      sep = "\\|"
    ) |>
    tidyr::separate(
      acc_z_hd,
      paste0("acc_z_hd-", hd_suffix),
      convert = TRUE,
      sep = "\\|"
    ) |>
    tidyr::pivot_longer(cols = dplyr::matches("-\\d{2}$")) |>
    tidyr::separate(
      "name",
      into = c("name", "fraction_time"),
      sep = "-"
    ) |>
    tidyr::pivot_wider(
      names_from = .data[["name"]],
      values_from = "value"
    ) |>
    dplyr::mutate(
      fraction_time = 10 * as.numeric(.data[["fraction_time"]]),
      timestamp = .data[["timestamp"]] +
        lubridate::milliseconds(.data[["fraction_time"]])
    ) |>
    dplyr::rename(ms = .data[["fraction_time"]]) |>
    dplyr::relocate(.data[["ms"]], .after = .data[["timestamp"]])

}
