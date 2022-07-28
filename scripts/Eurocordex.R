### Euro Codrex ###

# install.packages("eurocordexr")
library(eurocordexr)
library(tidyverse)
library(lubridate)
# library(ncdf4)
library(sf)

# import functions
source("functions/convert-units.R")
source("functions/prprocess.R")
source("functions/spi-spei.R")

# ### find the closer cell to the Cork Airport station (Latitude: 51.84722 N, Longitude: -8.48611W, Station n° 3904, Height: 155 meters)
# ncfile <- "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc"
# # ncin <- nc_open(ncfile)
# # View(ncin)
# df_coord <- nc_grid_to_dt(filename = ncfile, variable = "lat")
# df_coord$lon <- nc_grid_to_dt(filename = ncfile, variable = "lon")$lon
#
# df_coord$date <- NULL
#
# #add to the data frame another dataframe with the Cork Airport station latitude and longitude
# df_coord <- rbind(data.frame(icell=0, lon=-8.5, lat=51.8), df_coord)
#
# df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)
#
# #crate a data frame corresponding to the Cork Airport station in a proper format
# cork_airport <-subset(df_coord_sf, icell==0)
#
# #calculate the distance between the location's cell of the data set and the location of Cork Airport station
# df_coord_sf$dist <- st_distance(df_coord_sf, cork_airport)

##extract the past precipitation data as the proper format
pr1<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc", indexcell = 69225, var="pr")
pr2<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_198101-199012.nc", indexcell = 69225, var="pr")
pr3<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_199101-200012.nc", indexcell = 69225, var="pr")
pr4<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_200101-200512.nc", indexcell = 69225, var="pr")

#create a data table for pr (1976-2005)
pr_hist<-rbind(pr1, pr2, pr3, pr4)

#select specific period : 1976-2005
hist_data <- subset(pr_hist, year > 1975 & year < 2006)


##extract the future precipitation data as the proper format
pr5<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_204101-205012.nc", indexcell = 69225, var="pr")
pr6<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_205101-206012.nc", indexcell = 69225, var="pr")
pr7<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_206101-207012.nc", indexcell = 69225, var="pr")

#create a data table for pr (2041-2070)
rcp85_data <-rbind (pr5, pr6, pr7)


#callate spi
#spi6



# A package to make life easier working with daily netcdf files from the EURO-CORDEX RCMs. Relies on data.table to do the heavy data lifting.
#
# Main components:
#
# extract single grid cells (e.g. for stations) from rotated pole grid: rotpole_nc_point_to_dt()
# extract the whole array of a variable in long format: nc_grid_to_dt()
# can deal with non-standard calendars (360, noleap) and interpolate them
# get and check list of EURO-CORDEX .nc files: get_inventory()

#path_eurocordex <- "./data/eurocordex"
#dat_inventory <- get_inventory(path_eurocordex)
#dat_inventory_files <- get_inventory(path_eurocordex, add_files = T)
#dat_inventory
