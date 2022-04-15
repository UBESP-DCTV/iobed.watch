#' Pull the stream from the IOBED connection
#'
#' @param con (serialConnection) serial connection for the IOBED bed,
#'  as obtained by [bed_connection].
#' @param close (lgl, default TRUE) would you like the connection will
#'  be automatically closed after pulling?
#'
#' @return a character vector from the data retrieved by the buffer of
#'   the connection `con`, one character each element of the vector.
#' @export
#'
#' @examples
#' \dontrun{
#'   con <- bed_connection()
#'   pull_bed_stream(con)
#'   open(con)
#'   # do some stuff
#'   close(con)
#' }
pull_bed_stream <- function(con, close = TRUE) {
  if (!isOpen(con)) {
    usethis::ui_stop("
  {usethis::ui_field('con')} must be an open connection.
    You can create it by {usethis::ui_code('con <- bed_connection()')}
    Next, open it by {usethis::ui_code('open(con)')}
    ")
  }

  withr::defer(
    if (close) close(con)
  )

  serial::read.serialConnection(con) |>
    rawToChar(multiple = TRUE)
}
