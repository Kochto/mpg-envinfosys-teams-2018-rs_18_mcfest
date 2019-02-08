root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

# cent <- rgeos::gCentroid(cseg, byid = TRUE)
# dat <- data.frame(ID=c(1:79990))
# cent <- SpatialPointsDataFrame(coords=cent, data = dat)
# writeOGR(cent, paste0(envrmt$path_data_mof, "centroids.shp"), layer = "centroids", driver = "ESRI Shapefile")
cseg <- raster::shapefile(paste0(envrmt$path_data_mof, "cseg55.shp"))
#cseg_height <- raster::shapefile(paste0(envrmt$path_data_training, "cseg_zmax_neigh.shp"))
props <- read.csv(file = paste0(envrmt$path_data_training, "props.csv"), sep = ";", dec = ".", header = TRUE)
zstats <- raster::raster(paste0(envrmt$path_data_lidar_processed_zstats, "zmax.tif"))

####Number of neighbours for each tree polygon####
cseg@data$neighbour <- 1
csegbuff <- rgeos::gBuffer(cseg, width = .1, byid = TRUE)
csegcont <- rgeos::gIntersects(spgeom1 = csegbuff, spgeom2 = cseg, byid = TRUE, returnDense = FALSE)
nseg <- unlist(lapply(csegcont, length))
cseg@data$neighbour <- nseg
writeOGR(cseg, dsn = paste0(envrmt$path_data_mof, "cseg_neigh.shp"), layer = "cseg_neigh", 
         driver = "ESRI Shapefile", overwrite_layer = TRUE)

####Zmax per polygon####
cseg <- sp::spTransform(cseg, CRSobj = crs(zstats))
cseg@data$zmax <- 1
for (z in seq(length(cseg))){
  cseg@data[z, "zmax"] <- max(unlist(extract(zstats$zmax, cseg[z,])))
  print(z)
}
#cseg@data$zmax <- cseg_height@data$zmax
cseg@data <- merge(x = cseg@data, y = props, by.x = "treeID", by.y = "segid")
writeOGR(obj = cseg, dsn = paste0(envrmt$path_data_mof, "cseg_stats.shp"), 
         layer = "cseg_stats", driver = "ESRI Shapefile", overwrite_layer = TRUE)

