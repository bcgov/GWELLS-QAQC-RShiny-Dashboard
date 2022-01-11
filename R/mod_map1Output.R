#' map1Output UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map1Output_ui <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("mymap")),
  )
}

#' map1Output Server Functions
#'
#' @noRd 
mod_map1Output_server <- function(id, d ){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    # points <- eventReactive(input$recalc, {
    #   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    # }, ignoreNULL = FALSE)
    # output$mymap <- renderLeaflet({
    #   leaflet() %>%
    #     addProviderTiles(providers$Stamen.TonerLite,
    #                      options = providerTileOptions(noWrap = TRUE)
    #     ) %>%
    #     addMarkers(data = points())
    # })
    
    bc_landmass <- bcmaps::bc_bound(ask = FALSE) %>% 
      mutate(dummy = 1) %>%
      group_by(dummy) %>%
      summarise(dummy2 = 1)
    
    regions_landmass <- nr_regions(ask=FALSE) %>% 
      st_intersection(bc_landmass) %>%  
      st_cast("MULTIPOLYGON") %>%
      st_transform(4326)
    
    
    output$mymap <- renderLeaflet({
      data <- d()
      df <- data$df
      date_added_min <- data$date_added_min
      date_added_max <- data$date_added_max
      wtn_min <- data$wtn_min
      wtn_max <- data$wtn_max
      
      z <- df %>%
        filter(!is.na(longitude_decdeg), !is.na(latitude_decdeg)) %>%
        st_as_sf(coords= c("longitude_decdeg", "latitude_decdeg"), crs = 4326, remove = FALSE)  %>%
        select(well_tag_number, well_class_code, date_added) %>% 
        tail(1000)  
      
      
      mymap <- z %>% 
        mutate(label = paste0("well tag number: ", well_tag_number)) %>% 
        mapview(
          zcol = "well_class_code", 
          map.types = c("CartoDB.Positron", "CartoDB.DarkMatter", "OpenStreetMap",
                        "Esri.WorldShadedRelief"),
          layer.name = paste0("wells with <br>date added between ",
                              date_added_min, " and ", date_added_max,
                              " and <br>well tag number between ", wtn_min, " and ", wtn_max),
          label = .$label
        ) 
      
      mymap@map %>%
        addPolylines(data = regions_landmass,
                     color = "blue",
                     weight = 2,
                     opacity = 0.2,
                     dashArray = "3")
      
    })
    
    
  })
}

## To be copied in the UI
# mod_map1Output_ui("map1Output_ui_1")

## To be copied in the server
# mod_map1Output_server("map1Output_ui_1")
