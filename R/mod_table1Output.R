#' table1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table"))
  )
}




#' table1OutputData Server Functions
#'
#' @noRd 
mod_table1OutputData_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    
    message("run  mod_table1OutputData_server")
    ns <- session$ns
    
    
      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        dplyr::filter(table1_flag >0 ) %>%
        dplyr::arrange(dplyr::desc(table1_flag), dplyr::desc(well_tag_number)) %>%
        dplyr::select(
          well_tag_number,table1_flag,  my_well_type, table1_missing_lat_long_flag, 
          table1_table1_missing__wdip_flag, table1_missing_finished_well_depth_flag, 
          table1_missing_person_responsible_flag, company_of_person_responsible, worktype, date_added) %>%
        mutate(
          across(.cols = c("table1_missing_lat_long_flag", 
                           "table1_table1_missing__wdip_flag", 
                           "table1_missing_finished_well_depth_flag", 
                           "table1_missing_person_responsible_flag"),
                 .fns = ~logical_to_ok_issue(!as.logical(.x))
          )
        )

  })
}



#' table1Output Server Functions
#'
#' @noRd 
mod_table1Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    
    message("run  mod_table1Output_server")
    ns <- session$ns
    
    output$table <- DT::renderDataTable({
      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        dplyr::filter(table1_flag >0 ) %>%
        dplyr::arrange(dplyr::desc(table1_flag), dplyr::desc(well_tag_number)) %>%
        dplyr::select(
          fct_nr_region_name, well_tag_number, table1_flag,  my_well_type, table1_missing_lat_long_flag, 
          table1_table1_missing__wdip_flag, table1_missing_finished_well_depth_flag, 
          table1_missing_person_responsible_flag, company_of_person_responsible, worktype, date_added) %>%
        mutate(
          across(.cols = c("table1_missing_lat_long_flag", 
                           "table1_table1_missing__wdip_flag", 
                           "table1_missing_finished_well_depth_flag", 
                           "table1_missing_person_responsible_flag"),
                 .fns = ~logical_to_ok_issue(!as.logical(.x))
          )
        ) %>% 
        DT::datatable(
          colnames = c("Natural Resource Region",
                        "Well Tag Number",
                       "Problem Count",
                       "Well Type",
                       "Lat Long",
                       "WIDP",
                       "Well Depth",
                       "Person Responsible",
                       "Company of Person Responsible",
                       "Work Type",
                       "Date Added"
          ),
          caption = paste0("Table 1 - Post-WSA Missing Info for Date Added Between ",
                           date_added_min, " and ", date_added_max,
                           " and Well Tag Number Between ", wtn_min, " and ", wtn_max),
          rownames = FALSE,
          escape = FALSE,
          filter = "top",
          options= list(pageLength = 25, autoWidth = TRUE, scrollY = "600px")
        )
    })
  })
}

## To be copied in the UI
# mod_table1Output_ui("table1Output_ui_1")

## To be copied in the server
# mod_table1Output_server("table1Output_ui_1")