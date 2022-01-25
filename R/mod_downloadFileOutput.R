#' downloadFileOutput UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_downloadFileOutput_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("downloadData"))
    
    
    
  )
}

#' downloadFileOutput Server Functions
#'
#' @noRd 
mod_downloadFileOutput_server <- function(id,table1, table2, table3){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # output$downloadData01 <- downloadHandler(
    #   filename = function() {
    #     "tables.zip"
    #   },
    #   content = function(file) {
    #     #go to a temp dir to avoid permission issues
    #     owd <- setwd(tempdir())
    #     on.exit(setwd(owd))
    #     write.csv(table1(), "table1.csv", row.names = FALSE)
    #     write.csv(table2(), "table2.csv", row.names = FALSE)
    #     write.csv(table3(), "table3.csv", row.names = FALSE)
    #     #create the zip file
    #     zip(file,c("table1.csv", "table2.csv", "table3.csv"))
    #   }
    # )
    
    renderUI({
      #req(d())
      downloadButton(ns("downloadData01"))
    })
    

  })
}

## To be copied in the UI
# mod_downloadFileOutput_ui("downloadFileOutput_ui_1")

## To be copied in the server
# mod_downloadFileOutput_server("downloadFileOutput_ui_1")
