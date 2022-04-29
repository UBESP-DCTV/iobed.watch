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


test_that("load_fit works if file is already present", {
  # setup
  sample_data <- data_test_path("8356614998_ACTIVITY.fit")
  output_dir <- withr::local_tempdir()

  output_path <- load_fit(sample_data, output_dir)
  first_time <- fs::file_info(output_path)[["access_time"]]

  # eval
  suppressMessages(
    output_path_default <- load_fit(sample_data, output_dir)
  )
  default_time <- fs::file_info(output_path_default)[["access_time"]]

  suppressMessages(
    output_path_skip <- sample_data |>
      load_fit(output_dir, overwrite = FALSE)
  )
  skip_time <- fs::file_info(output_path_skip)[["access_time"]]

  Sys.sleep(2)
  output_path_overwrite <- sample_data |>
    load_fit(output_dir, overwrite = TRUE)
  overwrite_time <- fs::file_info(output_path_overwrite)[["access_time"]]



  # test
  expect_message({
    suppressMessages(load_fit(sample_data, output_dir))
    load_fit(sample_data, output_dir) # default skip / not overwrite
  },
    "File already exists"
  )
  expect_equal(first_time, default_time)
  expect_equal(first_time, skip_time)

  cat(glue::glue("
    firs_time: {first_time};
    overwritten_time: {overwrite_time}
  "))
  expect_true(first_time < overwrite_time)

})
