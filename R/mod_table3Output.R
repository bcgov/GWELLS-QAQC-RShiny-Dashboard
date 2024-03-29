#' table3Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table3Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table"))
  )
}


#' table3OutputData Server Functions
#'
#' @noRd 
mod_table3OutputData_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_table3Output_server")

      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        filter(table3_flag >0 ) %>% 
        arrange(desc(table3_flag), desc(well_tag_number)) %>%
        select(well_tag_number,table3_flag,  my_well_type, 
               table3_missing_lat_long_flag,table3_missing_finished_well_depth_flag,
               company_of_person_responsible, worktype, date_added) %>%
        mutate(
          across(.cols = c("table3_missing_lat_long_flag", 
                           "table3_missing_finished_well_depth_flag"
          ),
          .fns = ~logical_to_ok_issue(!as.logical(.x))
          )
        ) 
  })
}

#' table3Output Server Functions
#'
#' @noRd 
mod_table3Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_table3Output_server")
    output$table <- DT::renderDataTable({
      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      df %>% 
        filter(table3_flag >0 ) %>% 
        arrange(desc(table3_flag), desc(well_tag_number)) %>%
        select(fct_nr_region_name, well_tag_number, table3_flag,  my_well_type, 
               table3_missing_lat_long_flag,table3_missing_finished_well_depth_flag,
               company_of_person_responsible, worktype, date_added) %>%
        mutate(
          across(.cols = c("table3_missing_lat_long_flag", 
                           "table3_missing_finished_well_depth_flag"
                           ),
                 .fns = ~logical_to_ok_issue(!as.logical(.x))
          )
        ) %>% 
        DT::datatable(.,
                      colnames = c("Natural Resource Region",
                                   "Well Tag Number",
                                   "Problem Count",
                                   "Well Type",
                                   "Lat Long",
                                   "Finished Well Depth",
                                   "Company of Person Responsible",
                                   "Work Type",
                                   "Date Added"
                      ),
                      caption = paste0("Table 3 - Pre-WSA Wells Missing Info for Date Added Between ",
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
# mod_table3Output_ui("table3Output_ui_1")

## To be copied in the server
# mod_table3Output_server("table3Output_ui_1")
