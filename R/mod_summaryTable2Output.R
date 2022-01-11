#' summaryTable2Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_summaryTable2Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(outputId = ns("table"))
  )
}

#' summaryTable2Output Server Functions
#'
#' @noRd 
mod_summaryTable2Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_summaryTable2Output_server")
    output$table <- gt::render_gt({
      data <- d()
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        group_by(nr_region_name) %>%
        count(fct_well_class_code) %>%
        spread(key=fct_well_class_code, value = n, fill = 0) %>%  
        ungroup() %>% 
        left_join (df %>% count(nr_region_name)) %>%
        rename(Total = "n") %>% 
        gt(rowname_col = "nr_region_name") %>%
        tab_header(
          title = "Summary Table 2 - Count of well_class_code by region",
          subtitle = paste0("for date_added between ",
                            date_added_min, " and ", date_added_max,
                            " and well tag number between ", wtn_min, " and ", wtn_max)
        ) %>%
        fmt_number(columns = everything(), decimals = 0) %>% 
        summary_rows(
          # columns = is.numeric(),
          fns = list(Total = "sum"),
          decimals = 0
        )
    })
  })
}

## To be copied in the UI
# mod_summaryTable2Output_ui("summaryTable2Output_ui_1")

## To be copied in the server
# mod_summaryTable2Output_server("summaryTable2Output_ui_1")


