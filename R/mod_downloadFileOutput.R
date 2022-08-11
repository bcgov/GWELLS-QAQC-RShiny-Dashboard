# lots of code taken from these:
# # https://community.rstudio.com/t/download-data-button-to-appear-only-when-data-is-fetched/1426/4
# # https://shiny.rstudio.com/reference/shiny/1.6.0/renderUI.html
# # https://shiny.rstudio.com/articles/req.html


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
    uiOutput(ns("download_button"))
  )
}

mod_downloadFileOutputDrillers_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("download_button_Drillers"))
  )
}

#' downloadFileOutput Server Functions
#'
#' @noRd 
mod_downloadFileOutput_server <- function(id,table1, table2, table3){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_content <- downloadHandler( 
      filename = function() {
        "tables.zip"
      },
      content = function(file) {
        #go to a temp dir to avoid permission issues
        owd <- setwd(tempdir())
        on.exit(setwd(owd))
        write.csv(table1(), "table1_post_wsa_wells.csv", row.names = FALSE)
        write.csv(table2(), "table2_mislocated_wells.csv", row.names = FALSE)
        write.csv(table3(), "table3_pre_wsa_wells.csv", row.names = FALSE)
        #create the zip file
        zip(file,c("table1_post_wsa_wells.csv", "table2_mislocated_wells.csv", "table3_pre_wsa_wells.csv"))
      }
    )
    
    output$download_button <- renderUI({
      req(table1())
      downloadButton(ns("download_content"), label="Download QA/QC Tables")
    })
  })
}

#' @noRd 
mod_downloadFileOutputDrillers_server <- function(id, drillerstable){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_drillers_content <- downloadHandler( 
      filename = function() {
        "drillers_table.zip"
      },
      content = function(file) {
        #go to a temp dir to avoid permission issues
        owd <- setwd(tempdir())
        on.exit(setwd(owd))
        out_xlsx <- createWorkbook()
        
        for (region in unique(drillerstable()$fct_nr_region_name)) {
          df <- drillerstable() %>% filter(fct_nr_region_name == region)
          addWorksheet(out_xlsx, region)
          writeData(out_xlsx, sheet = region, x = df)
        }
        
        saveWorkbook(out_xlsx, "drillers_table.xlsx", overwrite=TRUE)
        #create the zip file
        zip(file,c("drillers_table.xlsx"))
      }
    )

    output$download_button_Drillers <- renderUI({
      req(drillerstable())
      downloadButton(ns("download_drillers_content"), label="Download Drillers Table")
    })
  })
}

## To be copied in the UI
# mod_downloadFileOutput_ui("downloadFileOutput_ui_1")

## To be copied in the server
# mod_downloadFileOutput_server("downloadFileOutput_ui_1")
