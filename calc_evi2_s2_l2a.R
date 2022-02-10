rm(list=ls())
require(raster)
###function to calculate ndvi from Sentinel-2-Level2A Data (atmospherically corrected with Sen2Cor)

#@param: infile(mandatory) - Directory to zip archive. e.g.:C:/Sentinel2/S2A_MSIL2A_20210524T112111_N0300_R037_T29SNC_20210524T144151.zip
#@param: mask(mandatory) - if set to TRUE(default) all pixels which are affected by clouds, shadows and other disturbances will be set to NA
#@param: temp_dir(optional) - location where temporaryfiles will be stored if your default tempdir has enough disk space no need to set
#@param: outdir (optional) - directory where output NDVI is saved - if not set the current working directory will be set as outdir
#@param: export (mandatory) - if set to TRUE raster will be written to param outdir - False NDVI-layer will only be returned in the current session-environment
##load function
calc_evi <- function(infile,mask=TRUE,temp_dir=NULL,outdir=NULL,export=TRUE){
  ##create tempdir manually
  if(is.null(temp_dir))(temp_dir<-tempdir())
  temp_dir <- gsub("\\\\","/",temp_dir)
  if(is.null(outdir))(outdir<-getwd())
  
    ##unzip if zipped directory
  if(grepl(pattern = ".zip$",x = infile))(unzip(infile,exdir = temp_dir))
      
  RED  <- list.files(pattern = "B04_10m.jp2$",temp_dir,recursive = TRUE,full.names = TRUE)
  NIR  <- list.files(pattern = "B08_10m.jp2$",temp_dir,recursive = TRUE,full.names = TRUE)
      
  val <- 2.5*((raster(NIR)-raster(RED))/(raster(NIR)+(2.4*raster(RED))+1))
  
  if(isTRUE(mask)){
    ###masking based on sceneclassification layer: https://sentinels.copernicus.eu/web/sentinel/technical-guides/sentinel-2-msi/level-2a/algorithm
    SCL <- raster(list.files(pattern = "SCL_20m.jp2$",temp_dir,recursive = TRUE,full.names = TRUE))
    SCL <- disaggregate(SCL,fact=c(2,2))
    SCL[SCL<4] <-NA
    SCL[SCL>5] <-NA
    val[is.na(SCL)] <- NA
    val <- round(val*1000,digits = 0) ## EVI will be multplied by 1000 wih no digits to save storage space
  }
    
  if(isTRUE(export)){
    outname <- paste0(outdir,"/EVI_",gsub(pattern = ".zip",replacement = ".tif",basename(infile)))
    writeRaster(val,filename = outname,datatype="INT2S")
  }
  file.remove(list.files(temp_dir,full.names = TRUE,recursive = TRUE))
  print(paste("processing",basename(infile),"succesfull"))
  return(val)
}


##set working directory
setwd("D:/NDVI_Francisco/EVI/")

###list all Level-2A files 
S2l2a <- list.files("Y:/Projekte/Fernerkundung/0_Daten/Europe/Sentinel2/",full.names = TRUE)
i <- 2
## run NDVI-function in a loop
for(i in seq_along(S2l2a)){
  print(i)
  calc_evi(infile = S2l2a[i])
}
