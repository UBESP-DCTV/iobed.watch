# iobed.bed (development version)

- Update GH installing XQuarz (https://github.com/r-lib/actions/issues/78#issuecomment-611733294), and removing checks for oldrel (which does not have support for the native pipe `|>`).

# iobed.bed 0.1.1

- Updated tests and `tidy_iobed_stream()` with the new bed streamed-output conventions.

# iobed.bed 0.1.0

-   Added `tidy_iobed_stream()` to convert the raw streamed data collected by `pull_bed_stream()` into a tidy data frame (more in details, a tibble).
-   Added `pull_bed_stream()` to bring buffered data from an open connection to the IOBED bed.
-   Added `bed_connection()` (powered by `{serial}`) to create a serial connection to the IOBED bed. Buffer for the connection is set to \~2 MB by default, corresponding to \>1 hours of stream with current data.
-   Added support for `{withr}` for testing local environments, and `{purrr}` for functional programming (under *Suggests* packages, for the moment).

# iobed.bed 0.0.0.9000

-   Added support for `{tibble}`.
-   Setup GitHub Actions for CI/CD including test and lint checks, and `{pkgdown}` deploy.
-   Activated `{renv}` for the project.
-   Added Git/GitHub support.
-   Added TDD environment powered by `{testthat}`, `{checkmate}`, and `{CorradoLanera/autotestthat}`.
-   Added `README.Rmd` and `README.md` to provide an home page for the project.
-   Added a `NEWS.md` file to track changes to the package.
