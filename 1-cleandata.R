#----------------------------------------------------------------
## Get and clean data
#----------------------------------------------------------------

library(tidyverse)

if(!require(devtools, quietly = TRUE)) {
  install.packages(devtools)
}

if(!require(ecofolio, quietly = TRUE)) {
  devtools::install_github("seananderson/ecofolio")
}


# SBC data - biomass based 
  # Fish and kelp biomass estimated along the same!!! transects  

sbc.fish <- read.csv("data/SBC/Annual_All_Species_Biomass_at_transect.csv", stringsAsFactors = F,na.strings ="-99999") %>%
  select("YEAR", "MONTH", "SITE", "TRANSECT", "SP_CODE", "DENSITY", "DRY_GM2", "SCIENTIFIC_NAME", "COMMON_NAME", "GROUP", "MOBILITY", "GROWTH_MORPH", "COARSE_GROUPING" ) %>%
  rename_all(tolower) %>%
  filter(group == "FISH") %>%
  as_tibble() %>%
  group_by(year, site, transect) %>%
  summarize(biomass = sum(dry_gm2)) %>%
  mutate(id = paste(site,transect,sep = "-"))

sbc.kelp <- read.csv("data/SBC/Annual_All_Species_Biomass_at_transect.csv", stringsAsFactors = F,na.strings ="-99999") %>%
  select("YEAR", "MONTH", "SITE", "TRANSECT", "SP_CODE", "DENSITY", "DRY_GM2", "SCIENTIFIC_NAME", "COMMON_NAME", "GROUP", "MOBILITY", "GROWTH_MORPH", "COARSE_GROUPING" ) %>%
  rename_all(tolower) %>%
  filter(sp_code == "MAPY") %>%
  as_tibble() %>%
  group_by(year, site, transect) %>%
  summarize(biomass = dry_gm2) %>%
  mutate(id = paste(site,transect,sep = "-"))


# MCR data - fish abundance and coral percent cover
  # I cannot determine if fish and coral are estimated at the same exact sites... need to discuss with AS,KK,LZ. Coral is the average percent cover along a transect. Fish is the total biomass at each transect. 

mcr.coral <- read.csv("data/MCR/coral-4_1_20191119.csv", stringsAsFactors = F, na.strings = "") %>%
  rename_all(tolower)

mcr.coral <- mcr.coral %>%
  as_tibble() %>%
  mutate(group = ifelse(taxonomy...substrate...functional.group %in% c("Sand", "Crustose Coralline Algae / Bare Space", "Turf", "Macroalgae"), "other", "coral"), 
         taxonomy...substrate...functional.group = NULL) %>%
  group_by(date, location, site, habitat, transect, quadrat, group) %>%
  summarize(percent.cover = sum(percent.cover)) %>%
  drop_na() %>%
  group_by(date, site, habitat, transect, group) %>%
  summarize(mean.pcover = mean(percent.cover)) %>%
  separate(date, into = c("year", "month"), sep = "[-]") %>%
  select(-month) %>%
  mutate(id = paste(site,habitat,transect,sep = "-"), 
         year = as.numeric(year)) %>%
  filter(group == "coral")

  
mcr.fish <- read.csv("data/MCR/MCR_LTER_Annual_Fish_Survey_20190519.csv") %>%
  as_tibble() %>%
  rename_all(tolower) %>%
  select(year, location, site, habitat, transect, swath, taxonomy, family, biomass, coarse_trophic, fine_trophic) %>%
  mutate(site = paste("LTER", site, sep = " ")) %>%
  group_by(year, site, habitat, transect, swath) %>%
  summarize(biomass = sum(biomass)) %>%
  drop_na() %>%
  group_by(year, site, habitat, transect) %>%
  summarize(mean.biomass = mean(biomass)) %>%
  mutate(id = paste(site,habitat,transect,sep = "-"), 
         year = as.numeric(year))























