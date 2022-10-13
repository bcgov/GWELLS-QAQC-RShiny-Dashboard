#' summaryTable1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_drillersTableOutput_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table"))
  )
}

#' drillerOutputData Server Functions
#'
#' @noRd 
mod_drillersTableOutputData_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    message("run  mod_drillersTableOutput_server")
    ns <- session$ns
    
    
    data <- d()
    df <- data$df
    df$construction_start_date <- as.Date(df$construction_start_date)
    df <- df %>% filter((construction_start_date >= '2016-03-01') & (construction_start_date <= Sys.Date()))
    df$year <- as.character(format(df$construction_start_date, "%Y"))
    df$company_of_person_responsible <- gsub(" Ltd.", "", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub(" Inc.", "", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub(" Corp.", "", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub("J. R.", "J.R.", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub("Red Williams", "Red William's", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub("Srvcs", "Services", df$company_of_person_responsible)
    df$company_of_person_responsible <- gsub("Geotility", "GeoTility", df$company_of_person_responsible)
    df$company_of_person_responsible[df$company_of_person_responsible == "Anderson Water Serv"] <- "Anderson Water Services"
    df$company_of_person_responsible[df$company_of_person_responsible == "Clear Blue Water Sys"] <- "Clear Blue Water Systems"
    
    df$company_of_person_responsible <- gsub("Foundex Explorations", "Foundex Exploration", df$company_of_person_responsible)
    df$fct_nr_region_name <- gsub(" Natural Resource Region", "", df$fct_nr_region_name)
    df$year <- as.character(df$year)
    df$year <- gsub("2016", "2016 (March 1 onwards)", df$year)
    year.list = sort(unique(df$year))
    df <- df %>% count(fct_nr_region_name, year, company_of_person_responsible, person_responsible)
    df <- df[order(df$fct_nr_region_name, df$company_of_person_responsible, df$person_responsible),]
    df <- pivot_wider(df, names_from = year, values_from = n)
    df <- df[append(c('fct_nr_region_name', 'company_of_person_responsible', 'person_responsible'), year.list)]
  })
}



#' drillerOutput Server Functions
#'
#' @noRd 
mod_drillersTableOutput_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    message("run  mod_drillersTableOutput_server")
    ns <- session$ns
    
    output$table <- DT::renderDataTable({
      data <- d()
      
      df <- data$df
      df$construction_start_date <- as.Date(df$construction_start_date)
      df <- df %>% filter((construction_start_date >= '2016-03-01') & (construction_start_date <= Sys.Date()))
      df$year <- as.numeric(format(df$construction_start_date, "%Y"))
      df$company_of_person_responsible <- gsub(" Ltd.", "", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub(" Inc.", "", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub(" Corp.", "", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub("J. R.", "J.R.", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub("Red Williams", "Red William's", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub("Srvcs", "Services", df$company_of_person_responsible)
      df$company_of_person_responsible <- gsub("Geotility", "GeoTility", df$company_of_person_responsible)
      df$company_of_person_responsible[df$company_of_person_responsible == "Anderson Water Serv"] <- "Anderson Water Services"
      df$company_of_person_responsible[df$company_of_person_responsible == "Clear Blue Water Sys"] <- "Clear Blue Water Systems"
      df$company_of_person_responsible <- gsub("Foundex Explorations", "Foundex Exploration", df$company_of_person_responsible)
      df$year <- as.character(df$year)
      df$year <- gsub("2016", "2016 (March 1 onwards)", df$year)
      year.list = sort(unique(df$year))
      df <- df %>% count(fct_nr_region_name, year, company_of_person_responsible, person_responsible)
      df <- df[order(df$fct_nr_region_name, df$company_of_person_responsible, df$person_responsible),]
      df <- pivot_wider(df, names_from = year, values_from = n)
      df <- df[append(c('fct_nr_region_name', 'company_of_person_responsible', 'person_responsible'), year.list)]
      df %>% DT::datatable(colnames = append(c("Natural Resource Region",
                                      "Company",
                                      "Person Responsible"),
                                      year.list
                         ),
                      caption = "Wells Drilled by Company/Person from 2016-03-01 to Present",
                      rownames = FALSE,
                      escape = FALSE,
                      filter = "top",
                      options= list(pageLength = 25, autoWidth = TRUE, scrollY = "600px")
        )
    })
  })
}
