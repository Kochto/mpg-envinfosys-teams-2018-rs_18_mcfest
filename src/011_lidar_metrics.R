root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

#mean intensity
#crown height
#crown slope
#percentile heights lidr
#mean hight of all first returns lidr
#


files <- list.files(envrmt$path_data_lidar_org, pattern = "*.las", full.names = TRUE)

#Correct Points
#uavRst::llas2llv0(files,paste0(envrmt$path_data_lidar_org_corrected))
mof <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_org_corrected), chunksize = 500, 
                                 chunkbuffer = 10, cores = 4)
crs(mof) <- "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

#Normalize data points (height)
lidR::opt_output_files(mof)<- paste0(envrmt$path_data_lidar_norm, "{ID}_norm")
#mof_norm <- lidR::lasnormalize(mof, lidR::tin())
mof_corrnorm <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_norm), chunksize = 500,
                                          chunkbuffer = 10, cores = 4)

#reclassify ground points
lidR::opt_output_files(mof_corrnorm)<-paste0(envrmt$path_data_lidar_csf,"{ID}_csf")
mof_ground_csf <- lidR::lasground(mof_corrnorm, csf())
mof_cat_csf <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_csf), chunksize = 500, 
                                 chunkbuffer = 10, cores = 4)

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

for(i in 1:length(las_files)){
  las = readLAS(las_files[i])
  #las = lidR::lasfilter(las, Z >=0 & Z < 50)
  grid = grid_metrics(las, res = 2, .stdmetrics_i)
  crs(grid) =proj4                
  writeRaster(grid, filename = paste0("edu/mpg-envinsys-plygrnd/data/tmp/istats/",i,".tif"))
}

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level1,"{ID}_level1")
level1 = lidR::catalog_apply(mof_cat_csf, filteri,0,5)
mof_lev1 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level1), chunksize = 500, 
                                         chunkbuffer = 10, cores = 4)
test3 <- grid_metrics(mof_lev1, res = 50, lidR::entropy(Z, by = 1), start = c(0, 0))
test2 <- grid_metrics(mof_lev1, res = 50, stdmetrics_i(Intensity), start = c(0, 0))


lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level2,"{ID}_level2")
level2 = lidR::catalog_apply(mof_cat_csf, filteri,5,10)
mof_lev2 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level2), chunksize = 100, 
                                      chunkbuffer = 10, cores = 4)

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level3,"{ID}_level3")
level3 = lidR::catalog_apply(mof_cat_csf, filteri,10,15)
mof_lev3 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level3), chunksize = 100, 
                                      chunkbuffer = 10, cores = 4)

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level4,"{ID}_level4")
level4 = lidR::catalog_apply(mof_cat_csf, filteri,15,20)
mof_lev4 <- uavRst::make_lidr_catalog(paste0(envrmt$path_data_lidar_height_level4), chunksize = 100, 
                                      chunkbuffer = 10, cores = 4)

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level5,"{ID}_level5")
level5 = lidR::catalog_apply(mof_cat_csf, filteri,20,25)

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level6,"{ID}_level6")
level6 = lidR::catalog_apply(mof_cat_csf, filteri,25,30)

lidR::opt_output_files(mof_cat_csf)<-paste0(envrmt$path_data_lidar_height_level7,"{ID}_level7")
level7 = lidR::catalog_apply(mof_cat_csf, filteri,30,50)

x <- lidR::readLAS(paste0(envrmt$path_data_lidar_csf, "55_csf.las"))
trees <- lastrees(x, li2012())
col <- random.colors(200)
plot(trees, color = "treeID", colorPalette = col)
test <- lidR::as.spatial(trees)
writeOGR(test, paste0(envrmt$path_data, "test.shp"),
         "test", driver="ESRI Shapefile", overwrite_layer = TRUE)

# lidR::opt_output_files(mof_csf)<-paste0(envrmt$path_data_lidar_csf,"{ID}_pitfree_csf")
# dsm_pitfree_csf <- lidR::grid_canopy(mof_csf, res = 0.5, 
#                                      lidR::pitfree(c(0,2,5,10,15), c(0, 0.5)))

test <- grid_metrics(mof, mean(Z), 20)
test2 <- grid_metrics(mof, lidR::entropy(Z, by = 1), res = 20, start = c(0, 0))

#lidr::entropy
#lidr::grid_metrics
#lidr::lasmetrics
#lidr::lastrees
#Baumschichten einteilen

#Baumschichten exportieren mit r.in.lidar
#custom function aus 


#https://github.com/GeoMOER-Students-Space/msc-phygeo-class-of-2017-creuden/blob/master/gis/gi-ws-08/scripts/gi-ws-08.R
#https://grass.osgeo.org/grass76/manuals/r.in.lidar.html
