### Euro Codrex ###

# Source : https://climate4impact.eu/impactportal/general/index.jsp

# install.packages("eurocordexr")
library(eurocordexr)
library(dplyr)
library(tidyverse)
library(lubridate)
#library(ncdf4)

##1971-1980
pr7180 <- "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc"
pr1 <- nc_grid_to_dt(
  filename = pr7180,
  variable = "pr"
)

#choose a specific index cell##
pr_df <- subset(pr1, icell==1)

pr_df$date <- as.Date(pr_df$date, format = "%Y-%m-%d")

pr_df$month <- month(pr_df$date)

#change the date format : date(1990-12-06) in YEAR and MONTH columns
x=data.frame(date = pr_df$date)

x = x %>%
  mutate(date = ymd(date)) %>%
  mutate_at(vars(date), funs(year, month, day))

x
x<-subset(x, select = -c(day))
x<-subset(x, select = -c(date))

pr_df<-cbind(pr_df, x)

##1981-1990
pr8190 <- "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_198101-199012.nc"
pr2<- nc_grid_to_dt(
  filename = pr8190,
  variable = "pr"
)

#choose a specific index cell##
pr_df2 <- subset(pr2, icell==1)

#change the date format : date(1990-12-06) in YEAR and MONTH columns
y=data.frame(date = pr_df2$date)

y = y %>%
  mutate(date = ymd(date)) %>%
  mutate_at(vars(date), funs(year, month, day))

y
y<-subset(y, select = -c(day))
y<-subset(y, select = -c(date))

pr_df2<-cbind(pr_df2, y)

#add a datatable one below an other
pr_all<-rbind(pr_df, pr_df2)



#tash<-nc_open("./data/eurocordex/tas_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_195101-196012.nc")

#t <- ncvar_get(tash, "tas")

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
