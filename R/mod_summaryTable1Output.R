#' summaryTable1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_summaryTable1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(outputId = ns("table"))
  )
}
    
#' summaryTable1Output Server Functions
#'
#' @noRd 
mod_summaryTable1Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_summaryTable1Output_server")
    output$table <- gt::render_gt({
      data <- d()
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        group_by(fct_nr_region_name,  .drop = FALSE)  %>%
        summarise(Total = n(),
                  after_feb2016 = sum(!old_or_unknown_date),
                  in_table1 = sum(table1_flag>0),
                  before_feb2016_or_unknown_date = sum(old_or_unknown_date),
                  in_table3 = sum(table3_flag>0),
                  in_table2 = sum(table2_flag),
                  cross_referenced = sum(cross_referenced == TRUE),
                  artesian = sum(artesian_conditions == "True")
                  
                  
                  
        )  %>% 
        gt(rowname_col = "fct_nr_region_name") %>%
        tab_header(
          title = "Wells Highlight by Region",
          subtitle = paste0("For Date  Added Between ",
                            date_added_min, " and ", date_added_max,
                            " and Well Tag Number Between ", wtn_min, " and ", wtn_max)
        ) %>%
        fmt_number(columns = everything(), decimals = 0) %>% 
        summary_rows(
          # columns = is.numeric(),
          fns = list(Total = "sum"),
          decimals = 0
        ) %>% 
        cols_label(
          before_feb2016_or_unknown_date = "Pre-WSA or Unknown Date",
          after_feb2016 = "Post-WSA",
          cross_referenced = "Cross-Referenced",
          in_table1 = "Missing Info",
          in_table2 = "Mislocated",
          in_table3 = "Missing Info",
          artesian = "Artesian"
        ) %>% 
        tab_spanner(
          label= "Post-WSA",
          columns = c("after_feb2016", "in_table1")
        ) %>% 
        tab_spanner(
          label= "Pre-WSA or Unknown Date",
          columns = c("before_feb2016_or_unknown_date", "in_table3")
        ) 
    })
  })
}
    
## To be copied in the UI
# mod_summaryTable1Output_ui("summaryTable1Output_ui_1")
    
## To be copied in the server
# mod_summaryTable1Output_server("summaryTable1Output_ui_1")
