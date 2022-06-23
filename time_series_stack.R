# install packages
install.packages("readxl")
install.packages("data.table")

# load libraries
library(readxl)
library(data.table)

# read data
data <- read_excel("data/nasa1.xlsx")

# view first few rows of data
head(data)
# # A tibble: 6 × 14
#   PARAMETER  YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT
#   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1 T2M_MAX    1981  11.0  11.6  14.6  15.6  18.1  21.5  21.9  21.5  21.3  15.1
# 2 T2M_MAX    1982  11.9  12.3  11.2  16.3  18.8  18.5  22.0  22.3  20.3  15.5
# 3 T2M_MAX    1983  12.2  10.5  13.4  12.0  15.7  21.6  26.8  22.8  19.2  17.4
# 4 T2M_MAX    1984  11.7  10.8  11.4  16.1  17.8  22.6  23.4  21.7  21.1  17.1
# 5 T2M_MAX    1985  10.4  11.3  11.6  14.3  17.2  18.5  20.7  18.8  19.9  17.4
# 6 T2M_MAX    1986  11.3   5.4  11.7  12.9  17.4  22.7  23    19.2  17.7  17.6
# # … with 2 more variables: NOV <dbl>, DEC <dbl>

# convert to data table
data <- as.data.table(data)

# view data
head(data)
#    PARAMETER YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT
# 1:   T2M_MAX 1981 11.01 11.55 14.64 15.58 18.08 21.53 21.86 21.48 21.26 15.13
# 2:   T2M_MAX 1982 11.87 12.30 11.22 16.28 18.80 18.52 22.01 22.34 20.33 15.46
# 3:   T2M_MAX 1983 12.15 10.53 13.44 11.98 15.70 21.55 26.75 22.82 19.15 17.44
# 4:   T2M_MAX 1984 11.74 10.76 11.40 16.14 17.76 22.58 23.43 21.71 21.08 17.10
# 5:   T2M_MAX 1985 10.38 11.32 11.59 14.27 17.24 18.51 20.72 18.76 19.86 17.39
# 6:   T2M_MAX 1986 11.29  5.40 11.69 12.90 17.40 22.70 23.00 19.22 17.73 17.55
#      NOV   DEC
# 1: 14.24 11.15
# 2: 13.55 11.20
# 3: 14.41 12.23
# 4: 12.64 11.49
# 5: 12.90 13.41
# 6: 13.11 13.08

# remove first column
data <- data[, -1]

# view data
head(data)
#    YEAR   JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT   NOV   DEC
# 1: 1981 11.01 11.55 14.64 15.58 18.08 21.53 21.86 21.48 21.26 15.13 14.24 11.15
# 2: 1982 11.87 12.30 11.22 16.28 18.80 18.52 22.01 22.34 20.33 15.46 13.55 11.20
# 3: 1983 12.15 10.53 13.44 11.98 15.70 21.55 26.75 22.82 19.15 17.44 14.41 12.23
# 4: 1984 11.74 10.76 11.40 16.14 17.76 22.58 23.43 21.71 21.08 17.10 12.64 11.49
# 5: 1985 10.38 11.32 11.59 14.27 17.24 18.51 20.72 18.76 19.86 17.39 12.90 13.41
# 6: 1986 11.29  5.40 11.69 12.90 17.40 22.70 23.00 19.22 17.73 17.55 13.11 13.08

# stack columns to create a time series
data <- melt(data, id.vars = c("YEAR"), variable.name = "MONTH")

# view data
head(data)
#    YEAR MONTH value
# 1: 1981   JAN 11.01
# 2: 1982   JAN 11.87
# 3: 1983   JAN 12.15
# 4: 1984   JAN 11.74
# 5: 1985   JAN 10.38
# 6: 1986   JAN 11.29

# sort by year, then by month
data <- data[order(data$YEAR),]

# view data
head(data)
#    YEAR MONTH value
# 1: 1981   JAN 11.01
# 2: 1981   FEB 11.55
# 3: 1981   MAR 14.64
# 4: 1981   APR 15.58
# 5: 1981   MAY 18.08
# 6: 1981   JUN 21.53
