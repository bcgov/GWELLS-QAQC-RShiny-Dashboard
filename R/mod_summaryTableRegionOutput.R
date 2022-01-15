#' summaryTableRegionOutput UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_summaryTableRegionOutput_ui <- function(id){
  ns <- NS(id)
  tagList(
    gt::gt_output(outputId = ns("table"))
  )
}

#' summaryTableRegionOutput Server Functions
#'
#' @noRd 
mod_summaryTableRegionOutput_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_summaryTableRegionOutput_server")
    output$table <- gt::render_gt({
      data <- d()
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      # was summaryTable1
      
      region_intended_use_counts <-
        df %>% 
        group_by(fct_nr_region_name,  .drop = FALSE ) %>% # drop=false to show all levels including those that dont appear in the data
        count(my_intended_water_use) %>%
        spread(key=my_intended_water_use, value = n, fill = 0)
      
      summaryTable1 <- df %>% 
        group_by(fct_nr_region_name,  .drop = FALSE) %>%
        summarise(
          Total = n()
        ) %>% 
        left_join(region_intended_use_counts)
      
      
      ## was summmarytable2
      summaryTable2 <- df %>% 
        group_by(fct_nr_region_name, .drop= FALSE) %>%
        count(fct_well_class_code,  .drop = FALSE ) %>%
        spread(key=fct_well_class_code, value = n, fill = 0) %>%  
        ungroup() %>% 
        left_join (df %>% count(fct_nr_region_name, .drop = FALSE))
      
      
      summaryTable2 %>% 
        select(n, everything()) %>%
        rename(Total = n) %>% 
        left_join(summaryTable1  %>%
                    select(-Total) ) %>%
        gt(rowname_col = "fct_nr_region_name") %>%
        tab_header(
          title = "Regional Summary Table",
          subtitle = paste0("for Date Added Between ",
                            date_added_min, " and ", date_added_max,
                            " and Well Tag Number Between ", wtn_min, " and ", wtn_max)
        ) %>%
        tab_spanner(
          columns = c("WATR_SPPLY", "UNK", "MONITOR", "DEW_DRA", "CLS_LP_GEO", "GEOTECH", "REMEDIATE", "INJECTION", "RECHARGE"),
          label = "Well Class",
        ) %>%
        tab_spanner(
          label = "Intended Well Use",
          columns = c("DOM", "UNK_USE","DWS","COM","IRR","OTHER","TST","OBS","OP_LP_GEO", "Non-Water Supply")
        ) %>%          
        fmt_number(columns = everything(), decimals = 0) %>% 
        summary_rows(
          # columns = is.numeric(),
          fns = list(Total = "sum"),
          decimals = 0
        ) %>% 
         tab_style(
           style = cell_text(weight = "bold"),
           locations = list(cells_grand_summary(),
                            cells_body(columns = "Total"))
         )
    })
  })
}

## To be copied in the UI
# mod_summaryTableRegionOutput_ui("summaryTableRegionOutput_ui_1")

## To be copied in the server
# mod_summaryTableRegionOutput_server("summaryTableRegionOutput_ui_1")
