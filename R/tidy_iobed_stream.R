#' Tidy version of IOBED stream
#'
#' Get a stream pulled by [pull_bed_stream] and tidy it in a tibble
#'
#' @param stream (chr) a stream from the IOBED connection
#'
#' @note If the first row is uncompleted it is ignored and a warning
#' is signaled (this should not happen!), on the other hand, if the
#' last row is not completed (almost always!) it is silently ignored.
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' sample_stream <- c(
#'   "2", "7", "8", " ", " ", " ", " ", "2", "2", "5", " ", " ", " ",
#'   "2", "2", "7", " ", " ", " ", " ", "2", "6", "8", " ", " ", " ",
#'   " ", "6", "5", "5", "3", "0", " ", " ", " ", " ", " ", "1", "2",
#'   ":", "4", "4", ":", "1", "4", "/", "2", "0", "0", "\n", "\r", "",
#'   "2", "7", "8", " ", " ", " ", " ", "2", "2", "5", " ", " ", " ",
#'   "2", "2", "6", " ", " ", " ", " ", "2", "6", "8", " ", " ", " ",
#'   " ", "6", "5", "5", "3", "0", " ", " ", " ", " ", " ", "1", "2",
#'   ":", "4", "4", ":", "1", "4", "/", "2", "0", "1", "\n", "\r", "",
#'   "2", "7", "8", " ", " ", " ", " ", "2", "2", "5", " ", " ", " "
#'   )
#'
#' tidy_iobed_stream(sample_stream)
#'
#' uscita_stream <- c(
#'   "2", "7", "9", " ", " ", " ", " ", "2", "2", "5", " ", " ", " ",
#'   "2", "2", "5", " ", " ", " ", " ", "2", "7", "0", " ", " ", " ",
#'   " ", "6", "5", "5", "3", "0", " ", " ", " ", " ", " ", "1", "2",
#'   ":", "5", "0", ":", "2", "t", "i", "p", "o", " ", "u", "s", "c",
#'   "i", "t", "a", "1", "/", "2", "0", "1", "\n", "\r", "", "2", "7",
#'   "9", " ", " ", " ", " ", "2", "2", "4", " ", " ", " ", "2", "2",
#'   "5", " ", " ", " ", " ", "2", "7", "0", " ", " ", " ", " ", "6",
#'   "5", "5", "3", "0", " ", " ", " ", " ", " ", "1", "2", ":", "5"
#' )
#' tidy_iobed_stream(uscita_stream)

tidy_iobed_stream <- function(stream) {
  col_names <- c("sbl", "sbr", "sul", "sur", "weight", "clock", "alarm", "elapsed")

  string <- stream |>
    stringr::str_c(collapse = "") |>
    stringr::str_replace_all("tipo uscita", " ") |>
    stringr::str_replace_all("(:\\d+) */", "\\1 0 ") |>
    stringr::str_replace_all("/", " ") |>
    stringr::str_replace_all("(\\n\\r)[^(\\n\\r)]+$", "\\1")

  is_bad_first <- string |>
    stringr::str_detect("^(\\d+ +){5}", negate = TRUE)

  if (is_bad_first) {
    usethis::ui_warn("
    First row of {usethis::ui_field('stream')} is not complete.
    It is removed now from the table.
    ")
    string <- string |>
      stringr::str_remove("^[^(\\n\\r)]*\\n*\\r")
  }

  res <- if (length(string) == 1 && string == "") {
    tibble::tibble(
      sbl = integer(),
      sbr = integer(),
      sul = integer(),
      sur = integer(),
      weight = integer(),
      clock = character(),
      alarm = integer(),
      elapsed = integer()
    )
  } else {
    string |>
      readr::read_table(col_names = col_names, col_types = "iiiiicii") |>
      dplyr::mutate(elapsed = 500L - .data[["elapsed"]])
  }

  res |>
    dplyr::mutate(clock = lubridate::hms(.data[["clock"]]))
}
