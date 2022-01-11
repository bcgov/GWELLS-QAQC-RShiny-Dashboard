#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    
    # fluidpage de exemple
    fluidPage(
      waiter::useWaiter(),
      tags$style(".glyphicon-ok-sign {color:#2b8ee5}
              .glyphicon-question-sign {color:#f4e107}
              .glyphicon-exclamation-sign {color:#e5413b}
              .glyphicon-flag, .glyphicon-trash {color:#28b728}"),
      fluidRow(
        column(4, mod_filterDataInputWTN_ui("filterDataInput_ui_1")),
        column(4, mod_filterDataInputDate_ui("filterDataInput_ui_1")),
        column(4, mod_filterDataInputGenerate_ui("filterDataInput_ui_1"))
      ),
      navbarPage(
        title = "text as wide as the logo", theme = "bcgov.css",
        tabPanel(
          "Summary Table 1",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext summaryTable1")),
            mainPanel(width = 10, mod_summaryTable1Output_ui("summaryTable1Output_ui_1"))
          ),        
          bc_template_footer
        ),   
        tabPanel(
          "Summary Table 2",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext summaryTable2")),
            mainPanel(width = 10, mod_summaryTable2Output_ui("summaryTable2Output_ui_1"))
          ),        
          bc_template_footer
        ),   
        tabPanel(
          "Summary Table 3",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext summaryTable3")),
            mainPanel(width = 10, mod_summaryTable3Output_ui("summaryTable3Output_ui_1"))
          ),        
          bc_template_footer
        ),   
        tabPanel(
          "Data Table 1",
          sidebarLayout(
            sidebarPanel(width = 2,helpText("helptext1")),
            mainPanel(width = 10, mod_table1Output_ui("table1Output_ui_1"))
            
          ),
          bc_template_footer
        ),
        
        tabPanel(
          "Data Table 2",
          sidebarLayout(
            sidebarPanel(width = 2,helpText("helptext table2")),
            mainPanel(width = 10, mod_table2Output_ui("table2Output_ui_1"))
          ),        
          bc_template_footer
        ),
        tabPanel(
          "Data Table 3",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext table3")),
            mainPanel(width = 10, mod_table3Output_ui("table3Output_ui_1"))
          ),        
          bc_template_footer
        ),        
        tabPanel(
          "Figure 1",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext figure1")),
            mainPanel(width = 10, mod_figure1Output_ui("figure1Output_ui_1"))
          ),        
          bc_template_footer
        ),    
        tabPanel(
          "Map 1",
          sidebarLayout(
            sidebarPanel(
              width = 2, helpText("helptext map1.  If more than 2000 wells are requested then only the first 2000 are displayed on the map."),
              
              ),
            mainPanel(width = 10, mod_map1Output_ui("map1Output_ui_1"))
            #, img(src = "www/region_map.png", height = 400)
          ),        
          bc_template_footer
        ),   
      )
    )
  )
}



#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "gwells_shiny"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
