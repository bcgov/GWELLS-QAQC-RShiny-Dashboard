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

mod_downloadFileOutput_ui_2 <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("download_button_2"))
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

mod_downloadFileOutput_xlsx_server <- function(id,table1, table2, table3){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_content <- downloadHandler( 
      filename = function() {
        "gwds_tables.zip"
      },
      content = function(file) {
        #go to a temp dir to avoid permission issues
        owd <- setwd(tempdir())
        on.exit(setwd(owd))
        
        dd.list <- as.data.frame(c("Unresolved", "Fixed/No Issue", "CR Followed up", "UT Followed up", "With Regional Staff", "Other"))

        t1_xlsx <- createWorkbook()
        addWorksheet(t1_xlsx, "data")
        addWorksheet(t1_xlsx, "drop-down values")
        writeData(t1_xlsx, sheet = "data", x = table1())
        writeData(t1_xlsx, sheet = "drop-down values", x = dd.list)
        dataValidation(t1_xlsx, "data", col = ncol(table1()) + 1, rows = 1:nrow(table1()), type = "list", 
                       value = "'drop-down values'!$A$2:$A$7", allowBlank = TRUE, showInputMsg = FALSE, showErrorMsg = FALSE)
        saveWorkbook(t1_xlsx, "table1_post_wsa_wells.xlsx", overwrite=TRUE)
        
        t2_xlsx <- createWorkbook()
        addWorksheet(t2_xlsx, "data")
        addWorksheet(t2_xlsx, "drop-down values")
        writeData(t2_xlsx, sheet = "data", x = table2())
        writeData(t2_xlsx, sheet = "drop-down values", x = dd.list)
        dataValidation(t2_xlsx, "data", col = ncol(table2()) + 1, rows = 1:nrow(table2()), type = "list", 
                       value = "'drop-down values'!$A$2:$A$7", allowBlank = TRUE, showInputMsg = FALSE, showErrorMsg = FALSE)
        saveWorkbook(t2_xlsx, "table2_mislocated_wells.xlsx", overwrite=TRUE)
        
        t3_xlsx <- createWorkbook()
        addWorksheet(t3_xlsx, "data")
        addWorksheet(t3_xlsx, "drop-down values")
        writeData(t3_xlsx, sheet = "data", x = table3())
        writeData(t3_xlsx, sheet = "drop-down values", x = dd.list)
        dataValidation(t3_xlsx, "data", col = ncol(table3()) + 1, rows = 1:nrow(table3()), type = "list", 
                       value = "'drop-down values'!$A$2:$A$7", allowBlank = TRUE, showInputMsg = FALSE, showErrorMsg = FALSE)
        saveWorkbook(t3_xlsx, "table3_pre_wsa_wells.xlsx", overwrite=TRUE)
        
        #create the zip file
        zip(file,c("table1_post_wsa_wells.xlsx", "table2_mislocated_wells.xlsx", "table3_pre_wsa_wells.xlsx"))
      }
    )
    
    output$download_button_2 <- renderUI({
      req(table1())
      downloadButton(ns("download_content"), label = "Download for GWDS")
    })
  })
}

## To be copied in the UI
# mod_downloadFileOutput_ui("downloadFileOutput_ui_1")

## To be copied in the server
# mod_downloadFileOutput_server("downloadFileOutput_ui_1")
