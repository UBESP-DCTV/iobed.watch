test_that("load_fit works", {
  # setup
  sample_data <- data_test_path("8356614998_ACTIVITY.fit")
  m5d_input <- digest::digest(sample_data, file = TRUE)

  unexists_input <- data_test_path("foo.fit")
  nonfit_input <- data_test_path("foo.txt")


  output_dir <- withr::local_tempdir()

  # eval
  output_path <- load_fit(sample_data, output_dir)
  m5d_output <- digest::digest(output_path, file = TRUE)

  # test
  output_path |>
    expect_equal(
      normalizePath(file.path(output_dir, "8356614998_ACTIVITY.fit"))
    )

  expect_file_exists(output_path)

  expect_error(load_fit(unexists_input, output_dir))
  expect_error(
    load_fit(nonfit_input, output_dir), "is not a '\\.fit' file"
  )
  expect_identical(m5d_input, m5d_output)
})
