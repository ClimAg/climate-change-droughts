###SPI from EURO-CORDEX###

##SPI code Lattice Plot###

# load libraries
library(data.table)
library(SPEI)
library(lattice)
library(latticeExtra)

##using the Eurocordex script (hist_data and rcp85_data)

#create a list
spi12<-spi(rcp85_data$pr, 12)

# #display the values
spi12

# create a time series from the SPI data
spi12ts <- as.data.table(spi12$fitted)

# merge the time series with the main data table
rcp85_data1<-rcp85_data
# # Convert numeric to month names
# my_months_name <- month.name[hist_data1$month]
# hist_data1$month<- my_months_name

#add the spi values
rcp85_data1$spi<- spi12ts

#create a data frame with 3 columns (year, month, spi values)
dfnew<-subset(rcp85_data1, select=c(month:spi))
head(dfnew)
# month year spi
# 1:  January 1976  NA
# 2: February 1976  NA
# 3:    March 1976  NA
# 4:    April 1976  NA
# 5:      May 1976  NA
# 6:     June 1976  NA


#reshapedata
dfnew<-dcast(rcp85_data1,
             year~month,
             value.var=c("spi"))
head(dfnew)

colnames(dfnew) <- c("year", month.name[rcp85_data1$month][1:12])

#reset row names
dfnew<-data.frame(dfnew)
row.names(dfnew)<-dfnew$year
dfnew[,1]<-NULL

###create a Lattice Plot###

# set plot resolution
options(repr.plot.res = 200)

# generate a matrix from the data
m1 <- as.matrix(dfnew)

# view the matrix
m1

#create spi color palette
palette_spi <- palette(c("red", "orange", "yellow", "white", "#D2B4DE", "#8E44AD", "#4A235A"))

#create a theme
myTheme <- modifyList(custom.theme(region=palette_spi),
                      list(
                        panel.background=list(col="black")))

#break color key
breaks <- c(-4, -2, -1.5, -1, 1, 1.5, 2, 4)

# plot the matrix
levelplot(
  m1,
  par.settings=myTheme,
  col.regions = palette_spi,
  at = breaks,
  # xlab ="Year",
  xlab=list(label = "Year", cex=1.5),
  ylab=list(label="Month", cex=1.5),
  main=list(label="Future data (2041-2070) SPI12",cex=2)
)

