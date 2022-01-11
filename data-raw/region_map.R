## code to prepare `region_map` dataset goes here

#usethis::use_data(region_map, overwrite = TRUE)

library(ggplot2)
library(sf)
library(bcmaps)
library(dplyr)
library(cowplot)
library(stringr)
bc_landmass <- bcmaps::bc_bound(ask = FALSE) %>% 
  mutate(dummy = 1) %>%
  group_by(dummy) %>%
  summarise(dummy2 = 1)

regions_landmass <- nr_regions(ask=FALSE) %>% 
  st_intersection(bc_landmass) %>%  
  st_cast("MULTIPOLYGON") %>%
  st_transform(4326)

ggplot() + 
  geom_sf(data = regions_landmass %>% mutate(REGION_NAME = stringr::str_replace(REGION_NAME," Natural Resource Region","")), aes(fill = REGION_NAME, color = REGION_NAME), alpha=0.5) + 
  theme_map() + 
  scale_color_brewer(type="qual") + 
  scale_fill_brewer(type="qual") + 
  labs(fill = "Region name", color = "Region name") + 
  theme(legend.position = "bottom")

ggsave("inst/app/www/region_map.png", width= 4)
