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
        column(4, mod_filterDataInputGenerate_ui("filterDataInput_ui_1"), downloadButton("downloadData", "Download")),
        column(4, mod_filterDataInputWTN_ui("filterDataInput_ui_1")),
        column(4, mod_filterDataInputDate_ui("filterDataInput_ui_1"))
      ),
      hr(),
      navbarPage(
        title = "text as wide as the logo", theme = "bcgov.css",
        tabPanel(
          "Summary Table",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext summaryTable1")),
            mainPanel(width = 10, mod_summaryTable1Output_ui("summaryTable1Output_ui_1"))
          ),        
          bc_template_footer
        ),   
        tabPanel(
          "Post-WSA Wells",
          sidebarLayout(
            sidebarPanel(width = 2,helpText("helptext1")),
            mainPanel(width = 10, mod_table1Output_ui("table1Output_ui_1"))
            
          ),
          bc_template_footer
        ),
        
        tabPanel(
          "Mislocated Wells",
          sidebarLayout(
            sidebarPanel(width = 2,helpText("helptext table2")),
            mainPanel(width = 10, mod_table2Output_ui("table2Output_ui_1"))
          ),        
          bc_template_footer
        ),
        tabPanel(
          "Pre-WSA Wells",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext table3")),
            mainPanel(width = 10, mod_table3Output_ui("table3Output_ui_1"))
          ),        
          bc_template_footer
        ),       
        tabPanel(
          "Regional Summary",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext summaryTableRegion")),
            mainPanel(width = 10, mod_summaryTableRegionOutput_ui("summaryTableRegionOutput_ui_1"))
          ),        
          bc_template_footer
        ),           
        tabPanel(
          "Map",
          sidebarLayout(
            sidebarPanel(
              width = 2, helpText("helptext map1.  If more than 5000 wells are requested then only the first 5000 are displayed on the map."),
              
            ),
            mainPanel(width = 10, 
                      mod_map1Output_ui("map1Output_ui_1")
            )
          ),        
          bc_template_footer
        ),           
        tabPanel(
          "Well Purposes Graph",
          sidebarLayout(
            sidebarPanel(width = 2, helpText("helptext figure1")),
            mainPanel(width = 10, mod_figure1Output_ui("figure1Output_ui_1"))
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
      app_title = "GWELLS QAQC"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
