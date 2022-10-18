# %% [markdown]
# # Finding the closest EURO-CORDEX grid cell to a Met Éireann met station
#
# - Station details can be found here: <https://cli.fusio.net/cli/climate_data/webdata/StationDetails.csv>
#   - Cork Airport: (-8.48611, 51.84722)
#   - Fermoy (Moore Park): (-8.26389, 52.16389)
# - The Cork Airport station has historical data from 1961
# - The Moore Park station was installed in 2003, replacing a manual station which operated from 1961 (see <https://www.met.ie/climate/weather-observing-stations>)
# - Check the "Show closed stations" box to obtain data for this replaced station: <https://www.met.ie/climate/available-data/historical-data>

# %%
# import required libraries
library(eurocordexr)
library(sf)

# %%
# set working directory to root
setwd("../../")

# %%
# read one of the EURO-CORDEX data files
ncfile <- paste(
    "./data/eurocordex/DMI/historical/mon/",
    "pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_",
    "DMI-HIRHAM5_v3_mon_197101-198012.nc",
    sep = ""
)

# %%
# extract the latitude and longitude from the nc file
df_coord <- nc_grid_to_dt(filename = ncfile, variable = "lat")
df_coord$lon <- nc_grid_to_dt(filename = ncfile, variable = "lon")$lon

# %%
head(df_coord)

# %%
# sort by grid cell in ascending order
df_coord <- df_coord[order(df_coord$icell),]

# %%
# remove redundant date column
df_coord$date <- NULL

# %%
head(df_coord)

# %% [markdown]
# ## Cork Airport

# %%
# create a row corresponding to Cork Airport's coordinates at icell = -1
df_coord <- rbind(data.frame(
    icell = -1, lon = -8.48611, lat = 51.84722
), df_coord)

# %%
head(df_coord, 10)

# %%
# convert to a spatial data frame
df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)

# %%
# create a standalone data frame for the Cork Airport data
met_station <- subset(df_coord_sf, icell == -1)

# %%
# calculate the distance between Cork Airport and all other cells
df_coord_sf$dist <- st_distance(df_coord_sf, met_station)

# %%
# convert to data frame to view the results
df_coord_sf <- as.data.frame(df_coord_sf)

# %%
# sort by distance in ascending order
df_coord_sf <- df_coord_sf[order(df_coord_sf$dist),]

# %%
# reset row names
rownames(df_coord_sf) <- NULL

# %%
# view the results
head(df_coord_sf, 10)

# %%
# save closest grid cell value
icell_ca <- df_coord_sf[2, "icell"]

# %% [markdown]
# ## Moore Park

# %%
# create a row corresponding to Moore Park's coordinates at icell = 0
df_coord <- rbind(data.frame(
    icell = -2, lon = -8.26389, lat = 52.16389
), df_coord)

# %%
head(df_coord, 10)

# %%
# convert to a spatial data frame
df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)

# %%
# create a standalone data frame for the Moore Park data
met_station <- subset(df_coord_sf, icell == -2)

# %%
# calculate the distance between Moore Park and all other cells
df_coord_sf$dist <- st_distance(df_coord_sf, met_station)

# %%
# convert to data frame to view the results
df_coord_sf <- as.data.frame(df_coord_sf)

# %%
# sort by distance in ascending order
df_coord_sf <- df_coord_sf[order(df_coord_sf$dist),]

# %%
# reset row names
rownames(df_coord_sf) <- NULL

# %%
# view the results
head(df_coord_sf, 10)

# %%
# save closest grid cell value
icell_mp <- df_coord_sf[2, "icell"]

# %% [markdown]
# ## Plots

# %%
# set plot resolution
options(repr.plot.res = 200)

# %%
# separate met station coordinates from the cells
met_station <- subset(df_coord, icell < 0)
df_coord <- subset(df_coord, icell > 0)

# %%
# filter closest grid cells
icell <- subset(df_coord, icell == icell_ca | icell == icell_mp)

# %%
met_station

# %%
head(df_coord)

# %%
icell

# %%
# convert to spatial data frames
df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)
met_station <- st_as_sf(met_station, coords = c("lon", "lat"), crs = 4326)
icell <- st_as_sf(icell, coords = c("lon", "lat"), crs = 4326)

# %%
# Ireland boundary data
ie <- st_read("./data/boundary/boundaries.gpkg", "NUTS_Ireland")

# %%
print(ie)

# %%
# keep only grid cells that intersect with Ireland's boundary
df_coord_ie <- st_intersection(df_coord_sf, ie)

# %%
par(family = "Source Sans 3")

plot(
    df_coord_ie["icell"],
    pch = 15,
    main = "EURO-CORDEX cells (icell) for Ireland",
    key.length = 1,
    key.width = lcm(1.5),
    axes = TRUE,
    reset = FALSE
)
plot(met_station["geometry"], pch = 21, bg = c("red", "green"), add = TRUE)
plot(ie["geom"], add = TRUE, border = "darkslategrey")
mtext(
    "Cork Airport - green, Moore Park - red", side = 1, line = -1
)

# %%
# project to Irish transverse mercator
# https://www.gov.uk/government/publications/uk-geospatial-data-standards-register/national-geospatial-data-standards-register#standards-for-coordinate-reference-systems
crs_ie <- 2157

df_coord_ie_ = st_transform(df_coord_ie, crs = crs_ie)
ie_ = st_transform(ie, crs = crs_ie)
met_station_ = st_transform(met_station, crs = crs_ie)
icell_ = st_transform(icell, crs = crs_ie)

# %%
par(family = "Source Sans 3")

plot(
    df_coord_ie_["icell"],
    pch = 15,
    main = "EURO-CORDEX cells (icell) for Ireland",
    key.length = 1,
    key.width = lcm(1.5),
    axes = TRUE,
    reset = FALSE
)
plot(
    st_make_grid(df_coord_ie_, cellsize = 12500),
    border = "grey",
    add = TRUE
)
plot(st_boundary(st_buffer(icell_, dist = 12500/2)), col = "black", add = TRUE)
plot(met_station_["geometry"], pch = 21, bg = c("red", "green"), add = TRUE)
plot(ie_["geom"], add = TRUE, border = "darkslategrey")
mtext(
    "Cork Airport - green, Moore Park - red", side = 1, line = -1
)
