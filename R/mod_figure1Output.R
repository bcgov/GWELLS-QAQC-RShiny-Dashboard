#' figure1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_figure1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::plotOutput(ns("plot"))
    #DT::dataTableOutput(ns("table"))
  )
}
    
#' figure1Output Server Functions
#'
#' @noRd 
mod_figure1Output_server <- function(id,d){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    message("run  mod_figure1Output_server")
    
    # output$table <- DT::renderDataTable({
    # 
    #     DT::datatable(mtcars)
    # })
    # 
     output$plot <- renderPlot({
      data <- d()

    df <- data$df
    date_added_min <- data$date_added_min
    date_added_max <- data$date_added_max
    wtn_min <- data$wtn_min
    wtn_max <- data$wtn_max


    df %>%
      count(fct_well_class_code, my_intended_water_use) %>%
      ggplot2::ggplot()+
      geom_col(aes(x=fct_well_class_code, y= n, fill = forcats::fct_rev(my_intended_water_use)))+
      scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
      labs(
        title = "Figure 1 - Intended Use by Well Class Code",
        subtitle = paste0("date added between ",
                          date_added_min, " and ", date_added_max,
                          " and well tag number between ", wtn_min, " and ", wtn_max),
        x= "Well Class Code",
        y = "Count",
        fill = "Intended Use"
      ) + 
      theme_light()
    })
  })
}
    
## To be copied in the UI
# mod_figure1Output_ui("figure1Output_ui_1")
    
## To be copied in the server
# mod_figure1Output_server("figure1Output_ui_1")
