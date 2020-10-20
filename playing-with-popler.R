# The popler package allows for easy access to all LTER population data.

# For more info check out https://github.com/ropensci/popler
install.packages('popler')
library("popler")
library("dplyr")

all_studies <- pplr_browse() # This will extract a summary of the metadata for all data sets in the popler package

unique(all_studies$lterid)
unique(all_studies$duration_years)
unique(all_studies$community)

# Example of how to get data

  mcr <- pplr_browse(lterid == 'MCR' & studytype == "obs") # build a browse object first
  
  coral <- pplr_browse(lterid == "MCR" & proj_metadata_key == 813)
  pplr_metadata_url(coral) # open link to web metadata
  pplr_citation(coral) # pull citation for the data sets
  
  coral_df <- pplr_get_data(coral)
  
  coral_df <- coral_df %>% select(-c(covariates, authors, authors_contact))
  
  write.csv(coral_df, "MCR_coraldata.csv", row.names = F, quote = F)
  
  fish <- pplr_browse(lterid == "MCR" & proj_metadata_key == 799)
  pplr_metadata_url(fish)
  fish_df <- pplr_get_data(fish)
  fish_df <- fish_df %>% select(-c(covariates, authors, authors_contact))
  
  write.csv(fish_df, "MCR_fishdata.csv", row.names = F, quote = F)
  
# Bring in the SBC LTER data
  
  sbc <- pplr_browse(lterid == 'SBC' & studytype == "obs") # build a browse object first
  kelp <- pplr_browse(lterid == "SBC" & proj_metadata_key == 1)
  kelp_df <- pplr_get_data(kelp) %>% select(-c(covariates, authors, authors_contact))
  
  kfish <- pplr_browse(lterid == "SBC" & proj_metadata_key == 2)
  kfish_df <- pplr_get_data(kfish) %>% select(-c(covariates, authors, authors_contact)) %>%
    group_by(year, spatial_replication_level_1, spatial_replication_level_2, sppcode) %>%
    summarize(abundance_observation = sum(abundance_observation))
  