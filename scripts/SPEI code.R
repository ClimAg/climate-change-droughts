####SPEI code###

# #import functions
# source("functions/convert-units.R")

# load libraries
library(data.table)
library(SPEI)

#import data in data
df <- read.table("./data/nasa(81-10).csv", quote = "\"", sep=";", header=T, dec=".")

# view first 6 rows of data
head(df)
# PARAMETER YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT   NOV   DEC   ANN
# 1   T2M_MAX 1981 11.01 11.55 14.64 15.58 18.08 21.53 21.86 21.48 21.26 15.13 14.24 11.15 21.86
# 2   T2M_MAX 1982 11.87 12.30 11.22 16.28 18.80 18.52 22.01 22.34 20.33 15.46 13.55 11.20 22.34
# 3   T2M_MAX 1983 12.15 10.53 13.44 11.98 15.70 21.55 26.75 22.82 19.15 17.44 14.41 12.23 26.75
# 4   T2M_MAX 1984 11.74 10.76 11.40 16.14 17.76 22.58 23.43 21.71 21.08 17.10 12.64 11.49 23.43
# 5   T2M_MAX 1985 10.38 11.32 11.59 14.27 17.24 18.51 20.72 18.76 19.86 17.39 12.90 13.41 20.72
# 6   T2M_MAX 1986 11.29  5.40 11.69 12.90 17.40 22.70 23.00 19.22 17.73 17.55 13.11 13.08 23.00

# convert to data table
df <- as.data.table(df)

#create a new data frame
  #extract only precipitation data "PRECTOTCORR" between YEAR et DEC
df1<-subset(df, PARAMETER== "PRECTOTCORR", select=c(YEAR:DEC))

  # stack columns to create a time series
df1<-melt(df1, id.vars=c("YEAR"), variable.name="MONTH")

  #sort by years, then by months
df1<-df1[order(df1$YEAR),]

#reset row names
row.names(df1)<-NULL

  #name the third column"PRCP"
colnames(df1)[3]<-"PRCP"

  # view first 5 rows of data in proper format
head(df1)
# YEAR MONTH PRCP
# 1: 1981   JAN 1.37
# 2: 1981   FEB 2.80
# 3: 1981   MAR 5.95
# 4: 1981   APR 1.11
# 5: 1981   MAY 5.35
# 6: 1981   JUN 2.41

#if needed : convert kgm2s to mmday :
#kgm2s (df1$PRCP)

#create maximal temperature vector
df2<-subset(df, PARAMETER== "T2M_MAX", select=c(YEAR:DEC))
df2<-melt(df2, id.var="YEAR", variable.name="MONTH")
df2<-df2[order(df2$YEAR),]
colnames(df2)[3]<-"TMAX"
df2<-subset(df2, select = c(-YEAR, -MONTH))

#view the 6 first rows
head(df2)
# Tmax
# 1: 11.01
# 2: 11.55
# 3: 14.64
# 4: 15.58
# 5: 18.08
# 6: 21.53

#if needed : convert K to °C :
#kelvin_to_celsuis(df2$TMAX)

#create minimal temperature vector
df3<-subset(df, PARAMETER== "T2M_MIN", select=c(YEAR:DEC))
df3<-melt(df3, id.var="YEAR", variable.name="MONTH")
df3<-df3[order(df3$YEAR),]
colnames(df3)[3]<-"TMIN"
df3<-subset(df3, select = c(-YEAR, -MONTH))

#view the 6 first rows
head(df3)
# Tmin
# 1: -0.51
# 2: -0.62
# 3:  0.33
# 4:  0.71
# 5:  2.47
# 6:  6.72

#if needed : convert K to °C :
#kelvin_to_celsuis(df3$TMIN)

# combine vectors to data frame
df1<-cbind(df1,df2,df3)
head(df1)
# YEAR MONTH PRCP  Tmax  Tmin
# 1: 1981   JAN 1.37 11.01 -0.51
# 2: 1981   FEB 2.80 11.55 -0.62
# 3: 1981   MAR 5.95 14.64  0.33
# 4: 1981   APR 1.11 15.58  0.71
# 5: 1981   MAY 5.35 18.08  2.47
# 6: 1981   JUN 2.41 21.53  6.72

#PET calculation
df1$PET<-hargreaves(Tmin=df1$TMIN,Tmax=df1$TMAX, lat=52.164)

#water balance calculation
WBal<-df1$PRCP-df1$PET

#create a list
spei6<-spei(WBal,6)

#display the values
spei6

# create a time series from the SPI data
spie6ts <- as.data.table(spei6$fitted)

# merge the time series with the main data table
df1$SPI6 <- spie6ts

# create a date column using the year and month
df1$DATE <- paste(as.character(df1$YEAR), as.character(df1$MONTH), as.character(01))

# set locale to English
Sys.setlocale("LC_TIME", "English")

# convert to datetime format
df1$DATE <- as.Date(df1$DATE, format = "%Y %b %d")

###create a graphic###
# # Make the window wider than taller
# windows(width = 3.5, height = 3)

# Save current graphical parameters
#opar <- par(no.readonly = TRUE)

# # Change the margins of the plot (the fourth is the right margin)
# par(mar = c(5, 5, 4, 8))

###create a graphic###

plot.new()

plot(df1$DATE, df1$SPI6, type = "l", xlab = "Year", ylab = "SPEI",main="Past Data (1981-2010) SPEI6")
lines(df1$DATE, rep(-1, times = length(df1$YEAR)), col = "yellow")
lines(df1$DATE, rep(-1.5, times = length(df1$YEAR)), col = "orange")
lines(df1$DATE, rep(-2, times = length(df1$YEAR)), col = "red")

legend("topleft",
       #inset = c(-0.45, 0), # You will need to fine-tune the first
       # value depending on the windows size
       legend = c("Moderately dry", "Very dry", "Extremely dry"),
       col = c("yellow", "orange", "red"),
       lty = c(1, 1, 1),
       bg=rgb(1,0,0, alpha=0.15),
       cex=0.7
       # xpd = TRUE
) # You need to specify this graphical parameter to
# put the legend outside the plot
# Back to the default graphical parameters
#on.exit(par(opar))
