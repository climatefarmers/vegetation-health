rm(list=ls())

library(raster)
library(matrixStats)
library(rgeos)
library(dplyr)

setwd("C:/Temp/ClimateFarmers/")

##load and prepare rasterdata
# get a vector of the full filenames
S2fls21 <- list.files(path = "EVI_crop_mask/",pattern = "T29SNC_2021.*.tif$",full.names = TRUE)

#create a date vector of satellite acquisition dates
dates <- matrix(unlist(strsplit(basename(S2fls21),"_")),byrow = TRUE,ncol = 9)[,9]
dates <- gsub(".tif$","",x = dates)
dates <- substr(dates,1,8)



#load the NDVI-images in rasterstack
NDVIstack <- stack(S2fls21)
#name the raster bands by variable and date
names(NDVIstack) <- paste0("NDVI_",dates)

##load vector data
# #load Francisco fields
# Franc_fields <- shapefile("Vectordata/Francisco_fields_EPSG32629.shp")
# #load10km Buffer
# Franc_buf <- shapefile("Vectordata/Francisco_10km_buffer.shp")
# #merge both
# Franc_all <- rbind(Franc_buf,Franc_fields)
# ##createanew ID column
# Franc_all$IDM <- 1:nrow(Franc_all)
# shapefile(Franc_all,"Vectordata/Francisco_all.shp")
# ##
Franc_all <- shapefile("Vectordata/Francisco_all.shp")

##get Treecover stats
TCD <- raster("TCD_2018_010m_E27N19_03035_v020.tif")
TCDval <- extract(TCD,Franc_all[2:36,]) ##exclude Buffer polygon by selecting only 2:36
TCDmean <- unlist(lapply(TCDval,mean))

Franc_all@data$TCDmean <- NA
Franc_all@data$TCDmean[2:36] <-TCDmean

Buf5 <- gBuffer(Franc_all[1,],width = -5000) ##add 5km Buffer

#plot(shp1[1,])
##extract the NDVI-values per geometry
#this usually takes some time can be minutes/hours/days depending on the CPU,Memory and amount of polygons/images
#beginCluster()
NDVI_values <- extract(NDVIstack,Franc_all[2:36,])
#endCluster()
#save extract
save(NDVI_values,file = "EVI_crop_mask/EVI21_35fields_Francisco.RData")
# ##prepare Timeseries-table
# Buf10 <- NDVI_values
# Buf5  <- NDVI_values
Buf5 <- lapply(Buf5,colMeans2,na.rm=TRUE)
Buf5 <- unlist(Buf5)
names(Buf5) <- names(NDVIstack)

Buf10 <- lapply(Buf10,colMeans2,na.rm=TRUE)
Buf10 <- unlist(Buf10)
names(Buf10) <- names(NDVIstack)

NDVI_timeseries <- lapply(NDVI_values,colMeans2,na.rm=TRUE)
NDVI_timeseries <- as.matrix(do.call("rbind",NDVI_timeseries))
colnames(NDVI_timeseries) <- names(NDVIstack)

NDVI_timeseries <- rbind(Buf10,Buf5,NDVI_timeseries)
rownames(NDVI_timeseries) <- 1:nrow(NDVI_timeseries)

NDVI_timeseries <- NDVI_timeseries[,order(dates)]

##set NDNvalues to NA
NDVI_timeseries[is.nan(NDVI_timeseries)] <- NA
NDVI_timeseries <- data.frame(NDVI_timeseries)

NDVI_timeseries$field_ID <- c(0,Franc_all$IDM)
##export table as csv
# write.table(NDVI_timeseries,file = "EVI21_Timeseries_Francisco_37zones.csv")
# NDVI <- read.table("EVI21_Timeseries_Francisco_36zones.csv")

##join info from Francisco
toj <- Franc_all@data[,c(1,2,12,13)]
colnames(toj)[3] <- "field_ID"
alldata <- left_join(x = NDVI_timeseries,toj)

#some manual changes
alldata[1,"Name"] <- "10km Buffer"
alldata[2,"Name"] <- "5km Buffer"
alldata[2,"descriptio"] <- "<NA>"
colnames(alldata)[77] <-"treecoverdensity"

#write output
write.table(alldata,file = "EVI21_Timeseries_Francisco_37zones.csv")

# shp1@data$descriptio
# shp1@data$areaha <- gArea(shp1,byid = TRUE)/10000
# 
# df1 <- data.frame(shp1@data[,c("Name","descriptio","areaha","IDM")])
# write.table(df1,file = "Atrributetable_Francisco.csv")
