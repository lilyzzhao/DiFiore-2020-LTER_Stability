#-----------------------------------
## Load data
#-----------------------------------

source("1-cleandata.R")

#------------------------------------
## Data exploration
#------------------------------------

sbc.fish # total fish biomass at the transect level from sbc lter
sbc.kelp # "foundation" species biomass at the transect level from sbc lter

mcr.coral # average percent cover of coral at each transect from the mcr lter (NOTE averaged across quads)
mcr.fish # average total fish biomass at the transect level from the mcr lter(NOTE: averaged across swaths)


# Plots and means for SBC data
p1 <- ggplot(sbc.kelp, aes(x = year, y = biomass))+
  geom_line(aes(group = id))+
  stat_summary(fun = mean, geom = "line", color = "red", lwd = 2)+
  labs(title = "SBC-Kelp")+
  theme_classic()

p2 <- ggplot(sbc.fish, aes(x = year, y = biomass))+
  geom_line(aes(group = id))+
  stat_summary(fun = mean, geom = "line", color = "red", lwd = 2)+
  coord_cartesian(ylim = c(0,150))+
  labs(title = "SBC-Fish")+
  theme_classic()


cowplot::plot_grid(p1,p2,ncol=1, align = "v")



# Plots and means for MCR data
p3 <- ggplot(mcr.coral, aes(x = year, y = mean.pcover))+
  geom_line(aes(group = id))+
  stat_summary(fun = mean, geom = "line", color = "red", lwd = 2)+
  labs(title = "MCR-Coral")+
  theme_classic()

p4 <- ggplot(mcr.fish, aes(x = year, y = mean.biomass))+
  geom_line(aes(group = id))+
  stat_summary(fun = mean, geom = "line", color = "red", lwd = 2)+
  coord_cartesian(ylim = c(0,50000))+
  labs(title = "MCR-Fish")+
  theme_classic()

cowplot::plot_grid(p3,p4,ncol=1, align = "v")


#---------------------------------------------------------
## Data analysis
#----------------------------------------------------------

# Possible ideas
  # 1. Calculate the ccf() and cor() between the foundation species and the fish communities
  # 2. Calculate the pe_avg_cv() or pe_mv() treating sites as subpopulations
  # 3. Compare the pe_avg_cv() for SBC relative to MCR
























