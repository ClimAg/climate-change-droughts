###code fonctionnel####
# install packages
install.packages("readxl")
install.packages("reshape2")

# load libraries
library(readxl)
library(reshape2)

# read data
data <- read_excel("~/Downloads/nasa1.xlsx")

# view first five rows of data
nasa1[1:5,]
# # A tibble: 5 × 14
#   PARAMETER  YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT
#   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1 T2M_MAX    1981  11.0  11.6  14.6  15.6  18.1  21.5  21.9  21.5  21.3  15.1
# 2 T2M_MAX    1982  11.9  12.3  11.2  16.3  18.8  18.5  22.0  22.3  20.3  15.5
# 3 T2M_MAX    1983  12.2  10.5  13.4  12.0  15.7  21.6  26.8  22.8  19.2  17.4
# 4 T2M_MAX    1984  11.7  10.8  11.4  16.1  17.8  22.6  23.4  21.7  21.1  17.1
# 5 T2M_MAX    1985  10.4  11.3  11.6  14.3  17.2  18.5  20.7  18.8  19.9  17.4
# # … with 2 more variables: NOV <dbl>, DEC <dbl>

# remove first column
nasa1<- nasa1[,-1]

# stack columns to create a time series
nasa1 <- melt(nasa1, id.var = "YEAR", variable.name = "MONTH")

# view first five rows of data
nasa1[1:5,]
#   YEAR MONTH value
# 1 1981   JAN 11.01
# 2 1982   JAN 11.87
# 3 1983   JAN 12.15
# 4 1984   JAN 11.74
# 5 1985   JAN 10.38

# sort by year, then by month
nasa1 <- nasa1[order(nasa1$YEAR),]

# reset row names
row.names(nasa1) <- NULL

# view first five rows of data
#   YEAR MONTH value
# 1 1981   JAN 11.01
# 2 1981   FEB 11.55
# 3 1981   MAR 14.64
# 4 1981   APR 15.58
# 5 1981   MAY 18.08