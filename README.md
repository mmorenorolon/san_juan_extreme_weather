# San Juan Extreme Weather Analysis

This repository contains the full documentation for my Statistics in Environmental Data Science (EDS222) final project, which explores trends in extreme precipitation events at the Luis Muñoz Marín International Airport (SJU) in San Juan, Puerto Rico. The analysis uses a Negative Binomial statistical model and large-scale climate indices to understand how extreme rainfall has changed over the past 50 years.

## Project Overview

Research Question: Have extreme precipitation events increased in San Juan over the last 50 years?

Key Findings: The long-term trend in extreme precipitation is small compared to the influence of climate variability, especially Tropical North Atlantic sea surface temperatures.

## Repository Structure
```
C:.
│   .gitignore
│   .Rhistory
│   data_exploration.qmd
|   paper.qmd
|   DAG.qmd
│   LICENSE
│   README.md
│   sj_extreme_precipitation.Rproj
│
└───raw_data
        sju_ncei_data.csv
        MONTHLY_ENSO_INDEX.csv
        NAO_INDEX.csv
        TNA_SST.csv
```
## 🧰 Tools & Technologies

- **Language:** R
- **Libraries:** `tidyverse`, `lubridate`, `ggplot2`, `kableExtra`, `broom`, `MASS` 
- **Platform:** RStudio, GitHub

## Data Source
### Daily Precipitation from SJU
Daily precipitation data for San Juan, Puerto Rico, were obtained from the NOAA National Centers for Environmental Information through the GHCN‑Daily archive for the [San Juan International Airport station](https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:RQW00011641/detail). 

### Atlantic Sea Surface Temperatures
Large‑scale climate variability was represented using three NOAA climate indices. Atlantic sea‑surface temperature anomalies were taken from the Tropical North Atlantic (TNA) index provided by the [NOAA Physical Sciences Laboratory](https://psl.noaa.gov/data/correlation/tna.data).

### El Niño Southern Oscillation
ENSO conditions were characterized using the Oceanic Niño Index (ONI) from the [NOAA Climate Prediction Center](https://www.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_change.shtml). 

### North Atlantic Oscillation

North Atlantic atmospheric variability was captured using the CPC’s monthly [NAO index](https://www.cpc.ncep.noaa.gov/data/teledoc/nao.shtml)



