prepare_all_data <- function(connection){
  message("preparing data")
  message("download wells")
  # wells <- dbGetQuery(connection, 
  #                     "select * FROM  wells"
  # )
  wells <- readr::read_rds("wells.rds")
  
  my_wtn <- wells$well_tag_number
  message("download geocoded")
  # geocode <- dbGetQuery(connection, 
  #                       "select * FROM  wells_geocoded"
  # )
  geocode <- readr::read_rds("geocode.rds")
  message("download qa")
  # qa <- dbGetQuery(connection, 
  #                  "select * FROM  wells_qa"
  # )
  qa <- readr::read_rds("qa.rds")
  
  colnames_in_more_than_one_db <- c("identification_plate_number", "well_identification_plate_attached", "well_status_code", "well_class_code", "well_subclass", "licenced_status_code", "intended_water_use_code", "observation_well_number", "obs_well_status_code", "water_supply_system_name", "water_supply_system_well_name", "street_address", "city", "legal_lot", "legal_plan", "legal_district_lot", "legal_block", "legal_section", "legal_township", "legal_range", "land_district_code", "legal_pid", "well_location_description", "latitude_decdeg", "longitude_decdeg", "utm_zone_code", "utm_northing", "utm_easting", "coordinate_acquisition_code", "construction_start_date", "construction_end_date", "alteration_start_date", "alteration_end_date", "decommission_start_date", "decommission_end_date", "driller_name", "consultant_name", "consultant_company", "diameter_inches", "total_depth_drilled_ft_bgl", "finished_well_depth_ft_bgl", "final_casing_stick_up_inches", "bedrock_depth_ft_bgl", "ground_elevation_ft_asl", "ground_elevation_method_code", "static_water_level_ft_btoc", "well_yield_usgpm", "well_yield_unit_code", "artesian_flow_usgpm", "artesian_pressure_psi", "well_cap_type", "well_disinfected_code", "well_orientation_code", "alternative_specs_submitted", "surface_seal_material_code", "surface_seal_method_code", "surface_seal_depth_ft", "backfill_type", "backfill_depth_ft", "liner_material_code", "liner_diameter_inches", "liner_thickness_inches", "surface_seal_thickness_inches", "liner_from_ft_bgl", "liner_to_ft_bgl", "screen_intake_method_code", "screen_type_code", "screen_material_code", "other_screen_material", "screen_information", "screen_opening_code", "screen_bottom_code", "other_screen_bottom", "filter_pack_from_ft", "filter_pack_to_ft", "filter_pack_material_code", "filter_pack_thickness_inches", "filter_pack_material_size_code", "development_hours", "development_notes", "water_quality_colour", "water_quality_odour", "yield_estimation_method_code", "yield_estimation_rate_usgpm", "yield_estimation_duration_hours", "static_level_before_test_ft_btoc", "drawdown_ft_btoc", "hydro_fracturing_performed", "hydro_fracturing_yield_increase", "decommission_reason", "decommission_method_code", "decommission_details", "decommission_sealant_material", "decommission_backfill_material", "comments", "ems", "person_responsible", "company_of_person_responsible", "aquifer_id", "avi_years", "storativity", "transmissivity_m_2_s", "hydraulic_conductivity_m_s", "specific_storage_1_m", "specific_yield", "testing_method", "testing_duration_hours", "analytic_solution_type", "boundary_effect_code", "aquifer_lithology_code", "artesian_pressure_head_ft_agl", "artesian_conditions", "full_address", "civic_number", "civic_number_suffix", "street_name", "street_type", "is_street_type_prefix", "street_direction", "is_street_direction_prefix", "street_qualifier", "locality_name")
  
  message("left joining")
  full_data <- wells %>% 
    dplyr::left_join(geocode) %>% 
    dplyr::left_join(qa %>% dplyr::select(-dplyr::all_of(colnames_in_more_than_one_db))) # %>%

  message("done joining")
  
  # the shinyapps.io free plan  is short  on memory, let's help us to stay within limits by erasing tables and running garbade control
  rm(wells)
  rm(geocode)
  rm(qa)
  gc()
  
  message("available memory:", getAvailMem())
  
  z <- full_data %>%
    dplyr::mutate(
      cross_referenced = tidyr::replace_na(stringr::str_detect(toupper(comments), "X REF|XREF|X-REF|CROSS REF|CROSSREF|CROSS-REF"), FALSE),
      max_date = pmax(dplyr::coalesce(construction_start_date, construction_end_date, alteration_start_date, alteration_end_date, decommission_start_date, decommission_end_date)),
      worktype = factor(dplyr::case_when(
        decommission_start_date == max_date | decommission_end_date == max_date ~ "decommission",
        alteration_start_date == max_date | alteration_end_date == max_date ~ "alteration",
        construction_start_date == max_date | construction_end_date == max_date ~ "construction",
        TRUE ~ "no date"
      ), levels = c("construction", "alteration", "decommission", "no date")
      ),
      old_or_unknown_date = max_date < lubridate::ymd("20160301") | is.na(max_date), 
      my_well_type = dplyr::case_when(
        artesian_conditions == "True" ~ "artesian",
        well_class_code == "WATR_SPPLY" ~ "water supply",
        well_class_code == "RECHARGE" ~ "recharge",
        well_class_code == "INJECTION" ~ "injection",
        well_class_code == "DEW_DRA" ~ "dewatering/discharge",
        well_class_code == "CLS_LP_GEO" ~ "closed loop geo",
        TRUE ~ NA_character_
      ),
      table1_missing_lat_long_flag =  dplyr::case_when(
        is.na(my_well_type) | old_or_unknown_date ~ FALSE,
        is.na(latitude_decdeg) | is.na(longitude_decdeg) ~ TRUE,
        !is.na(latitude_decdeg) | is.na(longitude_decdeg) ~ FALSE
      ),
      table1_table1_missing__wdip_flag =  dplyr::case_when(
        is.na(my_well_type) | old_or_unknown_date ~ FALSE,
        is.na(well_identification_plate_attached)  ~ TRUE,
        !is.na(well_identification_plate_attached)  ~ FALSE
      ),
      table1_missing_finished_well_depth_flag =  dplyr::case_when(
        is.na(my_well_type) | old_or_unknown_date ~ FALSE,
        is.na(finished_well_depth_ft_bgl)  ~ TRUE,
        !is.na(finished_well_depth_ft_bgl)  ~ FALSE
      ),
      table1_missing_person_responsible_flag =  dplyr::case_when(
        is.na(my_well_type) | old_or_unknown_date ~ FALSE,
        is.na(person_responsible)  ~ TRUE,
        !is.na(person_responsible)  ~ FALSE
      ),
      table1_flag = table1_missing_lat_long_flag + table1_table1_missing__wdip_flag + table1_missing_finished_well_depth_flag + table1_missing_person_responsible_flag,
      table2_flag = dplyr::case_when(
        distance_to_matching_pid >400 ~ TRUE,
        0< score_address & score_address < 80 ~ TRUE,
        0 <score_city ~ TRUE,
        TRUE ~ FALSE
      ),
      table3_missing_lat_long_flag =  dplyr::case_when(
        is.na(my_well_type) | !old_or_unknown_date ~ FALSE,
        is.na(latitude_decdeg) | is.na(longitude_decdeg) ~ TRUE,
        !is.na(latitude_decdeg) | is.na(longitude_decdeg) ~ FALSE
      ),
      table3_missing_finished_well_depth_flag =  dplyr::case_when(
        is.na(my_well_type) | !old_or_unknown_date ~ FALSE,
        is.na(finished_well_depth_ft_bgl)  ~ TRUE,
        !is.na(finished_well_depth_ft_bgl)  ~ FALSE
      ),
      table3_flag =  table3_missing_lat_long_flag + table3_missing_finished_well_depth_flag,
      my_intended_water_use =
        factor(dplyr::if_else(well_class_code == "WATR_SPPLY", intended_water_use_code, "SPECIALIZED"), 
               levels = c("DOM", "UNK","DWS","COM","IRR","OTHER","TST","OBS","OP_LP_GEO", "SPECIALIZED")
        )
    )%>%
    dplyr::mutate(
      fct_well_class_code = factor(well_class_code, levels = c("WATR_SPPLY", "UNK", "MONITOR", "DEW_DRA", "CLS_LP_GEO" ,"GEOTECH" ,"REMEDIATE" ,"INJECTION", "RECHARGE"))
    )  
  
  message("returning z")
  
  return(z)  
  
}

