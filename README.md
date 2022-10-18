# climate-change-droughts

Climate Change and Droughts in Ireland - Impacts on Agricultural Production

## R Conda environment

To run R code in a Jupyter Notebook, reate a Conda environment and install the Jupyter R kernel:

```sh
conda env create --file environment-r.yml
conda activate r-env
R -e "IRkernel::installspec()"
```

## Jupyter notebooks

Notebook | Link
--- | ---
Find closest EURO-CORDEX icell to study area | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/eurocordex-find-icell.ipynb)
SPI - historical - Cork Airport | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/eurocordex-process-spi-hist-ca.ipynb)
SPI - future - Cork Airport | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/eurocordex-process-spi-future-ca.ipynb)
SPEI - historical - Cork Airport | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/eurocordex-process-spei-hist-ca.ipynb)
SPEI - future - Cork Airport | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/eurocordex-process-spei-future-ca.ipynb)
***ISCRAES poster***
Enniscorthy EURO-CORDEX | [nbviewer](https://nbviewer.org/github/ClimAg/climate-change-droughts/blob/main/docs/enniscorthy.ipynb)

## Licence

Copyright 2022 Eva Kling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
