' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  Sys.setenv(TZ="America/Vancouver")
  suppressPackageStartupMessages({
    library(shiny)
    library(DBI)
    library(RPostgres)
    library(dplyr)
    library(stringr)
    library(waiter)
    library(ggplot2)
    library(leaflet)
    library(mapview)
    library(sf)
    library(bcmaps)
    library(tidyr)
    library(gt)
  })
  # get the data from CSV (or SQL if this ever get implemented)
  waiter_show(html = spin_fading_circles())  
  BCGOV_DB <- Sys.getenv("BCGOV_DB")
  BCGOV_HOST <- Sys.getenv("BCGOV_HOST")
  BCGOV_USR <- Sys.getenv("BCGOV_USR")
  BCGOV_PWD <- Sys.getenv("BCGOV_PWD")
  if (is.null(BCGOV_DB) || is.null(BCGOV_HOST)|| is.null(BCGOV_USR) || is.null(BCGOV_PWD)) stop("go away -- set up sql access as environment variables BCGOV_DB, BCGOV_HOST, BCGOV_USR, BCGOV_PWD")
  
  con1 <- DBI::dbConnect(
    #RPostgreSQL::PostgreSQL(),
    RPostgres::Postgres(),
    dbname = Sys.getenv("BCGOV_DB"),
    host = Sys.getenv("BCGOV_HOST"),
    user = Sys.getenv("BCGOV_USR"),
    password=Sys.getenv("BCGOV_PWD")
  )
  
  # get data from the 3 tables, left join it, create some flags etc..
  prepared_gwells <- prepare_all_data(con1)
  
  #ok we are ready to roll!  
  message("unhiding waiter")
  waiter_hide() # hide the waiter
  
  
  # the gwells data is filtered according to whatever filters the user select 
  data <- mod_filterDataInput_server("filterDataInput_ui_1",prepared_gwells)
  
  # Table 1 is generated from the filtered data
  mod_table1Output_server("table1Output_ui_1", d = data)
  mod_table2Output_server("table2Output_ui_1", d = data)
  mod_table3Output_server("table3Output_ui_1", d = data)
  mod_figure1Output_server("figure1Output_ui_1", d = data)
  mod_map1Output_server("map1Output_ui_1", d = data)
  mod_summaryTable1Output_server("summaryTable1Output_ui_1", d = data)
  mod_summaryTable2Output_server("summaryTable2Output_ui_1", d = data)
  mod_summaryTable3Output_server("summaryTable3Output_ui_1", d = data)
}
