##IMPACT OF WILD FIRES ON THE VEGETATION IN GALICIA AND NORTHERN PORTUGAL

##installation of packages:
#to read the Copernicus data it is needed to use "" since the data is imported external to R.
install.packages("ncdf4") 
#recalling the installed package using the library function 
library(ncdf4)

#create graphics 
install.packages("ggplot2")
library(ggplot2)

#remote sensing image processing 
install.packages("RStoolbox")
library(RStoolbox)

#pretty color plots
install.packages("viridis")
library(viridis)

#manipulate spatial data
library(raster)


##Setting the working directory and importing all the used data (source of the data: https://land.copernicus.vgt.vito.be/PDF/portal/Application.html#Home)
setwd("C:/R LAB/")
#Burnt Area
ba17 <- raster("c_gls_BA300_201708100000_GLOBE_PROBAV_V1.0.1.nc")
ba18 <- raster("c_gls_BA300_201808100000_GLOBE_PROBAV_V1.0.1.nc")
ba19 <- raster("c_gls_BA300_201908100000_GLOBE_PROBAV_V1.1.1.nc")
ba20 <- raster("c_gls_BA300_202008100000_GLOBE_PROBAV_V1.1.1.nc")
ba21 <- raster("c_gls_BA300_202108100000_GLOBE_S3_V1.2.1.nc")
ba22 <- raster("c_gls_BA300_202205100000_GLOBE_S3_V1.2.1.nc")
#NDVI
ndvi17 <- raster("c_gls_NDVI300_201701010000_GLOBE_PROBAV_V1.0.1.nc")
ndvi22 <- raster("c_gls_NDVI300_202201010000_GLOBE_OLCI_V2.0.1.nc")
#Fcover
fc17 <- raster("c_gls_FCOVER-RT6_201706300000_GLOBE_PROBAV_V2.0.1.nc")
fc20 <- raster("c_gls_FCOVER-RT0_202006300000_GLOBE_PROBAV_V2.0.1.nc")
#fc20 #example to look at the data

##Cropping the global data into only the north western part of iberian peninsula.
ext <- c(-10,-6,40,44) #quantifying the extend. (Longitude, Latitude)

ba17 <- crop(ba17, ext) #apply the extend on the data
ba18 <- crop(ba18, ext)
ba19 <- crop(ba19, ext)
ba20 <- crop(ba20, ext)
ba21 <- crop(ba21, ext)
ba22 <- crop(ba22, ext)

ndvi17 <- crop(ndvi17, ext)
ndvi22 <- crop(ndvi22, ext)

fc17 <- crop(fc17, ext)
fc20 <- crop(fc20, ext)

##plotting the burnt area data next to each other
#establishing a suitable color palette (redish colors because of fire, the brackets at the end defines the number of colors generated)
CLF <- colorRampPalette(c("yellow", "red", "darkred"))(100)

#plotting the images next to eachother using the par function 
jpeg('Burnt Area 2017 to 2022') #safe plot as jpeg image. Since the crated image is too small, i will use the export "save to image" function in the plot window 
par(mfrow=c(2,3))               #number in brackets define number of rows,colums
plot(ba17, col=CLF, main="Burnt Areas summer 2017")
plot(ba18, col=CLF, main="Burnt Areas summer 2018")
plot(ba19, col=CLF, main="Burnt Areas summer 2019")
plot(ba20, col=CLF, main="Burnt Areas summer 2020")
plot(ba21, col=CLF, main="Burnt Areas summer 2021")
plot(ba22, col=CLF, main="Burnt Areas spring 2022") # here the data from spring was used, because the data for summer 2022 is not avaiable yet

dev.off() #cleans the plot window in R, ready for the next plot

##plotting the NDVI data next to eachother. Same procedure as for burnt areas

#creating new fitting color palette using the "greenbrown" package. See more at: https://rdrr.io/rforge/greenbrown/src/R/brgr.colors.R
NC <- colorRampPalette(c("chocolate4", "orange", "yellow", "grey", "green", "forestgreen", "darkgreen"))(100)

par(mfrow=c(1,2))
plot(ndvi17, col=NC, main="NDVI 2014")
plot(ndvi22, col=NC, main="NDVI 2022")

dev.off()

##Creating plots for the Fcover data in the same way as for the NDVI above
#creating new color palette for Fcover using HEX codes and saving them
CLF2 <- colorRampPalette(c("#ADFF2F", "#7FFF00", "#32CD32", "#228B22", "#008000", "#006400"))(100)
par(mfrow=c(1,2))
plot(fc17, col=CLF2, main="FCover 2017")
plot(fc20, col=CLF2, main="FCover 2020") #Fcover data is only avaiable until 2020 sadly.

dev.off()

##The created plots look ok, but lets try to make them more clear with ggplot2 function and viridis color scales.

#NDVI plots
ggplot() +      #basic frame of ggplot
geom_raster(ndvi17, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.333M )) + #adding aestetics and data
scale_fill_viridis(option="cividis") +  #use viridis color scales
ggtitle("NDVI 2017")

ggplot() +
geom_raster(ndvi22, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.333m )) +
scale_fill_viridis(option="cividis") +
ggtitle("NDVI 2022")

#Fcover plots
ggplot() +
geom_raster(fc17, mapping = aes(x=x, y=y, fill=Fraction.of.green.Vegetation.Cover.1km )) +
scale_fill_viridis(option="cividis") +
ggtitle("FCover 2017")

ggplot() +
geom_raster(fc20, mapping = aes(x=x, y=y, fill=Fraction.of.green.Vegetation.Cover.1km )) +
scale_fill_viridis(option="cividis") +
ggtitle("FCover 2020")

dev.off()


## now lets create two images that shows the difference between NDVI 2017 and 2022 and Fcover 2017 and 2020
##creating new color palette for differencations using HEX codes and saving them
CLF3 <- colorRampPalette(c("#B2182B","#D6604D","#F4A582","#FDDBC7","#D1E5F0","#92C5DE","#4393C3","#2166AC"))(100)
ndvidiff <- ndvi22 - ndvi17 
plot(ndvidiff, col=CLF3, main= "Difference in NDVI between 2017 and 2022")

##difference between FCovers 
fcdiff <- fc20 - fc17
plot(fcdiff, col= CLF3, main = "Difference in FCover between 2017 and 2020")

dev.off()

##plotting an overview with the images of the difference and the most important burnt area years
par(mfrow=c(2,2))
plot(ndvidiff, col=CLF3, main= "Difference in NDVI between 2017 and 2022")
plot(fcdiff, col= CLF3, main = "Difference in FCover between 2017 and 2020")
plot(ba19, col=CLF, main="Burnt areas summer 2019")
plot(ba20, col=CLF, main="Burnt areas summer 2020")

dev.off()


##Next, lets show in a histogram and a boxpplot in detail the frequency distribution of NDVI and Fcover changes, to mark the difference in change over the years.
#histogram
par(mfrow=c(1,2))
hist(ndvidiff, col="limegreen", xlab="NDVI change", main= "NDVI change between 2017 and 2022")
hist(fcdiff, col="limegreen", xlab="FCover change", main= "FCover change between 2017 and 2020")

#Transform data with stack function to create a boxplot
NDVIstack <- stack(ndvi17, ndvi22)
#plot(NDVIstack) # just to see the stack out of couriosity
FCOVERstack <- stack(fc17, fc20)
par(mfrow=c(1,2))
boxplot(NDVIstack,vertical=T,axes=T,outline=F, col="limegreen",ylab="NDVI change", xlab="Left: 2017 Right 2022", main="NDVI Boxplot")
boxplot(FCOVERstack,vertical=T,axes=T,outline=F, col="limegreen",ylab="FCOVER change", xlab="Left: 2017 Right 2020", main="FCover Boxplot") 

#plotting histogram and boxplot together
par(mfrow=c(2,2))
hist(ndvidiff, col="limegreen", xlab="NDVI change", main= "NDVI change between 2017 and 2022")
hist(fcdiff, col="limegreen", xlab="FCover change", main= "FCover change between 2017 and 2020")
boxplot(NDVIstack,vertical=T,axes=T,outline=F, col="limegreen",ylab="NDVI change", xlab="Left: 2017 Right 2022", main="NDVI Boxplot")
boxplot(FCOVERstack,vertical=T,axes=T,outline=F, col="limegreen",ylab="FCOVER change", xlab="Left: 2017 Right 2020", main="FCover Boxplot") 

dev.off()




###################################################################################

#> sessionInfo()
#R version 4.2.1 (2022-06-23 ucrt)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 19044)

#Matrix products: default

#locale:
#[1] LC_COLLATE=English_Canada.utf8 
#[2] LC_CTYPE=English_Canada.utf8   
#[3] LC_MONETARY=English_Canada.utf8
#[4] LC_NUMERIC=C                   
#[5] LC_TIME=English_Canada.utf8    

#attached base packages:
#[1] stats     graphics  grDevices utils    
#[5] datasets  methods   base     

#other attached packages:
#[1] viridis_0.6.2     viridisLite_0.4.1
#[3] RStoolbox_0.3.0   ggplot2_3.3.6    
#[5] ncdf4_1.19        raster_3.6-3     
#[7] sp_1.5-0         

#loaded via a namespace (and not attached):
 #[1] splines_4.2.1        foreach_1.5.2       
 #[3] prodlim_2019.11.13   assertthat_0.2.1    
 #[5] stats4_4.2.1         globals_0.16.1      
 #[7] ipred_0.9-13         pillar_1.8.1        
 #[9] lattice_0.20-45      glue_1.6.2          
#[11] exactextractr_0.9.0  pROC_1.18.0         
#[13] digest_0.6.29        hardhat_1.2.0       
#[15] colorspace_2.0-3     recipes_1.0.1       
#[17] Matrix_1.4-1         plyr_1.8.7          
#[19] timeDate_4021.104    XML_3.99-0.10       
#[21] pkgconfig_2.0.3      listenv_0.8.0       
#[23] caret_6.0-93         purrr_0.3.4         
#[25] scales_1.2.1         terra_1.6-17        
#[27] gower_1.0.0          lava_1.6.10         
#[29] tibble_3.1.8         proxy_0.4-27        
#[31] generics_0.1.3       farver_2.1.1        
#[33] withr_2.5.0          nnet_7.3-17         
#[35] cli_3.4.1            survival_3.3-1      
#[37] magrittr_2.0.3       future_1.28.0       
#[39] fansi_1.0.3          parallelly_1.32.1   
#[41] doParallel_1.0.17    nlme_3.1-157        
#[43] MASS_7.3-57          class_7.3-20        
#[45] tools_4.2.1          data.table_1.14.2   
#[47] lifecycle_1.0.2      stringr_1.4.1       
#[49] munsell_0.5.0        compiler_4.2.1      
#[51] e1071_1.7-11         rlang_1.0.6         
#[53] classInt_0.4-7       units_0.8-0         
#[55] grid_4.2.1           iterators_1.0.14    
#[57] labeling_0.4.2       gtable_0.3.1        
#[59] ModelMetrics_1.2.2.2 codetools_0.2-18    
#[61] DBI_1.1.3            reshape2_1.4.4      
#[63] R6_2.5.1             gridExtra_2.3       
#[65] lubridate_1.8.0      dplyr_1.0.10        
#[67] rgdal_1.5-32         future.apply_1.9.1  
#[69] utf8_1.2.2           KernSmooth_2.23-20  
#[71] stringi_1.7.8        parallel_4.2.1      
#[73] Rcpp_1.0.9           vctrs_0.4.1         
#[75] sf_1.0-8             rpart_4.1.16        
#[77] tidyselect_1.1.2 

#Sys.time()
#[1] "2022-09-28 20:53:12 CEST"

############################################################################################################

