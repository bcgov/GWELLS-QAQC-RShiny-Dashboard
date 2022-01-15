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
    leaflet::leafletOutput(ns("mymap"), height = "70vh")   # 
  )
}

#' map1Output Server Functions
#'
#' @noRd 
mod_map1Output_server <- function(id, d ){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    

    
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
        select(well_tag_number, fct_well_class_code, date_added, nr_region_name ) %>% 
        tail(5000) 
      
      
      mymap <- z %>% 
        mutate(label = paste0("well tag number: ", well_tag_number)) %>% 
        mapview(
          zcol = "fct_well_class_code", 
          popup = popupTable(., zcol = c("well_tag_number", "fct_well_class_code", "date_added", "nr_region_name")),
          map.types = c("CartoDB.Positron", "CartoDB.DarkMatter", "OpenStreetMap",
                        "Esri.WorldShadedRelief"),
          layer.name = paste0("Wells With <br>Date Added Between ",
                              date_added_min, " and ", date_added_max,
                              " and <br>Well Tag Number Between ", wtn_min, " and ", wtn_max),
          label = .$label,
          col.regions = brewer.pal(n=9,name="Set1")
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
