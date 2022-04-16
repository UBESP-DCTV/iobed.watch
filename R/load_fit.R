#' Load FIT file
#'
#' It copies a FIT file (`.fit`) from a location (e.g., the watch
#' folder) to another location (e.g., person data folder).
#'
#' @param fit_source_path (chr) file path for the input FIT file.
#' @param output_dir (chr) path of the directory into which copy the
#'   `fit_source_path`.
#'
#' @return (chr) output file path
#' @export
load_fit <- function(fit_source_path, output_dir) {
  checkmate::assert_file_exists(fit_source_path)

  if (!stringr::str_detect(fit_source_path, "\\.fit$")) {
    usethis::ui_stop("
    {usethis::ui_field('fit_source_path')} is
    {usethis::ui_value(fit_source_path)} which is not a '.fit' file.

    You must provide a '.fit' file.
    ")
  }

  file_name <- basename(fit_source_path)
  output_path <- file.path(output_dir, file_name)

  normalizePath(fs::file_copy(fit_source_path, output_path))
}
