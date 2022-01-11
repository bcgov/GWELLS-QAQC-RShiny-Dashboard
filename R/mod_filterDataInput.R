#' filterDataInputWTN UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filterDataInputWTN_ui <- function(id){
  ns <- NS(id)
  
  shinyWidgets::numericRangeInput(
    inputId = ns("wtn_range"), 
    label = "wtn_range",
    value = c(1, 999999)
  )
}

#' filterDataInputDate UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filterDataInputDate_ui <- function(id){
  ns <- NS(id)
  
  dateRangeInput(
    inputId = ns("date_range"), 
    label = "date_range",
    start  =  Sys.Date()-13,
    end    =  Sys.Date(),
    min    = "2021-12-13",
    max    = Sys.Date()
  )
}

#' filterDataInputGenerate UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_filterDataInputGenerate_ui <- function(id){
  ns <- NS(id)
  actionButton(
    inputId = ns("generate"), 
    label = "Generate tables and figures")
}

#' filterDataInput Server Functions
#'
#' @noRd 
mod_filterDataInput_server <- function(id,df){
  stopifnot(!is.reactive(df)) # z ne doit pas être reactif, c'est le data de gwells.
  moduleServer( id, function(input, output, session){
    message("run  mod_filterDataInput_server")
    ns <- session$ns
    eventReactive(input$generate,{
      list(
        df = df %>%
          dplyr::filter(
            date_added >= input$date_range[1] &
              date_added <= input$date_range[2] &
              well_tag_number >= input$wtn_range[1] &
              well_tag_number <= input$wtn_range[2]),
        date_added_min = input$date_range[1],
        date_added_max = input$date_range[2],
        wtn_min = input$wtn_range[1],
        wtn_max = input$wtn_range[2]
      )
    })
  })
}

## To be copied in the UI
# mod_filterDataInput_ui("filterDataInput_ui_1")#

## To be copied in the server
# mod_filterDataInput_server("filterDataInput_ui_1")