root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

mof <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_org_extend), chunksize = 500, 
                                 chunkbuffer = 10, cores = 4)
								 
crs(mof) <- "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

#Normalize data points (height)
lidR::opt_output_files(mof)<- paste0(envrmt$path_data_lidar_norm, "{ID}_norm")
#mof_norm <- lidR::lasnormalize(mof, lidR::tin())
mof_corrnorm <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_norm), chunksize = 500,
                                          chunkbuffer = 10, cores = 4)
lidR:::catalog_laxindex(mof_corrnorm)

#reclassify ground points
lidR::opt_output_files(mof_corrnorm)<-paste0(envrmt$path_data_lidar_csf,"{ID}_csf")
#mof_ground_csf <- lidR::lasground(mof_corrnorm, csf())
mof_cat_csf <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_csf), chunksize = 500, 
                                 chunkbuffer = 10, cores = 4)
lidR:::catalog_laxindex(mof_corrnorm)

######ilter Functions#####
filterz = function(las,minZ = 0, maxZ = 5){
  las = readLAS(las)
  if (is.empty(las)) return(NULL)
  las = lidR::lasfilter(las, Z >=minZ & Z < maxZ)
  grid = grid_metrics(las, res = 2, .stdmetrics_z)
  grid = grid[[c(1,2,3,6,7)]]
  return(grid)
}
filteri = function(las,minZ = 0, maxZ = 5){
  las = readLAS(las)
  if (is.empty(lidR::lasfilter(las, Z >=minZ & Z < maxZ))) return(NULL)
  las = lidR::lasfilter(las, Z >=minZ & Z < maxZ)
  #grid = grid_metrics(las, res = 2, stdmetrics_i(Intensity))
  #grid = grid[[c(1,2,3,4)]] #
  return(las)
}


#Read catalog without buffer
mof_cat_csf <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_csf), chunksize = 500, 
                                         chunkbuffer = 0, cores = 4)

#####Filter levels#####
#Level 1 0-5 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level1,"{ID}_level1")
#level1 = lidR::catalog_apply(mof_cat_csf, filteri,0,5)
mof_lev1 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level1), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev1)

#Level 2 5-10 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level2,"{ID}_level2")
#level2 = lidR::catalog_apply(mof_cat_csf, filteri,5,10)
mof_lev2 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level2), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev2)

#Level 3 10-15 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level3,"{ID}_level3")
#level3 = lidR::catalog_apply(mof_cat_csf, filteri,10,15)
mof_lev3 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level3), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev3)

#Level 4 15-20 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level4,"{ID}_level4")
#level4 = lidR::catalog_apply(mof_cat_csf, filteri,15,20)
mof_lev4 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level4), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev4)

#Level 5 20-25 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level5,"{ID}_level5")
#level5 = lidR::catalog_apply(mof_cat_csf, filteri,20,25)
mof_lev5 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level5), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev5)

#Level 6 25-30 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level6,"{ID}_level6")
#level6 = lidR::catalog_apply(mof_cat_csf, filteri,25,30)
mof_lev6 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level6), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev6)

#Level 7 30-35 meters
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level7,"{ID}_level7")
#level7 = lidR::catalog_apply(mof_cat_csf, filteri,30,50)
mof_lev7 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level7), chunksize = 500, 
                                      chunkbuffer = 0, cores = 4)
lidR:::catalog_laxindex(mof_lev7)

#####Entropy#####
#All Levels
entall <- grid_metrics(mof_cat_csf, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(entall, filename = paste0(envrmt$path_data_lidar_processed_shannon, "entall.tif"), overwrite = TRUE)

#Level 1
ent1 <- grid_metrics(mof_lev1, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent1, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev1ent.tif"), overwrite = TRUE)

#Level 2
ent2 <- grid_metrics(mof_lev2, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent2, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev2ent.tif"), overwrite = TRUE)

#Level 3
ent3 <- grid_metrics(mof_lev3, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent3, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev3ent.tif"), overwrite = TRUE) 

#Level 4
ent4 <- grid_metrics(mof_lev4, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent4, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev4ent.tif"), overwrite = TRUE)

#Level 5
ent5 <- grid_metrics(mof_lev5, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent5, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev5ent.tif"), overwrite = TRUE) 

#Level 6
ent6 <- grid_metrics(mof_lev6, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent6, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev6ent.tif"), overwrite = TRUE) 

#Level 7
ent7 <- grid_metrics(mof_lev7, res = 2, lidR::entropy(Z, by = 1), start = c(0, 0))
writeRaster(ent7, filename = paste0(envrmt$path_data_lidar_processed_shannon, "lev7ent.tif"), overwrite = TRUE) 

#####Height-Stats#####
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_processed_zstats,"{ID}_zstats")
zstats = grid_metrics(mof_cat_csf,.stdmetrics_z, res = 2, start = c(0,0))
writeRaster(zstats, filename = paste0(envrmt$path_data_lidar_processed_zstats,"zstats_allLevels.tif"))
stack(paste0(envrmt$path_data_lidar_processed_zstats, "zstats_allLevels.tif"))

#####Number of Returns#####
lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data,"{ID}_rstats")
returnsAL = grid_density(mof_cat_csf, res = 2)
writeRaster(returnsAL, filename = paste0(envrmt$path_data_lidar_processed_nreturns,"returns_allLevels.tif"))