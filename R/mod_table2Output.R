#' table2Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_table2Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table"))
  )
}

#' table2Output Server Functions
#'
#' @noRd 
mod_table2Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    message("run  mod_table2Output_server")
    ns <- session$ns
    
    output$table <- DT::renderDataTable({
      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      
      df %>% 
        filter(table2_flag) %>%
        arrange(desc(score_address), desc(well_tag_number)) %>%
        select(well_tag_number, distance_to_matching_pid, score_address, score_location_description, score_city, worktype, company_of_person_responsible, date_added) %>% 
        DT::datatable(.,
                      colnames = c("well tag number",
                                   "distance to matching pid",
                                   "score address",
                                   "score location description",
                                   "score city",
                                   "work type",
                                   "company of person responsible",
                                   "date added"
                      ),
                      caption = paste0("Table 2 for date_added between ",
                                       date_added_min, " and ", date_added_max,
                                       " and well tag number between ", wtn_min, " and ", wtn_max),
                      rownames = FALSE,
                      escape = FALSE
        )
    })
  })
}

## To be copied in the UI
# mod_table2Output_ui("table2Output_ui_1")

## To be copied in the server
# mod_table2Output_server("table2Output_ui_1")


