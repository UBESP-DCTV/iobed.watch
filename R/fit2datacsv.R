fit2datacsv <- function(fit_path) {
  checkmate::assert_file_exists(fit_path)

  if (!stringr::str_detect(fit_path, "\\.fit$")) {
    usethis::ui_stop("
    {usethis::ui_field('fit_path')} is
    {usethis::ui_value(fit_path)} which is not a '.fit' file.

    You must provide a '.fit' file.
    ")
  }

  output_path <- from_fit_path_to_csv_name(fit_path)
  fit_jar_path <- "C:\\FitSDK\\java\\FitCSVTool.jar"


  cmd <- "java"
  args <- glue::glue(
    "-jar {fit_jar_path} -b {fit_path} {output_path} --data record"
  )

  tryCatch(
    system2(cmd, args, stdout = TRUE, stderr = TRUE),
    warning = function(w) usethis::ui_stop("{w}"),
    error = function(e) usethis::ui_stop("{e}")
  )

  stringr::str_replace(output_path, "\\.csv$", "_data.csv")
}


from_fit_path_to_csv_name <- function(x) {
  stringr::str_replace(x, "\\.fit$", ".csv")
}
