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
        select(well_tag_number,table3_flag,  my_well_type, 
               table3_missing_lat_long_flag,table3_missing_finished_well_depth_flag,
               company_of_person_responsible,date_added) %>%
        mutate(
          across(.cols = c("table3_missing_lat_long_flag", 
                           "table3_missing_finished_well_depth_flag"
                           ),
                 .fns = ~logical_to_character_icon(!as.logical(.x))
          )
        ) %>% 
        DT::datatable(.,
                      colnames = c("well tag number",
                                   "problem count",
                                   "well type",
                                   "lat long",
                                   "finished well depth",
                                   "company of person responsible",
                                   "date added"
                      ),
                      caption = paste0("Table 3 for date_added between ",
                                       date_added_min, " and ", date_added_max,
                                       " and well tag number between ", wtn_min, " and ", wtn_max),
                      rownames = FALSE,
                      escape = FALSE
        )
    })
  })
}

## To be copied in the UI
# mod_table3Output_ui("table3Output_ui_1")

## To be copied in the server
# mod_table3Output_server("table3Output_ui_1")
