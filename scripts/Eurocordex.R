### Euro Codrex ###

# install.packages("eurocordexr")
library(eurocordexr)
library(tidyverse)
library(lubridate)
library(data.table)

# import functions
source("functions/convert-units.R")
source("functions/ecprocess.R")
source("functions/spi-spei.R")

###SPI

##extract the past precipitation data as the proper format
pr1<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc", indexcell = 69225, var="pr")
pr2<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_198101-199012.nc", indexcell = 69225, var="pr")
pr3<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_199101-200012.nc", indexcell = 69225, var="pr")
pr4<-ec_process(datapath = "./data/eurocordex/pastdata/pr_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_200101-200512.nc", indexcell = 69225, var="pr")

#create a data table for pr (1976-2005)
pr_hist<-rbind(pr1, pr2, pr3, pr4)
#
# #select specific period : 1976-2005
# hist_data <- subset(pr_hist, year > 1975 & year < 2006)
#

# ##extract the future precipitation data as the proper format
# pr5<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_204101-205012.nc", indexcell = 69225, var="pr")
# pr6<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_205101-206012.nc", indexcell = 69225, var="pr")
# pr7<-ec_process(datapath = "./data/eurocordex/futuredata/pr_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_206101-207012.nc", indexcell = 69225, var="pr")
#
# #create a data table for pr (2041-2070)
# rcp85_data <-rbind (pr5, pr6, pr7)
#

###SPEI

##tasmax

##extract the past precipitation data as the proper format
tx1<-ec_process(datapath = "./data/eurocordex/pastdata/tasmax_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc", indexcell = 69225, var="tasmax")
tx2<-ec_process(datapath = "./data/eurocordex/pastdata/tasmax_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_198101-199012.nc", indexcell = 69225, var="tasmax")
tx3<-ec_process(datapath = "./data/eurocordex/pastdata/tasmax_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_199101-200012.nc", indexcell = 69225, var="tasmax")
tx4<-ec_process(datapath = "./data/eurocordex/pastdata/tasmax_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_200101-200512.nc", indexcell = 69225, var="tasmax")

#create a data table for pr (1976-2005)
tx_hist<-rbind(tx1, tx2, tx3, tx4)

#select specific period : 1976-2005
tx_hist <- subset(tx_hist, year > 1975 & year < 2006)

fwrite(tx_hist, "D:\\evakl\\Bureau\\climate-change-droughts\\data\\eurocordex\\csvpastdata\\txpast.csv")

txvect<-subset(df2, select = c(-month, year, -MONTH))
#
# ##extract the future precipitation data as the proper format
# tx5<-ec_process(datapath = "./data/eurocordex/futuredata/tasmax_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_204101-205012.nc", indexcell = 69225, var="tasmax")
# tx6<-ec_process(datapath = "./data/eurocordex/futuredata/tasmax_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_205101-206012.nc", indexcell = 69225, var="tasmax")
# tx7<-ec_process(datapath = "./data/eurocordex/futuredata/tasmax_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_206101-207012.nc", indexcell = 69225, var="tasmax")
#
# #create a data table for pr (2041-2070)
# rcp85_data <-rbind (tx5, tx6, tx7)


###tasmin

##extract the past precipitation data as the proper format
tn1<-ec_process(datapath = "./data/eurocordex/pastdata/tasmin_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_197101-198012.nc", indexcell = 69225, var="tasmin")
tn2<-ec_process(datapath = "./data/eurocordex/pastdata/tasmin_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_198101-199012.nc", indexcell = 69225, var="tasmin")
tn3<-ec_process(datapath = "./data/eurocordex/pastdata/tasmin_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_199101-200012.nc", indexcell = 69225, var="tasmin")
tn4<-ec_process(datapath = "./data/eurocordex/pastdata/tasmin_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_200101-200512.nc", indexcell = 69225, var="tasmin")

#create a data table for pr (1976-2005)
tn_hist<-rbind(tn1, tn2, tn3, tn4)

#select specific period : 1976-2005
hist_data <- subset(tn_hist, year > 1975 & year < 2006)


# ##extract the future precipitation data as the proper format
# tn5<-ec_process(datapath = "./data/eurocordex/futuredata/tasmin_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_204101-205012.nc", indexcell = 69225, var="tasmin")
# tn6<-ec_process(datapath = "./data/eurocordex/futuredata/tasmin_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_205101-206012.nc", indexcell = 69225, var="tasmin")
# tn7<-ec_process(datapath = "./data/eurocordex/futuredata/tasmin_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_206101-207012.nc", indexcell = 69225, var="tasmin")
#
# #create a data table for pr (2041-2070)
# rcp85_data <-rbind (tn5, tn6, tn7)