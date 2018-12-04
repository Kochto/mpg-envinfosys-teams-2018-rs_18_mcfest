root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

giLinks <- list()
giLinks$saga<-link2GI::linkSAGA()
giLinks$otb<-link2GI::linkOTB()
giLinks$grass<-link2GI::linkGRASS7(returnPath = TRUE)
 
#To visually test the accuracy of the applied treepos and chmseg algorithms.
#Testing is done in three scenarios leaf, leaf_boreal, boreal.

#Laubtest=============================================================
# Laubtest
laub <- raster::raster(paste0(envrmt$path_data_lidar_segtest, "laubtest.tif"))

lin <- function(x){x * 0.05 + 0.6}

laubFT <- uavRst::treepos_FT(chm=laub ,minTreeAlt = 2, maxCrownArea = 70)

#Parameter to play around with
path_run <- envrmt$path_run
path_tmp <- envrmt$path_data_tmp
laubGWS <- uavRst::treepos_GWS(chm=laub, minTreeAlt = 2, minCrownArea = 3, maxCrownArea = 150, 
                               join = 1, thresh = 0.35, split = TRUE, 
                               cores = 2, giLinks = giLinks)

laubLIDR <- uavRst::treepos_lidR(chm = laub, movingWin = 3, minTreeAlt = 2)

laubRL <- uavRst::treepos_RL(chm=laub, movingWin = 7, minTreeAlt = 5)

#Crowns für gesamtes Bild in Tiles rechnen, mit hoher überlappung
crlaubFT <- uavRst::chmseg_FT(treepos = laubFT, chm = laub, minTreeAlt = 2, format = "polygons")

crlaubITC <- uavRst::chmseg_ITC(chm = laub, EPSG = 25832, minTreeAlt = 2, maxCrownArea = 150, movingWin = 7)

#Parameter to play around with
crlaubGWS <- uavRst::chmseg_GWS(chm = laub , treepos = laubGWS, minTreeAlt = 2,
                               neighbour = 0,
                               thVarFeature = 1.,
                               thVarSpatial = 1.,
                               thSimilarity = 0.00001,
                               giLinks = giLinks)
path_output <- paste0(envrmt$path_data_lidar_segtest_laubtest)
crlaubRL <- uavRst::chmseg_RL(treepos = laubRL, chm = laub, maxCrownArea = 150, exclusion = 0)


writeOGR(crlaubFT, paste0(envrmt$path_data_lidar_segtest_laubtest, "crlaubFT.shp"), "crlaubFT", driver="ESRI Shapefile")
writeOGR(crlaubITC, paste0(envrmt$path_data_lidar_segtest_laubtest, "crlaubITC.shp"), "crlaubITC", driver="ESRI Shapefile")
writeOGR(crlaubGWS, paste0(envrmt$path_data_lidar_segtest_laubtest, "crlaubGWS.shp"), "crlaubGWS", driver= "ESRI Shapefile")
writeOGR(crlaubRL, paste0(envrmt$path_data_lidar_segtest_laubtest, "crlaubRL.shp"), "crlaubRL", driver= "ESRI Shapefile")

#Nadel Laub Test====================================================================
#Laub Nadel Mix #### Nclust, Orpheo Toolbox, rgeos
nadellaub <- raster::raster(paste0(envrmt$path_data_lidar_segtest, "testalle.tif"))
nadellaub <- raster::focal(nadellaub, matrix(1/25, nrow = 5, ncol = 5), fun = sum)

#To test if 3 by 3 focal mean has an impact see master thesis finn

lin <- function(x){x * 0.06 + 0.5}

nadellaubFT <- uavRst::treepos_FT(chm=nadellaub, minTreeAlt = 10, maxCrownArea = 15, winFun = lin)

#Parameter to play around with
path_run <- envrmt$path_run
path_tmp <- envrmt$path_data_tmp
nadellaubGWS <- uavRst::treepos_GWS(chm=nadellaub, minTreeAlt = 7, minCrownArea = 3, maxCrownArea = 200, 
                               join = 1, thresh = 0.5, split = TRUE, 
                               cores = 2, giLinks = giLinks)

nadellaubLIDR <- uavRst::treepos_lidR(chm = nadellaub, movingWin = 3, minTreeAlt = 2)

nadellaubRL <- uavRst::treepos_RL(chm=nadellaub, movingWin = 3, minTreeAlt = 2)

#Crowns für gesamtes Bild in Tiles rechnen, mit hoher überlappung
crnadellaubFT <- uavRst::chmseg_FT(treepos = test, chm = nadellaub, minTreeAlt = 10, format = "polygons")

#test <- ForestTools::vwf(nadellaub, winFun = function(x){x * 0.06 + 0.5}, minHeight = 2)


crnadellaubITC <- uavRst::chmseg_ITC(chm = nadellaub, EPSG = 25832, minTreeAlt = 5, maxCrownArea = 120, movingWin = 5)

#Parameter to play around with
crnadellaubGWS <- uavRst::chmseg_GWS(chm = nadellaub , treepos = nadellaubGWS, minTreeAlt = 7,
                                neighbour = 0,
                                thVarFeature = 1,
                                thVarSpatial = 1,
                                thSimilarity = 0.001,
                                giLinks = giLinks)

crnadellaubRL <- uavRst::chmseg_RL(treepos = nadellaubRL, chm = nadellaub, maxCrownArea = 150, exclusion = 0)


writeOGR(crnadellaubFT, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubFTfunar.shp"), "crnadellaubFTfunar", driver="ESRI Shapefile", overwrite_layer = TRUE)
writeOGR(crnadellaubITC, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubITC.shp"), "crnadellaubITC", driver="ESRI Shapefile", overwrite_layer = TRUE)
writeOGR(crnadellaubGWS, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubGWS.shp"), "crnadellaubGWS", driver= "ESRI Shapefile", overwrite_layer = TRUE)
writeOGR(crnadellaubRL, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubRL.shp"), "crnadellaubRL", driver= "ESRI Shapefile")

#Nadeltest====================================================================
#Nadel
nadel <- raster::raster(paste0(envrmt$path_data_lidar_segtest, "nadeltest.tif"))

lin <- function(x){x * 0.05 + 0.6}

nadelFT <- uavRst::treepos_FT(chm=nadel ,minTreeAlt = 2, maxCrownArea = 150, winFun = lin)

#Parameter to play around with
path_run <- envrmt$path_run
path_tmp <- envrmt$path_data_tmp
nadelGWS <- uavRst::treepos_GWS(chm=nadel, minTreeAlt = 2, minCrownArea = 3, maxCrownArea = 150, 
                                    join = 1, thresh = 0.35, split = TRUE, 
                                    cores = 2, giLinks = giLinks)

nadelLIDR <- uavRst::treepos_lidR(chm = nadel, movingWin = 3, minTreeAlt = 2)

nadelRL <- uavRst::treepos_RL(chm=nadel, movingWin = 3, minTreeAlt = 2)

#Crowns für gesamtes Bild in Tiles rechnen, mit hoher überlappung
crnadelFT <- uavRst::chmseg_FT(treepos = nadelFT, chm = nadel, minTreeAlt = 2, format = "polygons")

crnadelITC <- uavRst::chmseg_ITC(chm = nadel, EPSG = 25832, minTreeAlt = 2, maxCrownArea = 150, movingWin = 3)

#Parameter to play around with
crnadelGWS <- uavRst::chmseg_GWS(chm = nadel , treepos = nadelGWS, minTreeAlt = 2,
                                     neighbour = 0,
                                     thVarFeature = 1.,
                                     thVarSpatial = 1.,
                                     thSimilarity = 0.00001,
                                     giLinks = giLinks)

crnadelRL <- uavRst::chmseg_RL(treepos = nadelRL, chm = nadel, maxCrownArea = 150, exclusion = 0)


writeOGR(crnadelFT, paste0(envrmt$path_data_lidar_segtest_nadeltest, "crnadelFT.shp"), "crnadelFT", driver="ESRI Shapefile")
writeOGR(crnadelITC, paste0(envrmt$path_data_lidar_segtest_nadeltest, "crnadelITCmov3.shp"), "crnadelITCmov3", driver="ESRI Shapefile")
writeOGR(crnadelGWS, paste0(envrmt$path_data_lidar_segtest_nadeltest, "crnadelGWS.shp"), "crnadelGWS", driver= "ESRI Shapefile")
writeOGR(crnadelRL, paste0(envrmt$path_data_lidar_segtest_nadeltest, "crnadelRL.shp"), "crnadelRL", driver= "ESRI Shapefile")
