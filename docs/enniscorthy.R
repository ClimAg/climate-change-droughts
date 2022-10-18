# %% [markdown]
# # Enniscorthy EURO-CORDEX data
#
# Enniscorthy is in Co. Wexford (-6.75, 52.75)

# %%
# set working directory to root
setwd("../../")

# %%
# import requirements and functions
source(
    "./jupyter-notebooks/scripts/spi-spei.R",
    echo = TRUE,
    max.deparse.length = 2000
)
library(sf)

# %%
# directory where the future nc files are stored
datadir <- "./data/eurocordex/DMI/rcp85/mon/"

# %% [markdown]
# ## Finding the closest grid cell

# %%
# read one of the EURO-CORDEX data files
ncfile <- paste(
    datadir,
    "pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_204101-205012.nc",
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

# %%
# create a row corresponding to Enniscorthy's coordinates at icell = -1
df_coord <- rbind(data.frame(
    icell = -1, lon = -6.75, lat = 52.75
), df_coord)

# %%
head(df_coord, 10)

# %%
# convert to a spatial data frame
df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)

# %%
# create a standalone data frame for the Enniscorthy data
study <- subset(df_coord_sf, icell == -1)

# %%
# calculate the distance between Enniscorthy and all other cells
df_coord_sf$dist <- st_distance(df_coord_sf, study)

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
icell_ <- df_coord_sf[2, "icell"]

# %%
icell_

# %% [markdown]
# ## Plots

# %%
# set plot resolution
options(repr.plot.res = 200)

# %%
# separate study area coordinates from the cells
study <- subset(df_coord, icell < 0)
df_coord <- subset(df_coord, icell > 0)

# %%
# filter closest cells
icell <- subset(df_coord, icell == icell_)

# %%
study

# %%
head(df_coord)

# %%
icell

# %%
# convert to spatial data frames
df_coord_sf <- st_as_sf(df_coord, coords = c("lon", "lat"), crs = 4326)
study <- st_as_sf(study, coords = c("lon", "lat"), crs = 4326)
icell <- st_as_sf(icell, coords = c("lon", "lat"), crs = 4326)

# %%
# Ireland boundary data
ie <- st_read("./data/boundary/boundaries.gpkg", "NUTS_Ireland")

# %%
print(ie)

# %%
# keep only cells that intersect with Ireland's boundary
df_coord_ie <- st_intersection(df_coord_sf, ie)

# %%
# project to Irish transverse mercator
# https://www.gov.uk/government/publications/uk-geospatial-data-standards-register/national-geospatial-data-standards-register#standards-for-coordinate-reference-systems
crs_ie <- 2157

df_coord_ie = st_transform(df_coord_ie, crs = crs_ie)
ie = st_transform(ie, crs = crs_ie)
study = st_transform(study, crs = crs_ie)
icell = st_transform(icell, crs = crs_ie)

# %%
par(family = "Source Sans 3")

plot(
    df_coord_ie["icell"],
    pch = 15,
    main = "EURO-CORDEX cells closest to Enniscorthy (green)",
    key.length = 1,
    key.width = lcm(1.5),
    # axes = TRUE,
    reset = FALSE
)
plot(
    st_make_grid(df_coord_ie, cellsize = 12500),
    border = "grey",
    add = TRUE
)
plot(st_boundary(st_buffer(icell, dist = 12500/2)), col = "black", add = TRUE)
plot(study["geometry"], pch = 21, bg = c("green"), add = TRUE)
plot(ie["geom"], add = TRUE, border = "darkslategrey")

# %% [markdown]
# ## Extracting RCP8.5 precipitation data

# %%
# process precipitation data
pr <- future_process(
    datadir = datadir, variable = "pr", indexcell = icell_
)

# %%
head(pr)

# %%
dcast(pr, year~month, value.var = c("pr"))

# %%
# save as CSV file
write.table(
    pr,
    file = paste(
        "./data/eurocordex/DMI/",
        "enniscorthy_pr_EUR-11_",
        "NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon.csv",
        sep = ""
    ),
    row.names = FALSE,
    sep = ",",
    quote = FALSE
)

# %% [markdown]
# ## Extracting historic data

# %%
# directory where the historical nc files are stored
datadir <- "./data/eurocordex/DMI/historical/mon/"

# %%
# process precipitation data
pr <- hist_process(
    datadir = datadir, variable = "pr", indexcell = icell_
)

# %%
head(pr)

# %%
dcast(pr, year~month, value.var = c("pr"))

# %%
# save as CSV file
write.table(
    pr,
    file = paste(
        "./data/eurocordex/DMI/",
        "enniscorthy_pr_EUR-11_",
        "NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon.csv",
        sep = ""
    ),
    row.names = FALSE,
    sep = ",",
    quote = FALSE
)
