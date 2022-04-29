test_that("parse_fit_data works", {
  # setup
  sample_data <- data_test_path("8356614998_ACTIVITY.fit")
  output_dir <- withr::local_tempdir()
  subdir_path <- file.path(output_dir, "subdir")
  fs::dir_create(subdir_path)


  fit_data_csv_path <- sample_data |>
    load_fit(output_dir) |>
    fit2datacsv()

  rds_filename <- basename(fit_data_csv_path) |>
    stringr::str_replace_all("_data\\.csv", "_tidy.rds")

  # evaluate
  res <- parse_fit_data(fit_data_csv_path)
  saved_res <- suppressMessages(
    parse_fit_data(fit_data_csv_path, dir_path = subdir_path)
  )

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

  expect_false(rds_filename %in% list.files(output_dir))
  expect_true(
    rds_filename %in% list.files(file.path(output_dir, "subdir"))
  )

  prefixed_saved_res <- suppressMessages(
    fit_data_csv_path |>
      parse_fit_data(dir_path = subdir_path, prefix_name = "id")
  )
  expect_true(
    paste0("id-", rds_filename) %in%
      list.files(file.path(output_dir, "subdir"))
  )

})
