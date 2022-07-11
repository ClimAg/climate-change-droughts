####SPI code Lattice Plot###

# #import functions
# source("functions/convert-units.R")

# install packages
install.packages("data.table")

# load libraries
library(data.table)

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

###create a new data frame###
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

#if needed : convert kgm2s in mmday
#kgm2s(df1$PRCP)

#install package
install.packages ("SPEI")
#load package
library(SPEI)

#create a list
spi6<-spi(df1$PRCP,6)

# #display the values
spi6

# create a time series from the SPI data
spi6ts <- as.data.table(spi6$fitted)

# merge the time series with the main data table
df1$SPI6 <- spi6ts
dfnew<-subset(df1, select=c(-PRCP))
head(dfnew)
# YEAR MONTH      SPI6
# 1: 1981   JAN        NA
# 2: 1981   FEB        NA
# 3: 1981   MAR        NA
# 4: 1981   APR        NA
# 5: 1981   MAY        NA
# 6: 1981   JUN 0.8447237

#reshapedata
dfnew<-dcast(df1,
      YEAR~MONTH,
      value.var=c("SPI6"))
head(dfnew)

#reset row names
dfnew<-data.frame(dfnew)
row.names(dfnew)<-dfnew$YEAR
dfnew[,1]<-NULL
str(dfnew)

###create a 3D graphic###

#Plotting matrices using the "lattice" R package

# import required libraries
library(lattice)
library(colorspace)

# set plot resolution
options(repr.plot.res = 200)

# generate a matrix from the data
m1 <- as.matrix(dfnew)

# view the matrix
m1

# #create a theme
# library(latticeExtra)
# library(RColorBrewer)
#
# myth<-lattice.options(default.theme = standard.theme(color = FALSE))
# sb <- trellis.par.get("strip.background")
# sb[["col"]][1] <- "lightred"
# myth2<-trellis.par.set("strip.background", sb)
# #
# # myTheme <- modifyList(custom.theme(region=brewer.pal(8, 'RdBu')),
# #                       list(
# #                         strip.background=list(col='blue'),
# #                         panel.background=list(col='red')))


# plot the matrix
levelplot(
  m1, par.settings=myth2,
  # col.regions = divergingx_hcl("PRGn", n = 12),
  col.regions=heat.colors(100),
  cuts = 7,
  xlab = "Year",
  ylab = "Month",
  main="Past data (1981-2010) SPI6 "
)
