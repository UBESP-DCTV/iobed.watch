#' Create a connection to IOBED's beds
#'
#' Setup a connection to the bed serial output with all the
#' specifications needed for the type of its output stream.
#'
#' @param port (chr) the serial port used for the connection.
#' @param buffersize (int, default 2^21, i.e. ~2 MB) number of bytes
#'   to dedicate to the buffer.
#'
#' @note The number of bytes used is set to approx 2 MB because the bed
#'   stream a line of information of less than 100 characters (about
#'   50-60), collecting sensors signals at 5Hz. So, at 1 Byte each
#'   character, it sum up to 0.5 kB/s. 2 MB of buffer should be
#'   sufficient to collect 4000 seconds of data (~ 1 hour), that should
#'   be both a sufficient and reasonable amount of time for a single
#'   session of data collection.
#'
#'
#' @return a connection
#' @export
#'
#' @examples
#' \dontrun{
#'   # connect the serial cable to the computer and
#'   con <- bed_connection() # default port is "COM3"
#'
#'   port_used <- "COM1"
#'   bed_connection(port = port_used)
#' }
bed_connection <- function(port, buffersize = 2^21) {
  con <- serial::serialConnection(
    name = "IOBED connection",
    port = port,
    mode = "38400,n,8,1",
    buffering = "line",
    translation = "binary",
    buffersize = buffersize
  )

  usethis::ui_done(
    "Connection with port {usethis::ui_value(port)} established."
  )
  usethis::ui_todo(
    "Remind to {usethis::ui_code('open(<connection name>)')} it!"
  )

  invisible(con)
}
