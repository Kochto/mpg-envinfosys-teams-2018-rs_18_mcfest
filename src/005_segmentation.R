root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

giLinks <- list()
giLinks$saga<-link2GI::linkSAGA()
giLinks$otb<-link2GI::linkOTB()
giLinks$grass<-link2GI::linkGRASS7(returnPath = TRUE)
 
#To visually test the accuracy of the applied treepos and chmseg algorithms.
#Testing is done in three scenarios leaf, leaf_boreal, boreal.

#Nadel Laub Test====================================================================
#Laub Nadel Mix #### Nclust, Orpheo Toolbox, rgeos
#To test if 3 by 3 focal mean has an impact see master thesis finn
nadellaub <- raster::raster(paste0(envrmt$path_data_lidar_segtest, "testalle.tif"))
nadellaub <- raster::focal(nadellaub, matrix(1/9, nrow = 3, ncol = 3), fun = sum)
writeRaster(nadellaub, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "meannadellaub.tif"), overwrite = TRUE)

#Crowns für gesamtes Bild in Tiles rechnen, mit hoher überlappung
#ForestTools
#lin <- function(x){x * 0.06 + 0.5}
#nadellaubFT <- uavRst::treepos_FT(chm=nadellaub, minTreeAlt = 12, maxCrownArea = 15, winFun = lin)
test <- ForestTools::vwf(nadellaub, winFun = function(x){x * 0.07 + 0.6}, minHeight = 12, minWinNeib = "queen", verbose = TRUE, maxWinDiameter = 30)
crnadellaubFT <- uavRst::chmseg_FT(treepos = test, chm = nadellaub, minTreeAlt = 12, format = "polygons", verbose = TRUE)
writeOGR(crnadellaubFT, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubFT_mean.shp"), "crnadellaubFTmean", driver="ESRI Shapefile", overwrite_layer = TRUE)

#ITC
crnadellaubITC <- uavRst::chmseg_ITC(chm = nadellaub, EPSG = 25832, minTreeAlt = 12, maxCrownArea = 150, movingWin = 7)
writeOGR(crnadellaubITC, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubITC_150.shp"), "crnadellaubITC150", driver="ESRI Shapefile", overwrite_layer = TRUE)

#Parameter to play around with
#GWS
path_run <- envrmt$path_run
path_tmp <- envrmt$path_data_tmp
nadellaubGWS <- uavRst::treepos_GWS(chm=nadellaub, minTreeAlt = 7, minCrownArea = 3, maxCrownArea = 200, 
                                    join = 1, thresh = 0.5, split = TRUE, 
                                    cores = 2, giLinks = giLinks)

crnadellaubGWS <- uavRst::chmseg_GWS(chm = nadellaub , treepos = nadellaubGWS, minTreeAlt = 7,
                                neighbour = 0,
                                thVarFeature = 1,
                                thVarSpatial = 1,
                                thSimilarity = 0.001,
                                giLinks = giLinks)
writeOGR(crnadellaubGWS, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubGWS.shp"), "crnadellaubGWS", driver= "ESRI Shapefile", overwrite_layer = TRUE)

#RLidar
nadellaubRL <- uavRst::treepos_RL(chm=nadellaub, movingWin = 3, minTreeAlt = 2)
crnadellaubRL <- uavRst::chmseg_RL(treepos = nadellaubRL, chm = nadellaub, maxCrownArea = 150, exclusion = 0)
writeOGR(crnadellaubRL, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubRL.shp"), "crnadellaubRL", driver= "ESRI Shapefile")





