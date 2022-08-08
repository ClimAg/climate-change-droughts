# ### find the closer cell to the Cork Airport station (Latitude: 51.84722 N, Longitude: -8.48611W, Station n° 3904, Height: 155 meters)


# install.packages("eurocordexr")
library(eurocordexr)
library(sf)

ncfile <- "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc"

df_coord <- nc_grid_to_dt(filename = ncfile, variable = "lat")
df_coord$lon <- nc_grid_to_dt(filename = ncfile, variable = "lon")$lon

df_coord$date <- NULL

#add to the data frame another dataframe with the Cork Airport station latitude and longitude
df_coord <- rbind(data.frame(icell=0, lon=-8.5, lat=51.8), df_coord)

df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)

#crate a data frame corresponding to the Cork Airport station in a proper format
cork_airport <-subset(df_coord_sf, icell==0)

#calculate the distance between the location's cell of the data set and the location of Cork Airport station
df_coord_sf$dist <- st_distance(df_coord_sf, cork_airport)
