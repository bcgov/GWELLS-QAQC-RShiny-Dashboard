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


#' table2OutputData Server Functions
#'
#' @noRd 
mod_table2OutputData_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    message("run  mod_table2Output_server")
    ns <- session$ns
    

      data <- d()
      
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      
      df %>% 
        filter(table2_flag) %>%
        arrange(desc(score_address), desc(well_tag_number)) %>%
        select(well_tag_number, distance_geocode, distance_to_matching_pid, score_address, score_city, worktype, company_of_person_responsible, date_added) 
  })
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
        select(fct_nr_region_name, well_tag_number, distance_geocode, distance_to_matching_pid, score_address, score_city, worktype, company_of_person_responsible, date_added) %>% 
        mutate(distance_to_matching_pid= round(distance_to_matching_pid,1)) %>% 
        DT::datatable(.,
                      colnames = c("Natural Resource Region",
                                  "Well Tag Number",
                                   "Geocode Distance",
                                   "Distance to Matching PID",
                                   "Score Address",
                                   "Score City",
                                   "Work Type",
                                   "Company of Person Responsible",
                                   "Date Added"
                      ),
                      caption = paste0("Table 2 - Mislocated Wells for Date Added Between ",
                                       date_added_min, " and ", date_added_max,
                                       " and Well Tag Number Between ", wtn_min, " and ", wtn_max),
                      rownames = FALSE,
                      escape = FALSE,
                      filter = "top",
                      options= list(pageLength = 25, autoWidth = TRUE, scrollY = "600px")
        ) %>% 
        DT::formatStyle('distance_geocode', fontWeight = DT::styleInterval(400, c('normal', 'bold'))) %>%
        DT::formatStyle('distance_to_matching_pid', fontWeight = DT::styleInterval(25, c('normal', 'bold'))) %>%
        DT::formatStyle('score_address', fontWeight = DT::styleInterval(80, c('bold', 'normal')))
    })
  })
}

## To be copied in the UI
# mod_table2Output_ui("table2Output_ui_1")

## To be copied in the server
# mod_table2Output_server("table2Output_ui_1")


