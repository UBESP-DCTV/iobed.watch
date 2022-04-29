test_that("parse_fit_data works", {
  # setup
  sample_data <- data_test_path("8356614998_ACTIVITY.fit")
  output_dir <- withr::local_tempdir()

  fit_data_csv_path <- sample_data |>
    load_fit(output_dir) |>
    fit2datacsv()

  # evaluate
  res <- parse_fit_data(fit_data_csv_path)

  # test
  expect_tibble(
    res,
    ncols = 8,
    nrows = 14 * 25 # 14 rows * 25 hd subtime
  )
  expect_names(
    names(res),
    identical.to = c(
      "timestamp", "ms", "hr", "temp_c", "heading_rad",
      paste0("acc_", c("x", "y", "z"), "_hd")
    )
  )
  expect_equal(
    res[["timestamp"]][[1]],
    lubridate::ymd_hms("2022-02-25 14:12:25 UTC") +
      lubridate::milliseconds(40)
  )
})
