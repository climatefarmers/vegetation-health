rm(list=ls())###crop NDVI to 10km buffer
require(raster)

##set working directory
setwd("C:/Temp/ClimateFarmers/")

##list full NDVI-tiles which where calculated using the script calc_NDVI_S2_L2A.R
VI_full <- list.files("D:/NDVI_Francisco/EVI/",pattern = "^EVI.*.tif$",full.names = TRUE)

##get the extent of the 10km buffer from Franciscos Farm (created in QGIS)
extent1   <- extent(shapefile("Vectordata/Francisco_10km_buffer.shp"))

##prepare mask from ESAWorldcovermap
mask <- raster("ESA_WorldCover_10m_2020_v100_N36W009_Map_UTM29.tif")
  ##classes to be excluded
  mask[mask==50] <- NA #builtup
  mask[mask==70] <- NA #snow
  mask[mask==80] <- NA #water

##run a simple raster crop to reduce the data to the extent of the 10km area
for (i in VI_full){
  #i <- VI_full[1]
  outname <- paste0("EVI_crop_mask/Buf10km_",basename(i))
  VI_cropped <- crop(raster(i),extent1) ###crop to extent
  VI_cropped[is.na(mask)] <- NA ###set builtup,snow and water to NA
  writeRaster(VI_cropped,filename = outname,datatype="INT2S")
  print(paste("product",basename(i), "cropped"))
  timestamp()
}
