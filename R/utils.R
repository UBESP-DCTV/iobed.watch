data_test_path <- function(x) {
  ifelse(
    dir.exists("../testthat"),
    file.path("../data-test", x),
    here::here("tests/data-test/", x)
  ) |>
  normalizePath(mustWork = FALSE) |>
  path.expand()
}
