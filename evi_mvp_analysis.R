### EVI ANALYSIS ###

#MVP approach:
#1. Data processing: clean & reduce data dimensionality 
#2. Calculate mean EVI 
#3. Detect all polygons below mean
#4. Export dataframes  

#@param: farm - mean evi over all farm polygons, calculated in previous steps
#@param: buffer - mean evi over buffer area, calculated in previous steps

#Note on "assessmemt": 
#Assessment given according to Climate Farmers co-benefits whitepaper: 
# In need of improvement: <10%: lower than the average evi of the reference point
# Adequate: Interval of +/- 10% the average evi of the reference point
# Good: 10-25% higher than the evi of the reference point
# Exemplary: >25% higher than the evi of the reference point

################################ Libraies ######################################

#libraies 
library(ggplot2)
library(reshape2)
library(data.table)
library(tidyverse)
library(tidyr)
library(lubridate)

################################ 1. Data Processing ######################################

rm(list=ls())  
data2 <- fread("/Users/vic/Documents/ClimateFarmers/Franc_prj/EVI21_Timeseries_Francisco_37zones.csv")

#converts incoming data to longdata frame format, eliminate cells with NA values
df.EVI <- pivot_longer(data2,
                       cols = 2:75, # !!! change col numbers according to size of incoming csv!!! 
                       names_to = "Date", 
                       values_to = "EVI", 
                       values_drop_na = TRUE,
)

#adjust scale (arbitrary - to save space)
df.EVI %>%
  mutate(EVI = EVI / 1000) 

#reformat date, read string as date, write "nicely"
df.EVI$Date <- (gsub('NDVI_', '', df.EVI$Date)) 
df.EVI$Date <- 
  strptime(df.EVI$Date, format = "%Y%m%d") %>%
  as.Date(df.EVI$Date)

################################ Mean EVI polygons vs Buffer ######################################

#generate two dataframes - one for the farm and one for the bufffer
farm.only.evi <- df.EVI %>% filter(V1 != 1) 
buffer.evi <- subset(df.EVI, V1 == "1") 
buffer.evi[, c(1:2)] <- NULL 

#mean EVI and comparison with buffer 
buffer.mean.evi <- mean(buffer.evi$EVI, na.rm = T) 
EVI.means <- (rowMeans(data2[ , c(2:74)], na.rm = T) / 1000) # !!! also csv size dependent 
farm.mean.evi <- mean(EVI.means) # singular output 

#function finds acceptable range according to previous white paper
assessment <- function(farm, buffer){
  percent_change <<- ((farm - buffer) / farm) * 100
  if (percent_change  <= -10) { 
    evaluation <<- "Needs Improvement"
  }
  if (percent_change >= -10 & percent_change <= 10){ 
    evaluation <<-- "Acceptable"
  }
  if (percent_change >= 10 & percent_change <= 25){ 
    evaluation <<- "Good"
  }
  else {
    evaluation <<- "Exemplary"
  }
  return(evaluation)
  
}
eval <- assessment(farm.mean.evi, buffer.mean.evi)
percent_increase <- function(farm,buffer){
  ((farm - buffer) / farm) * 100 
} 
evi.inc <- percent_increase(farm.mean.evi,buffer.mean.evi)

################################ Detect all polygons below mean ######################################

# EVI ratios
EVI.ratios <- EVI.means/buffer.mean.evi 

#new dataframe -> with the name, descripto, and EVI ratios
df.land <- cbind(data2$Name, data2$descriptio, EVI.means, EVI.ratios) %>% 
  as.data.frame() %>% 
#  mutate(EVI.ratios = as.numeric(EVI.ratios)) %>% 
  setNames(c("Names", "Land_Cover_Type", "Mean_EVI", "Ratios")) 
df.land$Ratios <- as.numeric(levels(df.land$Ratios))[as.integer(df.land$Ratios)]

#assess if polygon above or below buffer mean EVI
df.land <- df.land %>%
  add_column(Acceptable_Polygon = if_else(.$Ratios > 1, TRUE, FALSE)) %>% 
  subset(select = -c(Ratios))

#%polygons above mean
poly.percent <- (length(which(df.land$Acceptable_Polygon == TRUE))/length(df.land$Acceptable_Polygon))*100

################################ Final Dataframes -> Export as csv ######################################

#MVP df with: mean.evi farm, mean evi buffer % increase over buffer assment
df.total.mean <- cbind(farm.mean.evi, buffer.mean.evi, poly.percent, evi.inc, eval) %>% 
  as.data.frame() %>% 
  setNames(c("All_Polygons_Mean_EVI", "Buffer_Mean_EVI", "%_Polygons_Over_Buffer_Mean","%_Farm_Above_Buffer_Mean", "Assessment"))

#export MVP files as csv 
write.csv(df.total.mean,"/Users/vic/Documents/ClimateFarmers/Franc_prj/EVIMVP.csv", row.names = FALSE)
write.csv(df.land,"/Users/vic/Documents/ClimateFarmers/Franc_prj/EVIMVPstats.csv", row.names = FALSE)

