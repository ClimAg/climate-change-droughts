# climate-change-droughts

Conda environment (specifications are defined in `environment.yml`):

```sh
conda env create
conda activate ClimAgR
```

To launch an R console, open a terminal and type `R`, or `Rterm` on Windows. In the R console, run the following to install the language server and the R kernel spec for Jupyter Lab:

```r
install.packages("languageserver")
IRkernel::installspec()
```
