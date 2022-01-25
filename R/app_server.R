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
    library(forcats)
    library(leafpop)
    library(RColorBrewer)
    library(gwellsshiny)
  })
  # get the data from CSV (or SQL if this ever get implemented)
  waiter_show(html = spin_fading_circles()) 
  
  data_source <- "csv"
  
  if(data_source == "sql"){ #are we getting the data from SQL?
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
    full_data <- download_data_sql(con1)
  }
  
  if(data_source == "csv"){
    full_data <- download_data_csv()
  }
  
  prepared_gwells <- prepare_all_data(full_data)
  
  #ok we are ready to roll!  
  message("unhiding waiter")
  waiter_hide() # hide the waiter
  
  
  # the gwells data is filtered according to whatever filters the user select 
  data <- mod_filterDataInput_server("filterDataInput_ui_1",prepared_gwells)
  
  # Table 1 is generated from the filtered data
  table1Data <- reactive({mod_table1OutputData_server("table1Output_ui_1", d = data)})
  table2Data <- reactive({mod_table2OutputData_server("table2Output_ui_1", d = data)})
  table3Data <- reactive({mod_table3OutputData_server("table3Output_ui_1", d = data)})
  
  mod_table1Output_server("table1Output_ui_1", d = data)
  mod_table2Output_server("table2Output_ui_1", d = data)
  mod_table3Output_server("table3Output_ui_1", d = data)
  mod_figure1Output_server("figure1Output_ui_1", d = data)
  mod_map1Output_server("map1Output_ui_1", d = data)
  mod_summaryTableRegionOutput_server("summaryTableRegionOutput_ui_1", d = data)
  mod_summaryTable1Output_server("summaryTable1Output_ui_1", d = data)
  
  
  mod_downloadFileOutput_server("downloadFileOutput_ui_1", table1= table1Data, table2 = table2Data, table3 = table3Data)
  
  # # https://community.rstudio.com/t/download-data-button-to-appear-only-when-data-is-fetched/1426/4
  # # https://shiny.rstudio.com/reference/shiny/1.6.0/renderUI.html
  # # https://shiny.rstudio.com/articles/req.html
  # output$downloadData <-  renderUI({
  #   req(input$generate)
  #   downloadButton("downloadData01")
  # })
  # 
  # output$downloadData01 <- downloadHandler(
  #   filename = function() {
  #     "tables.zip"
  #   },
  #   content = function(file) {
  #     
  #     #go to a temp dir to avoid permission issues
  #     owd <- setwd(tempdir())
  #     on.exit(setwd(owd))
  #     
  #     write.csv(table1Data(), "table1.csv", row.names = FALSE)
  #     write.csv(table2Data(), "table2.csv", row.names = FALSE)
  #     write.csv(table3Data(), "table3.csv", row.names = FALSE)
  #     #create the zip file
  #     zip(file,c("table1.csv", "table2.csv", "table3.csv"))
  #     
  
  #}
  # )
  
  
  # code simple pour bouton qui s'affiche tout seul.. pas de module
  
  output$downloadData <- renderUI({
    req(table1Data())
    downloadButton("downloadData01")
  })
  
  
  output$downloadData01 <- downloadHandler(
    filename = function() {
      "tables.zip"
    },
    content = function(file) {
      
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      
      write.csv(table1Data(), "table1.csv", row.names = FALSE)
      write.csv(table2Data(), "table2.csv", row.names = FALSE)
      write.csv(table3Data(), "table3.csv", row.names = FALSE)
      #create the zip file
      zip(file,c("table1.csv", "table2.csv", "table3.csv"))
      
    }
  )
  
}
