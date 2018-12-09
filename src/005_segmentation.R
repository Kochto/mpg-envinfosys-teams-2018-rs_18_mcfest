root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

giLinks <- list()
giLinks$saga<-link2GI::linkSAGA()
giLinks$otb<-link2GI::linkOTB()
giLinks$grass<-link2GI::linkGRASS7(returnPath = TRUE)
 
#segmetation strategy for the entire forest====================================================================

#To test if 3 by 3 focal mean has an impact see master thesis finn
chm <- raster::raster(paste0(envrmt$path_data_lidar, "canopy.tif"))

chm <- raster::focal(chm, matrix(1/9, nrow = 3, ncol = 3), fun = sum) #apply a 3x3 focal mean filter
writeRaster(chm, filename = paste0(envrmt$path_data_lidar, "chm_mean.tif")) #write the mean filter to the disk

tiles<- TileManager::TileScheme(chm, dimByCell = c(1200, 1200), buffer = 50, bufferspill = FALSE) #setup tiles to process image on

#Calculate treepositions for the entire forest
treepos <- ForestTools::vwf(chm, winFun = function(x){x * 0.061 + 0.6}, minHeight = 8, minWinNeib = "queen", verbose = TRUE, maxWinDiameter = 30)

splitseg <- lapply(seq(16), function (i){
  tmp <- raster::crop(chm,tiles$buffPolygons[i,]) #Crop averaged crown model to the size of each tile
  crowns <- uavRst::chmseg_FT(treepos,tmp,minTreeAlt = 8,format= "polygons", verbose =TRUE) #does the actual segmentation
  crs(crowns) <- crs(chm) #assign the right coordinate system to the segmeted crowns
  ids <- na.omit(sp::over(treepos,crowns)) #get the ID's of the treeposition layer if they are "above" polygons of the Crowns layer
  ids$rownames <- as.numeric(row.names(ids)) #save the ID's as they are rownames to the dataframe
  crowns@data$treeID <- ids$rownames #create a matching column with ID's in the attribute table of the crowns polygons layer 
  crowns <- raster::crop(crowns,tiles$tilePolygons[i,]) #now crop the polygon layer to the tiles (clear cutting edges - no overlap)
  return(crowns)
})

# writeOGR(crowns, dsn = paste0(envrmt$path_data_lidar, "valtest.shp"), driver = "ESRI Shapefile", 
#          layer ="valtest", overwrite_layer = TRUE) #to test the function above step by step

for (l in 1:length(splitseg)){ #write out every layer created by the function above
  writeOGR(splitseg[[l]], dsn = paste0(envrmt$path_data_mof, "seg", l, ".shp"), driver = "ESRI Shapefile", layer = paste0("seg", l), overwrite_layer = TRUE)
}

for (l in 1:length(splitseg)){ #bind all layers created by the above function together
  tem <- splitseg[[l]]
  if (l==1){
    cseg <- tem
  }
  else{
    cseg <- rbind(cseg, tem)
  }
}


cseg <- sp::aggregate(cseg,by = c("treeID", "layer", "height", "winRadius", "crownArea")) #aggregate polygon layers together while preserving it's attribute table
writeOGR(cseg, dsn = paste0(envrmt$path_data_mof, "cseg.shp"), driver = "ESRI Shapefile", layer ="cseg", overwrite_layer = TRUE)

cseg55 <- cseg[cseg@data$crownArea>5.5,] #filter out polygons (trees) lower than 5.5 square meters 
writeOGR(cseg55, dsn = paste0(envrmt$path_data_mof, "cseg55.shp"), driver = "ESRI Shapefile", layer ="cseg55", overwrite_layer = TRUE)


###Testing area####

nadellaub <- raster::raster(paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "meannadellaub.tif"))
# nadellaub <- raster::focal(nadellaub, matrix(1/9, nrow = 3, ncol = 3), fun = sum)
# writeRaster(nadellaub, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "meannadellaub.tif"), overwrite = TRUE)

#ForestTools
#lin <- function(x){x * 0.06 + 0.5}

stats <- list()
stats[[18]] <- ft(raster = nadellaub, mul = 0.031, sum = 0.6, minHeight = 8)
saveRDS(stats, paste0(envrmt$path_data, "stats.rds"))


tre <- ForestTools::vwf(nadellaub, winFun = function(x){x * 0.05 + 0.6}, minHeight = 8, minWinNeib = "queen", verbose = TRUE, maxWinDiameter = 30)
crnadellaubFT <- uavRst::chmseg_FT(treepos = tre, chm = nadellaub, minTreeAlt = 8, format = "polygons", verbose = TRUE)
writeOGR(crnadellaubFT, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubFT_mean.shp"), "crnadellaubFTmean", driver="ESRI Shapefile", overwrite_layer = TRUE)



pts <- rgdal::readOGR(dsn = "F:/09_Semester/mpg-envinsys-plygrnd/mpg-envinfosys-teams-2018-rs_18_mcfest/Val_Tree_pos_Group/Val_Tree_pos_Group.shp", layer = "Val_Tree_pos_Group")
pts <- spTransform(pts,crs(crnadellaubFT))

test <- sp::over(SpatialPoints(pts),SpatialPolygons(crnadellaubFT@polygons), returnList = TRUE)
test <- data.frame(unlist(test))
test$pts <- rownames(test)
names(test) <- c("polygons", "pts")


#==============================
pb <- length(unique(test$polygons)) # polygons with == one tree
# bkp gibt es nicht, da keine bäume ohne polygon
pkb <- length(crnadellaubFT@data$layer)- length(test$polygons) #empty polygons - polygon without a tree
mbp <- length(test$polygons)- pb #polygons with more than one tree

hit_ratio <- pb/length(crnadellaubFT@data$layer) #polygons with one tree on all calculated polygons
miss_ratio <- 1-(length(test$polygons)/length(crnadellaubFT@data$layer)) #ratio of empty polygons to all created polygons


     
     
# sum(duplicated(test)==FALSE)/131
#      
#      
# test <- sp::over(SpatialPoints(shp),SpatialPolygons(segITC@polygons), returnList = TRUE)
# test <- unlist(test)
#      
#    
# sum(duplicated(test$)==FALSE)/175 #TP
# 
# 1-sum(duplicated(test)==FALSE)/175 # FP
# (175-length(unique(test[-duplicated(test)])))/175   #FP
     


















# #ITC
# crnadellaubITC <- uavRst::chmseg_ITC(chm = nadellaub, EPSG = 25832, minTreeAlt = 12, maxCrownArea = 150, movingWin = 7)
# writeOGR(crnadellaubITC, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubITC_nomean.shp"), "crnadellaubITCnomean", driver="ESRI Shapefile", overwrite_layer = TRUE)
# 
# #Parameter to play around with
# #GWS
# path_run <- envrmt$path_run
# path_tmp <- envrmt$path_data_tmp
# nadellaubGWS <- uavRst::treepos_GWS(chm=nadellaub, minTreeAlt = 7, minCrownArea = 3, maxCrownArea = 200,
#                                     join = 1, thresh = 0.5, split = TRUE,
#                                     cores = 2, giLinks = giLinks)
# 
# crnadellaubGWS <- uavRst::chmseg_GWS(chm = nadellaub , treepos = nadellaubGWS, minTreeAlt = 7,
#                                 neighbour = 0,
#                                 thVarFeature = 1,
#                                 thVarSpatial = 1,
#                                 thSimilarity = 0.001,
#                                 giLinks = giLinks)
# writeOGR(crnadellaubGWS, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubGWS.shp"), "crnadellaubGWS", driver= "ESRI Shapefile", overwrite_layer = TRUE)
# 
# #RLidar
# nadellaubRL <- uavRst::treepos_RL(chm=nadellaub, movingWin = 3, minTreeAlt = 2)
# crnadellaubRL <- uavRst::chmseg_RL(treepos = nadellaubRL, chm = nadellaub, maxCrownArea = 150, exclusion = 0)
# writeOGR(crnadellaubRL, paste0(envrmt$path_data_lidar_segtest_nadel_laub_test, "crnadellaubRL.shp"), "crnadellaubRL", driver= "ESRI Shapefile")
# 
# 
# 
# plot(nadellaub, add=TRUE, col = grey.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))
