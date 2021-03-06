# Agricultural Ecosystem Health Indicator Based on Enhanced Vegetation Index 

EVI, or Enhanced Vegetation Index is a pixel-by-pixel computation performed over a raster object deriving a measure of vegetation health. This program uses Sentinel 2 Level 2A data and outputs a one year vegetation index timeseries comparison of a farm shapefile against it's surrounding area to assess comparitive agricultural health. 

## Description

### What is a Vegetation Index? (DONE) 

Remote sensing indexes generally serve the purpose of chracterizing the quantity and/or condition of vegetation. Simply measuring reflected light doesn't account for temporal and atmospheric effect on solar irradiance, and therefore, one must combine data from multiple spectral bands. Based on the absorbance/reflectance profiles of healthy vegetation, these band combinations can produce a measure vegetation health. 


### What is the EVI? 

The Enhanced Vegetation Index (EVI) is a measure of vegetation health based off red, near infrared and sometimes blue reflected spectra. The EVI shares many similarities with the well known index, NDVI (normalized difference vegetation index), and often garners comparable results. The NDVI, however, is plagued by fluctuations induced by atmospheric conditions and soil background effects, limiting its applicability accross varied biomes (Matssushita et. al 2007). In comparison, EVI possesses a higher degree of linear correlation with green leaf area index (LAI) in crop fields (Boegh et al., 2002), and a lower tendency to saturate in temperate and tropical forests (Xiao et al., 2004).  

While there is no singular equation for the EVI, they can be divided into two categroies: the two band or the three band approach. The original EVI - developed for MODIS - employed three spectral bands, but as many earth observation spectrometers lack a blue spectral channel, the two band approach doesn't make use of the blue band. 

These programs use the two band EVI, with indexes calculated to 

- [ ] MODIS to S2 sensor calibration - indexes calculated from different instruments requires recalibration, due to the vareity in detector and filter characteristics.....  


EVI=  2.5*(NIR-RED)/NIR+(2.4*RED)+1
for masking I used the esa-worldcovermap and excluded builtup, water and snow (doesnt ocur anyway)





### Method of Comparison! 

- [ ] This set of programs pulls one year of Sentinal 2 Level 2A data and calculates the EVI of a given farm as well as of a buffer zone of a 10 km radius around the farm, subsequently performaing a temporal aggregation and comparison - calculating the yearly mean EVI for the.... 

- [ ] Masking method: cloudmask s2 proudct and mask for buildings and water 

### Workflow 
1. wekeo_downloader.py -> download data
2. calc_evi2_s2_l2a.R -> calculate index 
3. crop_and_mask_vi_10km.R -> crop to farm buffer extent and mask non vegetation
4. extract_evi_francisco.R -> extract values per field
5. evi_mvp_analysis.R -> assess vegetation health
6. evi_viz.R -> extra script for plotting, vizualizing data, canibalization of script 5. 

### Output format and example data

evi_mvp_analysis.R gives two output csv files, one containing a few single value indicators of vegetation health, and one with the mean vegetation index of each polygon mapped to the field ID, including the landuse type. An example output is given in the folder in Francisco_Output, additionally including, a JSON schema (given below) to better describe the EVIMVP.csv. Example shapefile and vector data in folder Francisco_Vectordata.

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



**Citations**: 

(https://pubmed.ncbi.nlm.nih.gov/28903251/)
Matsushita B, Yang W, Chen J, Onda Y, Qiu G. Sensitivity of the Enhanced Vegetation Index (EVI) and Normalized Difference Vegetation Index (NDVI) to Topographic Effects: A Case Study in High-density Cypress Forest. Sensors (Basel). 2007 Nov 5;7(11):2636-2651. doi: 10.3390/s7112636. PMID: 28903251; PMCID: PMC3965234.

## License

This project is licensed under the [NAME HERE] License.... see the LICENSE.md file for details

