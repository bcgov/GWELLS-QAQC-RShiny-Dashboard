#' summaryTable3Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_summaryTable3Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(outputId = ns("table"))
  )
}
    
#' summaryTable3Output Server Functions
#'
#' @noRd 
mod_summaryTable3Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_summaryTable3Output_server")
    output$table <- gt::render_gt({
      data <- d()
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        group_by(nr_region_name)  %>%
        summarise(Total = n(),
                  before_feb2016_or_unknown_date = sum(old_or_unknown_date),
                  after_feb2016 = sum(!old_or_unknown_date),
                  cross_referenced = sum(cross_referenced == TRUE),
                  artesian = sum(artesian_conditions == "True"),
                  in_table1 = sum(table1_flag>0),
                  in_table2 = sum(table2_flag),
                  in_table3 = sum(table3_flag>0)
        )  %>% 
        gt(rowname_col = "nr_region_name") %>%
        tab_header(
          title = "Summary Table 3 - Count of 'interesting' wells by region",
          subtitle = paste0("for date_added between ",
                            date_added_min, " and ", date_added_max,
                            " and well tag number between ", wtn_min, " and ", wtn_max)
        ) %>%
        fmt_number(columns = everything(), decimals = 0) %>% 
        summary_rows(
          # columns = is.numeric(),
          fns = list(Total = "sum"),
          decimals = 0
        ) %>% 
        cols_label(
          before_feb2016_or_unknown_date = "Before Feb 2016 or unknown date",
          after_feb2016 = "After Feb 2016",
          cross_referenced = "cross referenced",
          in_table1 = "in Table 1",
          in_table2 = "in Table 2",
          in_table3 = "in Table 3",
        )
    })
  })
}
    
## To be copied in the UI
# mod_summaryTable3Output_ui("summaryTable3Output_ui_1")
    
## To be copied in the server
# mod_summaryTable3Output_server("summaryTable3Output_ui_1")
