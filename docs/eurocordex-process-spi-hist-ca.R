# %% [markdown]
# # SPI - Historical data - Cork Airport

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

# %%
# Cork Airport grid cell
indexcell <- 68801

# directory where the historical nc files are stored
datadir <- "./data/eurocordex/DMI/historical/mon/"

# %%
# process precipitation data
pr <- hist_process(datadir = datadir, variable = "pr", indexcell = indexcell)

# %%
head(pr)

# %%
dcast(pr, year~month, value.var = c("pr"))

# %% [markdown]
# ## SPI-12

# %% [markdown]
# ### Arguments
#
# - kernel: unshifted rectangular kernel
# - distribution: gamma
# - fit: unbiased probability weighted moments

# %%
spi <- spi_calc(data = pr, spi_num = 12)

# %%
# view the data
spi

# %%
plot_title <- paste(
    "SPI-12, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ### Arguments
#
# - kernel: unshifted rectangular kernel
# - distribution: PearsonIII (non-default)
# - fit: unbiased probability weighted moments

# %%
spi <- spi_calc(data = pr, spi_num = 12, distribution = "PearsonIII")

# %%
plot_title <- paste(
    "SPI-12, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ### Arguments
#
# - kernel: unshifted rectangular kernel
# - distribution: log-Logistic (non-default)
# - fit: unbiased probability weighted moments

# %%
spi <- spi_calc(data = pr, spi_num = 12, distribution = "log-Logistic")

# %%
plot_title <- paste(
    "SPI-12, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ## SPI-6

# %%
spi <- spi_calc(data = pr, spi_num = 6)

# %%
# view the data
spi

# %%
plot_title <- paste(
    "SPI-6, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ## SPI-3

# %%
spi <- spi_calc(data = pr, spi_num = 3)

# %%
# view the data
spi

# %%
plot_title <- paste(
    "SPI-3, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ## SPI-1

# %%
spi <- spi_calc(data = pr, spi_num = 1)

# %%
# view the data
spi

# %%
plot_title <- paste(
    "SPI-1, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ## Validation
#
# Monthly historical Cork Airport data from Met Éireann: <https://www.met.ie/climate/available-data/historical-data>
#
# Direct download link:
#
# - Data from 1961 to present: <https://cli.fusio.net/cli/climate_data/webdata/mly3904.zip>

# %%
# read data
pr <- readLines("./data/met/raw/meteireann/corkairport/mly3904/mly3904.csv")
# https://stackoverflow.com/a/15860268
pr <- pr[-1:-19]
pr <- read.csv(
    textConnection(pr), header = TRUE, stringsAsFactors = FALSE
)

# %%
head(pr)

# %%
# filter for the past data range
pr <- subset(pr, year < 2006 & year > 1975)

# %%
# keep only precipitation data
pr <- subset(pr, select = c(year, month, rain))

# %%
# rename rain column to pr
colnames(pr)[3] <- "pr"

# %%
head(pr)

# %%
# convert precipitation to mm/day
# https://stackoverflow.com/a/42045514
pr$pr <- pr$pr/days_in_month(paste(pr$year, "-", pr$month, "-15", sep = ""))

# %%
# convert month format
pr$month <- month(pr$month, label = TRUE)

# %%
# sort data
pr <- pr[order(pr$year, pr$month),]

# %%
# reset row names
rownames(pr) <- NULL

# %%
# convert to data table
pr <- as.data.table(pr)

# %%
dcast(pr, year~month, value.var = c("pr"))

# %% [markdown]
# ### SPI-12

# %%
spi <- spi_calc(data = pr, spi_num = 12)

# %%
spi

# %%
plot_title <- "SPI-12, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ### SPI-6

# %%
spi <- spi_calc(data = pr, spi_num = 6)

# %%
spi

# %%
plot_title <- "SPI-6, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ### SPI-3

# %%
spi <- spi_calc(data = pr, spi_num = 3)

# %%
spi

# %%
plot_title <- "SPI-3, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spi, plot_title = plot_title)

# %% [markdown]
# ### SPI-1

# %%
spi <- spi_calc(data = pr, spi_num = 1)

# %%
spi

# %%
plot_title <- "SPI-1, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spi, plot_title = plot_title)
