test_that("fit2datacsv works", {
  skip_on_ci()
  skip_on_cran()

  # setup
  output_dir <- withr::local_tempdir()
  sample_data <- data_test_path("8356614998_ACTIVITY.fit") |>
    load_fit(output_dir)

  unexists_input <- data_test_path("foo.fit")
  nonfit_input <- data_test_path("foo.txt")

  # eval
  output_datacsv <- fit2datacsv(sample_data)

  # test
  output_datacsv |>
    expect_equal(
      normalizePath(file.path(
        dirname(sample_data), "8356614998_ACTIVITY_data.csv"
      ))
    )

  expect_file_exists(output_datacsv)

  expect_error(fit2datacsv(unexists_input))
  expect_error(fit2datacsv(nonfit_input), "is not a '\\.fit' file")
})


test_that("from_fit_path_to_csv_name", {
  skip_on_ci()
  skip_on_cran()
  # setup
  sample_data <- file.path("foo", "8356614998_ACTIVITY.fit")
  expected_output <- file.path("foo", "8356614998_ACTIVITY.csv")

  # eval
  res <- from_fit_path_to_csv_name(sample_data)

  # test
  expect_equal(res, expected_output)
})
