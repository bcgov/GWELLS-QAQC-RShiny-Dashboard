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

#' downloadFileOutput Server Functions
#'
#' @noRd 
mod_downloadFileOutput_server <- function(id,table1, table2, table3, table4){
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
        out_xlsx <- createWorkbook()
        
        for (region in unique(table4()$fct_nr_region_name)) {
          df <- table4() %>% filter(fct_nr_region_name == region)
          addWorksheet(out_xlsx, region)
          writeData(out_xlsx, sheet = region, x = df)
        }
        
        saveWorkbook(out_xlsx, "table4_drillers.xlsx", overwrite=TRUE)
        #create the zip file
        zip(file,c("table1_post_wsa_wells.csv", "table2_mislocated_wells.csv", "table3_pre_wsa_wells.csv", "table4_drillers.xlsx"))
      }
    )
    
    output$download_button <- renderUI({
      req(table1())
      downloadButton(ns("download_content"))
    })
  })
}

## To be copied in the UI
# mod_downloadFileOutput_ui("downloadFileOutput_ui_1")

## To be copied in the server
# mod_downloadFileOutput_server("downloadFileOutput_ui_1")
