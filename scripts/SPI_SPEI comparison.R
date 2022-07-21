####SPI_SPEI comparison code###

#import functions
source("functions/spi-spei.R")

# load libraries
library(data.table)
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

### Correlation analysis of SPI anad SPEI ###

#create matrix of correlation coefficients and p-values
#the YEAR and MONTH columns are not taken in account


mat_1 <-rcorr(as.matrix(dfall[, 3: 10]), type=c("pearson","spearman"))
mat_1

# The list object mat_1 contains three elements:
#
# r: Output of the correlation matrix
# n: Number of observation
# P: p-value

r_value <-round(mat_1[["r"]], 3)
r_value

# If we are interested in the third element, the p-value.
# It is common to show the correlation matrix with the p-value instead of the coefficient of correlation.

# p_value <-round(mat_2[["P"]], 3)
# p_value

pval <- corr.test(as.matrix(dfall[, 3: 10]), adjust="none")$p


##Corrplot
corrplot(r_value,
         method="number",
         type="upper",
         bg="white",
         tl.col="black",
         tl.srt=45,
         # col= sequential_hcl("Viridis", n = 200),
         col= diverging_hcl("Berlin", n = 200, rev = TRUE),
         # col = COL2("PuOr", 200),
         # col=c("green", "yellow"),
         is.corr = FALSE)

# corrplot(r_value,
#          type="lower",
#          add=T,
#          p.mat=pval,
#          insig="p-value",
#          tl.col="black",
#          tl.pos="n",
#          sig.level=0)


#Scatter plot

#visualisation
ggplot(dfall, aes(x = SPI1, y = SPEI12)) +
  geom_point() +
  stat_smooth()

cor(dfall$SPI1, dfall$SPEI1, use="na.or.complete")

#computation
model = lm ( SPI12 ~ SPEI12, data=dfall)
model

#regression line
ggplot(dfall, aes(y=SPI12, x=SPEI12)) +
  geom_point() +
  stat_smooth(method = lm)

#check the quality of a linear regression model
summary(model)


confint(model)


## Calculate RMSE and other values
rmse <- round(sqrt(mean(resid(model)^2)), 2)
coefs <- coef(model)
b0 <- round(coefs[1], 2)
b1 <- round(coefs[2],2)
r2 <- round(summary(model)$r.squared, 2)

eqn <- bquote(italic(y) == .(b0) + .(b1)*italic(x) * "," ~~
                r^2 == .(r2) * "," ~~ RMSE == .(rmse))

## Plot the data
plot( SPI12 ~ SPEI12, data=dfall)
abline(model)
text(-1, 1, eqn, pos = 4)
