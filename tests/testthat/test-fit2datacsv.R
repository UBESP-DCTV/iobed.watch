test_that("fit2datacsv works", {
  # setup
  sample_data <- here::here("inst/test-data/8356614998_ACTIVITY.fit") |>
    normalizePath()

  unexists_input <- here::here("inst/test-data/foo.fit")
  nonfit_input <- here::here("inst/test-data/foo.txt")

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


test_that("from_fit_path_to_csv_name",{
  # setup
  sample_data <- here::here("inst/test-data/8356614998_ACTIVITY.fit") |>
    normalizePath()
  expected_output <- here::here(
      "inst/test-data/8356614998_ACTIVITY.csv"
    ) |>
    normalizePath()

  # eval
  res <- from_fit_path_to_csv_name(sample_data)

  # test
  expect_equal(res, expected_output)
})
