root_folder <- envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd", alt_env_id = "COMPUTERNAME",
                                        alt_env_value = "PCRZP", alt_env_root_folder = "F:\\edu\\mpg-envinsys-plygrnd")

source(paste0(root_folder, "/mpg-envinfosys-teams-2018-rs_18_mcfest/src/000_setup.R"))


areapredict <- raster::raster(paste0(envrmt$path_data_training, "areapredmod3.tif"))
cseg <- raster::shapefile(paste0(envrmt$path_data_mof, "cseg55.shp"))
cseg_height <- raster::shapefile(paste0(envrmt$path_data_training, "cseg_zmax_neigh.shp"))

mask <- gdalUtils::gdal_rasterize(src_datasource = paste0(envrmt$path_data_mof, "cseg55.shp"),
                               dst_filename = paste0(envrmt$path_data_training, "rcseg.tif"), 
                               a = "treeID",
                               tr = c(xres(areapredict), yres(areapredict)),
                               #ts = c(ncol(areapredict), nrow(areapredict)), 
                               l = "cseg55",
                               output_Raster = TRUE)
rcseg <- raster::raster(paste0(envrmt$path_data_training, "rcseg.tif"))
areapredict <- crop(areapredict, rcseg)

segID <- rcseg[][which(values(rcseg!=0))]
segID <- rcseg[which(values(rcseg!=0))]
val <- areapredict[][which(values(rcseg!=0))]
val <- areapredict[which(values(rcseg!=0))]

extr <- data.frame(segid = segID, type = val)
inf <- table(extr)
props <- data.frame(segid = rownames(inf), BU = inf[,1], DGL = inf[,2], FI = inf[,3], LAR = inf[,4], TEI = inf[,5])
props$sum <- rowSums(props[,2:6])
props$prop <- 1
for (i in seq(nrow(props))){
props$prop[i] <- max(props[i,2:6])/props$sum[i]
print(i)
}
t <- c()
uid <- unique(props$segid)
props$spec <- "test"
for (i in seq(nrow(props))){
  if(sum((props[which(props$segid == uid[i]),2:6] == max(props[i,2:6]))== TRUE) > 1){
    props$spec[i] <- "unspec"
    t <- c(t, i)
    }
  props$spec[i] <- names(props[which(props[i,2:6] == max(props[i,2:6]))+1])
  print(i)
}

write.table(x = props, file = paste0(envrmt$path_data_training, "props.csv"), sep = ";", dec = ".")
