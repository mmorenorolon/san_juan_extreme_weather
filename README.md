# San Juan Extreme Weather Analysis

This repository contains an exploratory data analysis of daily precipitation data collected at the Luis Muñoz Marín International Airport (SJU) in San Juan, Puerto Rico. The project investigates rainfall patterns and extreme weather events to support climate resilience and infrastructure planning.

## Project Overview

- **Objective:** Analyze historical precipitation data to identify trends in extreme events in San Juan.
- **Context:** Puerto Rico faces increasing climate risks, including flooding and hurricanes. Understanding local precipitation dynamics is key to adaptation strategies.

## Repository Structure
```
C:.
│   .gitignore
│   .Rhistory
│   data_exploration.qmd
│   LICENSE
│   README.md
│   sj_extreme_precipitation.Rproj
│
└───raw_data
        sju_ncei_data.csv
```
## 🧰 Tools & Technologies

- **Language:** R
- **Libraries:** `tidyverse`, `lubridate`, `ggplot2`, `here`
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



