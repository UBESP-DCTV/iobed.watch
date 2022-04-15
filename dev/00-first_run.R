prj_name <- basename(here::here())

here::here() |>
  list.files(
    pattern = "\\.([rR]|([rR]?md))$",
    recursive = TRUE,
    all.files = TRUE
  ) |>
  c("DESCRIPTION") |>
  purrr::walk(~{
    readLines(.x) |>
      stringr::str_replace_all("iobed\\.bed", prj_name) |>
      writeLines(.x)
  })

usethis::use_package_doc(open = FALSE)

renv::upgrade()
renv::update()
renv::status()
renv::snapshot()
