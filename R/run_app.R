#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts. 
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options 
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}


# run_app où on roule le rmarkdown..
# https://stackoverflow.com/questions/58265749/how-can-i-make-a-dockerized-shiny-app-in-a-flexdashboard-wrapper-with-golem
# run_app <- function(...) {
#   rmarkdown::run(
#     system.file("md.Rmd", package = "gwellsshiny")
#   )
# }
