test_that("bed_connection works", {
  withr::with_connection(
    # setup
    list(con = suppressMessages(bed_connection("COM3"))),

    # tests
    expect_class(con, "serialConnection")
  )
})
