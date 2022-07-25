####SPI_SPEI comparison code###

#import functions
source("functions/spi-spei.R")

# load libraries
library(data.table)
library(lubridate)
library(SPEI)
library(Hmisc)
library(GGally)
library(ggcorrplot)
library(corrplot)
library(colorspace)


spi1data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 1)
spei1data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 1, lat = 51.847)

spi3data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 3)
spei3data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 3, lat = 51.847)

spi6data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 6)
spei6data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 6, lat = 51.847)

spi12data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 12)
spei12data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 12, lat = 51.847)

dfall <- subset(spi6data, select=c(YEAR, MONTH))
dfall<-cbind(dfall,
             spi1data[, ncol(spi1data), drop = FALSE], spei1data[, ncol(spei1data), drop = FALSE],
             spi3data[, ncol(spi3data), drop = FALSE], spei3data[, ncol(spei3data), drop = FALSE],
             spi6data[, ncol(spi6data), drop = FALSE], spei6data[, ncol(spei6data), drop = FALSE],
             spi12data[, ncol(spi12data), drop = FALSE], spei12data[, ncol(spei12data), drop = FALSE])
dfall

# ### Correlation analysis of SPI anad SPEI ###
#
# #create matrix of correlation coefficients and p-values
# #the YEAR and MONTH columns are not taken in account
#
#
# mat_1 <-rcorr(as.matrix(dfall[, 3: 10]), type=c("pearson","spearman"))
# mat_1
#
# # The list object mat_1 contains three elements:
# #
# # r: Output of the correlation matrix
# # n: Number of observation
# # P: p-value
#
# r_value <-round(mat_1[["r"]], 3)
# r_value
#
# # If we are interested in the third element, the p-value.
# # It is common to show the correlation matrix with the p-value instead of the coefficient of correlation.
#
# # p_value <-round(mat_2[["P"]], 3)
# # p_value
#
#
# ##Corrplot
# corrplot(r_value,
#          method="number",
#          type="upper",
#          bg="white",
#          tl.col="black",
#          tl.srt=45,
#          col= diverging_hcl("Berlin", n = 200, rev = TRUE),
#          is.corr = FALSE)
#
### Linear Regression Analysis ###

# #Scatter plot
#
# #coefficient correlation
# cor(dfall$SPI6, dfall$SPEI6, use="na.or.complete")
#
# #computation
# model = lm ( SPI6 ~ SPEI6, data=dfall)
# model
#
# #regression line
# ggplot(dfall, aes(y=SPI6, x=SPEI6)) +
#   geom_point() +
#   stat_smooth(method = lm)
#
# #check the quality of a linear regression model
# summary(model)
#
# #display the confidence interval (CI 95%)
# confint(model)
#
# ## Calculate RMSE and other values
# rmse <- round(sqrt(mean(resid(model)^2)), 2)
# coefs <- coef(model)
# b0 <- round(coefs[1], 2)
# b1 <- round(coefs[2],2)
# r2 <- round(summary(model)$r.squared, 2)
#
# eqn <- bquote(italic(y) == .(b0) + .(b1)*italic(x) * "," ~~
#                 r^2 == .(r2) * "," ~~ RMSE == .(rmse))
#
# ## Plot the data
# plot( SPI6 ~ SPEI6, data=dfall)
# abline(model)
# text(-1, 1, eqn, pos = 4)

### Comparison SPI12 and SPEI12 ###

# create a date column using the year and month
dfall$DATE <- paste(as.character(dfall$YEAR), as.character(dfall$MONTH), as.character(01))
dfall$DATE <- ymd(dfall$DATE)
class(dfall$DATE)

# set locale to English
Sys.setlocale("LC_TIME", "English")

# # convert to datetime format
dfall$DATE <- as.Date(dfall$DATE, format = "%Y %b %d")

###create a graphic###
# Make the window wider than taller
#windows(width = 4.5, height = 3)

plot.new()

# Save current graphical parameters
# opar <- par(no.readonly = TRUE)

# # Change the margins of the plot (the fourth is the right margin)
#par(mar = c(5, 5, 4, 10))

plot(dfall$DATE, dfall$SPI12, type = "l", xlab = "Year", ylab = "SPI/SPEI",main="Past Data (1981-2010) SPI-12 (green) and SPEI-12 (black) comparison", col="seagreen3")
par(new=TRUE)
lines(dfall$DATE, dfall$SPEI12)
lines(dfall$DATE, rep(-1, times = length(dfall$YEAR)), col = "yellow", lwd=2)
lines(dfall$DATE, rep(-1.5, times = length(dfall$YEAR)), col = "orange", lwd=2)
lines(dfall$DATE, rep(-2, times = length(dfall$YEAR)), col = "red", lwd=2)

legend("topleft",
       #inset = c(-1, 0), # You will need to fine-tune the first
       # value depending on the windows size
       #6.5, 0,
       legend = c("Moderately dry", "Very dry", "Extremely dry"),
       col = c("yellow", "orange", "red"),
       lty = c(1, 1, 1),
       bg=rgb(1,0,0, alpha=0.15),
       cex=0.7,
       #xpd = TRUE
       )

# on.exit(par(opar))
