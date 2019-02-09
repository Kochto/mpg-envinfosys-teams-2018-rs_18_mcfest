root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))
#####Statistics per polygon#####
# cent <- rgeos::gCentroid(cseg, byid = TRUE)
# dat <- data.frame(ID=c(1:79990))
# cent <- SpatialPointsDataFrame(coords=cent, data = dat)
# writeOGR(cent, paste0(envrmt$path_data_mof, "centroids.shp"), layer = "centroids", driver = "ESRI Shapefile")
# cseg <- raster::shapefile(paste0(envrmt$path_data_mof, "cseg_corr.shp"))
# props <- read.csv(file = paste0(envrmt$path_data_training, "props_mod6.csv"), sep = ";", dec = ".", header = TRUE)
# zstats <- raster::raster(paste0(envrmt$path_data_lidar_processed_zstats, "zmax.tif"))

####Number of neighbours for each tree polygon####
# csegbuff <- rgeos::gBuffer(cseg, width = .1, byid = TRUE)
# csegcont <- rgeos::gIntersects(spgeom1 = csegbuff, spgeom2 = cseg, byid = TRUE, returnDense = FALSE)
# nseg <- unlist(lapply(csegcont, length))
# cseg@data$neighbour <- nseg
# writeOGR(cseg, dsn = paste0(envrmt$path_data_mof, "cseg_neigh.shp"), layer = "cseg_neigh", 
#          driver = "ESRI Shapefile", overwrite_layer = TRUE)
####Zmax per polygon####
# cseg <- sp::spTransform(cseg, CRSobj = crs(zstats))
# cseg@data$zmax <- 1
# for (z in seq(length(cseg))){
#   cseg@data[z, "zmax"] <- max(unlist(extract(zstats$zmax, cseg[z,])))
#   print(z)
# }
# cseg@data$zmax <- cseg_height@data$zmax
# writeOGR(cseg, dsn = paste0(envrmt$path_data_mof, "cseg_neigh_zmax.shp"), layer = "cseg_neigh_zmax",
#          driver = "ESRI Shapefile", overwrite_layer = TRUE)
# cseg <- raster::shapefile(paste0(envrmt$path_data_mof, "cseg_neigh_zmax.shp"))
# cseg@data <- merge(x = cseg@data, y = props, by.x = "treeID", by.y = "segid", sort = FALSE)
writeOGR(obj = cseg, dsn = paste0(envrmt$path_data_mof, "cseg_stats_mod6.shp"),
         layer = "cseg_stats_mod6", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#####forest segments statistics based on classification #####
# metrics <- raster::shapefile(paste0(envrmt$path_data_mof, "hor_p_metrics.shp"))
# cseg <- raster::shapefile(paste0(envrmt$path_data_mof, "cseg_stats_mod6.shp"))
# 
# acc_fs <- lapply(seq(length(metrics)), function(l){
#   tem <- as.data.frame(table(raster::intersect(metrics[l,], cseg)@data$spec))
#   if (length(tem$Freq[which(tem$Var1 == metrics[l,]$FE_DWBAGRP)]) != 0){
#   acc <- tem$Freq[which(tem$Var1 == metrics[l,]$FE_DWBAGRP)] / sum(tem$Freq)
#   }
#   else {
#     acc <- 0
#   }
#   print(paste(l, acc))
#   return(acc)
# })
# metrics@data$acc_fs_mod6 <- unlist(acc_fs)
# 
writeOGR(metrics, dsn = paste0(envrmt$path_data_mof, "hor_p_metrics.shp"), layer = "hor_p_metrics",
         driver = "ESRI Shapefile", overwrite_layer = TRUE)
