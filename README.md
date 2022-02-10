# Agricultural Ecosystem Health Indicator Based on Enhanced Vegetation Index 

EVI, or Enhanced Vegetation Index is a pixel-by-pixel computation performed over a raster object deriving a measure of vegetation health. This program uses Sentinel 2 Level 2A data and outputs a one year vegetation index timeseries comparison of a farm shapefile against it's surrounding area to assess comparitive agricultural health. 

## Description

### What is a Vegetation Index? 

Remote sensing indexes generally serve the purpose of chracterizing the quantity and/or condition of vegetation. Simply measuring reflected light doesn't account for temporal and atmospheric effect on solar irradiance, and therefore, one must combine data from multiple spectral bands. Based on the absorbance/reflectance profiles of healthy vegetation, these band combinations can produce a measure vegetation health. 

### What is the EVI? 

The Enhanced Vegetation Index ...
Two band EVI Sensor calibration - indexes calculated from different instruments requires recalibration, due to the vareity in detector and filter characteristics.  

### Method of Comparison! 

This set of programs pulls one year of Sentinal 2 Level 2A data and calculates the EVI of a given farm as well as of a buffer zone of a 10 km radius around the farm, subsequently performaing a temporal aggregation and comparison - calculating the yearly mean EVI for the 

Masking method: cloudmask s2 proudct and mask for buildings and water 

### Workflow 
1. wekeo_downloader.py -> download data
2. calc_evi2_s2_l2a.R -> calculate index 
3. crop_and_mask_vi_10km.R -> crop to farm buffer extent and mask non vegetation
4. extract_evi_francisco.R -> extract values per field
5. evi_mvp_analysis.R -> assess vegetation health
6. evi_viz.R -> extra script for plotting, vizualizing data, canibalization of script 5. 

### Output format and example data

evi_mvp_analysis.R gives two output csv files, one containing a few single value indicators of vegetation health, and one with the mean vegetation index of each polygon mapped to the field ID, including the landuse type. An example output is given in the folder in Francisco_Output, additionally including, a json schema (given below) to better describe the EVIMVP.csv. Example shapefile and vector data in folder Francisco_Vectordata.

```
{
  "path": "EVIMVP.csv",
  "name": "evimvp",
  "profile": "tabular-data-resource",
  "scheme": "file",
  "format": "csv",
  "hashing": "md5",
  "encoding": "utf-8",
  "schema": {
    "fields": [
      {
        "type": "number",
        "name": "All_Polygons_Mean_EVI",
        "description": "Mean EVI over all spatial samples in farm area, after masking."
      },
      {
        "type": "number",
        "name": "Buffer_Mean_EVI",
        "description": "Mean EVI over all spatial samples buffer area, after masking."
      },
      {
        "type": "number",
        "name": "%_Polygons_Over_Buffer_Mean",
        "description": "Averge percent increase of farm mean EVI over buffer EVI."
      },
      {
        "type": "number",
        "name": "%_Farm_Above_Buffer_Mean",
        "description": "Percent of polygons (given by number not field area) that are above the buffer mean EVI." 
      },
      {
        "type": "string",
        "name": "Assessment", 
        "description": "Categorize vegetation health into one of four categories based on whitepaper."
      }
    ]
  }
}
```

## Getting Started


### Dependencies

The following libraries are required:

* raster
* ggplot2
* reshape2
* data.table
* tidyr
* lubridate 

### Installing

* Install above packages 
* Can clone from: https://github.com/climatefarmers/vegetation-health/
- [ ] indicate which scripts need file path specifications, etc. 

### Executing program

- [ ] how to run the program
- [ ] step-by-step bullets.... 
- [ ] code block for commands for each file... 
```
code blocks for commands!!! 
```

## Help

- [ ] for later! add any advise for common problems or issues....
```
... add a command to run if program contains helper info
```
## Future Updates 

Intended upgrades: 
* Improved masking script 
* Correlation of output to landuse types
* Implementation of climate data to account for precipitation
* Testing against alternative S2-MODIS sensor calibration methods 
* Automation and much more.... 


## Authors

@Martin (Remote Sensing & GIS Engineer - Climate Farmers, Environment Agency Austria) - martin@climatefarmers.org\
@Victoria (Physicst & Data Engineer - Climate Farmers, German Aerospace Center - Institue for Optical & Sensor Sytems) - victoria@climatefarmers.org (hit me up with Q's!)


## Version History

* 0.1
    * Initial Release -> including some bug fixes and optimizations! 

## License

This project is licensed under the [NAME HERE] License.... see the LICENSE.md file for details

