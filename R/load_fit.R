load_fit <- function(fit_source_path, output_dir) {
  assert_file_exists(fit_source_path)

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
