root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))

pts <- rgdal::readOGR(dsn = "F:/09_Semester/mpg-envinsys-plygrnd/mpg-envinfosys-teams-2018-rs_18_mcfest/Val_Tree_pos_Group/Val_Tree_pos_Group.shp", layer = "Val_Tree_pos_Group")
pts <- spTransform(pts,crs(crnadellaubFT))

test <- sp::over(SpatialPoints(pts),SpatialPolygons(crnadellaubFT@polygons), returnList = TRUE)
test <- data.frame(unlist(test))
test$pts <- rownames(test)
names(test) <- c("polygons", "pts")


pb <- length(unique(test$polygons)) # polygons with == one tree
# bkp gibt es nicht, da keine bäume ohne polygon
pkb <- length(crnadellaubFT@data$layer)/ length(test$polygons) #empty polygons - polygon without a tree
mbp <- length(test$polygons)- pb #polygons with more than one tree

hit_ratio <- pb/length(crnadellaubFT@data$layer) #polygons with one tree on all calculated polygons
miss_ratio <- 1-(length(test$polygons)/length(crnadellaubFT@data$layer)) #ratio of empty polygons on all created polygons

data.frame(pb, pkb, mbp, hit_ratio, miss_ratio)
