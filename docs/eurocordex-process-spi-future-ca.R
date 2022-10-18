# %% [markdown]
# # SPI - Future data - Cork Airport

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

# directory where the future nc files are stored
datadir <- "./data/eurocordex/DMI/rcp85/mon/"

# %%
# process precipitation data
pr <- future_process(
    datadir = datadir, variable = "pr", indexcell = indexcell
)

# %%
head(pr)

# %%
dcast(pr, year~month, value.var = c("pr"))

# %% [markdown]
# ## SPI-12

# %%
spi <- spi_calc(data = pr, spi_num = 12)

# %%
# view the data
spi

# %%
plot_title <- paste(
    "SPI-12, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPI-6, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPI-3, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPI-1, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spi, plot_title = plot_title)
